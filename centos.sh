#!/bin/bash
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
yum -y install nano unzip zip screen wget openssl zlib-devel openssl-devel libcurl-devel libxml2-devel bc gawk git


if [ $osv == 7 ];
	then
	yum-config-manager --enable remi-php80
	yum -y install nginx php-fpm php-common php-bcmath php-imap php-devel php-pear php-xmlrpc php-tidy php-solr php-apcu php-redis php-gd php-mysqlnd php-pdo php-xml php-mbstring php-mcrypt php-curl php-opcache php-cli php-pecl-zip
else
	sudo dnf module enable php:remi-8.0 -y
	yum -y install nginx php-fpm php-common php-bcmath php-devel php-pear php-tidy php-apcu php-redis php-gd php-mysqlnd php-pdo php-xml php-mbstring php-curl php-opcache php-cli php-pecl-zip php-xmlrpc php-solr
fi

git clone https://github.com/pmmp/pthreads.git
cd pthreads
zts-phpize
./configure --with-php-config=/usr/bin/zts-php-config
make && make install
echo "extension=pthreads.so" > /etc/php-zts.d/pthreads.ini
cd
rm -Rf pthreads

