#!/bin/bash

. /home/lemp.conf

# Kiem tra xem imagick da duoc cai dat chua
if [ -f /etc/php/8.2/mods-available/imagick.ini ]; then  # Thay doi php8.2 voi phien ban PHP ban dang su dung
    echo "========================================================================="
    echo "Su dung chuc nang nay de Cai dat / Go bo Imagick cho server"
    echo "-------------------------------------------------------------------------"
    echo "Server da cai dat Imagick"
    echo "-------------------------------------------------------------------------"
    read -r -p "Ban muon go bo Imagick? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "-------------------------------------------------------------------------"
            echo "Xin vui long cho...."; sleep 1
            sudo rm -rf /etc/php/8.2/mods-available/imagick.ini  # Thay doi php8.2 voi phien ban PHP ban dang su dung
            sudo apt remove --purge -y php8.2-imagick  # Thay doi php8.2 voi phien ban PHP ban dang su dung

            sudo systemctl restart php8.2-fpm.service  # Thay doi php8.2 voi phien ban PHP ban dang su dung
            clear
            echo "========================================================================="
            echo "Go bo Imagick thanh cong!"
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            ;;
        *)
            clear
            echo "========================================================================="
            echo "Ban da huy go bo IMAGICK"
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            ;;
    esac
    exit
fi

echo "========================================================================="
echo "Su dung chuc nang nay de Cai dat / Go bo Imagick cho server"
echo "-------------------------------------------------------------------------"
echo "Server hien chua cai dat Imagick"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon cai dat Imagick? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Xin vui long cho...."; sleep 1
        sudo apt remove --purge -y php8.2-imagick  # Dam bao go bo neu da cai
        yes "" | sudo apt install php8.2-imagick  # Thay doi php8.2 voi phien ban PHP ban dang su dung
        sudo phpenmod imagick  # Kich hoat extension imagick

        # Kiem tra va khoi dong lai PHP-FPM
        sudo systemctl restart php8.2-fpm.service  # Thay doi php8.2 voi phien ban PHP ban dang su dung

        clear
        echo "========================================================================="
        echo "Cai dat IMAGICK thanh cong!"
        echo "-------------------------------------------------------------------------"
        echo "Kiem tra ket qua cai dat Imagick:"
        echo "-------------------------------------------------------------------------"
        echo "http://$serverip:$priport/check-imagick.php"
        echo "-------------------------------------------------------------------------"
        echo "Neu Imagick cai thanh cong, trang nay se hien anh thong bao cua lemp"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
        clear
        echo "========================================================================="
        echo "Ban da huy cai dat IMAGICK"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac
exit
