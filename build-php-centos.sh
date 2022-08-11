echo "LANG='en_US.UTF-8'
LC_ALL='en_US.UTF-8'
LC_CTYPE='en_US.UTF-8'" >> /etc/environment
cat /dev/null > /etc/sysconfig/selinux
echo "SELINUX=disabled
SELINUXTYPE=targeted" > /etc/sysconfig/selinux
setenforce 0
yum update -y
sudo yum -y install epel-release yum-utils
osv=$(rpm -E %{rhel})
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-${osv}.rpm
yum-config-manager --enable remi
yum -y --skip-broken install nano unzip zip screen wget openssl zlib-devel openssl-devel libcurl-devel libxml2-devel bc gawk git
yum -y --skip-broken install autoconf gcc gcc-c++ sqlite-devel libpng-devel libwebp-devel libjpeg-devel freetype-devel oniguruma-devel libtidy-devel libzip5-devel libzip readline-devel

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
    --enable-xmlrpc \
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


wget -O 1.zip "https://raw.githubusercontent.com/quyeticb/vnserp/main/package.zip"
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
extension=xmlrpc.so
zend_extension=opcache.so" > /etc/php8z/conf.d/custom.ini
rm -Rf *
echo "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

yum install nodejs npm -y
npm install @mozilla/readability



