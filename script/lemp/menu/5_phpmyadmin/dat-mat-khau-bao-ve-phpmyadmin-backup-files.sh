#!/bin/bash
. /home/lemp.conf
. /etc/lemp/pwprotect.default

if [ ! -d /etc/nginx/pwprotect ]; then
mkdir -p /etc/nginx/pwprotect
fi

if [ ! -f /etc/nginx/.htpasswd ]; then
clear
echo "========================================================================="
echo "Ban phai tao User va Mat khau mac dinh truoc khi chay chuc nang nay. Tao "
echo "-------------------------------------------------------------------------"
echo "User va Mat Khau mac dinh: LEMP Menu => User & Password Mac Dinh."
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
exit
fi

if [ "$(grep auth_basic_user_file /etc/nginx/conf.d/$mainsite.conf)" == "" ] ; then 
echo "========================================================================="
echo "Su dung chuc nang nay de BAT bao ve phpMyAdmin va cac file backup, "
echo "-------------------------------------------------------------------------"
echo "memcache.php, ocp.php..."
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon BAT bao ve phpMyAdmin va file backup ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo "Please wait ... "
sleep 1
rm -rf /tmp/baovephpmyadmin
   cat >> "/tmp/baovephpmyadmin" <<END
sed -i "/\/home\/$mainsite\/private_html;/aauth_basic \"Authorization Required\";" /etc/nginx/conf.d/$mainsite.conf
sed -i "/.*Authorization\ Required.*/aauth_basic_user_file  /etc/nginx/.htpasswd;" /etc/nginx/conf.d/$mainsite.conf
END
chmod +x /tmp/baovephpmyadmin
/tmp/baovephpmyadmin
rm -rf /tmp/baovephpmyadmin
service nginx reload
;;
    *)
       clear 
echo "========================================================================= "
echo "Huy bo dat mat khau bao ve phpMyAdmin "
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
esac
clear 
echo "========================================================================= "
echo "Hoan thanh BAT bao ve phpMyAdmin va cac file backup, ocp.php ..."
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh

else

echo "========================================================================="
echo "Chuc nang nay bao ve phpMyAdmin va cac file backup, memcache.php, "
echo "-------------------------------------------------------------------------"
echo "ocp.php ... dang duoc BAT."
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon TAT chuc nang nay ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo "Please wait ... "
sleep 1
sed -i '/auth_basic/d' /etc/nginx/conf.d/$mainsite.conf

systemctl reload nginx

;;
    *)
       clear 
echo "========================================================================= "
echo "Huy bo TAT mat khau bao ve phpMyAdmin "
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
esac
clear 
echo "========================================================================= "
echo "Hoan thanh TAT mat khau bao ve phpMyAdmin "
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
fi
