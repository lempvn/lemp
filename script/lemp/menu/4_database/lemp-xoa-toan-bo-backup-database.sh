#!/bin/bash

. /home/lemp.conf
if [ ! -d /home/$mainsite/private_html ]; then
clear
echo "========================================================================="
echo "You can not use this function"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de xoa tat ca cac file backup database tren server"
echo "-------------------------------------------------------------------------"
read -r -p "Ban chac chan muon xoa cac file backup ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
cd /home/$mainsite/private_html/backup/
find . -name "*.tar.gz" > /tmp/deletebackupdb
find . -name "*.tar.gz.*" >> /tmp/deletebackupdb
find . -name "*.sql.gz" >> /tmp/deletebackupdb
find . -name "*.sql.gz.*" >> /tmp/deletebackupdb
checksize=$(du -sb /tmp/deletebackupdb | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
	clear
	echo "========================================================================= "
	echo "Khong tim thay backup cua cac database tren server"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
	exit
	fi
listfolder=$(cat /tmp/deletebackupdb)
for pathfolder in $listfolder
do
export lemp=$pathfolder
export sim=${lemp%/*}
rm -rf "${sim}"
done
cd
rm -rf /tmp/deletebackupdb
rm -rf /home/$mainsite/private_html/Listbackupall*
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
clear
echo "========================================================================= "
echo "Xoa backup tat ca database thanh cong"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
;;
    *)
        echo ""
        ;;
esac
clear
echo "========================================================================="
echo "Huy bo xoa cac ban backup database"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
