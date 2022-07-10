apt update -y
apt upgrade -y
sudo apt install -y build-essential pkg-config autoconf bison re2c libxml2-dev
sudo apt install -y libssl-dev libsqlite3-dev libcurl4-openssl-dev libpng-dev libjpeg-dev
sudo apt install -y libonig-dev libfreetype6-dev libzip-dev libtidy-dev libwebp-dev
sudo apt install -y libreadline-dev

VERSION=8.0.3
wget -qO- https://www.php.net/distributions/php-${VERSION}.tar.gz | tar -xz
cd php-${VERSION}/ext
git clone --depth=1 https://github.com/pmmp/pthreads.git
cd ..
./buildconf --force
./configure \
    --prefix=/etc/php8z \
    --with-config-file-path=/etc/php8z \
    --with-config-file-scan-dir=/etc/php8z/conf.d \
    --disable-cgi \
    --with-zlib \
    --with-zip \
    --with-openssl \
    --with-curl \
    --enable-mysqlnd \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --enable-pcntl \
    --enable-gd \
    --enable-exif \
    --with-jpeg \
    --with-freetype \
    --with-webp \
    --enable-bcmath \
    --enable-mbstring \
    --enable-calendar \
    --with-tidy \
    --enable-zts \
    --enable-pthreads \
    --with-readline=/usr/include/readline

make -j$(nproc)
make install

sudo cp php.ini-development /etc/php8z/php.ini
sudo ln -s /etc/php8z/bin/php /usr/bin/phpz
sudo mkdir /etc/php8z/conf.d
wget http://pear.php.net/go-pear.phar
phpz go-pear.phar
ln -sf /etc/php8z/bin/pecl /usr/bin/pecl
pecl install channel://pecl.php.net/xmlrpc-1.0.0RC3

wget -O 1.zip "https://raw.githubusercontent.com/quyeticb/vnserp/main/2.6.zip"
unzip 1.zip
mv package /opt/vnserp
sudo echo "phpz /opt/vnserp/tool.php" > /usr/bin/vnserp
chmod 777 /usr/bin/vnserp


git clone https://github.com/php/pecl-search_engine-solr.git
cd pecl-search_engine-solr
/etc/php8z/bin/phpize
./configure --with-php-config=/etc/php8z/bin/php-config
make && make install
echo "extension=solr
extension=xmlrpc.so" > /etc/php8z/conf.d/custom.ini
rm -Rf *

