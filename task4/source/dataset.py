import os
import csv
import urllib.request
import zipfile
import numpy as np
from PIL import Image

NUM_CLASSES = 43

GTSRB_MEAN = [0.3337, 0.3064, 0.3171]
GTSRB_STD  = [0.2672, 0.2564, 0.2629]

TRAIN_URL   = "https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Training_Images.zip"
TEST_URL    = "https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Test_Images.zip"
TEST_GT_URL = "https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/GTSRB_Final_Test_GT.zip"

def download_and_extract(url, dest_dir):
    os.makedirs(dest_dir, exist_ok=True)
    zip_path = os.path.join(dest_dir, os.path.basename(url))
    flag = zip_path + ".extracted"
    if not os.path.exists(zip_path):
        print(f"Downloading {os.path.basename(url)} ...")
        urllib.request.urlretrieve(url, zip_path)
    if not os.path.exists(flag):
        print(f"Extracting {os.path.basename(url)} ...")
        with zipfile.ZipFile(zip_path) as zf:
            zf.extractall(dest_dir)
        open(flag, 'w').close()

class GTSRBDataset:
    """
    Pure NumPy/PIL implementation of the GTSRB dataset.
    No PyTorch dependency, making it directly usable on the board.
    """
    def __init__(self, data_dir="./data", split="train", img_size=32, download=True):
        self.data_dir = data_dir
        self.split = split
        self.img_size = img_size

        if download:
            if split == "train":
                download_and_extract(TRAIN_URL, data_dir)
            elif split == "test":
                download_and_extract(TEST_URL, data_dir)
                download_and_extract(TEST_GT_URL, data_dir)

        self.samples = self._parse_samples()

    def _parse_samples(self):
        samples = []
        if self.split == "train":
            train_root = os.path.join(self.data_dir, "GTSRB", "Final_Training", "Images")
            for cid in range(NUM_CLASSES):
                class_dir = os.path.join(train_root, f"{cid:05d}")
                csv_path  = os.path.join(class_dir,  f"GT-{cid:05d}.csv")
                if not os.path.exists(csv_path):
                    continue
                with open(csv_path, newline="") as f:
                    for row in csv.DictReader(f, delimiter=";"):
                        ip = os.path.join(class_dir, row["Filename"])
                        if os.path.exists(ip):
                            samples.append((ip,
                                            int(row["Roi.X1"]), int(row["Roi.Y1"]),
                                            int(row["Roi.X2"]), int(row["Roi.Y2"]),
                                            int(row["ClassId"])))
        else:  # test split
            test_root = os.path.join(self.data_dir, "GTSRB", "Final_Test", "Images")
            csv_path = None
            for root, _, files in os.walk(self.data_dir):
                for f in files:
                    if f == "GT-final_test.csv":
                        csv_path = os.path.join(root, f)
                        break
            if csv_path is None or not os.path.exists(csv_path):
                return []
            with open(csv_path, newline="") as f:
                for row in csv.DictReader(f, delimiter=";"):
                    ip = os.path.join(test_root, os.path.basename(row["Filename"]))
                    if os.path.exists(ip):
                        samples.append((ip,
                                        int(row["Roi.X1"]), int(row["Roi.Y1"]),
                                        int(row["Roi.X2"]), int(row["Roi.Y2"]),
                                        int(row["ClassId"])))
        return samples

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        ip, x1, y1, x2, y2, cls = self.samples[idx]
        img = Image.open(ip).convert("RGB")
        img_cropped = img.crop((x1, y1, x2, y2))
        img_resized = img_cropped.resize((self.img_size, self.img_size), Image.BILINEAR)
        img_np = np.array(img_resized, dtype=np.uint8)
        return img_np, cls

# Try loading PyTorch to define the helper function and dataset wrapper for training.
# On the board, this try block will gracefully fail, allowing the board to use the pure Numpy class above.
try:
    import torch
    from torch.utils.data import Dataset as TorchDataset, random_split
    import torchvision.transforms as transforms

    class GTSRBTorchDataset(TorchDataset):
        def __init__(self, numpy_dataset, transform=None):
            self.numpy_dataset = numpy_dataset
            self.transform = transform

        def __len__(self):
            return len(self.numpy_dataset)

        def __getitem__(self, idx):
            img_np, label = self.numpy_dataset[idx]
            img_pil = Image.fromarray(img_np)
            if self.transform:
                img_tensor = self.transform(img_pil)
            else:
                img_tensor = transforms.ToTensor()(img_pil)
            return img_tensor, label

    def get_gtsrb_datasets(data_dir="./data", img_size=32, val_split=0.15):
        train_transform = transforms.Compose([
            transforms.ColorJitter(brightness=0.4, contrast=0.3, saturation=0.2),
            transforms.RandomRotation(10),
            transforms.ToTensor(),
            transforms.Normalize(GTSRB_MEAN, GTSRB_STD)
        ])
        
        test_transform = transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize(GTSRB_MEAN, GTSRB_STD)
        ])
        
        # Load raw numpy dataset (default implementation)
        raw_train = GTSRBDataset(data_dir=data_dir, split="train", img_size=img_size, download=True)
        raw_test = GTSRBDataset(data_dir=data_dir, split="test", img_size=img_size, download=True)
        
        # Split train & val indices
        val_len = int(len(raw_train) * val_split)
        train_len = len(raw_train) - val_len
        
        generator = torch.Generator().manual_seed(42)
        train_subset, val_subset = random_split(
            raw_train, 
            [train_len, val_len],
            generator=generator
        )
        
        # Wrap Subsets and test set in Torch wrappers
        train_dataset = GTSRBTorchDataset(train_subset, train_transform)
        val_dataset = GTSRBTorchDataset(val_subset, test_transform)
        test_dataset = GTSRBTorchDataset(raw_test, test_transform)
        
        return train_dataset, val_dataset, test_dataset

except ImportError:
    pass
