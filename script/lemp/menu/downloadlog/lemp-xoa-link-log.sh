#!/bin/bash
. /home/lemp.conf
echo "-------------------------------------------------------------------------"
echo "Please wait...."
sleep 1
if [ "$(ls -1 /home/$mainsite/private_html/server-log | wc -l)" == "0" ]; then
clear
echo "========================================================================= "
echo "Khong ton tai ban download cua cac file log."
/etc/lemp/menu/downloadlog/lemp-error-menu.sh
fi
rm -rf /home/$mainsite/private_html/server-log/*.*
clear
echo "========================================================================= "
echo "Xoa tat ca link download file Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-error-menu.sh


