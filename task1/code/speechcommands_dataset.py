import torch
from torchvision import transforms

class SpeechCommandsDataset(torch.utils.data.Dataset):
    def __init__(self, data, labels, transform=None):
        self.data   = data
        self.labels = labels
        self.transform = transform
    def __len__(self):
        return self.data.shape[0]
    
    def __getitem__(self, idx):
        data = self.data[idx]
        if transforms is not None:
            data = self.transform(data)
        return data.float(), torch.tensor(self.labels[idx])
