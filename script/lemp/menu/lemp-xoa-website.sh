#!/bin/bash

. /home/lemp.conf
rm -rf /tmp/checktmp
echo "Check /tmp by lemp" > /tmp/checktmp
if [ ! -f /tmp/checktmp ]; then
clear
echo "========================================================================="
echo "Server cua ban gap van de voi thu muc /tmp "
echo "-------------------------------------------------------------------------"
echo "Hay fix no truoc khi su dung tinh nang nay!"
lemp
exit
fi

rm -rf /tmp/checktmp
check_folder_protect_config()
{
if [ -d /etc/nginx/pwprotect/$website ]; then
cd /etc/nginx/pwprotect/$website
rm -rf * .??*
cd
rm -rf /etc/nginx/pwprotect/$website
fi
}

#check_ftp_account()
#{
#if [ ! -f /etc/lemp/FTP-Account.info ]; then
#echo "=========================================================================" > /etc/lemp/FTP-Account.info
#echo "Xin dung xoa file nay " >> /etc/lemp/FTP-Account.info
#echo "-------------------------------------------------------------------------" >> /etc/lemp/FTP-Account.info
#echo "Neu ban xoa file nay, LEMP se khong hoat dong!" >> /etc/lemp/FTP-Account.info
#echo "-------------------------------------------------------------------------" >> /etc/lemp/FTP-Account.info
#echo "Tat ca FTP User cho cac domain tren VPS duoc liet ke ben duoi:" >> /etc/lemp/FTP-Account.info
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
#echo "Phat hien tai khoan FTP: $(grep /home/$website/ /etc/lemp/FTP-Account.info | awk 'NR==1 {print $7}') cua $website  "
#echo "-------------------------------------------------------------------------"
#echo "LEMP se remove tai khoan FTP: $(grep /home/$website/ /etc/lemp/FTP-Account.info | awk 'NR==1 {print $7}')"
#echo "-------------------------------------------------------------------------"
#echo "Please wait ...."
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

echo "==============================================================================="
echo "Su dung chuc nang nay de remove website khoi server"
echo "-------------------------------------------------------------------------------"
echo "Sau khi remove, du lieu website bi xoa va khong the phuc hoi."
echo "-------------------------------------------------------------------------------"
echo "Ban nen xoa het user FTP cua website dinh xoa truoc khi su dung tinh nang nay!"
echo "-------------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
lemp
exit
fi



if [ "$website" = "$mainsite" ]; then
clear
echo "========================================================================="
echo "Ban dang muon remove domain quan ly !!!!"
echo "-------------------------------------------------------------------------"
echo "Domain quan ly khong the xoa khoi website !"
lemp
exit
fi

if [ -f /etc/lemp/uploadsite ]; then
rm -rf /tmp/uploadsite
cp -r /etc/lemp/uploadsite /tmp/uploadsite
uploadsite=$(cat /etc/lemp/uploadsite)
if [ "$website" = "$uploadsite" ]; then
/etc/lemp/menu/lemp-xoa-domain-file-manager-upload.sh
fi
fi

if [ -f /etc/lemp/netdatasite.info ]; then
netdatasite=$(cat /etc/lemp/netdatasite.info)
if [ "$website" = "$netdatasite" ]; then
clear
echo "========================================================================="
echo "Ban khong the xoa Domain Netdata"
lemp
fi
fi

if [ -f /etc/lemp/net2ftpsite.info ]; then
rm -rf /tmp/net2ftpsite.info
cp -r /etc/lemp/net2ftpsite.info /tmp/net2ftpsite.info
net2ftpsite=$(cat /etc/lemp/net2ftpsite.info)
if [ "$website" = "$net2ftpsite" ]; then
/etc/lemp/menu/lemp-xoa-website-net2ftp-lemp-main.sh
fi
fi



kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
lemp
exit
fi

if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website Khong ton tai tren he thong !"
lemp
exit
fi


if [ -f /home/$website/public_html/wp-config.php ]; then
rm -rf /tmp/removewebsite.txt
echo "$website" > /tmp/removewebsite.txt
/etc/lemp/menu/lemp-xoa-website-wordpress.sh
fi


if [ -f /home/$website/public_html/config.php ]; then
if [ -d /home/$website/public_html/phpbb ]; then
rm -rf /tmp/removewebsite.txt
echo "$website" > /tmp/removewebsite.txt
/etc/lemp/menu/lemp-xoa-website-phpbb-forum.sh
fi
fi

if [ -d /home/$website/public_html/administrator ]; then
if [ -f /home/$website/public_html/configuration.php ]; then
rm -rf /tmp/removewebsite.txt
echo "$website" > /tmp/removewebsite.txt
/etc/lemp/menu/lemp-xoa-website-joomla.sh
fi
fi

if [ -f /home/$website/public_html/Settings.php ]; then
if [ -f /home/$website/public_html/Sources/Themes.php ]; then
rm -rf /tmp/removewebsite.txt
echo "$website" > /tmp/removewebsite.txt
/etc/lemp/menu/lemp-xoa-website-smf-forum.sh
fi
fi

if [ -f /home/$website/public_html/inc/config.php ]; then
if [ -f /home/$website/public_html/inc/mybb_group.php ]; then
rm -rf /tmp/removewebsite.txt
echo "$website" > /tmp/removewebsite.txt
/etc/lemp/menu/lemp-xoa-website-mybb-forum.sh
fi
fi

if [ -f /home/$website/public_html/config.php ]; then
if [ ! "$(grep DIR_CACHE /home/$website/public_html/config.php)" == "" ]; then
if [ ! "$(grep DIR_LOGS /home/$website/public_html/config.php)" == "" ]; then
rm -rf /tmp/removewebsite.txt
echo "$website" > /tmp/removewebsite.txt
/etc/lemp/menu/lemp-xoa-website-opencart.sh
fi
fi
fi

echo "-------------------------------------------------------------------------"
echo "Tim thay $website "
echo "-------------------------------------------------------------------------"
read -r -p "Ban chac chan muon remove $website ra khoi VPS ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait....";sleep 1
rm -rf /home/$website
rm -f /etc/nginx/conf.d/$website.conf
rm -rf /etc/nginx/pwprotect/$website
### Remove website from Zend Opcache BlackList
if [ ! -f /etc/lemp/opcache.blacklist ]; then
cat > "/etc/lemp/opcache.blacklist" <<END
END
fi
if [ ! "$(grep /home/$website /etc/lemp/opcache.blacklist)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Phat hien $website trong Zend Opcache Blacklist"
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
#check_ftp_account
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
check_and_delete_auto_backup_website
if [ -f /root/.acme.sh/$website/$website.conf ]; then
rm -rf /root/.acme.sh/$website
rm -rf /etc/nginx/auth-acme/$website
rm -rf /etc/lemp/Backup.Vhost.SSL/$website
fi
############ 
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

clear
echo "========================================================================="
echo "Xoa $website khoi Server thanh cong."
lemp
        ;;
    *)
clear
echo "========================================================================="
echo "Ban khong xoa $website khoi Server "
lemp
        ;;
esac
else
clear
echo "========================================================================="
echo "Khong tim thay $website tren Server."
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai"
lemp
exit
fi
