#!/bin/bash
. /home/lemp.conf

# Kiem tra phien ban PHP dang chay tren Apache
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
PHP_INI_FILE="/etc/php/$PHP_VERSION/fpm/php.ini"

# Kiem tra file php.ini
if [ ! -f $PHP_INI_FILE ]; then
clear
echo "========================================================================="
echo "LEMP khong tim thay php.ini tren server"
# Thay duong dan cho Ubuntu neu can
/etc/lemp/menu/config-php/lemp-config-php.ini-menu
exit
fi
display_errors_value=$(grep display_errors "$PHP_INI_FILE" | awk -F'=' '{print $2}' | tr -d '\n' | awk '{$1=$1};1')


# Kiem tra xem gia tri co rong khong
if [ -z "$display_errors_value" ]; then
    clear
    echo "========================================================================="
    echo "LEMP khong the thuc hien chuc nang nay"
    /etc/lemp/menu/config-php/lemp-config-php.ini-menu
    exit
fi

if [ "$display_errors_value" == "Off" ]; then
    /etc/lemp/menu/lemp-dang-tat-display_errors.sh
elif [ "$display_errors_value" == "On" ]; then
    /etc/lemp/menu/lemp-dang-bat-display_errors.sh
fi
