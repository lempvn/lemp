#!/bin/bash
. /etc/lemp/pwprotect.default
if [ ! -d /etc/nginx/pwprotect ]; then
mkdir -p /etc/nginx/pwprotect
fi
if [ ! -f /etc/nginx/.htpasswd ]; then
clear
echo "========================================================================="
echo "Ban phai tao User va Mat khau truoc khi chay chuc nang nay. Tao User va "
echo "-------------------------------------------------------------------------"
echo "Mat Khau mac dinh: LEMP Menu => User & Password Mac Dinh."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de Bat/Tat mat khau truy cap wp-login.php"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website khong phai la domain!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong phai la wordpress blog hoac chua cai dat wordpress!"
echo "-------------------------------------------------------------------------"
echo "Vui long cai dat wp truoc hoac nhap domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi  

echo "$website" > /tmp/websitemk.txt
sed -i '  s/\./_/g' /tmp/websitemk.txt
sed -i 's/\-/_/g' /tmp/websitemk.txt
username=`cat /tmp/websitemk.txt | sed "s/\_//" | sed "s/\_//" | sed "s/\_//" | sed "s/\_//" | cut -c1-30`

#####################################################################################

if [ -f /etc/nginx/pwprotect/$website/wp_login.conf ]; then
 if [  "$(grep "/etc/nginx/.htpasswd" /etc/nginx/pwprotect/$website/wp_login.conf)" == "" ]; then
prompt="Nhap lua chon cua ban: "
options=( "Thay Mat Khau Truy Cap" "Su Dung Mat Khau Truy Cap Mac Dinh" "Tat Mat Khau Truy Cap" "Thoat")
echo "========================================================================="
echo "Folder Wp-Admin da duoc dat mat khau truy cap"
echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) chooseacction="thaymktruycap"; break;;
    2) chooseacction="sudungmkmacdinh"; break;;
    3) chooseacction="tatmatkhautruycap"; break;;
    4) chooseacction="cancel"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################
#Thay Mat Khau Truy Cap
###################################
if [ "$chooseacction" = "thaymktruycap" ]; then
echo "-------------------------------------------------------------------------"
echo -n "Nhap username [ENTER]: " 
read username
if [ "$username" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap username"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau: "
read matkhau
if [ "$matkhau" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap mat khau"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$matkhau" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat mat khau mac dinh."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Thong tin ban nhap: "
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
echo "-------------------------------------------------------------------------"
echo "LEMP se thay thong tin dang nhap cu theo thong tin moi nay "
echo "-------------------------------------------------------------------------"
echo "please wait ...."
sleep 1



rm -rf /etc/nginx/pwprotect/$website/.htpasswd_wp_login


sudo htpasswd -c -b /etc/nginx/pwprotect/$website/.htpasswd_wp_login $username $matkhau

chmod -R 644 /etc/nginx/pwprotect/$website/.htpasswd_wp_login

systemctl restart nginx.service

clear
echo "========================================================================="
echo "Thay thong tin bao ve wp-login.php thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
###################################
#Su Dung Mat Khau Truy Cap Mac Dinh
###################################
elif [ "$chooseacction" = "sudungmkmacdinh" ]; then
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon dung dang nhap mac dinh cho wp_login.conf ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
sed -i 's/.*htpasswd.*/auth_basic_user_file\ \/etc\/nginx\/.htpasswd;/g' /etc/nginx/pwprotect/$website/wp_login.conf
rm -rf /etc/nginx/pwprotect/$website/.htpasswd_wp_login

systemctl restart nginx.service

clear
echo "========================================================================= "
echo "Dat mat khau bao ve wp-login.php cua $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
;;
esac
clear
echo "========================================================================= "
echo "Cancel"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
###################################
#tatmatkhautruycap
###################################
elif [ "$chooseacction" = "tatmatkhautruycap" ]; then
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon tat mat khau truy cap wp-login.php ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
cat > "/tmp/abcdfrfrf.sh" <<END
#!/bin/sh
sed -i '/wp_login.conf/d' /etc/nginx/conf.d/$website.conf 
END
chmod +x /tmp/abcdfrfrf.sh
/tmp/abcdfrfrf.sh
rm -f /tmp/abcdfrfrf.sh
rm -rf /etc/nginx/pwprotect/$website/wp_login.conf

systemctl restart nginx.service

clear
echo "========================================================================= "
echo "Tat mat khau truy cap wp-login.php cua $website thanh cong"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
;;
esac
clear
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
fi
fi
#####################################################################################

if [ -f /etc/nginx/pwprotect/$website/wp_login.conf ]; then
 if [ ! "$(grep "/etc/nginx/.htpasswd" /etc/nginx/pwprotect/$website/wp_login.conf)" == "" ]; then
prompt="Nhap lua chon cua ban: "
options=( "Su Dung Mat Khau Truy Cap Khac" "Tat Mat Khau Truy Cap" "Thoat")
echo "========================================================================="
echo "wp-login.php cua $website da duoc dat mat khau truy cap"
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) chooseacction="thaymktruycap"; break;;
    2) chooseacction="tatmatkhautruycap"; break;;
    3) chooseacction="cancel"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################
#Thay Mat Khau Truy Cap
###################################
if [ "$chooseacction" = "thaymktruycap" ]; then
echo "-------------------------------------------------------------------------"
echo -n "Nhap username [ENTER]: " 
read username
if [ "$username" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap username"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau: "
read matkhau
if [ "$matkhau" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap mat khau"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$matkhau" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat mat khau."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Thong tin ban nhap: "
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
echo "-------------------------------------------------------------------------"
echo "LEMP se thay thong tin dang nhap cu theo thong tin moi nay "
echo "-------------------------------------------------------------------------"
echo "please wait ...."
sleep 1
#

if [ ! -d /etc/nginx/pwprotect/$website ]; then
mkdir -p /etc/nginx/pwprotect/$website
fi

rm -rf /etc/nginx/pwprotect/$website/.htpasswd_wp_login

#echo $centOsVersion;


sudo htpasswd -c -b /etc/nginx/pwprotect/$website/.htpasswd_wp_login $username $matkhau


chmod -R 644 /etc/nginx/pwprotect/$website/.htpasswd_wp_login
cat > "/tmp/abcdfrfrf.sh" <<END
#!/bin/sh
sed -i 's/.*htpasswd.*/auth_basic_user_file\ \/etc\/nginx\/pwprotect\/$website\/.htpasswd_wp_login;/g' /etc/nginx/pwprotect/$website/wp_login.conf 
END
chmod +x /tmp/abcdfrfrf.sh
/tmp/abcdfrfrf.sh
rm -f /tmp/abcdfrfrf.sh


systemctl restart nginx.service

clear
echo "========================================================================="
echo "Thay thong tin bao ve wp-login.php cho $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
###################################
#tatmatkhautruycap
###################################
elif [ "$chooseacction" = "tatmatkhautruycap" ]; then
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon tat mat khau truy cap wp-login.php ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
cat > "/tmp/abcdfrfrf.sh" <<END
#!/bin/sh
sed -i '/wp_login.conf/d' /etc/nginx/conf.d/$website.conf
sed -i '/Protect-Wp-login.php/d' /etc/nginx/conf.d/$website.conf
 
END
chmod +x /tmp/abcdfrfrf.sh
/tmp/abcdfrfrf.sh
rm -f /tmp/abcdfrfrf.sh
rm -rf /etc/nginx/pwprotect/$website/wp_login.conf

systemctl restart nginx.service

clear
echo "========================================================================= "
echo "Tat mat khau truy cap wp-login.php cua $website thanh cong"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
;;
esac
clear
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
fi
fi
###############################################################################################
prompt="Nhap lua chon cua ban: "
echo "========================================================================="
echo "Lua chon mat khau khi truy cap wp-login.php"
echo "========================================================================="
options=( "Su Dung Username Va Mat Khau Mac Dinh" "Dang Nhap Bang Username Va Mat Khau Moi" )
PS3="$prompt"
select opt in "${options[@]}"; do 
    case "$REPLY" in
    1) chooseacction="dungmacdinh"; break;;
    2) chooseacction="dungthongtinmoi"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################
#dungthongtinmoi
###################################
if [ "$chooseacction" = "dungmacdinh" ]; then

if [ ! -d /etc/nginx/pwprotect/$website ]; then
mkdir -p /etc/nginx/pwprotect/$website
fi

cat > "/etc/nginx/pwprotect/$website/wp_login.conf" <<END
    location ~ ^/(wp-login\\.php) {
		include /etc/nginx/fastcgi_params;
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_param SCRIPT_FILENAME /home/$website/public_html\$fastcgi_script_name;
		auth_basic "Authorization Required";
		auth_basic_user_file  /etc/nginx/.htpasswd;
	}
END
	
if [ "$(grep Protect-Wp-login.php /etc/nginx/conf.d/$website.conf)" == "" ]; then
sed -i "/.*block.conf*./a\#Config\ to\ Protect-Wp-login.php" /etc/nginx/conf.d/$website.conf
sed -i "s/.*Protect-Wp-login.php*./\n&/" /etc/nginx/conf.d/$website.conf
fi
sed -i "/.*Protect-Wp-login.php*./ainclude \/etc\/nginx\/pwprotect\/$website\/wp_login.conf;" /etc/nginx/conf.d/$website.conf

systemctl restart nginx.service

clear
echo "========================================================================="
echo "Dat mat khau bao ve wp-login.php cua $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh

else 
echo "-------------------------------------------------------------------------"
echo "Username: $username"
echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau: "
read matkhau
if [ "$matkhau" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap mat khau"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$matkhau" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat mat khau."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [[ ! ${#matkhau} -ge 6 ]]; then
clear
echo "========================================================================="
echo "Mat khau toi thieu phai co 6 ki tu."
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi


echo "-------------------------------------------------------------------------"
echo "Please wait ...."
sleep 1
if [ ! -d /etc/nginx/pwprotect/$website ]; then
mkdir -p /etc/nginx/pwprotect/$website
fi
rm -rf /etc/nginx/pwprotect/$website/.htpasswd_wp_login


sudo htpasswd -c -b /etc/nginx/pwprotect/$website/.htpasswd_wp_login $username $matkhau


chmod -R 644 /etc/nginx/pwprotect/$website/.htpasswd_wp_login

cat > "/etc/nginx/pwprotect/$website/wp_login.conf" <<END
    location ~ ^/(wp-login\\.php) {
		include /etc/nginx/fastcgi_params;
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_param SCRIPT_FILENAME /home/$website/public_html\$fastcgi_script_name;
		auth_basic "Authorization Required";
		auth_basic_user_file  /etc/nginx/pwprotect/$website/.htpasswd_wp_login;
	}
END
	
if [ "$(grep Protect-Wp-login.php /etc/nginx/conf.d/$website.conf)" == "" ]; then
sed -i "/.*block.conf*./a\#Config\ to\ Protect-Wp-login.php" /etc/nginx/conf.d/$website.conf
sed -i "s/.*Protect-Wp-login.php*./\n&/" /etc/nginx/conf.d/$website.conf
fi
sed -i "/.*Protect-Wp-login.php*./ainclude \/etc\/nginx\/pwprotect\/$website\/wp_login.conf;" /etc/nginx/conf.d/$website.conf

systemctl restart nginx.service

clear
echo "========================================================================="
echo "Dat mat khau bao ve wp_login.php cua $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh

exit
fi
