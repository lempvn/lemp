#!/bin/bash
# Nguon cau hinh lemp
if [ -f /home/lemp.conf ]; then
    source /home/lemp.conf
else
    echo "Tep cau hinh /home/lemp.conf khong ton tai!"
    exit 1
fi

# Kiem tra tep thong tin co so du lieu
if [ ! -f /home/DBinfo.txt ]; then
    echo "=========================================================================" > /home/DBinfo.txt
    echo "THONG TIN DATABASE TREN VPS" >> /home/DBinfo.txt
    echo "=========================================================================" >> /home/DBinfo.txt
    echo "" >> /home/DBinfo.txt
fi

check_nginx_service () {
    # Kiem tra trang thai Nginx
    if systemctl is-active --quiet nginx; then
        clear
        if [ -f /etc/lemp/menu/lemp-them-website-menu.sh ]; then
            /etc/lemp/menu/lemp-them-website-menu.sh
        else
            echo "Tep /etc/lemp/menu/lemp-them-website-menu.sh khong ton tai!"
            exit 1
        fi
    else
        clear
        echo "========================================================================"
        echo "Nginx service dang khong hoat dong"
        echo "------------------------------------------------------------------------"
        echo "LEMP dang co gang khoi dong lai Nginx"
        echo "------------------------------------------------------------------------"
        echo "Please wait ..."
        sleep 5
        systemctl restart nginx
        if systemctl is-active --quiet nginx; then
            clear
            /etc/lemp/menu/lemp-them-website-menu.sh
        else
            echo "LEMP khong the khoi dong Nginx Service"
            echo "Rat tiec Nginx dang dung Hay bat len truoc khi su dung chuc nang nay!"
            lemp
        fi
    fi
}

# Kiem tra trang thai cua dich vu PHP-FPM
check_php_fpm_status () {
    local service="$1"
    if systemctl is-active --quiet "$service"; then
        echo "$service is running"
    else
        echo "$service is stopped"
    fi
}

# Lay phien ban PHP hien tai
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
echo "Phien ban PHP hien tai: $PHP_VERSION"

# Kiem tra dich vu PHP-FPM dua tren phien ban PHP
php_fpm_service="php${PHP_VERSION}-fpm.service"

if systemctl list-units --type=service | grep -q "$php_fpm_service"; then
    echo "Dich vu PHP-FPM phien ban $PHP_VERSION dang ton tai."
else
    echo "Dich vu PHP-FPM phien ban $PHP_VERSION khong ton tai."
    exit 1
fi

# Kiem tra Nginx cho dich vu PHP-FPM
check_nginx_service

# Kiem tra trang thai cua dich vu PHP-FPM
check_php_fpm_status "$php_fpm_service"

echo "========================================================================"
lemp
