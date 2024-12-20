#!/bin/bash
. /home/lemp.conf
rm -rf /home/$mainsite/private_html/ListWebsite*
randomcode=-`date |md5sum |cut -c '1-12'`
rm -rf /tmp/*check*
rm -rf /tmp/abc
clear
echo "========================================================================="
echo "Website Co Du Lieu:"
echo "-------------------------------------------------------------------------"
echo "=================================================================================================================" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "List Website - Created by LEMP" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "=================================================================================================================" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "-----------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "Website Co Du Lieu :" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "-----------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "$(ls /etc/nginx/conf.d | sed 's/.conf//' | sed 's/^www.//')" > /tmp/abc
sowebsitetrenserver=$(cat /tmp/abc)
rm -rf /tmp/checksite-list
for website in $sowebsitetrenserver 
do
if [ -f /home/$website/public_html/index.php ]; then
echo "$website" >> /tmp/checksite-list
fi
if [ ! -f /home/$website/public_html/index.php ]; then
echo "$website" >> /tmp/checksiteempty
fi
 done
 if [ ! -f /tmp/checksite-list ]; then
 websitedulieu=0
 else
 websitedulieu=$(cat /tmp/checksite-list | wc -l)
 fi
 if [ -f /tmp/checksite-list ]; then
cat /tmp/checksite-list | pr -2 -t

lemp_check_size=`cat /tmp/checksite-list`
rm -rf /tmp/checksiztungsite
for website123 in $lemp_check_size 
do
sizetungsize=`du -sh /home/$website123 | awk 'NR==1 {print $1}'`
echo "$website123 (Size: $sizetungsize)" >> /tmp/checksiztungsite
done
cat /tmp/checksiztungsite | pr -2 -t > /tmp/checksizetungsize12
cat /home/$mainsite/private_html/ListWebsite$randomcode.txt /tmp/checksizetungsize12  > /tmp/checksizetungzite2
rm -rf /home/$mainsite/private_html/ListWebsite$randomcode.txt
mv /tmp/checksizetungzite2 /home/$mainsite/private_html/ListWebsite$randomcode.txt
else
echo "There's no website has data in server"
echo "There's no website has data in server"  >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
fi
 if [ -f /tmp/checksiteempty ]; then
	websitedatabaseempty=$(cat /tmp/checksiteempty | wc -l)
	sowebsitedatabaseempty=$(echo "| Website No Data: $websitedatabaseempty")
	echo "-------------------------------------------------------------------------"
	echo "Website No Data:"
	echo "-------------------------------------------------------------------------" 
	cat /tmp/checksiteempty | pr -2 -t  
	####
	echo "-----------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
	echo "Website No Data:" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
	echo "-----------------------------------------------------------------------------------------------------------------"  >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
	cat /tmp/checksiteempty  >> /home/$mainsite/private_html/ListWebsite$randomcode.txt 
	fi		
echo "-----------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "Total website: $(ls -1 /etc/nginx/conf.d | wc -l) | Website has data: $websitedulieu $sowebsitedatabaseempty " >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "=================================================================================================================" >> /home/$mainsite/private_html/ListWebsite$randomcode.txt
echo "========================================================================="
echo "Xem Chi Tiet:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/ListWebsite$randomcode.txt"
echo "-------------------------------------------------------------------------"
echo "Tong website: $(ls -1 /etc/nginx/conf.d | wc -l) | Website Co Du Lieu: $websitedulieu $sowebsitedatabaseempty "
rm -rf /tmp/*check*
rm -rf /tmp/abc
/etc/lemp/menu/lemp-them-website-menu.sh
