#!/bin/bash
. /home/lemp.conf
. /etc/lemp/pwprotect.default
if [ ! -d /etc/nginx/pwprotect ]; then
mkdir -p /etc/nginx/pwprotect
fi

if [ ! -f /etc/lemp/netdatasite.info ]; then
clear
echo "========================================================================="
echo "Ban chua cai dat domain NetData cho Server !"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi
netdatasite=$(cat /etc/lemp/netdatasite.info)
if [ ! -f /etc/nginx/.htpasswd ]; then
clear
echo "========================================================================="
echo "Ban phai tao User va Mat khau mac dinh truoc khi chay chuc nang nay. Tao "
echo "-------------------------------------------------------------------------"
echo "User va Mat Khau mac dinh: lemp Menu => User & Password Mac Dinh."
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi

if [ "$(grep auth_basic_user_file /etc/nginx/conf.d/$netdatasite.conf)" == "" ] ; then 
echo "========================================================================="
echo "Su dung chuc nang nay de BAT bao ve domain NetData. "
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon BAT bao ve domain NetData ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo "Please wait ... "
sleep 1
rm -rf /tmp/baovedomainnetdata
   cat >> "/tmp/baovedomainnetdata" <<END
sed -i "/server_name\ $netdatasite;/aauth_basic \"Authorization Required\";" /etc/nginx/conf.d/$netdatasite.conf
sed -i "/.*Authorization\ Required.*/aauth_basic_user_file  /etc/nginx/.htpasswd;" /etc/nginx/conf.d/$netdatasite.conf
END
chmod +x /tmp/baovedomainnetdata
/tmp/baovedomainnetdata
rm -rf /tmp/baovedomainnetdata


systemctl restart nginx

;;
    *)
       clear 
echo "========================================================================= "
echo "Huy bo dat mat khau bao ve domain NetData "
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
        ;;
esac
clear 
echo "========================================================================= "
echo "Hoan thanh BAT bao ve domain NetData."
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh

else

echo "========================================================================="
echo "Chuc nang bao ve domain NetData dang duoc BAT."
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
sed -i '/auth_basic/d' /etc/nginx/conf.d/$netdatasite.conf

systemctl reload nginx

;;
    *)
       clear 
echo "========================================================================= "
echo "Huy bo TAT bao ve domain NetData"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
        ;;
esac
clear 
echo "========================================================================= "
echo "Hoan thanh TAT mat khau bao ve domain NetData "
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
fi
