#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Chuc nang nay dung de cai dat wordpress multisite dang Sub-directories "
echo "-------------------------------------------------------------------------" 
echo "Cai dat xong, ban tao account moi trong WP-Admin ma khong can tao Vhost"
echo "========================================================================="
echo -n "Nhap ten website: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website Co the khong dung dinh dang domain!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ -f /home/$website/public_html/wp-config-sample.php ]; then
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website co code wordpress nhung chua cai dat !"
echo "-------------------------------------------------------------------------"
echo "Hay cai dat wordpress va thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong phai wordpress blog !"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! "$(grep "WP_ALLOW_MULTISITE" /home/$website/public_html/wp-config.php)" == "" ]; then
clear
echo "========================================================================="
echo "$website da cai dat Wordpress Multisite thanh cong"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
tendatabase=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
echo "========================================================================="
echo "Tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "$website su dung wordpress code"
echo "========================================================================="
echo "LUA CHON PHUONG THUC CAI DAT WORDPRESS MULTISITE"
echo "========================================================================="
prompt="Nhap lua chon cua ban: "
options=( "Cai dat Wordpress Multisite Ngay" "Sao luu (Database & Wp-config.php) roi cai dat" "Huy cai dat")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) luachoncaidat="caingay"; break;;
    2) luachoncaidat="sauluuroicai"; break;;
    3) luachoncaidat="cancel"; break;;
    *) echo "Ban nhap sai, Vui long nhap theo danh sach trong list";continue;;
    #*) echo "You typed wrong, Please type in the ordinal number on the list";continue;;
    esac  
done
###################################
#caingay
###################################
if [ "$luachoncaidat" = "caingay" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."  
sleep 2
cd /home/$website/public_html
wp core multisite-convert --allow-root
cd
if [ ! "$(grep "WP_ALLOW_MULTISITE" /home/$website/public_html/wp-config.php)" == "" ]; then
sed -i "/.*block.conf*./a\#Config\ for\ Wordpress\ WP-MultiSite" /etc/nginx/conf.d/$website.conf
sed -i "s/.*WP-MultiSite*./\n&/" /etc/nginx/conf.d/$website.conf
sed -i "/.*WP-MultiSite*./ainclude \/etc\/nginx\/conf\/rule-multisite-subfolder.conf;" /etc/nginx/conf.d/$website.conf
fi
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
service nginx restart
else
systemctl restart php-fpm.service
systemctl restart nginx.service
fi 
clear
if [ ! "$(grep "rule-multisite-subfolder.conf" /etc/nginx/conf.d/$website.conf)" == "" ]; then
echo "========================================================================="
echo "Cai dat WP Multisite & Config Vhost cho $website thanh cong !"
else
echo "========================================================================="
echo "Cai dat Wordpress Multisite cho $website that bai !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
fi
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
###################################
#sao luu roi cai
###################################
elif [ "$luachoncaidat" = "sauluuroicai" ]; then
tendatabase=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
echo "`date '+%d%m'`" > /tmp/datetime
tenmo=$(cat /tmp/datetime)
if [ ! -d /home/$website/public_html/0-lemp ]; then
mkdir -p /home/$website/public_html/0-lemp
fi
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 2
cd /home/$website/public_html
#wp db export $tendatabase-$tenmo --allow-root
randomwp=`date |md5sum |cut -c '1-16'`
#mv -f /home/$website/public_html/$tendatabase-$tenmo /home/$website/public_html/0-lemp/$tendatabase-$tenmo.Before-WP-Multisite_$randomwp
if [ "$(grep "default_storage_engine = MyISAM" /etc/my.cnf.d/server.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mysqldump -u root -p$mariadbpass $tendatabase --lock-tables=false | gzip -9 > /home/$website/public_html/0-lemp/$tendatabase-$tenmo.Before-WP-Multisite_$randomwp.sql.gz
else
mysqldump -u root -p$mariadbpass $tendatabase --single-transaction | gzip -9 > /home/$website/public_html/0-lemp/$tendatabase-$tenmo.Before-WP-Multisite_$randomwp.sql.gz
fi
cp /home/$website/public_html/wp-config.php /home/$website/public_html/0-lemp/wp-config.php-$tenmo.Before-WP-Multisite_$randomwp
wp core multisite-convert --allow-root
cd
if [ ! "$(grep "WP_ALLOW_MULTISITE" /home/$website/public_html/wp-config.php)" == "" ]; then
sed -i "/.*block.conf*./a\#Config\ for\ Wordpress\ WP-MultiSite" /etc/nginx/conf.d/$website.conf
sed -i "/.*WP-MultiSite*./ainclude \/etc\/nginx\/conf\/rule-multisite-subfolder.conf;" /etc/nginx/conf.d/$website.conf
fi
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
service nginx restart
else
systemctl restart php-fpm.service
systemctl restart nginx.service
fi 
clear
if [ ! "$(grep "rule-multisite-subfolder.conf" /etc/nginx/conf.d/$website.conf)" == "" ]; then
echo "========================================================================="
echo "Cai dat WP Multisite & Config Vhost cho $website thanh cong !"
else
echo "========================================================================="
echo "Cai dat Wordpress Multisite cho $website that bai !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
fi
if [ -f /home/$website/public_html/0-lemp/$tendatabase-$tenmo.Before-WP-Multisite_$randomwp.sql.gz ]; then
echo "-------------------------------------------------------------------------"
echo "Sao luu Database & wp-config.php thanh cong"
echo "-------------------------------------------------------------------------"
echo "Link foler backup: http://$website/0-lemp"
else
echo "-------------------------------------------------------------------------"
echo "Sao luu database that bai !"
fi
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
