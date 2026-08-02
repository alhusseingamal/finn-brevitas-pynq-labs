import os
import torch
import torch.nn as nn
from torch.nn import Module
import torch.nn.functional as F
import torchvision.transforms as transforms
import brevitas.nn as qnn
import argparse
import numpy as np
from losses import SqrHingeLoss
import brevitas.export as bo
import brevitas.quant as bq
import time
import matplotlib.pyplot as plt

class KWS(Module):
    def __init__(self, weight_bit_width=8, act_bit_width=8):

        super(KWS, self).__init__()

        # TODO: Your model definition here:
        self.in_quant = qnn.QuantIdentity(bit_width=act_bit_width, return_quant_tensor=True)

        self.conv1 = qnn.QuantConv2d(in_channels=1, out_channels=32, kernel_size=(3,3), padding=(1,1), weight_bit_width=weight_bit_width)
        self.bn1 = nn.BatchNorm2d(32)

        self.conv2 = qnn.QuantConv2d(in_channels=32, out_channels=64, kernel_size=(3,3), padding=(1,1), weight_bit_width=weight_bit_width)
        self.bn2 = nn.BatchNorm2d(64)

        self.conv3 = qnn.QuantConv2d(in_channels=64, out_channels=64, kernel_size=(3,3), padding=(1,1), weight_bit_width=weight_bit_width)
        self.bn3 = nn.BatchNorm2d(64)

        self.pool = torch.nn.MaxPool2d(kernel_size=(2,2), stride=(2,2))

        self.fc0 = qnn.QuantLinear(in_features=64*2*12, out_features=128, weight_bit_width=weight_bit_width)
        self.fc1 = qnn.QuantLinear(in_features=128, out_features=11, weight_bit_width=weight_bit_width)
        
        self.relu1 = qnn.QuantReLU(bit_width=act_bit_width, return_quant_tensor=True)
        self.relu2 = qnn.QuantReLU(bit_width=act_bit_width, return_quant_tensor=True)
        self.relu3 = qnn.QuantReLU(bit_width=act_bit_width, return_quant_tensor=True)
        self.relu4 = qnn.QuantReLU(bit_width=act_bit_width, return_quant_tensor=True)
        self.dropout = torch.nn.Dropout(p=0.3)
    
    def forward(self,x):
        #TODO: Your forward pass here

        x = x.view(x.shape[0], 1, 10, 49)
        x = 2.0 * x - torch.tensor([1.0], device=x.device)

        x = self.in_quant(x)

        x = self.conv1(x)
        x = self.bn1(x)
        x = self.relu1(x)
        x = self.pool(x)            # (B,32,5,24)

        x = self.conv2(x)
        x = self.bn2(x)
        x = self.relu2(x)
        x = self.pool(x)            # (B,64,2,12)

        x = self.conv3(x)
        x = self.bn3(x)
        x = self.relu3(x)


        x = x.view(x.shape[0], -1)  # flatten -> 1536 (64*2*12)

        x = self.dropout(x)
        x = self.fc0(x)
        x = self.relu4(x)
        x = self.dropout(x)
        x = self.fc1(x)
        
        return x

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Quantized model for keyword spotting")
    parser.add_argument("filename", type=str, nargs='?', help="Output file name")
    parser.add_argument("--epochs", type=int, nargs='?',default=100, help="Number of epochs")
    parser.add_argument("--gpu", type=str, nargs='?',default=0, help="Index of GPU if available")
    parser.add_argument("--train", action='store_true', help="Train model")
    parser.add_argument("--seed", type=int, nargs='?',default=5, help="Random seed")
    parser.add_argument("--lr", type=float, nargs="?", default=0.001, help="Learning rate")
    parser.add_argument("--bsize", type=int, nargs='?', default=256, help="Batchsize")
    parser.add_argument("--wbits", type=int, default=8, help="Weight bit width")
    parser.add_argument("--abits", type=int, default=8, help="Activation bit width")

    args = parser.parse_args()
    bsize = args.bsize
    random_seed = args.seed
    torch.manual_seed(random_seed)
    torch.cuda.manual_seed(random_seed)
    torch.cuda.manual_seed_all(random_seed)
    np.random.seed(random_seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False

    # Dataset parameter
    tf_dataset_labels = ['unknown','down', 'go', 'left', 'no', 'off', 'on', 'right', 'stop', 'up', 'yes'] #, 'silence'
    

    #class for preprocessed KWS data
    from torchvision import transforms
    from speechcommands_dataset import SpeechCommandsDataset
    from sklearn.utils import class_weight
    from sklearn.model_selection import train_test_split
    import numpy as np
    
    device = torch.device("cuda:"+str(args.gpu) if torch.cuda.is_available() else "cpu")
    print(device)
    model = KWS(weight_bit_width=args.wbits, act_bit_width=args.abits).to(device)


    #Load and split training data
    data        = np.load("data/kws_train_X.npy")
    labels      = np.load("data/kws_train_Y.npy")
    X_train, X_val, y_train, y_val = train_test_split(data, labels, test_size = 0.2, random_state=random_seed, stratify=labels)
    train_set   = SpeechCommandsDataset(X_train, y_train, transform=transforms.Compose([transforms.ToTensor()]))
    val_set     = SpeechCommandsDataset(X_val, y_val, transform=transforms.Compose([transforms.ToTensor()]))
    
    #Load test data
    data        = np.load("data/kws_test_X.npy")
    labels      = np.load("data/kws_test_Y.npy")
    test_set    = SpeechCommandsDataset(data, labels, transform=transforms.Compose([transforms.ToTensor()]))
    
    #get class weights
    class_weights= class_weight.compute_class_weight('balanced',classes=np.unique(y_train), y=y_train)
    class_weights= torch.tensor(class_weights,dtype=torch.float)

    # encapsulate data into dataloader form
    num_workers = 1
    train_loader = torch.utils.data.DataLoader(dataset=train_set, batch_size=bsize, shuffle=True, num_workers=num_workers)
    val_loader = torch.utils.data.DataLoader(dataset=val_set, batch_size=bsize, shuffle=False, num_workers=num_workers)
    test_loader = torch.utils.data.DataLoader(dataset=test_set, batch_size=bsize, shuffle=False, num_workers=num_workers)
    
    # Set your preferred loss function here
    error = torch.nn.CrossEntropyLoss(weight=class_weights).to(device)

    # Set your preferred optimizer
    optimizer = torch.optim.Adam(model.parameters(), lr=args.lr, weight_decay=1e-4)

    scheduler = torch.optim.lr_scheduler.StepLR(optimizer=optimizer, step_size=20, gamma=0.5)

    if args.train:
        highestAcc = 0.0
        loss_list = []
        val_accuracy_list = []
        train_accuracy_list = []

        start_time = time.time()

        for epoch in range(args.epochs):
            model.train()
            error.train()
            train_correct = 0
            train_total = 0
            for images, labels in train_loader:
                # Transfering images and labels to GPU if available
                images, labels = images.to(device), labels.to(device)
            
                prediction = model.forward(images)

                loss = error(prediction, labels)

                optimizer.zero_grad()   # Initializing a gradient as 0 so there is no mixing of gradient among the batches
                loss.backward()         #Propagating the error backward
                optimizer.step()        # Optimizing the parameters
                # model.clip_weights(-1,1)  # Clip weights (if necessary)
                with torch.no_grad():
                    pred = prediction.argmax(1, keepdim=True)
                    train_correct += pred.eq(labels.data.view_as(pred)).sum().item()
                    train_total += images.size(0)

            
            scheduler.step()
            train_acc = (train_correct * 100.0) / train_total
            train_accuracy_list.append(train_acc)
            
            # Validation
            total   = 0
            correct = 0
            val_loss    = 0

            model.eval()
            error.eval()
            with torch.no_grad():
                for images, labels in val_loader:
                    images, labels = images.to(device), labels.to(device)
                        
                    prediction = model.forward(images)
                    val_loss += error(prediction, labels).item()

                    pred = prediction.argmax(1, keepdim=True)
                    correct += pred.eq(labels.data.view_as(pred)).sum().item()
                    total += images.size(0)
            
                val_loss /= len(val_loader)

            accuracy = correct * 100 / total
            loss_list.append(val_loss)
            val_accuracy_list.append(accuracy)

            if accuracy > highestAcc:
                highestAcc = accuracy
                torch.save(obj = model.state_dict(), f = "models/"+args.filename+".pt")

            print(f"Epoch: {epoch}, Loss: {val_loss:.4f}, Train Acc: {train_acc:.2f}%, Val Acc: {accuracy:.2f}%")



        elapsed_time = time.time() - start_time
        print("-" * 50)
        print(f"Total Training Time: {elapsed_time/60:.2f} minutes")

        model_size = os.path.getsize("models/"+args.filename+".pt") / (1024 * 1024)
        print(f"Model Size: {model_size:.2f} MB")
        print(f"Best Validation Accuracy: {highestAcc:.2f}%")
        print("-" * 50)
        

        # Accuracy Plot
        plt.figure(figsize=(10, 5))
        plt.plot(train_accuracy_list, label='Training Accuracy')
        plt.plot(val_accuracy_list, label='Validation Accuracy')
        plt.title(f'Model Accuracy ({args.wbits}-bit W / {args.abits}-bit A)')
        plt.ylabel('Accuracy (%)')
        plt.xlabel('Epoch')
        plt.legend(loc='lower right')
        plt.tight_layout()
        plt.savefig("models/"+args.filename+"_accuracy_plot.png")
        print(f"Accuracy plot saved to models/{args.filename}_accuracy_plot.png")


        #brevitas onnx export
        model.load_state_dict(torch.load("models/"+args.filename+".pt", map_location=torch.device('cpu')))
        model.eval()
        input_tensor = torch.randn(1, 1, 1, 490)
        bo.export_qonnx(model, input_tensor, "models/"+args.filename+'.onnx')


        onnx_model_size = os.path.getsize("models/"+args.filename+'.onnx') / (1024 * 1024)
        print("-" * 50)
        print(f"ONNX Deployment Model Size: {onnx_model_size:.2f} MB")
        print("-" * 50)
    else:
        # Testing the model
        total   = 0
        correct = 0
        test_loss    = 0.0
        model.load_state_dict(torch.load("models/"+args.filename+".pt", map_location=device))
        model.eval()
        error.eval()
        with torch.no_grad():
            for images, labels in test_loader:
                images, labels = images.to(device), labels.to(device)
                
                prediction = model.forward(images)
                
                test_loss += error(prediction, labels).item()

                pred = prediction.argmax(1, keepdim=True)
                correct += pred.eq(labels.data.view_as(pred)).sum().item()
            
                total += images.size(0)

            test_loss /= len(test_loader)

        accuracy = correct * 100 / total
        print(f"Test Loss: {test_loss:.4f}, Test Accuracy: {accuracy:.2f}%")

