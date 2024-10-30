#!/bin/bash 
. /home/lemp.conf

# Kiem tra neu cong da bi chan
if ufw status | grep -q "$priport/tcp.*DENY"; then
    clear
    echo "========================================================================="
    echo "Phpmyadmin port ($priport) dang CLOSE."
    echo "-------------------------------------------------------------------------"
    echo "Ban khong can re-close port nay!"
    /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
    exit
fi

echo "========================================================================="
echo "Neu ban close Phpmyadmin port (port: $priport), ban se khong the truy cap"
echo "-------------------------------------------------------------------------"
echo "Phpmyadmin, xem status va khong the download bat ky file nao qua port nay"
echo "-------------------------------------------------------------------------"
echo "Nhu: Backup files, Log files..."
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon CLOSE port $priport? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "Vui long doi...."; sleep 1
        clear
        echo "========================================================================="
        echo "Close phpmyadmin port ($priport) thanh cong!"
        echo "-------------------------------------------------------------------------"
        sudo ufw deny $priport/tcp  # Chan cong qua UFW
        /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
    *)
        clear
        echo "========================================================================="
        echo "Ban huy CLOSE Phpmyadmin port (Port $priport)"
        /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
esac
