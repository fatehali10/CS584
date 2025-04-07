if [ ! -d /home/cc/team20/proj/tesseract-ocr ]
then
    mkdir -p /home/cc/team20/proj/tesseract-ocr
fi

cd /home/cc/team20/proj/tesseract-ocr

if [ ! -d /home/cc/team20/proj/tesseract-ocr/tesseract-5.5.0 ]
then
    wget https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.5.0.tar.gz -O tesseract-5.5.0.tar.gz
    tar xf tesseract-5.5.0.tar.gz
fi

cd /home/cc/team20/proj/tesseract-ocr/tesseract-5.5.0

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/cc/team20/proj/leptonica_install/lib
export LIBLEPT_HEADERSDIR=/home/cc/team20/proj/leptonica_install/include/leptonica
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/cc/team20/proj/leptonica_install/lib/pkgconfig

./autogen.sh
./configure --prefix=/home/cc/team20/proj/tesseract-ocr_install --with-extra-libraries=/home/cc/team20/proj/leptonica_install/lib
make && make install

wget -P /home/cc/team20/proj/tesseract-ocr_install/share/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/4.00/eng.traineddata
