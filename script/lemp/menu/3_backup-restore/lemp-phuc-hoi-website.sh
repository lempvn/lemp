#!/bin/bash
. /home/lemp.conf
nhapwebsite ()
{
echo -n "Nhap ten website [ENTER]: " 
read website
}
echo "========================================================================="
echo "Su dung chuc nang nay de phuc hoi website tu file backup"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website
if [ "$website" = "" ]; then
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
echo "-------------------------------------------------------------------------"
nhapwebsite
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
echo "========================================================================="
echo "$website co le khong phai la domain !"
echo "-------------------------------------------------------------------------"
nhapwebsite
fi
if [ ! -d /home/$website/public_html ]; then
echo "========================================================================="
echo "Khong tim thay $website tren server"
echo "-------------------------------------------------------------------------"
nhapwebsite
fi
if [ ! -f /home/$mainsite/private_html/backup/$website/*.zip ]; then
clear
echo "========================================================================="
echo "Khong tim thay file backup cua $website tren server !"
echo "-------------------------------------------------------------------------"
echo "Hay upload file backup .ZIP cua ban vao folder duoi va lam lai: "
echo "-------------------------------------------------------------------------"
echo "/home/$mainsite/private_html/backup/$website"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit
fi
find /home/$mainsite/private_html/backup/$website/ -name '*.zip' -type f -exec basename {} \;  > /tmp/backupname
if [ ! "$(cat /tmp/backupname | wc -l)" == "1" ]; then
clear
echo "========================================================================="
echo "Co nhieu hon 1 file backup dinh dang .ZIP trong: "
echo "-------------------------------------------------------------------------"
echo "/home/$mainsite/private_html/backup/$website"
echo "-------------------------------------------------------------------------"
echo "Vui long de lai 1 file duy nhat .ZIP trong folder nay"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit
fi
filename=`cat /tmp/backupname`
rm -rf /tmp/backupname
websiteTO=`echo $website | tr '[a-z]' '[A-Z]'`
echo "========================================================================="
echo "Phat hien file backup cua $website: $filename "
echo "-------------------------------------------------------------------------"
echo "File backup duoc tao vao: $(date -r /home/$mainsite/private_html/backup/$website/$filename +%H:%M/%F)"
echo "========================================================================="
echo "LUA CHON CACH PHUC HOI $websiteTO"
echo "========================================================================="
prompt="Nhap vao lua chon cua ban (0-Thoat): "
options=("Giu Nguyen Du Lieu Hien Tai Va Ghi De Du Lieu Tu File Backup" "Xoa Hoan Toan Du Lieu Hien Tai Va Phuc Hoi Backup")
PS3="$prompt"
select opt in "${options[@]}"; do 
case "$REPLY" in
1) luachon="restore1"; break;;
2) luachon="restore2"; break;;
3) clear && /etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh;;  
0) clear && /etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh;;  
*) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;
esac   
done
if [ "$luachon" = "restore2" ]; then
echo "========================================================================="
echo "Trong qua trinh phuc hoi website, KHONG DUOC tat man hinh SSH !"
echo "========================================================================="
echo "LEMP se xoa toan bo du lieu website hien tai (Code,images,files..) "
echo "-------------------------------------------------------------------------"
echo "Va thay the bang du lieu tu file backup. Qua trinh nay khong the quay lai"
echo "-------------------------------------------------------------------------"
echo "Vi vay ban phai can nhac truoc khi quyet dinh phuc hoi."
echo "-------------------------------------------------------------------------"
echo "Nhan [ Enter ] de phuc hoi. Nhan phim bat ky khac de huy bo"
echo "========================================================================="
read -s -n1 -r -p "Nhan [Enter] de tiep tuc ..." key
if [[ ! $key = "" ]]; then
clear
echo "========================================================================="
echo "Huy bo phuc hoi $website"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
echo ""
echo "Please wait..."
sleep 1
mv /home/$website/public_html /home/$website/public_html_backup
mkdir /home/$website/public_html
cd /home/$mainsite/private_html/backup/$website
unzip $filename -d /home/$website/public_html
cd	
chown -R nginx:nginx /home/$website/public_html
if [ -f /home/$website/public_html/index.php ]; then 
rm -rf /home/$website/public_html_backup 

for service in $(systemctl list-units --type=service --state=running | grep php | awk '{print $1}'); do
    systemctl restart $service
done

systemctl restart nginx.service
#touch /var/cache/ngx_pagespeed/cache.flush
( echo "flushall" ) | redis-cli

clear
echo "========================================================================="
echo "Ban da phuc hoi xong $website"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
else
rm -rf /home/$website/public_html
mv /home/$website/public_html_backup /home/$website/public_html
clear
echo "========================================================================="
echo "Co dieu gi do khong on voi file backup cua ban"
echo "-------------------------------------------------------------------------"
echo "Phuc hoi website that bai."
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
fi

if [ "$luachon" = "restore1" ]; then
echo "========================================================================="
echo "Trong qua trinh phuc hoi website, KHONG DUOC tat man hinh SSH !"
echo "========================================================================="
echo "LEMP se thay the cac file hien tai cua website (Code,images,files..) "
echo "-------------------------------------------------------------------------"
echo "Bang du lieu tu file backup. Qua trinh nay khong the quay lai ! "
echo "-------------------------------------------------------------------------"
echo "Vi vay ban phai can nhac truoc khi quyet dinh phuc hoi"
echo "-------------------------------------------------------------------------"
echo "Nhan [ Enter ] de phuc hoi. Nhan phim bat ky khac de huy bo"
echo "========================================================================="
read -n1 -r -p "Nhan [Enter] de tiep tuc ..." key
if [[ ! $key = "" ]]; then
clear
echo "========================================================================="
echo "Huy bo phuc hoi $website"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
echo ""
echo "Please wait..."
sleep 1
rm -rf /tmp/websiterestore
mkdir -p /tmp/websiterestore
cd /home/$mainsite/private_html/backup/$website
unzip -o $filename -d /tmp/websiterestore
cd
if [ ! -f /tmp/websiterestore/index.php ]; then
rm -rf /tmp/websiterestore
clear
echo "========================================================================="
echo "Co dieu gi do khong on voi file backup cua ban"
echo "-------------------------------------------------------------------------"
echo "Phuc hoi website that bai."
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
else
yes | cp -rf /tmp/websiterestore/*.* /home/$website/public_html
yes | cp -rf /tmp/websiterestore/* /home/$website/public_html
rm -rf /tmp/websiterestore
chown -R nginx:nginx /home/$website/public_html

for service in $(systemctl list-units --type=service --state=running | grep php | awk '{print $1}'); do
    systemctl restart $service
done

systemctl restart nginx.service
#touch /var/cache/ngx_pagespeed/cache.flush
( echo "flushall" ) | redis-cli

clear
echo "========================================================================="
echo "Ban da phuc hoi xong $website"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi 
fi

