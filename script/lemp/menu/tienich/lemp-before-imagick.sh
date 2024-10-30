#!/bin/bash
. /home/lemp.conf

# Kiem tra trang thai cua php-fpm
if [ "$(systemctl is-active php8.2-fpm.service)" == "active" ]; then  # Thay doi php8.2 voi phien ban PHP ban dang su dung
    /etc/lemp/menu/tienich/lemp-imagick-cai-dat-remove.sh
else
    echo "-------------------------------------------------------------------------"
    sudo systemctl restart php8.2-fpm.service  # Thay doi php8.2 voi phien ban PHP ban dang su dung
    if [ "$(systemctl is-active php8.2-fpm.service)" == "active" ]; then  # Thay doi php8.2 voi phien ban PHP ban dang su dung
        /etc/lemp/menu/tienich/lemp-imagick-cai-dat-remove.sh
    else
        clear
        echo "========================================================================="
        echo "PHP-FPM khong the khoi dong!"
        echo "-------------------------------------------------------------------------"
        echo "Ban khong the cai dat / Go bo imagick"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
    fi
fi
