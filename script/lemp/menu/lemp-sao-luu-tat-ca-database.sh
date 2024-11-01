#!/bin/bash
. /home/lemp.conf
saoluudata ()
{
echo "Vui long khong tat man hinh....!"
rm -rf /home/$mainsite/private_html/backup/AllDB
mkdir -p /home/$mainsite/private_html/backup/AllDB
cd /home/$mainsite/private_html/backup/AllDB
mysqldump -u root -p$mariadbpass -A | gzip -6 > AllDB_$abc456.sql.gz
clear
echo "========================================================================="
echo "Link file backup tat ca database:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/AllDB/AllDB_$abc456.sql.gz"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-tat-ca-database-menu.sh
}
abc456=`date |md5sum |cut -c '1-5'` 
if [ -f /home/$mainsite/private_html/backup/AllDB/*.sql.gz ]; then
echo "Phat hien thay file sao luu cu !"
echo "--------------------------------------------------------------------------"
read -r -p "Ban muon xoa no va tao sao luu moi ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
	echo "Dang sao luu tat ca database.........."
	sleep 1
	saoluudata
        ;;
    *)
        echo ""
        ;;
esac
else
	echo "Dang sao luu tat ca database..........."
	saoluudata
fi
