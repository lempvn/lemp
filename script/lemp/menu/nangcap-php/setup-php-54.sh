#!/bin/bash
. /home/lemp.conf
phphientai=$(php -r "echo PHP_MAJOR_VERSION.''.PHP_MINOR_VERSION;")
php_version1=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
if [ "$php_version1" == "5.4" ]; then
clear
echo "========================================================================="
echo "Phien ban PHP hien tai: $(php -i | grep 'PHP Version' | awk 'NR==1 {print $4}') "
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
exit
fi
echo "========================================================================="
echo "Sau khi PHP ve phien ban 5.4, PHPmyadmin se duoc chuyen ve 4.4.15"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon su dung PHP phien ban 5.4 ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "Ok ! please wait ...."
sleep 1
/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini

mkdir -p /root/updown
yes | cp -rf /etc/php-fpm.conf /root/updown/
if [ -f /etc/php.d/opcache.bak ]; then
yes | cp -rf /etc/php.d/opcache.bak /root/updown/
fi
if [ -f /etc/php.d/opcache.ini ]; then
yes | cp -rf /etc/php.d/opcache.ini /root/updown/
fi
yes | cp -rf /etc/php.ini /root/updown/
yes | cp -rf /etc/php-fpm.d/www.conf /root/updown
if [ -f /etc/php.d/imagick.ini ]; then
rm -rf /etc/php.d/imagick.ini 
pecl uninstall imagick
fi
#### uninstall php zip module
if [ "$phphientai" = "70" ]; then
pecl uninstall zip
fi
sed -i '/extension=zip.so/d' /etc/php.ini
########
yum -y remove php\*
yum-config-manager --disable remi-php$phphientai 
#
#yyyyyyyyyyyyyyyyyyyyyy
yum-config-manager --enable remi-php54
/etc/lemp/menu/nangcap-php/install-php.sh5

#edit php.ini va Zend opcache
rm -rf /etc/php.ini  
rm -rf /etc/php-zts.d/*opcache*
rm -rf /etc/php.d/*opcache*
rm -rf /etc/php-fpm.conf
yes | cp -rf /root/updown/php-fpm.conf /etc/
yes | cp -rf /root/updown/php.ini /etc/
yes | cp -rf /root/updown/www.conf /etc/php-fpm.d/
#copy opcache config
yes | cp -rf /root/updown/opcache.* /etc/php.d/
php_version=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
sed --in-place '/zend_extension/d' /etc/php.d/opcache.*
yes "" | pecl install imagick
#wget --no-check-certificate -q https://lemp.com/script/lemp/check-imagick.php.zip -O /home/$mainsite/private_html/check-imagick.php
wget --no-check-certificate -q https://github.com/vpsvn/lemp-version-2/raw/main/script/lemp/check-imagick.php.zip -O /home/$mainsite/private_html/check-imagick.php
if [ "$php_version" == "5.4" ]; then
  if [ "$(find / -name 'opcache.so')" == "0" ]; then
 pecl install channel://pecl.php.net/ZendOpcache-7.0.5
  fi
duongdanopcache=$(find / -name 'opcache.so' | grep php/modules/opcache.so)
echo "zend_extension=$duongdanopcache" >> /etc/php.d/opcache.*
duongdanimagick=$(find / -name 'imagick.so' | grep php/modules/imagick.so)
echo "extension=$duongdanimagick" >> /etc/php.d/imagick.ini
else
#echo "zend_extension=opcache.so" >> /etc/php.d/opcache.*
echo "zend_extension=/usr/lib64/php/modules/opcache.so" >> /etc/php.d/opcache.*
echo "extension=imagick.so" > /etc/php.d/imagick.ini
fi

## Ioncube
/etc/lemp/menu/nangcap-php/setup-ioncube.sh

sed -i '/extension=zip.so/d' /etc/php.ini
/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
rm -rf /root/updown/
phpmyadmin_version=4.4.15.7
cd  /home/$mainsite/private_html/
wget -q https://files.phpmyadmin.net/phpMyAdmin/${phpmyadmin_version}/phpMyAdmin-${phpmyadmin_version}-all-languages.zip
unzip -q phpMyAdmin-*.zip
yes | cp -rf phpMyAdmin-*/* .
rm -rf phpMyAdmin-*
cd
chown -R nginx:nginx /home/$mainsite/private_html
chmod 777 /var/lib/php/session/
rm -rf /etc/lemp/phpmyadmin.version
echo "4.4.15.7" > /etc/lemp/phpmyadmin.version
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
chkconfig --add php-fpm
chkconfig --levels 235 php-fpm on
service php-fpm restart
else
systemctl enable php-fpm.service 
systemctl start php-fpm.service
systemctl restart php-fpm.service
fi
chmod 777 /var/lib/php/session/
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ ! "$(/sbin/service php-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then
	clear
	echo "========================================================================="
	echo "Sorry, There's an error on changing PHP version."
	
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
fi
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ ! "`systemctl is-active php-fpm.service`" == "active" ]; then
	clear
	echo "========================================================================="
	echo "Sorry, There's an error on changing PHP version."
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
fi
fi
clear
echo "========================================================================="
echo "Hoan thanh thay doi PHP version. "
echo "-------------------------------------------------------------------------"
echo "Phien ban PHP hien tai: $(php -i | grep 'PHP Version' | awk 'NR==1 {print $4}')                          "
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
        ;;
esac
clear
echo "========================================================================="
  printf "Ban huy thay doi phien ban PHP.                         \n"
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh

