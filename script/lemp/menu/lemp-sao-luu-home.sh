#!/bin/sh
. /home/lemp.conf


echo "========================================================================="
echo "Sao luu toan bo thu muc Home co the mat thoi gian "
echo "-------------------------------------------------------------------------"
echo "va dung luong dia cung de chua file backup. "
echo "========================================================================="
read -r -p "Ban muon backup folder Home ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
backuphomename=`date |md5sum |cut -c '1-12'`
echo "Dang backup thu muc Home ..... "
sleep 3
rm -rf /home/$mainsite/private_html/backup/home/*
cd /usr/local
zip -r $serverip-$website$backuphomename.zip /home
mkdir -p /home/$mainsite/private_html/backup/home
mv $serverip-$website$backuphomename.zip /home/$mainsite/private_html/backup/home/$serverip-$website$backuphomename.zip
clear
echo "========================================================================="
echo "Link file backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/home/$serverip-$website$backuphomename.zip"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit

 ;;
    *)
        echo ""
        ;;
esac
clear
echo "========================================================================="
echo "Huy backup thu muc Home"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh

