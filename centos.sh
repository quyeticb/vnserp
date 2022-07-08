#!bin/bash
echo "LANG='en_US.UTF-8'
LC_ALL='en_US.UTF-8'
LC_CTYPE='en_US.UTF-8'" >> /etc/environment
cat /dev/null > /etc/sysconfig/selinux
echo "SELINUX=disabled
SELINUXTYPE=targeted" > /etc/sysconfig/selinux
setenforce 0
yum update -y
sudo yum -y install epel-release yum-utils
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum-config-manager --enable remi
yum-config-manager --enable remi-php80
yum -y install nano wget nginx redis php-fpm php-common php-imap php-bcmath php-devel php-pear php-xmlrpc php-tidy php-solr php-apcu php-redis php-gd php-mysqlnd php-pdo php-xml php-mbstring php-mcrypt php-curl php-opcache php-cli php-pecl-zip
yum -y install sshpass unzip exim zip screen wget nano openssl ntpdate zlib-devel openssl-devel libcurl-devel libxml2-devel redis wget bc gawk git wget unzip ntpdate bc
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
rm -f installer
rm -Rf pthreads
mkdir ~/.ssh
echo "StrictHostKeyChecking=no" > ~/.ssh/config
service sshd restart
systemctl enable nginx.service
systemctl enable php-fpm.service
systemctl enable redis
mkdir -p /home/default/public_html
mkdir /home/default/private_html
mkdir /home/default/logs
chmod 777 /home/default/logs
mkdir -p /var/log/nginx
chown -R nginx:nginx /var/log/nginx
chown -R nginx:nginx /var/lib/php/session
echo "<?php echo '403'; ?>" > /home/default/public_html/index.php
systemctl start nginx.service
systemctl start php-fpm.service
yum -y install nginx-module-geoip
# Config system
echo "* soft nofile 262144
* hard nofile 262144
nginx soft nofile 262144
nginx hard nofile 262144
nobody soft nofile 262144
nobody hard nofile 262144
root soft nofile 262144
root hard nofile 262144
solr soft nproc 65535
solr hard nproc 65535" > /etc/security/limits.conf
echo 1999999 > /proc/sys/kernel/threads-max
echo 1999999 > /proc/sys/kernel/pid_max
echo 1999999 > /proc/sys/vm/max_map_count
echo "net.core.somaxconn = 65535
kernel.shmmax=200000000
kernel.shmall=50000" >> /etc/sysctl.conf
mkdir -p /var/lib/php/session
chown -R nginx:nginx /var/lib/php
chown nginx:nginx /home/default
chown -R nginx:nginx /home/*/public_html
chown -R nginx:nginx /home/*/private_html
total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ram_conf=$(echo "$total/2000000" | bc)
echo "date.timezone = America/New_York
max_execution_time = 180
short_open_tag = On
realpath_cache_size = 640k
realpath_cache_ttl = 86400
memory_limit = 4096M
upload_max_filesize = 256M
post_max_size = 256M
expose_php = Off
mail.add_x_header = Off
max_input_nesting_level = 128
max_input_vars = 2000
mysqlnd.net_cmd_buffer_size = 16384
always_populate_raw_post_data=-1
disable_functions=shell_exec" > /etc/php.d/custom.ini
echo "zend_extension=opcache.so
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=1024
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=100000
opcache.max_wasted_percentage=5
opcache.use_cwd=1
opcache.validate_timestamps=0
opcache.revalidate_freq=0
opcache.fast_shutdown=1
opcache.blacklist_filename=/etc/php.d/opcache-default.blacklist" > /etc/php.d/*opcache*.ini
echo "<?php
\$start=microtime(true);
phpinfo();
echo microtime(true)-\$start;" > /home/default/public_html/quyet-info.php
yum install -y firewalld
systemctl restart firewalld.service
firewall-cmd --permanent --add-service=http --add-service=https
firewall-cmd --reload

wget https://github.com/quyeticb/vnserp/raw/main/2.6.zip -O vnserp.zip
unzip vnserp.zip
mv package vnserp
rm -f vnserp.zip




