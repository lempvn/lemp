#!/bin/sh
. /home/lemp.conf
echo "========================================================================="
read -r -p "Ban muon reboot server? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "Chuan bi reboot ..... "
sleep 1
reboot
;;
esac
clear
echo "========================================================================="
echo "Ban khong reboot VPS!!!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh