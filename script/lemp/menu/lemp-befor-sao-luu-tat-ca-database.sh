#!/bin/bash 

. /home/lemp.conf
echo "========================================================================= "
echo "Su dung chuc nang nay de backup tat ca database tren server"
echo "-------------------------------------------------------------------------"
echo "thanh mot file duy nhat. Ban chi co the phuc hoi tat ca database tu file"
echo "-------------------------------------------------------------------------"
echo "backup va khong the phuc hoi tung database rieng le duoc"
echo "========================================================================= "
read -r -p "Ban muon backup database full ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/lemp-sao-luu-tat-ca-database.sh
;;
esac
clear
echo "========================================================================= "
echo "Ban huy bo sau luu tat ca database ! "
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-tat-ca-database-menu.sh
exit
fi