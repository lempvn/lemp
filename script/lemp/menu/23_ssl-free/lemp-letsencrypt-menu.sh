#!/bin/bash
. /home/lemp.conf

# Tao thu muc du phong neu chua ton tai
if [ ! -d /etc/lemp/Backup.Vhost.SSL ]; then
    mkdir -p /etc/lemp/Backup.Vhost.SSL
fi

if [ ! -d /etc/lemp/.tmp ]; then
    mkdir -p /etc/lemp/.tmp
fi

# Cai dat acme.sh neu chua ton tai
if [ ! -f /root/.acme.sh/acme.sh ]; then
    clear
    echo "========================================================================="
    echo "LEMP se cai dat tien ich Acme.Sh truoc khi chay chuc nang nay"
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."; sleep 5
    wget -O - https://get.acme.sh | sh
    rm -rf /etc/lemp/.tmp/check_crontab_acme
    crontab -l > /etc/lemp/.tmp/check_crontab_acme
    if [ ! "$(grep "/root/.acme.sh" /etc/lemp/.tmp/check_crontab_acme)" = "" ]; then
        /root/.acme.sh/acme.sh --uninstallcronjob
    fi
    rm -rf /etc/lemp/.tmp/check_crontab_acme
    sleep 3
    clear
    echo "========================================================================="
    echo "Cai dat acme.sh hoan thanh"
    echo "-------------------------------------------------------------------------"
    echo "Bay gio ban co the su dung chuc nang cai dat SSL cho website cua minh."
    /etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi

version=$(/root/.acme.sh/acme.sh --version | awk 'NR==2' | sed 's/v//')

show_menu_lets_encrypt () {
    prompt="Lua chon cua ban (0-Thoat):"
    options=("Cai Dat SSL Cho Domain" "Kiem Tra SSL Cua Domain" "Auto Renew SSL" "Renew SSL Cho Domain" "List Domain Cai Dat SSL" "Remove SSL (Quay lai HTTP)" "Upgrade Acme.sh")
    printf "=========================================================================\n"
    printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
    printf "=========================================================================\n"
    printf "                        Cai Dat SSL - Let's Encrypt \n"
    echo "========================================================================="
    echo "                    Powered by Acme.Sh | Version: $version"
    printf "=========================================================================\n"
    PS3="$prompt"
    select opt in "${options[@]}" ; do 
        case "$REPLY" in
            1) /etc/lemp/menu/23_ssl-free/lemp-cai-dat-ssl-letsencrypt.sh;;
            2) /etc/lemp/menu/23_ssl-free/lemp-kiem-tra-ssl-letsencrypt.sh;;
            3) /etc/lemp/menu/23_ssl-free/lemp-bat-auto-gia-han-letsencrypt.sh;; 
            4) /etc/lemp/menu/23_ssl-free/lemp-renew-ssl-letsencrypt.sh;;
            5) /etc/lemp/menu/23_ssl-free/lemp-list-domain-cai-dat-letsencrypt.sh;;
            6) /etc/lemp/menu/23_ssl-free/lemp-remove-ssl-letsencrypt.sh;;
            7) /etc/lemp/menu/23_ssl-free/lemp-update-letsencrypt.sh;;
            8) clear && /bin/lemp;;
            0) clear && /bin/lemp;;
            *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu!" ; continue;;
        esac
    done
}

check_nginx_service () {
    if [ "$(systemctl is-active nginx.service)" == "active" ]; then
        show_menu_lets_encrypt 
    else
        clear
        echo "========================================================================"
        echo "Dich vu Nginx khong dang chay"
        echo "------------------------------------------------------------------------"
        echo "LEMP dang co gang khoi dong no"
        echo "------------------------------------------------------------------------"
        echo "Vui long cho ..."
        sleep 5 ; clear
        systemctl start nginx.service
        clear
        echo "========================================================================"
        echo "Kiem tra lai dich vu Nginx mot lan nua!"
        echo "------------------------------------------------------------------------"
        echo "Vui long cho ..."
        sleep 5 ; clear
        if [ "$(systemctl is-active nginx.service)" == "active" ]; then
            show_menu_lets_encrypt 
        else
            clear
            echo "========================================================================"
            echo "LEMP khong the khoi dong dich vu Nginx"
            sleep 4 ;
            clear
            echo "========================================================================="
            echo "Rat tiec, Nginx dang dung. Hay bat len truoc khi dung chuc nang nay!"
            /bin/lemp
        fi
    fi
}

check_nginx_service
