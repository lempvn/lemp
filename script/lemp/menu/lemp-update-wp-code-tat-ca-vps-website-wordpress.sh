#!/bin/bash
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

randomcode=-`date |md5sum |cut -c '1-18'`
cd /etc/nginx/conf.d
ls > /tmp/websitelist
sed -i 's/\.conf//g' /tmp/websitelist
cd
rm -rf /tmp/wordpresslist
file1="/tmp/websitelist"
while read -r wpsite
    do
if [ -f /home/$wpsite/public_html/wp-config.php ]; then
echo "$wpsite" >> /tmp/wordpresslist
fi
 done < "$file1"
 if [ ! -f /tmp/wordpresslist ]; then
clear
echo "========================================================================="
 echo "LEMP khong tim thay website chay Wordpress Code tren Server"
 /etc/lemp/menu/lemp-wordpress-tools-menu.sh
 exit
 fi
sositewp=$(cat /tmp/wordpresslist | wc -l)
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
echo "========================================================================="
echo "Hien tai co $sositewp website dang su dung code wordpress tren he thong" 
echo "-------------------------------------------------------------------------"
echo "LEMP se check va update tat ca website co the update."
echo "========================================================================="
sleep 1
file="/tmp/wordpresslist"

rm -rf /tmp/*vpsvn*
rm -rf /home/$mainsite/private_html/Listbackupwpdata*

echo "=========================================================================" > /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "List Backup Files - Created by lemp " >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "=========================================================================" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt

mkdir -p /tmp/sowebsitecanupdatevpsvn
mkdir -p /tmp/updatethanhcongvpsvn
mkdir -p /tmp/saoluudatabasethanhcongvpsvn
mkdir -p /tmp/updatethatbaivpsvn
mkdir -p /tmp/saoluudatathatbaivpsvn
while read -r wpwebsite
    do
if [ -f /home/$wpwebsite/public_html/wp-config.php ]; then
#echo "$line"
chown -R www-data:www-data /home/$wpwebsite/public_html
cd /home/$wpwebsite/public_html
date |md5sum |cut -c '1-10' > /tmp/abcd
random=$(cat /tmp/abcd)
tendatabase=`cat /home/$wpwebsite/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
echo "`date '+%d%m'`" > /tmp/datetime
tenmo=$(cat /tmp/datetime)
cd /home/$wpwebsite/public_html/
lempcheckversion=$(wp core check-update --allow-root | tail -n1 | awk 'NR==1 {print $1}')
  if [ "$lempcheckversion" == "Success:" ]; then
  echo "Update $wpwebsite Status:"
  echo "Website $wpwebsite dang chay phien ban wordpress moi nhat "
  echo "========================================================================="
 else
      if [ ! -d /home/$wpwebsite/public_html/0-lemp ]; then
mkdir -p /home/$wpwebsite/public_html/0-lemp
      fi
 echo "Update $wpwebsite Status:"
echo "LEMP se update $wpwebsite tu $(wp core version --allow-root) len $lempcheckversion"
echo "-------------------------------------------------------------------------"
check1=$(date +"%H%m%s")
touch /tmp/sowebsitecanupdatevpsvn/$check1
if [ "$(grep "default_storage_engine = MyISAM" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mariadb-dump -u root -p$mariadbpass $tendatabase --lock-tables=false | gzip -9 > /home/$wpwebsite/public_html/0-lemp/$tendatabase-$random-$tenmo.sql.gz
else
mariadb-dump -u root -p$mariadbpass $tendatabase --single-transaction | gzip -9 > /home/$wpwebsite/public_html/0-lemp/$tendatabase-$random-$tenmo.sql.gz
fi

wp core update --allow-root > /tmp/abc.txt
wp core update-db --allow-root > /tmp/abc.txt
chown -R www-data:www-data /home/$wpwebsite/public_html
cd /home/$wpwebsite/public_html
lempcheckversion2=$(wp core check-update --allow-root | tail -n1 | awk 'NR==1 {print $1}')
     if [ "$lempcheckversion2" == "Success:" ]; then   
     echo "Update Wordpress code cho $wpwebsite thanh cong"
     echo "-------------------------------------------------------------------------"
check2=$(date +"%H%m%s")
touch /tmp/updatethanhcongvpsvn/$check2  
		if [ -f /home/$wpwebsite/public_html/0-lemp/$tendatabase-$random-$tenmo.sql.gz ]; then
echo "Backup database $tendatabase thanh cong. Link Backup:"
echo "-------------------------------------------------------------------------"
echo "http://$wpwebsite/0-lemp/$tendatabase-$random-$tenmo.sql.gz"
echo ""  >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "=========================================================================" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "Backup Database: $tendatabase cua website $wpwebsite" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "-------------------------------------------------------------------------" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "http://$wpwebsite/0-lemp/$tendatabase-$random-$tenmo.sql.gz" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
echo "=========================================================================" >> /home/$mainsite/private_html/Listbackupwpdata$randomcode.txt
check3=$(date +"%H%m%s")
touch /tmp/saoluudatabasethanhcong/$check3
echo "========================================================================="
		else
echo "Backup database that bai"
echo "========================================================================="
		fi   
     else
echo "Update wordpress code that bai"
  echo "-------------------------------------------------------------------------"
  echo "abc" > /tmp/updatethatbaivpsvn/$wpwebsite
  rm -rf /home/$wpwebsite/public_html/0-lemp/$tendatabase-$random-$tenmo.sql.gz
     fi
cd
     
  fi
fi
done < "$file"
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
if [ "$(ls -1 /tmp/sowebsitecanupdatevpsvn | wc -l)" == "0" ]; then
clear
echo "========================================================================="
echo "Co $sositewp wordpress website trong he thong"
echo "-------------------------------------------------------------------------"
echo "Tat ca cac website nay deu su dung wordpress phien ban moi nhat"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
else

systemctl restart php${PHP_VERSION}-fpm.service

clear
echo "========================================================================="
echo "Co $sositewp wordpress website trong he thong"
echo "-------------------------------------------------------------------------"
echo "Website can update: $(ls -1 /tmp/sowebsitecanupdatevpsvn | wc -l) | Website update thanh cong: $(ls -1 /tmp/updatethanhcongvpsvn | wc -l)"
echo "-------------------------------------------------------------------------"
if [ "$(ls -A /tmp/updatethatbaivpsvn)" ]; then
echo "Website update that bai: "
echo "-------------------------------------------------------------------------"
ls /tmp/updatethatbaivpsvn
echo "-------------------------------------------------------------------------"
fi
echo "Database sao luu thanh cong: $(ls -1 /tmp/saoluudatabasethanhcongvpsvn | wc -l)"
if [ ! "$(ls -1 /tmp/saoluudatabasethanhcongvpsvn | wc -l)" == "0" ]; then
echo "-------------------------------------------------------------------------"
echo "List file backup database: "
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/Listbackupwpdata$randomcode.txt "
fi
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
rm -rf /tmp/*vpsvn*
fi
