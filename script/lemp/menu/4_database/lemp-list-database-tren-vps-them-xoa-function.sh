#!/bin/bash
. /home/lemp.conf
rm -rf /home/$mainsite/private_html/ListDatabase*
randomcode=-`date |md5sum |cut -c '1-12'`
clear
echo "========================================================================="
echo "==================================================================================================================" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
echo "                                        Database Information Created by LEMP" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
echo "==================================================================================================================" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt

echo "" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
rm -rf /tmp/abc
ls -l /var/lib/mysql | grep "^d" | awk -F" " '{print $9}' | grep -Ev "(Database|information_schema|mysql|performance_schema|lempCheckDB)" > /tmp/abc
listdatabasetrenserver=$(cat /tmp/abc)
checksizeabc=$(du -sb /tmp/abc | awk 'NR==1 {print $1}')
sodatabasetrenserver=$(cat /tmp/abc | wc -l)
rm -rf /tmp/*check*
for database in $listdatabasetrenserver 
do
if [ ! "$(ls -1 /var/lib/mysql/$database | wc -l)" == "1" ]; then
echo "$database" >> /tmp/checvpsbase-list
fi
if [ "$(ls -1 /var/lib/mysql/$database | wc -l)" == "1" ]; then
echo "$database" >> /tmp/checvpsbaseempty-list
fi
 done
 if [ ! -f /tmp/checvpsbase-list ]; then
	if [ "$checksizeabc" == "1" ]; then
	echo "Ban Chua Tao Database Tren Server"
	else
	echo "Tat Ca Database Deu Khong Co Du Lieu"
	fi
###
echo "------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
echo "Tat Ca Database Deu Khong Co Du Lieu" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
echo "------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
 else
 databasedulieu=$(cat /tmp/checvpsbase-list | wc -l)
 echo "Database Co Du Lieu:"
 echo "-------------------------------------------------------------------------"
 cat /tmp/checvpsbase-list | pr -2 -t 
 ###
echo "------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
 echo "Database Co Du Lieu:" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
echo "------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
 
lemp_check_size=`cat /tmp/checvpsbase-list`
rm -rf /tmp/checksiztungdb
for datbase123 in $lemp_check_size 
do
sizetungdb=`du -sh /var/lib/mysql/$datbase123 | awk 'NR==1 {print $1}'`
echo "$datbase123 (Size: $sizetungdb)" >> /tmp/checksiztungdb
done
cat /tmp/checksiztungdb | pr -2 -t > /tmp/checksizetungdb12
cat /home/$mainsite/private_html/ListDatabase$randomcode.txt /tmp/checksizetungdb12  > /tmp/checksizetungdb2
rm -rf /home/$mainsite/private_html/ListDatabase$randomcode.txt
mv /tmp/checksizetungdb2 /home/$mainsite/private_html/ListDatabase$randomcode.txt
 sodatabasecodulieu=$(echo "| Database has data: $databasedulieu")
 fi
	if [ -f /tmp/checvpsbaseempty-list ]; then
	databaseempty=$(cat /tmp/checvpsbaseempty-list | wc -l)
	sodatabaseempty=$(echo "| Database Empty: $databaseempty")
	echo "-------------------------------------------------------------------------"
	echo "Database Empty:"
	echo "-------------------------------------------------------------------------" 
	cat /tmp/checvpsbaseempty-list | pr -2 -t   
	####
echo "------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
	echo "Database Empty:" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
echo "------------------------------------------------------------------------------------------------------------------"  >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
	cat /tmp/checvpsbaseempty-list | pr -2 -t >> /home/$mainsite/private_html/ListDatabase$randomcode.txt 
	fi
if [ ! "$checksizeabc" == "1" ]; then
echo "========================================================================="
echo "Xem Chi Tiet:"
echo "-------------------------------------------------------------------------" 
echo "http://$serverip:$priport/ListDatabase$randomcode.txt"
echo "-------------------------------------------------------------------------" 
echo "Tong Database: $sodatabasetrenserver $sodatabasecodulieu $sodatabaseempty "
fi
####
echo "------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
echo "Tong Database: $sodatabasetrenserver | Database has data: $databasedulieu $sodatabaseempty" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
echo "------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListDatabase$randomcode.txt
rm -rf /tmp/abc
rm -rf /tmp/*check*
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
