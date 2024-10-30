#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/*vpsvn*
code=`date |md5sum |cut -c '1-12'`
ls -l /var/lib/mysql | grep "^d" | awk -F" " '{print $9}' | grep -Ev "(Database|information_schema|mysql|performance_schema|lempCheckDB)" > /tmp/listdabasevpsvn
checksize=$(du -sb /tmp/listdabasevpsvn | awk 'NR==1 {print $1}')
   if [ "$checksize" == "0" ]; then
   clear
   echo "========================================================================="
   echo "Khong phat hien thay database dang duoc su dung tren server"
   /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
   exit
   fi
sodatabasetrenserver=$(cat /tmp/listdabasevpsvn | wc -l)
listdatabasetrenserver=$(cat /tmp/listdabasevpsvn)
mkdir -p /tmp/saoluudatabasethanhcongvpsvn
mkdir -p /tmp/saoluudatabasethatbaivpsvn
rm -rf /tmp/*check*
for database in $listdatabasetrenserver 
do
if [ ! "$(ls -1 /var/lib/mysql/$database | wc -l)" == "1" ]; then
echo "$database" >> /tmp/checvpsbase-list
fi
 done

if [ ! -f /tmp/checvpsbase-list ]; then
rm -rf /tmp/*vpsvn*
rm -rf /tmp/*list*
clear
echo "========================================================================="
echo "Khong tim thay database co du lieu tren server"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
 

prompt="Nhap lua chon cua ban:"
options=("BAT/TAT Tu Dong Backup Database" "List Database BAT Tu Dong Backup")
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in
    1 ) /etc/lemp/menu/lemp-befor-chon-tat-bat-tu-dong-sao-luu-database.sh;;
    2 ) /etc/lemp/menu/lemp-danh-sach-data-tu-dong-sao-luu-database.sh;;
    $(( ${#options[@]}+1 )) ) echo "";  clear && /etc/lemp/menu/4_database/lemp-them-xoa-database.sh;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach.";continue;;

    esac
done
