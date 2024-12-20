#!/bin/bash
. /home/lemp.conf
. /tmp/change_php_config

###Imagick & Zend Opcache
if [ "$imagickstatus" == "1" ]; then
echo "install imagick..."
yum -y install ImageMagick ImageMagick-devel ImageMagick-c++ ImageMagick-c++-devel
echo "pecl install imagick..."
yes "" | pecl install imagick

if [ ! -f /home/$mainsite/private_html/check-imagick.php ]; then
cp -r /etc/lemp/menu/inc/check-imagick.php.zip /home/$mainsite/private_html/check-imagick.php
fi

php_version=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

if [ "$php_version" == "5.4" ]; then
duongdanimagick=$(find / -name 'imagick.so' | grep php/modules/imagick.so)
echo "extension=$duongdanimagick" >> /etc/php.d/imagick.ini
else

# neu cai dat thanh cong imagick -> include vao
if [ -f /usr/lib64/php/modules/imagick.so ]; then
echo "extension=imagick.so" > /etc/php.d/imagick.ini
else
rm -rf /etc/php.d/imagick.ini
fi

fi
fi
