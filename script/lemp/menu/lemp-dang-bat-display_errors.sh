#!/bin/bash
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
PHP_INI_FILE="/etc/php/$PHP_VERSION/fpm/php.ini"


echo "========================================================================="
echo "Voi mot so code loi, Neu dat [display_errors = Off] trong php.ini se lam"
echo "-------------------------------------------------------------------------"
echo "website hien thi duy nhat trang trang. Fix by set [display_errors = On]"
echo "-------------------------------------------------------------------------"
echo "Neu website khong co loi, lemp khuyen nghi dat [display_errors = Off]"
echo "========================================================================="
echo "Hien tai: DISPLAY ERRORS = ON "
echo "========================================================================="
read -r -p "Ban muon dat [display_errors = Off] trong php.ini ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    
sed -i.bak "s,display_errors = On,display_errors = Off,g" ${PHP_INI_FILE}
    echo "Cho xiu..."
sleep 1

for service in $(systemctl list-units --type=service --state=running | grep php | awk '{print $1}'); do
    systemctl restart $service
done

    clear
    echo "========================================================================="
echo "Thiet lap [display_errors = Off] trong php.ini thanh cong"
/etc/lemp/menu/lemp-config-php.ini-menu
        ;;
    *)
       clear
    echo "========================================================================="
   echo "Ban huy thay doi gia tri [display_errors]  !"
/etc/lemp/menu/lemp-config-php.ini-menu
        ;;
esac
