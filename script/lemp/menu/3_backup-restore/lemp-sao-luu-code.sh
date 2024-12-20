#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/*vpsvn*
mkdir -p /tmp/saoluuwebsitethanhcongvpsvn
mkdir -p /tmp/saoluuwebsitethatbaivpsvn
ls /etc/nginx/conf.d > /tmp/lemp-websitelist
sed -i 's/\.conf//g' /tmp/lemp-websitelist 
 cat > "/tmp/lemp-replace" <<END
sed -i '/$mainsite/d' /tmp/lemp-websitelist
END
chmod +x /tmp/lemp-replace
/tmp/lemp-replace
rm -rf /tmp/lemp-replace
rm -rf /tmp/checksite-list
sowebsitetrenserver=$(cat /tmp/lemp-websitelist | wc -l)
listwebsite=$(cat /tmp/lemp-websitelist)
rm -rf /tmp/checksite-list
for checksite in $listwebsite 
do
if [ -f /home/$checksite/public_html/index.php ]; then
echo "$checksite" >> /tmp/checksite-list
fi
 done

if [ ! -f /tmp/checksite-list ]; then
rm -rf /tmp/*lemp*
rm -rf /tmp/*vpsvn*
clear
echo "========================================================================="
echo "Khong tim thay website co du lieu tren server"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
nhapwebsite ()
{
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
}
echo "========================================================================="
echo "Su dung chuc nang nay de sao luu code cua website tren server"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
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
echo "$website co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
nhapwebsite
fi

if [ ! -d /home/$mainsite/private_html/backup/$website ]; then
mkdir -p /home/$mainsite/private_html/backup/$website/
fi
if [ -f /home/$website/public_html/index.php ]; then
echo "-------------------------------------------------------------------------"
echo "Tim thay $website tren server"
backuphomename=-`date |md5sum |cut -c '1-12'`

if [ -f /home/$mainsite/private_html/backup/$website/*.zip ]; then

find /home/$mainsite/private_html/backup/$website -name '*.zip' -type f -exec basename {} \;  > /tmp/backupname
filename=`cat /tmp/backupname`
rm -rf /tmp/backupname

echo "-------------------------------------------------------------------------"
echo "Phat hien file backup cu : $filename"
echo "--------------------------------------------------------------------------"
echo "Thoi gian backup: $(date -r /home/$mainsite/private_html/backup/$website/$filename +%H:%M/%F)"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon xoa no va tao file backup moi? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
	echo "Dang sao luu $website, please wait..."
	sleep 1
	if [  -f /bin/lemp-backupcode-$website ]; then
	if [ ! "$(grep lemp-backupcode-$website /etc/cron.d/lemp.code.cron)" == "" ]; then
pathname=$(grep "\/home\/$mainsite\/private_html\/backup\/$website" /bin/lemp-backupcode-$website | awk 'NR==6 {print $3}')
filename2=$(basename $pathname)
thongbao=$(echo "($website Enabled Auto Backup)")
	else
filename2=$website$backuphomename.zip
thongbao=$(echo "")
	fi
else
filename2=$website$backuphomename.zip
thongbao=$(echo "")
fi
	cd /home/$website/public_html/
	zip -r $website.zip *
	rm -rf /home/$mainsite/private_html/backup/$website/*.zip
	mv $website.zip /home/$mainsite/private_html/backup/$website/$filename2

clear
echo "========================================================================="
echo "Link Backup File:"
if [  -f /bin/lemp-backupcode-$website ]; then
	if [ ! "$(grep lemp-backupcode-$website /etc/cron.d/lemp.code.cron)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "$thongbao"
fi
fi
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$website/$filename2"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
        ;;
    *)
        ;;
esac
cd /home/$mainsite/private_html/backup/$website
if [ -f /home/$mainsite/private_html/backup/$website/*.zip ]; then
for file in *.zip; do
time=$(date -r /home/$mainsite/private_html/backup/$website/$file +%H%M-%d%m%y)
    mv "$file" "`basename $file .zip`.zip.$time"
    echo "$file.$time" > /tmp/lemp_ten_file_cu
done
fi
cd
echo "-------------------------------------------------------------------------"
echo "LEMP se doi ten file backup cu thanh:"
echo "-------------------------------------------------------------------------"
echo "`cat /tmp/lemp_ten_file_cu`"
echo "-------------------------------------------------------------------------"
echo "Sau do se sao luu $website"
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 4
if [  -f /bin/lemp-backupcode-$website ]; then
	if [ ! "$(grep lemp-backupcode-$website /etc/cron.d/lemp.code.cron)" == "" ]; then
pathname=$(grep "\/home\/$mainsite\/private_html\/backup\/$website" /bin/lemp-backupcode-$website | awk 'NR==6 {print $3}')
filename2=$(basename $pathname)
thongbao=$(echo " ($website Enabled Auto Backup)")
	else
filename2=$website$backuphomename.zip
thongbao=$(echo "")
	fi
else
filename2=$website$backuphomename.zip
thongbao=$(echo "")
fi
	cd /home/$website/public_html/
	zip -r $website.zip *
	mv $website.zip /home/$mainsite/private_html/backup/$website/$filename2
clear
echo "========================================================================="
echo "Link Backup File:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$website/$filename2"
echo "-------------------------------------------------------------------------"
echo "File Backup Cu Duoc Doi Ten Thanh:"
echo "-------------------------------------------------------------------------"
echo "$(cat /tmp/lemp_ten_file_cu)"
rm -rf /tmp/*lemp*
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
else
echo "-------------------------------------------------------------------------"
	echo "LEMP dang sao luu $website, ban cho xiu...."
	sleep 1
	if [  -f /bin/lemp-backupcode-$website ]; then
	if [ ! "$(grep lemp-backupcode-$website /etc/cron.d/lemp.code.cron)" == "" ]; then
pathname=$(grep "\/home\/$mainsite\/private_html\/backup\/$website" /bin/lemp-backupcode-$website | awk 'NR==6 {print $3}')
filename2=$(basename $pathname)
thongbao=$(echo " ($website Enabled Auto Backup)")
	else
filename2=$website$backuphomename.zip
thongbao=$(echo "")
	fi
else
filename2=$website$backuphomename.zip
thongbao=$(echo "")
fi
	cd /home/$website/public_html/
	zip -r $website.zip *
	rm -rf /home/$mainsite/private_html/backup/$website/*.zip
	mv $website.zip /home/$mainsite/private_html/backup/$website/$filename2
echo "Done... "
clear
echo "========================================================================="
echo "Link Backup File:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$website/$filename2"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
else
clear
echo "========================================================================="
echo "Khong tim thay $website tren server hoac web chua co du lieu!"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi

