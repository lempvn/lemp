#!/bin/bash
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

if [ ! -f /etc/lemp/pwprotect.default ]; then
    echo "" > /etc/lemp/pwprotect.default
fi
if [ ! -f /usr/local/bin/htpasswd.py ]; then
    cp -r /etc/lemp/menu/lemp-tao-mat-khau-bao-ve-folder.py /usr/local/bin/htpasswd.py
    chmod 755 /usr/local/bin/htpasswd.py
fi
if [ -f /etc/lemp/netdatasite.info ]; then
    netdatasite=$(cat /etc/lemp/netdatasite.info)
    if [ ! -f /etc/nginx/conf.d/$netdatasite.conf ]; then
        rm -rf /etc/lemp/netdatasite.info
    fi
    if [ ! -d /etc/netdata ]; then
        rm -rf /etc/lemp/netdatasite.info
    fi
fi

if [ ! -f /etc/lemp/netdata.version ]; then
    echo "1.47.4" > /etc/lemp/netdata.version
fi

show_menu_netdata () {
    prompt="Lua chon cua ban (0-Thoat):"
    options=("Setup NetData" "Tat / Bat NetData" "Thay Domain NetData" "Bao Ve Domain NetData" "Nang Cap NetData")
    printf "=========================================================================\n"
    printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
    printf "=========================================================================\n"
    printf "                            Quan Ly NetData \n"
    printf "=========================================================================\n"
	printf "LUU Y! KHI CAI DAT NETDATA XONG THI NEN BAT THEM [Bao Ve Domain NetData] \n"
	printf "=========================================================================\n"
    if [ ! -f /etc/lemp/netdatasite.info ]; then
        printf "                      NetData status: Not Install \n"
    else
        if [ "$(systemctl is-active netdata.service)" == "active" ]; then
            printf "               Status: Installed and Enable | Version: $(cat /etc/lemp/netdata.version)\n"
        else
            printf "               Status: Installed but Disable | Version: $(cat /etc/lemp/netdata.version)\n"
        fi
    fi
    printf "=========================================================================\n"
    if [ -f /etc/lemp/netdatasite.info ]; then
        netdatasite=$(cat /etc/lemp/netdatasite.info)
        checknetdataconfig=$(grep auth_basic /etc/nginx/conf.d/$netdatasite.conf)
        if [ "$checknetdataconfig" == "" ]; then
            Protection=Disable
        else
            Protection=Enable
        fi
        printf "Link: http://$netdatasite | Protection: $Protection \n"
        printf "=========================================================================\n"
    fi
    PS3="$prompt"
    select opt in "${options[@]}"; do 
        case "$REPLY" in
            1) /etc/lemp/menu/22_netdata/lemp-cai-dat-netdata.sh;;
            2) /etc/lemp/menu/22_netdata/lemp-tat-bat-netdata.sh;;
            3) /etc/lemp/menu/22_netdata/lemp-thay-domain-netdata.sh;;
            4) /etc/lemp/menu/22_netdata/lemp-mat-khau-bao-ve-netdata.sh;;
            5) /etc/lemp/menu/22_netdata/lemp-nang-cap-netdata.sh;;
            0) clear && lemp;;
            *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !"; continue;;
        esac
    done
}

check_nginx_service () {
    if [ "$(systemctl is-active nginx.service)" == "active" ]; then
        show_menu_netdata 
    else
        clear
        echo "========================================================================"
        echo "Nginx service is not running"
        echo "------------------------------------------------------------------------"
        echo "LEMP trying to start it"
        echo "------------------------------------------------------------------------"
        echo "Please wait ..."
        sleep 5; clear
        systemctl start nginx.service
        clear
        echo "========================================================================"
        echo "Check Nginx service once again !"
        echo "------------------------------------------------------------------------"
        echo "please wait ..."
        sleep 5; clear
        if [ "$(systemctl is-active nginx.service)" == "active" ]; then
            show_menu_netdata 
        else
            clear
            echo "========================================================================"
            echo "LEMP can not start Nginx Service"
            sleep 4;
            clear
            echo "========================================================================="
            echo "Rat tiec, Nginx dang stopped. Hay bat len truoc khi dung chuc nang nay!"
            lemp
        fi
    fi
}

if [ "$(systemctl is-active php${PHP_VERSION}-fpm.service)" == "active" ]; then
    check_nginx_service
else
    clear
    echo "========================================================================"
    echo "PHP${PHP_VERSION}-FPM service is not running"
    echo "------------------------------------------------------------------------"
    echo "LEMP trying to start it"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5; clear
    systemctl start php${PHP_VERSION}-fpm.service
    clear
    echo "========================================================================"
    echo "Check PHP${PHP_VERSION}-FPM service once again !"
    echo "------------------------------------------------------------------------"
    echo "please wait ..."
    sleep 5; clear
    if [ "$(systemctl is-active php${PHP_VERSION}-fpm.service)" == "active" ]; then
        check_nginx_service
    else
        clear
        echo "========================================================================"
        echo "LEMP can not start PHP${PHP_VERSION}-FPM Service"
        sleep 4;
        clear
        echo "========================================================================="
        echo "Rat tiec, PHP${PHP_VERSION}-FPM dang stopped. Hay bat len truoc khi dung chuc nang nay!"
        lemp
    fi
fi
