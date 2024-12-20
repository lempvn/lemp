#!/bin/bash
. /home/lemp.conf

#
echo "current_os_version="$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)) >> /tmp/change_php_config
. /tmp/change_php_config

#
phphientai=$(php -r "echo PHP_MAJOR_VERSION.''.PHP_MINOR_VERSION;")
php_version1=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
if [ "$php_version1" == "$new_php_version" ]; then
clear
echo "========================================================================="
echo "Phien ban PHP hien tai: $(php -i | grep 'PHP Version' | awk 'NR==1 {print $4}') "
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
exit
fi

echo "========================================================================="
echo "Ban muon su dung PHP phien ban $new_php_version ?"
read -r -p "Please select [y/N] " response
case $response in
[yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "Ok ! please wait ...."
sleep 1
/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini

/etc/lemp/menu/nangcap-php/before-setup-php.sh

if [ "$current_os_version" == "6" ] || [ "$current_os_version" == "7" ]; then 
yum-config-manager --disable remi-php$phphientai
yum-config-manager --enable remi-php$num_php_version
/etc/lemp/menu/nangcap-php/install-php.sh
else
/etc/lemp/menu/nangcap-php/install-php.sh8
fi

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

###########################
/etc/lemp/menu/nangcap-php/setup-suhosin.sh
/etc/lemp/menu/nangcap-php/setup-ioncube.sh
/etc/lemp/menu/nangcap-php/setup-imagick.sh


if [ "$php_version" == "5.4" ]; then
if [ "$(find / -name 'opcache.so')" == "0" ]; then
echo "pecl install ZendOpcache..."
pecl install channel://pecl.php.net/ZendOpcache-7.0.5
fi
fi

sed -i -e "/zend_extension=/d" /etc/php.d/opcache.ini
if [ -f /usr/lib64/php/modules/opcache.so ]; then
echo "zend_extension=/usr/lib64/php/modules/opcache.so" >> /etc/php.d/opcache.*
else
duongdanopcache=$(find / -name 'opcache.so' | grep php/modules/opcache.so)
if [ ! "$duongdanopcache" = "" ]; then
echo "zend_extension=$duongdanopcache" >> /etc/php.d/opcache.*
else

if [ -f /etc/php.d/opcache.ini ]; then
rm -rf /etc/php.d/opcache.bak
mv /etc/php.d/opcache.ini /etc/php.d/opcache.bak
fi
#rm -rf /etc/php.d/opcache.*

fi
fi
######################

#Install Zip Module
#yes "" | pecl install zip
#if [ "`grep extension=zip.so /etc/php.ini`" == "" ];then
#sed -i "/.*default_socket_timeout.*/aextension=zip.so" /etc/php.ini
#fi

/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
rm -rf /root/updown/

if [ "$current_os_version" == "6" ]; then 
chkconfig --add php-fpm
chkconfig --levels 235 php-fpm on
service php-fpm restart
else 
systemctl enable php-fpm.service 
systemctl start php-fpm.service
systemctl restart php-fpm.service
fi
chmod 777 /var/lib/php/session/

if [ "$current_os_version" == "6" ]; then 
if [ ! "$(/sbin/service php-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then
clear
echo "========================================================================="
echo "Sorry, There's an error on changing PHP version."

/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
fi
fi

if [ ! "$current_os_version" == "6" ]; then
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

rm -rf /tmp/change_php_config

clear

echo "========================================================================="
printf "Ban huy thay doi phien ban PHP.                         \n"
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh

