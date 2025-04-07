# CS584

## Requirements

One GPU Server from Chameleon Cloud https://www.chameleoncloud.org/

- GPU Type: RTX 6000
- Server Host OS: CC-Ubuntu22.04-CUDA-20241028 
- Server Host Type: baremetal

## Deployment

### 1. Installation

Note: It takes about 3 hours to complete installation due to training data preprocessing and OCR model dependency installation.

```
ssh $server_ip

screen -S deployment
mkdir -p /home/cc/team20/proj/git
cd /home/cc/team20/proj/git
git clone https://github.com/fatehali10/CS584.git

cd /home/cc/team20/proj/git/CS584/deployment
bash install.sh
bash install_leptonica.sh  
bash install_tesseract-ocr.sh

# exit with keyboard: Ctrl+A+D
```

### 2. Launch server

```
screen -S service
source /home/cc/team20/py310/bin/activate
cd /home/cc/team20/proj/git/CS584/frontend_code
python -m swagger_server
# exit with keyboard: Ctrl+A+D
```

### 3. Client Access

```
# Navigate to http://{server_ip}:8085/ui
```

## Model Training

```
source /home/cc/team20/py310/bin/activate
cd /home/cc/team20/proj/git/table-transformer/src/
python main.py --data_type structure --config_file structure_config.json --data_root_dir /home/cc/team20/data/tiny_fintabnet_database/FinTabNet.c_Image_Structure_PASCAL_VOC --model_load_path /home/cc/team20/models/TATR-v1.1-Fin-msft.pth --load_weights_only --epochs 10

```

## Optional: Jupyter Notebook

```
ssh $server_ip

source /home/cc/team20/py310/bin/activate
mkdir -p /home/cc/team20/proj/run_experiment
cd /home/cc/team20/proj/run_experiment
jupyter lab --ip 0.0.0.0 --port 9001
```



