#!/bin/bash
. /home/lemp.conf

website=`cat /tmp/removewebsite.txt`
tendatabase=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
websiteto=`echo $website | tr '[a-z]' '[A-Z]'`
check_folder_protect_config()
{
if [ -d /etc/nginx/pwprotect/$website ]; then
cd /etc/nginx/pwprotect/$website
rm -rf * .??*
cd
rm -rf /etc/nginx/pwprotect/$website
fi
}

check_and_delete_auto_backup_website()
{
	if [  -f /bin/lemp-backupcode-$website ]; then
	if [ ! "$(grep lemp-backupcode-$website /etc/cron.d/lemp.code.cron)" == "" ]; then
echo "========================================================================="
echo "Phat hien $website dang bat auto backup code"
echo "-------------------------------------------------------------------------"
echo "LEMP se tat che do auto backup code khi remove khoi server"
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
sleep 5
	rm -rf /bin/lemp-backupcode-$website
	cat > "/tmp/removebackupcode" <<END
sed -i '/lemp-backupcode-$website/d' /etc/cron.d/lemp.code.cron
END
chmod +x /tmp/removebackupcode
/tmp/removebackupcode 
rm -rf /tmp/removebackupcode
systemctl restart cron.service
	fi
	fi
}
#check_ftp_account()
#{
#if [ ! -f /etc/lemp/FTP-Account.info ]; then
#echo "=========================================================================" > /etc/lemp/FTP-Account.info
#echo "Please Do Not Delete This File " >> /etc/lemp/FTP-Account.info
#echo "-------------------------------------------------------------------------" >> /etc/lemp/FTP-Account.info
#echo "If you delete this file, LEMP will not run !" >> /etc/lemp/FTP-Account.info
#echo "-------------------------------------------------------------------------" >> /etc/lemp/FTP-Account.info
#echo "All FTP User for all domain on VPS list below:" >> /etc/lemp/FTP-Account.info
#echo "=========================================================================" >> /etc/lemp/FTP-Account.info
#echo "" >> /etc/lemp/FTP-Account.info
#fi
#if [ -f /etc/pure-ftpd/pureftpd.passwd ]; then
#if [ ! "$(grep /home/$website/ /etc/pure-ftpd/pureftpd.passwd)" == "" ];then  
#rm -rf /tmp/abcd
#cat > "/tmp/abcd" <<END	
#sed -i '/\/home\/$website/d' /etc/pure-ftpd/pureftpd.passwd
#END
#chmod +x /tmp/abcd
#/tmp/abcd
#rm -rf /tmp/abcd
#pure-pw mkdb
#fi
#fi

#if [ ! "$(grep /home/$website/ /etc/lemp/FTP-Account.info)" == "" ];then 
#echo "========================================================================="
#echo "Tim thay tai khoan FTP: $(grep /home/$website/ /etc/lemp/FTP-Account.info | awk 'NR==1 {print $7}') cua $website  "
#echo "-------------------------------------------------------------------------"
#echo "LEMP se remove tai khoan FTP: $(grep /home/$website/ /etc/lemp/FTP-Account.info | awk 'NR==1 {print $7}')"
#echo "-------------------------------------------------------------------------"
#echo "Please wait ...."
#echo "-------------------------------------------------------------------------"
#sleep 6
#rm -rf /tmp/abcde
#cat > "/tmp/abcde" <<END	
#sed -i '/\/home\/$website/d' /etc/lemp/FTP-Account.info
#END
#chmod +x /tmp/abcde
#/tmp/abcde
#rm -rf /tmp/abcde
#fi
#}
printf "===============================================================================\n"
echo "$website su dung code wordpress"
echo "-------------------------------------------------------------------------------"
echo "Ban nen xoa het user FTP cua website dinh xoa truoc khi su dung tinh nang nay!"
echo "-------------------------------------------------------------------------------"
echo "Database dang duoc su dung: $tendatabase "
prompt="Nhap lua chon cua ban: "
options=( "Xoa Ca Website + Database" "Chi Xoa Website, Giu Lai Database" "Sao Luu Website + Database Truoc Khi Xoa" "Huy Bo")
printf "===============================================================================\n"
echo "LUA CHON CACH XOA $websiteto"
printf "===============================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) cachxoa="xoacahai"; break;;
    2) cachxoa="xoawebsite"; break;;
    3) cachxoa="xoaantoan"; break;;
    4) cachxoa="huybo"; break;;  
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################
#Xoacahai
###################################
if [ "$cachxoa" = "xoacahai" ]; then
echo "Please wait...."
cd /home/$website/public_html
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
wp db drop --allow-root --yes
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
cd
rm -rf /home/$website
rm -rf /etc/nginx/conf.d/$website.conf
### Remove website from Zend Opcache BlackList
if [ ! -f /etc/lemp/opcache.blacklist ]; then
cat > "/etc/lemp/opcache.blacklist" <<END
END
fi
if [ ! "$(grep /home/$website /etc/lemp/opcache.blacklist)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Tim thay $website trong Zend Opcache Blacklist"
echo "-------------------------------------------------------------------------"
echo "LEMP se xoa $website trong blacklist nay"
echo "-------------------------------------------------------------------------"
echo "Please wait .... "
sleep 6
rm -rf /tmp/zendcacheblacklist
cat > "/tmp/zendcacheblacklist" <<END
sed --in-place '\/home\/$website/d' /etc/lemp/opcache.blacklist
END
chmod +x /tmp/zendcacheblacklist
/tmp/zendcacheblacklist
rm -rf /tmp/zendcacheblacklist
fi
#check_ftp_account ## Check tai khoan FTP 
check_and_delete_auto_backup_website ## Check auto backup code
check_folder_protect_config ### Check Config Protect Folder & Files
############

# Chuyen ten website qua webuser
convert_to_username() {
    echo "$website" | sed 's/\./_/g'
}

# Goi ham va luu gia tri tra ve vao bien moi
webuser=$(convert_to_username "$website")
#echo "Original website: $website"
#echo "Converted webuser: $webuser"

for version in $(ls /etc/php/); do
    if [ -f /etc/php/$version/fpm/pool.d/${webuser}.conf ]; then
		echo "========================================================================="
        rm /etc/php/*/fpm/pool.d/${webuser}.conf
	    echo "========================================================================="
        break
    fi
done


systemctl restart php${version}-fpm.service

systemctl restart nginx


if [ -f /bin/lemp-backupdb-$tendatabase ]; then
echo "-------------------------------------------------------------------------"
echo "Phat hien $tendatabase trong danh sach tu dong sao luu"
echo "-------------------------------------------------------------------------"
echo "LEMP se remove $tendatabase khoi danh sach tu dong sao luu"
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 3
rm -rf /bin/lemp-backupdb-$tendatabase
cat > "/tmp/removebackupdb" <<END
sed --in-place '/lemp-backupdb-$tendatabase/d' /etc/cron.d/lemp.db.cron
END
chmod +x /tmp/removebackupdb
/tmp/removebackupdb 
rm -rf /tmp/removebackupdb
systemctl restart cron.service
fi 
#clear
echo "========================================================================="
echo "Xoa $website va database thanh cong."
lemp
###################################
#xoawebsite
###################################
elif [ "$cachxoa" = "xoawebsite" ]; then
cd
echo "Please wait ...."
sleep 1
rm -rf /home/$website
rm -rf /etc/nginx/conf.d/$website.conf
### Remove website from Zend Opcache BlackList
if [ ! -f /etc/lemp/opcache.blacklist ]; then
cat > "/etc/lemp/opcache.blacklist" <<END
END
fi
if [ ! "$(grep /home/$website /etc/lemp/opcache.blacklist)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Tim thay $website trong Zend Opcache Blacklist"
echo "-------------------------------------------------------------------------"
echo "LEMP se xoa $website trong blacklist nay"
echo "-------------------------------------------------------------------------"
echo "Please wait .... "
sleep 6
rm -rf /tmp/zendcacheblacklist
cat > "/tmp/zendcacheblacklist" <<END
sed --in-place '\/home\/$website/d' /etc/lemp/opcache.blacklist
END
chmod +x /tmp/zendcacheblacklist
/tmp/zendcacheblacklist
rm -rf /tmp/zendcacheblacklist
#check_ftp_account ## Check tai khoan FTP 
check_and_delete_auto_backup_website ## Check auto backup code
check_folder_protect_config ### Check Config Protect Folder & Files
fi
############

# Chuyen ten website qua webuser
convert_to_username() {
    echo "$website" | sed 's/\./_/g'
}

# Goi ham va luu gia tri tra ve vao bien moi
webuser=$(convert_to_username "$website")
#echo "Original website: $website"
#echo "Converted webuser: $webuser"

for version in $(ls /etc/php/); do
    if [ -f /etc/php/$version/fpm/pool.d/${webuser}.conf ]; then
		echo "========================================================================="
        rm /etc/php/*/fpm/pool.d/${webuser}.conf
	    echo "========================================================================="
        break
    fi
done



systemctl restart php${version}-fpm.service

systemctl restart nginx

  
cd
#clear
echo "========================================================================="
echo "Xoa $website khoi VPS thanh cong."
echo "-------------------------------------------------------------------------"
echo "Database $tendatabase  van con tren VPS"
lemp

#################################
#Xoa an toan"
################################
elif [ "$cachxoa" = "xoaantoan" ]; then
random123=`date |md5sum |cut -c '1-5'`
echo "========================================================================="
echo "Please wait ...."
sleep 1
if [ -d /home/$mainsite/private_html/backup/$tendatabase ]; then
rm -rf /home/$mainsite/private_html/backup/$tendatabase
fi
mkdir -p /home/$mainsite/private_html/backup/$tendatabase
cd /home/$mainsite/private_html/backup/$tendatabase
if [ "$(grep "default_storage_engine = MyISAM" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mariadb-dump -u root -p$mariadbpass $tendatabase --lock-tables=false | gzip -9 > $tendatabase_$random123.sql.gz
else
mariadb-dump -u root -p$mariadbpass $tendatabase --single-transaction | gzip -9 > $tendatabase_$random123.sql.gz
fi
if [ -d /home/$mainsite/private_html/backup/$website ]; then
rm -rf /home/$mainsite/private_html/backup/$website
fi
cd /home/$website/public_html/
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
wp db drop --allow-root --yes
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
zip -r $website.zip *
mkdir -p /home/$mainsite/private_html/backup/$website/
mv $website.zip /home/$mainsite/private_html/backup/$website/$website_$random123.zip
rm -rf /home/$website
rm -rf /etc/nginx/conf.d/$website.conf
cd
### Remove website from Zend Opcache BlackList
if [ ! -f /etc/lemp/opcache.blacklist ]; then
cat > "/etc/lemp/opcache.blacklist" <<END
END
fi
if [ ! "$(grep /home/$website /etc/lemp/opcache.blacklist)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Tim thay $website trong Zend Opcache Blacklist"
echo "-------------------------------------------------------------------------"
echo "LEMP se xoa $website trong blacklist nay"
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
sleep 6
rm -rf /tmp/zendcacheblacklist
cat > "/tmp/zendcacheblacklist" <<END
sed --in-place '\/home\/$website/d' /etc/lemp/opcache.blacklist
END
chmod +x /tmp/zendcacheblacklist
/tmp/zendcacheblacklist
rm -rf /tmp/zendcacheblacklist
fi
############
#check_ftp_account ## Check tai khoan FTP 
check_and_delete_auto_backup_website ## Check auto backup code
check_folder_protect_config ### Check Config Protect Folder & Files

# Chuyen ten website qua webuser
convert_to_username() {
    echo "$website" | sed 's/\./_/g'
}

# Goi ham va luu gia tri tra ve vao bien moi
webuser=$(convert_to_username "$website")
#echo "Original website: $website"
#echo "Converted webuser: $webuser"

for version in $(ls /etc/php/); do
    if [ -f /etc/php/$version/fpm/pool.d/${webuser}.conf ]; then
		echo "========================================================================="
        rm /etc/php/*/fpm/pool.d/${webuser}.conf
	    echo "========================================================================="
        break
    fi
done


systemctl restart php${version}-fpm.service

systemctl restart nginx


if [ -f /bin/lemp-backupdb-$tendatabase ]; then
echo "-------------------------------------------------------------------------"
echo "Phat hien $tendatabase trong danh sach tu dong sao luu"
echo "-------------------------------------------------------------------------"
echo "LEMP se remove $tendatabase khoi danh sach tu dong sao luu"
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 3
rm -rf /bin/lemp-backupdb-$tendatabase
cat > "/tmp/removebackupdb" <<END
sed --in-place '/lemp-backupdb-$tendatabase/d' /etc/cron.d/lemp.db.cron
END
chmod +x /tmp/removebackupdb
/tmp/removebackupdb 
rm -rf /tmp/removebackupdb
systemctl restart cron.service
fi 

#clear
echo "========================================================================="
echo "Xoa $website va database thanh cong."
echo "-------------------------------------------------------------------------"
echo "Link file backup database $tendatabase : "
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$tendatabase/$tendatabase_$random123.sql.gz"
echo "-------------------------------------------------------------------------"
echo "Link file backup code:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$website/$website_$random123.zip"
lemp
###################################
#Huy bo
###################################
else 
cd
#clear
echo "========================================================================="
echo "Huy bo remove $website khoi server"
lemp
fi







