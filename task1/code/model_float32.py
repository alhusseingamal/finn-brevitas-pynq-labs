import os
import torch
from torch.nn import Module
import torch.nn.functional as F
import torch.nn as nn
import torchvision.transforms as transforms
import argparse
import numpy as np
import brevitas.export as bo
import time
import matplotlib.pyplot as plt

class KWS_Float(Module):
    def __init__(self):

        super(KWS_Float, self).__init__()
        
        # TODO: Your model definition here:
        self.conv1 = torch.nn.Conv2d(in_channels=1,out_channels=32,kernel_size=(3,3),padding=(1,1))
        self.bn1 = nn.BatchNorm2d(32)

        self.conv2 = torch.nn.Conv2d(in_channels=32,out_channels=64,kernel_size=(3,3),padding=(1,1))
        self.bn2 = nn.BatchNorm2d(64)

        self.conv3 = torch.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=(3,3), padding=(1,1))
        self.bn3 = nn.BatchNorm2d(64)

        self.pool = torch.nn.MaxPool2d(kernel_size=(2,2), stride=(2,2))

        self.fc0 = torch.nn.Linear(in_features=64*2*12, out_features=128) 
        self.fc1 = torch.nn.Linear(in_features=128, out_features=11)

        self.relu = torch.nn.ReLU()
        self.dropout = torch.nn.Dropout(p=0.3)
        
    def forward(self,x):
        # TODO: Your forward pass here

        x = x.view(x.shape[0], 1, 10, 49)

        x = self.conv1(x)
        x = self.bn1(x)
        x = self.relu(x)
        x = self.pool(x)            # (B,32,5,24)

        x = self.conv2(x)
        x = self.bn2(x)
        x = self.relu(x)
        x = self.pool(x)            # (B,64,2,12)

        x = self.conv3(x)
        x = self.bn3(x)
        x = self.relu(x)

        x = x.view(x.shape[0], -1)  # flatten -> 1536

        x = self.dropout(x)
        x = self.fc0(x)
        x = self.relu(x)
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

    args = parser.parse_args()
    bsize = args.bsize
    random_seed = args.seed
    torch.manual_seed(random_seed)
    torch.cuda.manual_seed(random_seed)
    torch.cuda.manual_seed_all(random_seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False

    # Dataset parameter
    tf_dataset_labels = ['unknown','down', 'go', 'left', 'no', 'off', 'on', 'right', 'stop', 'up', 'yes']
    

    #class for preprocessed KWS data
    from torchvision import transforms
    from speechcommands_dataset import SpeechCommandsDataset
    from sklearn.model_selection import train_test_split
    import numpy as np
    from sklearn.utils import class_weight
    
    if torch.cuda.is_available():
        major, minor = torch.cuda.get_device_capability()
        supported = torch.cuda.get_arch_list()
        gpu_arch = f"sm_{major}{minor}"

        if gpu_arch in supported:
            device = torch.device("cuda")
        else:
            print(f"GPU {gpu_arch} not supported by this PyTorch build. Falling back to CPU.")
            device = torch.device("cpu")
    else:
        device = torch.device("cpu")

    print(device)
    model = KWS_Float().to(device)


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
    
    num_workers=1
    train_loader    = torch.utils.data.DataLoader(dataset=train_set,    batch_size=bsize, shuffle=True, num_workers=num_workers, pin_memory=True)
    val_loader      = torch.utils.data.DataLoader(dataset=val_set,      batch_size=bsize, shuffle=False, num_workers=num_workers, pin_memory=True)
    test_loader     = torch.utils.data.DataLoader(dataset=test_set,     batch_size=bsize, shuffle=False, num_workers=num_workers, pin_memory=True)
    
    #get class weights
    class_weights= class_weight.compute_class_weight('balanced',classes=np.unique(y_train), y=y_train)
    class_weights= torch.tensor(class_weights,dtype=torch.float)
    
    # Set your preferred loss function here
    error = torch.nn.CrossEntropyLoss(weight=class_weights).to(device)

    # Set your preferred optimizer
    optimizer = torch.optim.Adam(model.parameters(), lr=args.lr, weight_decay=1e-4)

    # Use a scheduler
    scheduler = torch.optim.lr_scheduler.StepLR(optimizer=optimizer, step_size=20, gamma=0.5)


    if args.train:
        highestAcc = 0.0 # FIX: Pure python float
        loss_list = []
        accuracy_list = []
        train_accuracy_list = [] 

        start_time = time.time() 
        
        for epoch in range(args.epochs):
            model.train()
            error.train()
            
            # Variables to track training accuracy
            train_correct = 0
            train_total = 0
            
            for images, labels in train_loader:
                images, labels = images.to(device), labels.to(device)
            
                prediction = model.forward(images)

                loss = error(prediction, labels)
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

                # Calculate training accuracy for this batch
                with torch.no_grad():
                    pred = prediction.data.argmax(1, keepdim=True)
                    train_correct += pred.eq(labels.data.view_as(pred)).sum().item()
                    train_total += images.size(0)
            
            scheduler.step()
            
            train_accuracy = train_correct * 100 / train_total
            train_accuracy_list.append(train_accuracy)
            
            # Testing the model
            total   = 0
            correct = 0
            loss    = 0

            model.eval()
            error.eval()
            with torch.no_grad():
                for images, labels in val_loader:
                    images, labels = images.to(device), labels.to(device)
                        
                    prediction = model.forward(images)
                    
                    loss += error(prediction, labels).item()

                    pred = prediction.data.argmax(1, keepdim=True)
                    correct += pred.eq(labels.data.view_as(pred)).sum().item()
                
                    total += images.size(0)
                
                loss /= len(val_loader)
            accuracy = correct * 100 / total
            loss_list.append(loss)
            accuracy_list.append(accuracy)

            if accuracy > highestAcc:
                highestAcc = accuracy
                torch.save(obj = model.state_dict(), f = "models/"+args.filename+".pt")

            print("Epoch: {}, Loss: {:.4f}, Train Acc: {:.2f}%, Val Acc: {:.2f}%".format(epoch, loss, train_accuracy, accuracy))

        end_time = time.time()
        elapsed_time = end_time - start_time
        print("-" * 50)
        print(f"Total Training Time: {elapsed_time/60:.2f} minutes")
        
        model_size = os.path.getsize("models/"+args.filename+".pt") / (1024 * 1024)
        print(f"Model Size: {model_size:.2f} MB")
        print(f"Best Validation Accuracy: {highestAcc:.2f}%")
        print("-" * 50)

        plt.figure(figsize=(10, 5))
        plt.plot(train_accuracy_list, label='Training Accuracy')
        plt.plot(accuracy_list, label='Validation Accuracy')
        plt.title('Model Accuracy')
        plt.ylabel('Accuracy (%)')
        plt.xlabel('Epoch')
        plt.legend(loc='lower right')
        plt.savefig("models/"+args.filename+"_accuracy_plot.png")
        print(f"Accuracy plot saved to models/{args.filename}_accuracy_plot.png")

        #brevitas onnx export
        model.load_state_dict(torch.load("models/"+args.filename+".pt", map_location=torch.device('cpu')))
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
        loss    = 0
        loss_list = []
        accuracy_list = []
        model.load_state_dict(torch.load("models/"+args.filename+".pt", map_location=device))
        model.eval()
        error.eval()
        with torch.no_grad():
            for images, labels in test_loader:
                images, labels = images.to(device), labels.to(device)
                
                prediction = model.forward(images)
                
                loss += error(prediction, labels).item()

                pred = prediction.data.argmax(1, keepdim=True)
                correct += pred.eq(labels.data.view_as(pred)).sum().item()
            
                total += images.size(0)

            loss /= len(test_loader)
        accuracy = correct * 100 / total
        accuracy_list.append(accuracy)
        print("Loss: {}, Accuracy: {}%".format(loss, accuracy))
