#!/bin/bash
. /home/lemp.conf

# Kiem tra xem nginx co dang chay hay khong
if [ "$(systemctl is-active nginx)" == "active" ]; then
    /etc/lemp/menu/lemp-xoa-website.sh
else
    echo "-------------------------------------------------------------------------"
    systemctl restart nginx
    if [ "$(systemctl is-active nginx)" == "active" ]; then
        /etc/lemp/menu/lemp-xoa-website.sh
    else
        clear
        echo "========================================================================="
        echo "Rat tiec, Nginx dang stopped. Hay bat Nginx truoc khi su dung chuc nang nay!"
        lemp
    fi
fi
