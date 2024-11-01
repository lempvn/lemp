#!/bin/bash
. /tmp/change_php_config

## Ioncube 
if [ "$ioncubestatus" = "1" ]; then

#if [ ! -d /usr/local/ioncube ]; then
mkdir -p /usr/local/ioncube
#fi

#wget --no-check-certificate -q -O - https://github.com/vpsvn/vps-vps-software/raw/master/ioncube_loaders_lin_x86-64_BETA.tar.gz | tar -xzf - -C /usr/local/ioncube
#rm -r -f /root/ioncube_loaders_lin_x86-64_BETA.tar.gz

echo "Download ioncube..."
wget --no-check-certificate -q -O - https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz | tar -xzf - -C /usr/local/ioncube
rm -rf /root/ioncube_loaders_lin_x86-64.tar.gz

rm -rf /etc/php.d/*.ioncube.*
rm -rf /etc/php.d/ioncube.*
#ioncube

php_version=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

if [ -f /usr/local/ioncube/ioncube_loader_lin_${php_version}.so ]; then
cat > "/etc/php.d/ioncube.ini" <<END
zend_extension=/usr/local/ioncube/ioncube_loader_lin_${php_version}.so
END
elif [ -f /usr/local/ioncube/ioncube/ioncube_loader_lin_${php_version}.so ]; then
cat > "/etc/php.d/ioncube.ini" <<END
zend_extension=/usr/local/ioncube/ioncube/ioncube_loader_lin_${php_version}.so
END
fi

fi

#clear
