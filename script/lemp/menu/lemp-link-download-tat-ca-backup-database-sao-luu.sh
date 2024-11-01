#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/*vpsvn*
mkdir -p /tmp/danhsachdatabasebackupvpsvn
listdatabases=$(ls -l /var/lib/mysql | grep "^d" | awk -F" " '{print $9}' | grep -Ev "(Database|information_schema|mysql|performance_schema|lempCheckDB)")
code=`date |md5sum |cut -c '1-12'`
rm -rf /tmp/checksite-list
for dataname in $listdatabases 
do
if [ -f /home/$mainsite/private_html/backup/$dataname/*.sql.gz ]; then
echo "$dataname" >> /tmp/checksite-list
fi
done

if [ ! -f /tmp/checksite-list ]; then
clear
echo "========================================================================="
echo "lemp khong tim thay file backup database tren server"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
sodatabasecobackup=$(cat /tmp/checksite-list | wc -l)
listdatabasedasaoluu=$(cat /tmp/checksite-list)
getlink ()
{
find /home/$mainsite/private_html/backup/$dataname/ -name '*.sql.gz' -type f -exec basename {} \;  > /tmp/linvpsbasename
filename=`cat /tmp/linvpsbasename`
find /home/$mainsite/private_html/backup/$dataname/ -type f -exec basename {} \;  > /tmp/linkbackupall
backupall=$(cat /tmp/linkbackupall)
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
showinfo=`echo "File backup gan nhat (Thoi gian backup $(date -r /home/$mainsite/private_html/backup/$dataname/$filename +%H:%M/%F)):" `
else
showinfo=`echo "File Backup (Thoi gian backup $(date -r /home/$mainsite/private_html/backup/$dataname/$filename +%H:%M/%F)): "`
fi
echo "========================================================================="
echo "Tim thay file backup cua: $dataname"
echo "-------------------------------------------------------------------------"
sleep 2
echo "http://$serverip:$priport/backup/$dataname/$filename"
cd
echo "" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "========================================================================================================================" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "Database [ $dataname ]" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt 
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "$showinfo"  >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "http://$serverip:$priport/backup/$dataname/$filename" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
touch /tmp/danhsachdatabasebackupvpsvn/$dataname
#####################

if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "Tat ca cac file backup:" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
for backupfile in $backupall
do
echo "http://$serverip:$priport/backup/$dataname/$backupfile" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
done
fi
#########################
rm -rf /tmp/linkbackupall
}

echo "========================================================================="
echo "Dung chuc nang nay de lay link download tat ca backup database tren Server"
echo "=========================================================================" 
read -r -p "Ban muon lay danh sach nay ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "========================================================================="
echo "Please wait ..."
sleep 2
rm -rf /home/$mainsite/private_html/Listbackupall*.txt
echo "========================================================================================================================" > /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "                                Link Download All Backup Files - Created by LEMP" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "========================================================================================================================" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt

for dataname in $listdatabasedasaoluu 
do
getlink
done
clear
echo "========================================================================="
echo "Database co backup:"
echo "-------------------------------------------------------------------------"
ls /tmp/danhsachdatabasebackupvpsvn | pr -2 -t
echo "-------------------------------------------------------------------------"
echo "Link download tat ca backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/Listbackupall-DB-$code.txt"
echo "" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "===================================================The End==============================================================" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
rm -rf /tmp/*vpsvn*
   ;;
    *)
    clear
        echo "========================================================================= "
        echo "Huy bo lay link download backup cua tat ca database"
        /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
esac

