#!/bin/bash 

. /home/lemp.conf

if [ ! -d /home/$mainsite/private_html/backup/AllDB ]; then
mkdir -p /home/$mainsite/private_html/backup/AllDB
fi
if [ ! -f /home/$mainsite/private_html/backup/AllDB/*.gz ]; then
clear
echo "========================================================================="
echo "Khong phat hien thay File Backup dinh dang .GZ !"
echo "-------------------------------------------------------------------------"
echo "Hay tao backup truoc hoac upload file backup cua ban vao:"
echo "-------------------------------------------------------------------------"
echo "/home/$mainsite/private_html/backup/AllDB"
echo "-------------------------------------------------------------------------"
echo "Sau do chay lai chuc nang nay."
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-tat-ca-database-menu.sh
exit
fi

if [ -d /home/$mainsite/private_html/backup/AllDB ]; then
cd /home/$mainsite/private_html/backup/AllDB
checknumberfile=$(ls -l | grep ^- | wc -l)
if [ "$checknumberfile" -gt "1" ]; then
cd
clear
echo "========================================================================="
echo "Co $checknumberfile files trong /home/$mainsite/private_html/backup/AllDB"
echo "-------------------------------------------------------------------------"
echo "Trong thu muc AllDB chi duoc phep co 1 file backup duy nhat ! "
echo "-------------------------------------------------------------------------"
echo "Hay xoa file khong su dung va lam lai !"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-tat-ca-database-menu.sh
exit
 fi
 fi

clear
echo "========================================================================="
echo "            LEMP - Manage VPS/Server by LEMP.VN                "
echo "========================================================================="
echo "                      Restore All Database                             "
echo "========================================================================="
echo""
echo "Dung chuc nang nay de phuc hoi Database tu ban backup gan nhat tren VPS"
echo "Neu ban muon phuc hoi database tu file backup khac"
echo "Hay xoa file backup trong:"
echo "-------------------------------------------------------------------------"
echo "/home/$mainsite/private_html/backup/AllDB"
echo "-------------------------------------------------------------------------"
echo "Va upload file backup cua ban vao thu muc AllDB."
echo "File Backup Database phai co duoi mo rong la .GZ"
echo "Neu dinh dang khac, chuc nang nay se khong hoat dong !"
echo "========================================================================="
read -p "Nhan [Enter] de tiep tuc ..."

 clear
 find /home/$mainsite/private_html/backup/AllDB/ -type f -exec basename {} \;  > /tmp/backupname
filename=`cat /tmp/backupname`
rm -rf /tmp/backupname
echo "========================================================================="
echo "            LEMP - Manage VPS/Server by LEMP.VN                "
echo "========================================================================="
echo "                      Restore All Database                             "
echo "========================================================================="
echo""

echo "Neu tren VPS chua co database, sau khi restore, cac database restore"
echo "se co user va mat khau nhu trong ban backup."
echo "-------------------------------------------------------------------------"
echo "Neu tren VPS da co database, khi su dung chuc nang nay, "
echo "tat ca cac database hien tai se bi replace bang du lieu cua file backup"
echo "Ban phai can than khi su dung chuc nang nay !"
echo "========================================================================= "
echo "Phat hien ban backup: $filename"
echo "--------------------------------------------------------------------------"
echo "File duoc tao (upload) vao: $(date -r /home/$mainsite/private_html/backup/AllDB/$filename +%H:%M/%F)"
echo "========================================================================= "
read -r -p "Ban muon phuc hoi tat ca cac database tu file backup nay ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/lemp-phuc-hoi-tat-ca-database.sh
;;
esac
clear
echo "========================================================================= "
echo "Ban huy bo phuc hoi tat ca database ! "
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-tat-ca-database-menu.sh
exit
fi
