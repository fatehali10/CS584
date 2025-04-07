sudo apt-get -y install autoconf automake libtool pkg-config libtiff-dev

mkdir -p /home/cc/team20/proj/leptonica
cd /home/cc/team20/proj/leptonica
wget https://github.com/DanBloomberg/leptonica/releases/download/1.85.0/leptonica-1.85.0.tar.gz
tar xzf leptonica-1.85.0.tar.gz
cd /home/cc/team20/proj/leptonica/leptonica-1.85.0
./configure --prefix=/home/cc/team20/proj/leptonica_install
make && make install
