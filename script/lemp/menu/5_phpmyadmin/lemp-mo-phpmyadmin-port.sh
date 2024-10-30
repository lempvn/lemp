#!/bin/bash 
. /home/lemp.conf

# Kiem tra neu cong da duoc mo
if ufw status | grep -q "$priport/tcp.*ALLOW"; then
    clear
    echo "========================================================================="
    echo "Port Phpmyadmin port ($priport) dang OPEN."
    echo "-------------------------------------------------------------------------"
    echo "Ban khong can mo lai no!"
    /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
    exit
fi

echo "========================================================================="
echo "Port ($priport) phai duoc mo neu ban muon truy cap Phpmyadmin,"
echo "-------------------------------------------------------------------------"
echo "Hay tai cac file qua port nay nhu: Backup files, Log files"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon mo port $priport? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "Vui long doi...."; sleep 1
        clear
        echo "========================================================================="
        echo "Mo phpmyadmin port ($priport) thanh cong!"
        echo "-------------------------------------------------------------------------"
        echo "Ban da co the truy cap phpmyadmin va download backup, log, CSR...files"
        echo "-------------------------------------------------------------------------"
        sudo ufw allow $priport/tcp  # Mo cong qua UFW
        /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
    *)
        clear
        echo "========================================================================="
        echo "Ban huy viec mo Phpmyadmin Port (Port $priport)"
        /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
esac
