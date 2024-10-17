#!/bin/bash 
. /home/lemp.conf

uploadsite=$(cat /tmp/uploadsite)
check_folder_protect_config()
{
if [ -d /etc/nginx/pwprotect/$uploadsite ]; then
cd /etc/nginx/pwprotect/$uploadsite
rm -rf * .??*
cd
rm -rf /etc/nginx/pwprotect/$uploadsite
fi
}
check_ftp_account()
{
if [ ! -f /etc/lemp/FTP-Account.info ]; then
echo "=========================================================================" > /etc/lemp/FTP-Account.info
echo "Please Do Not Delete This File " >> /etc/lemp/FTP-Account.info
echo "-------------------------------------------------------------------------" >> /etc/lemp/FTP-Account.info
echo "If you delete this file, LEMP will not run !" >> /etc/lemp/FTP-Account.info
echo "-------------------------------------------------------------------------" >> /etc/lemp/FTP-Account.info
echo "All FTP User for all domain on VPS list below:" >> /etc/lemp/FTP-Account.info
echo "=========================================================================" >> /etc/lemp/FTP-Account.info
echo "" >> /etc/lemp/FTP-Account.info
fi
if [ -f /etc/pure-ftpd/pureftpd.passwd ]; then
if [ ! "$(grep /home/$uploadsite/ /etc/pure-ftpd/pureftpd.passwd)" == "" ];then  
rm -rf /tmp/abcd
cat > "/tmp/abcd" <<END	
sed -i '/\/home\/$uploadsite/d' /etc/pure-ftpd/pureftpd.passwd
END
chmod +x /tmp/abcd
/tmp/abcd
rm -rf /tmp/abcd
pure-pw mkdb
fi
fi
if [ ! "$(grep /home/$uploadsite/ /etc/lemp/FTP-Account.info)" == "" ];then 
echo "========================================================================="
echo "Phat hien tai khoan FTP: $(grep /home/$uploadsite/ /etc/lemp/FTP-Account.info | awk 'NR==1 {print $7}') cua $uploadsite  "
echo "-------------------------------------------------------------------------"
echo "LEMP se remove tai khoan FTP: $(grep /home/$uploadsite/ /etc/lemp/FTP-Account.info | awk 'NR==1 {print $7}')"
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
echo "-------------------------------------------------------------------------"
sleep 6
rm -rf /tmp/abcde
cat > "/tmp/abcde" <<END	
sed -i '/\/home\/$uploadsite/d' /etc/lemp/FTP-Account.info
END
chmod +x /tmp/abcde
/tmp/abcde
rm -rf /tmp/abcde
fi
}
echo "========================================================================="
echo "Domain ban muon remove la Domain File Manager"
echo "-------------------------------------------------------------------------"
read -r -p "Ban chac chan muon xoa domain nay khoi server ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait....";sleep 1
rm -rf /etc/lemp/uploadsite
rm -rf /home/$uploadsite
rm -f /etc/nginx/conf.d/$uploadsite.conf 
if [ ! -f /etc/lemp/opcache.blacklist ]; then
cat > "/etc/lemp/opcache.blacklist" <<END
END
fi
if [ ! "$(grep /home/$uploadsite /etc/lemp/opcache.blacklist)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Phat hien $uploadsite trong Zend Opcache Blacklist"
echo "-------------------------------------------------------------------------"
echo "LEMP se xoa $uploadsite trong blacklist nay"
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
sleep 6
rm -rf /tmp/zendcacheblacklist
cat > "/tmp/zendcacheblacklist" <<END
sed --in-place '\/home\/$uploadsite/d' /etc/lemp/opcache.blacklist
END
chmod +x /tmp/zendcacheblacklist
/tmp/zendcacheblacklist
rm -rf /tmp/zendcacheblacklist
fi
check_ftp_account
check_and_delete_auto_backup_website()
{
	if [  -f /bin/lemp-backupcode-$uploadsite ]; then
	if [ ! "$(grep lemp-backupcode-$uploadsite /etc/cron.d/lemp.code.cron)" == "" ]; then
echo "========================================================================="
echo "Phat hien $uploadsite dang bat auto backup code"
echo "-------------------------------------------------------------------------"
echo "LEMP se tat che do auto backup code khi remove khoi server"
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
sleep 5
	rm -rf /bin/lemp-backupcode-$uploadsite
	cat > "/tmp/removebackupcode" <<END
sed -i '/lemp-backupcode-$uploadsite/d' /etc/cron.d/lemp.code.cron
END
chmod +x /tmp/removebackupcode
/tmp/removebackupcode 
rm -rf /tmp/removebackupcode
service crond restart
	fi
	fi
}
check_and_delete_auto_backup_website
check_folder_protect_config

systemctl reload nginx
for service in $(systemctl list-units --type=service --state=running | grep php | awk '{print $1}'); do
    systemctl restart $service
done


rm -rf /tmp/upload*
clear
echo "========================================================================= "
echo "Remove Domain File Manager thanh cong ! "
lemp
;;
    *)
    rm -rf /tmp/upload*
       clear 
echo "========================================================================= "
echo "Ban huy remove Domain File Manager."
lemp
        ;;
esac
rm -rf /tmp/upload*
clear 
echo "========================================================================= "
echo "Ban huy remove Domain File Manager"
lemp



