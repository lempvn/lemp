#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de Toi uu (Optimize) hoac Sua loi (repair) Database "
echo "-------------------------------------------------------------------------" 
echo -n "Nhap ten website: " 
read website
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
databasename=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
echo "-------------------------------------------------------------------------"
echo "Tim thay $website trong he thong"
echo "-------------------------------------------------------------------------"
echo "$website su dung wordpress code"
echo "-------------------------------------------------------------------------"
echo "Database dang duoc su dung: $databasename "
echo "========================================================================="
echo "Lua chon thao tac database"
echo "========================================================================="
prompt="Nhap lua chon cua ban: "
options=( "Toi Uu Database" "Sua Loi Database" "Huy Bo")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) cachlam="toiuu"; break;;
    2) cachlam="repair"; break;;
    3) cachlam="huybo"; break;;  
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################
#Xoacahai
###################################
if [ "$cachlam" = "toiuu" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
echo "-------------------------------------------------------------------------"
sleep 1
cd /home/$website/public_html/
wp db optimize --allow-root
sleep 1
cd
clear
echo "========================================================================="
echo "Hoan thanh toi uu database cho $website"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
elif [ "$cachlam" = "repair" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
echo "-------------------------------------------------------------------------"
sleep 1
cd /home/$website/public_html/
wp db repair --allow-root
cd
sleep 1
clear
echo "========================================================================="
echo "Hoan thanh sua loi database cua $website"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
else 
cd
clear
echo "========================================================================="
echo "Huy bo Toi uu hoac Repair database cho $website"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi


