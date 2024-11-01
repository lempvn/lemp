#!/bin/bash
. /home/lemp.conf
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
if [ "$(/sbin/service php-fpm status | awk 'NR==1 {print $3}')" == "stopped" ]; then
clear
echo "========================================================================="
echo "PHP-FPM dang stop!"
echo "Ban khong the install / Remove Imagick"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
fi


#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
if [ "$(/bin/systemctl status  php-fpm.service | awk 'NR==3 {print $2}')" == "inactive" ]; then
clear
echo "========================================================================="
echo "PHP-FPM  Stopped!"
echo "Ban khong the install / Remove Imagick"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [ "$(/bin/systemctl status  php-fpm.service | awk 'NR==3 {print $2}')" == "failed" ]; then
clear
echo "========================================================================="
echo "PHP-FPM dang Stop!"
echo "Ban khong the install / Remove Imagick"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
fi
echo "========================================================================="
read -r -p "You want to install / re-install imagick ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "Ok ! please wait ...."
sleep 1
clear
rm -rf /etc/php.d/imagick.ini 
pecl uninstall imagick
#############################
yes "" | pecl install imagick
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
wget -q http://lemp.com/script/lemp/check-imagick.php.zip -O /home/$mainsite/private_html/check-imagick.php
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
else
systemctl restart php-fpm.service
fi
clear
echo "========================================================================="
echo "You have finished install or re-install IMAGICK"
echo "-------------------------------------------------------------------------"
echo "Kiem tra install Imagick status:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/check-imagick.php"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
 ;;
    *)
    clear
    echo "========================================================================="
   echo "You cancel install / re-install Imagick"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac
clear
    echo "========================================================================="
    echo "You cancel install / re-install Imagick"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
