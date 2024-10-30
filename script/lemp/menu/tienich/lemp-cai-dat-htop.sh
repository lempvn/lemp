#!/bin/bash 
. /home/lemp.conf

# Kiem tra xem htop da duoc cai dat hay chua
if [ -f /usr/bin/htop ]; then
    clear
    echo "========================================================================= "
    echo "HTOP da cai dat tren server  "
    echo "-------------------------------------------------------------------------"
    echo "Chay HTOP bang command: htop "
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
    exit
fi

echo "========================================================================="
echo "Htop la PM xem trang thai server tuong tu nhu [ top -c ] nhung chi tiet hon"
echo "-------------------------------------------------------------------------"
echo "Su dung chuc nang nay de cai dat htop cho server. "
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon cai dat htop?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Please wait ..."; sleep 1
        # Cai dat htop tren Ubuntu
        sudo apt update
        sudo apt install -y htop

        if [ -f /usr/bin/htop ]; then
            clear
            echo "========================================================================="
            echo "Cai dat HTOP thanh cong "
            echo "-------------------------------------------------------------------------"
            echo "Chay HTOP bang command: htop "
        else
            clear
            echo "========================================================================="
            echo "Cai dat htop that bai"
            echo "-------------------------------------------------------------------------"
            echo "Ban vui long thu lai."
        fi
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
       clear
       /etc/lemp/menu/tienich/lemp-tien-ich.sh
       ;;
esac

find / -name 'htop'
