#!bin/bash
echo "LANG='en_US.UTF-8'
LC_ALL='en_US.UTF-8'
LC_CTYPE='en_US.UTF-8'" >> /etc/environment
cat /dev/null > /etc/sysconfig/selinux
echo "SELINUX=disabled
SELINUXTYPE=targeted" > /etc/sysconfig/selinux
setenforce 0
#yum update -y
sudo yum -y install epel-release yum-utils
osv=$(rpm -E %{rhel})
read -p "Your Centos version is $osv. Enter to continue..."
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-${osv}.rpm
yum-config-manager --enable remi
yum-config-manager --enable remi-php80
yum -y install sshpass unzip exim zip screen wget nano openssl ntpdate zlib-devel openssl-devel libcurl-devel libxml2-devel redis wget bc gawk git wget unzip ntpdate bc

if [ $osv == 7 ];
	then
	yum -y install nano wget nginx redis php-fpm php-common php-bcmath php-imap php-devel php-pear php-xmlrpc php-tidy php-solr php-apcu php-redis php-gd php-mysqlnd php-pdo php-xml php-mbstring php-mcrypt php-curl php-opcache php-cli php-pecl-zip
elif
	yum -y install nano wget nginx redis php-fpm php-common php-bcmath php-devel php-pear php-tidy php-apcu php-redis php-gd php-mysqlnd php-pdo php-xml php-mbstring php-curl php-opcache php-cli php-pecl-zip
	pecl install channel://pecl.php.net/xmlrpc-1.0.0RC3
	echo "extension=xmlrpc.so" >> /etc/php.d/custom.ini
	yum -y install sshpass unzip exim zip screen wget nano openssl zlib-devel openssl-devel libcurl-devel libxml2-devel redis wget bc gawk git wget unzip bc
	echo | pecl install solr
	echo "extension=solr.so" >> /etc/php.d/custom.ini
fi

git clone https://github.com/pmmp/pthreads.git
cd pthreads
zts-phpize
./configure --with-php-config=/usr/bin/zts-php-config
make && make install
echo "extension=pthreads.so" > /etc/php-zts.d/pthreads.ini
cd
wget https://getcomposer.org/installer
php installer
mv composer.phar /usr/bin/composer



