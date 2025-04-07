cd /home/cc
mkdir team20

cd /home/cc/team20
python3 -m venv py310
source /home/cc/team20/py310/bin/activate
pip install --upgrade pip

mkdir /home/cc/team20/data
cd /home/cc/team20/data

wget https://dax-cdn.cdn.appdomain.cloud/dax-fintabnet/1.0.0/fintabnet.tar.gz

tar xzf fintabnet.tar.gz

# Model
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126
pip install ipython pandas tensorboard
pip install PyMuPDF pdfplumber tqdm editdistance packaging pycocotools scipy jupyterlab
# OCR
pip install pytesseract pickleshare
# Frontend
pip install connexion[flask] connexion[swagger-ui] swagger-ui-bundle uvicorn

mkdir -p /home/cc/team20/proj/git
cd /home/cc/team20/proj/git
git clone https://github.com/microsoft/table-transformer.git

cp /home/cc/team20/proj/git/CS584/model_code/table-transformer/scripts/*.py /home/cc/team20/proj/git/table-transformer/scripts/
cp /home/cc/team20/proj/git/CS584/model_code/table-transformer/src/*.py /home/cc/team20/proj/git/table-transformer/src/

bash /home/cc/team20/proj/git/CS584/deployment/modify_import.sh /home/cc/team20/proj/git/table-transformer/src/eval.py
bash /home/cc/team20/proj/git/CS584/deployment/modify_import.sh /home/cc/team20/proj/git/table-transformer/src/inference.py
bash /home/cc/team20/proj/git/CS584/deployment/modify_import.sh /home/cc/team20/proj/git/table-transformer/src/main.py

# tensorboard
sudo firewall-cmd --zone=public --add-port=6006/tcp
# Swagger UI
sudo firewall-cmd --zone=public --add-port=8085/tcp
# jupyterlab
sudo firewall-cmd --zone=public --add-port=9001/tcp

cd /home/cc/team20/proj/git/table-transformer
python scripts/generate_tiny_fintabnet.py --data_dir /home/cc/team20/data/fintabnet --output_dir /home/cc/team20/data/tiny_fintabnet

cd /home/cc/team20/proj/git/table-transformer
python scripts/process_fintabnet.py --data_dir /home/cc/team20/data/tiny_fintabnet --output_dir /home/cc/team20/data/tiny_fintabnet_database

cd /home/cc/team20/proj/git/table-transformer
python scripts/generate_page_images.py --data_dir /home/cc/team20/data/tiny_fintabnet_database/FinTabNet.c_Image_Structure_PASCAL_VOC --pdf_dir /home/cc/team20/data/tiny_fintabnet/pdf --output_dir /home/cc/team20/data/tiny_fintabnet_database

# Download models
mkdir /home/cc/team20/models
wget -P /home/cc/team20/models https://huggingface.co/bsmock/tatr-pubtables1m-v1.0/resolve/main/pubtables1m_detection_detr_r18.pth
wget -P /home/cc/team20/models https://huggingface.co/bsmock/TATR-v1.1-Fin/resolve/main/TATR-v1.1-Fin-msft.pth

# cd /home/cc/team20/proj/git
# git clone https://github.com/fatehali10/CS584.git

# Launch Server:
# screen -S service
# source /home/cc/team20/py310/bin/activate
# cd /home/cc/team20/proj/git/CS584/frontend_code
# python -m swagger_server
# exit with keyboard: Ctrl+A+D
# Client access:
# http://192.5.87.132:8085/ui
