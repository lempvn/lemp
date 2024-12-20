#!/bin/bash
. /home/lemp.conf
if [ ! -f /etc/cron.d/lemp.code.cron ]; then
touch /etc/cron.d/lemp.code.cron
fi
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
acction1="/tmp/lemp-websitelist"
while read -r checksite
    do
if [ -f /home/$checksite/public_html/index.php ]; then
echo "$checksite" >> /tmp/checksite-list
fi
 done < "$acction1"

if [ ! -f /tmp/checksite-list ]; then
clear
echo "========================================================================="
echo "Khong tim thay website co du lieu tren server"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
sowebsitecodulieu=$(cat /tmp/checksite-list | wc -l)
randomcode=-`date |md5sum |cut -c '1-15'`
ls /bin/ > /tmp/checkautobackupvpsvn.txt
saoluucode () { 
if [ ! "$(grep lemp-backupcode-$website /tmp/checkautobackupvpsvn.txt)" == "" ]; then
	if [ ! "$(grep lemp-backupcode-$website /etc/cron.d/lemp.code.cron)" == "" ]; then
pathname=$(grep "\/home\/$mainsite\/private_html\/backup\/$website" /bin/lemp-backupcode-$website | awk 'NR==6 {print $3}')
filename=$(basename $pathname)
thongbao=$(echo "(Dang BAT auto backup)")
	else
filename=$website$randomcode.zip
thongbao=$(echo "")
	fi
else
filename=$website$randomcode.zip
thongbao=$(echo "")
fi
if [ ! -d /home/$mainsite/private_html/backup/$website ]; then
mkdir -p /home/$mainsite/private_html/backup/$website
fi
cd /home/$mainsite/private_html/backup/$website
if [ -f /home/$mainsite/private_html/backup/$website/*.zip ]; then
for file in *.zip; do
time=$(date -r /home/$mainsite/private_html/backup/$website/$file +%H%M-%d%m%y)
    mv "$file" "`basename $file .zip`.zip.$time"
    echo "$file.$time" > /tmp/lemp_ten_file_cu
done
fi
cd
cd /home/$website/public_html/
zip -r -q $website.zip *
mv $website.zip /home/$mainsite/private_html/backup/$website/$filename
cd
if [ -f /home/$mainsite/private_html/backup/$website/$filename ]; then
echo "========================================================================="
echo "Backup $website $thongbao:"
sleep 1
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$website/$filename"
if [ -f /tmp/lemp_ten_file_cu ]; then
echo "-------------------------------------------------------------------------"
echo "File Backup cu duoc doi ten thanh:"
echo "-------------------------------------------------------------------------"
echo "`cat /tmp/lemp_ten_file_cu`"
rm -rf /tmp/lemp_ten_file_cu
fi
sleep 3
echo "========================================================================================================================" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt
echo "Website $website $thongbao:" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt 
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt
echo "http://$serverip:$priport/backup/$website/$filename" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt
touch /tmp/saoluuwebsitethanhcongvpsvn/$website
else
echo "=========================================================================" 
echo "Backup website $website that bai !"
echo "========================================================================================================================" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt
echo "Backup website $website that bai !" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt
touch /tmp/saoluuwebsitethatbaivpsvn/$website
fi
}

echo "========================================================================="
echo "Su dung chuc nang nay de sao luu tat ca cac website tren server"
echo "-------------------------------------------------------------------------"
echo "Sau khi duoc kich hoat, LEMP se lan luot sao luu tat ca cac website"
echo "-------------------------------------------------------------------------"
echo "Tuy thuoc vao so luong va dung luong cac website ma thoi gian backup co"
echo "-------------------------------------------------------------------------"
echo "the nhanh hoac cham. LEMP se khong backup: $mainsite"
echo "=========================================================================" 
read -r -p "Ban muon backup tat ca website ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "========================================================================="
echo "PLEASE DO NOT TURNOFF THIS CREEEN !"
echo "========================================================================="
sleep 2
rm -rf /home/$mainsite/private_html/listbackup*
echo "========================================================================================================================" > /home/$mainsite/private_html/listbackup-AW$randomcode.txt
echo "                                      Link Download All Backup Files - Created by LEMP" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt
echo "========================================================================================================================" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt
echo "" >> /home/$mainsite/private_html/listbackup-AW$randomcode.txt
dobackup=$(cat /tmp/checksite-list)
for website in $dobackup 
do
saoluucode
done
clear
echo "========================================================================="
echo "Co $sowebsitetrenserver website tren server"
echo "-------------------------------------------------------------------------"
echo "Website co du lieu: $sowebsitecodulieu"
	if [ "$(ls -1 /tmp/saoluuwebsitethanhcongvpsvn | wc -l)" == "$sowebsitecodulieu" ]; then
	echo "-------------------------------------------------------------------------"
	echo "Backup $sowebsitecodulieu website thanh cong"
	else
	echo "-------------------------------------------------------------------------"
	echo "Backup that bai $(ls -1 /tmp/saoluuwebsitethatbaivpsvn | wc -l) website"
	echo "-------------------------------------------------------------------------"
	echo "Website sao luu that bai:"
	echo "-------------------------------------------------------------------------"
	ls /tmp/saoluuwebsitethatbaivpsvn
	fi
if [ ! "$(ls -1 /tmp/saoluuwebsitethatbaivpsvn | wc -l)" == "$sowebsitecodulieu" ]; then
echo "-------------------------------------------------------------------------"
echo "List Backup Files:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/listbackup-AW$randomcode.txt"
fi
rm -rf /tmp/*vpsvn*
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh

   ;;
    *)
    clear
    rm -rf /tmp/*vpsvn*
        echo "========================================================================= "
        echo "Huy bo backup tat ca website"
        /etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
        ;;
esac 
