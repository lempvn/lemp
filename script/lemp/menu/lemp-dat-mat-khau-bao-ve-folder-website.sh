#!/bin/bash
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
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de BAT/TAT mat khau truy cap vao folder cho website."
echo "-------------------------------------------------------------------------"
echo "Step I: Nhap Website => Step II: Nhap Folder => Tao Username va Mat khau "
echo "-------------------------------------------------------------------------"
echo "moi hoac su dung thong tin dang nhap mac dinh."
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap ten website"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Khong tim thay $website tren server "
/etc/lemp/menu/tienich/lemp-tien-ich.sh
fi   

echo "$website" > /tmp/websitemk.txt
sed -i '  s/\./_/g' /tmp/websitemk.txt
sed -i 's/\-/_/g' /tmp/websitemk.txt
username=`cat /tmp/websitemk.txt | sed "s/\_//" | sed "s/\_//" | sed "s/\_//" | sed "s/\_//" | cut -c1-30`
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten folder ban muon dat mat khau truy cap: "
read foldermk
foldermk=`echo $foldermk | sed 's/\///' | sed 's/\///' | sed 's/\///' | sed 's/\///'`
if [ ! -d /home/$website/public_html/$foldermk ]; then
clear
echo "========================================================================="
echo "Khong tim thay folder $foldermk cua $website"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi

if [ -f /home/$website/public_html/wp-config.php ]; then
if [ "$foldermk" == "wp-admin" ]; then
clear
echo "========================================================================="
echo "$website la wordpress website "
echo "-------------------------------------------------------------------------"
echo "Hay su dung Wordpress Blog Tools de dat mat khau bao ve foler ban nhap"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
fi

if [ -f /etc/lemp/net2ftpsite.info ]; then
net2ftpsite=$(cat /etc/lemp/net2ftpsite.info)
if [ "$website" = "$net2ftpsite" ]; then
if [ "$foldermk" == "temp" ]; then
clear
echo "========================================================================="
echo "$website la domain Net2FTP"
echo "-------------------------------------------------------------------------"
echo "Ban khong the hoan thanh config nay."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
fi
fi
fi

#####################################################################################

if [ -f /etc/nginx/pwprotect/$website/$foldermk.conf ]; then
 if [  "$(grep "/etc/nginx/.htpasswd" /etc/nginx/pwprotect/$website/$foldermk.conf)" == "" ]; then
prompt="Nhap lua chon cua ban: "
options=( "Thay Mat Khau Truy Cap" "Su Dung Mat Khau Truy Cap Mac Dinh" "Tat Mat Khau Truy Cap" "Thoat")
echo "========================================================================="
echo "Folder $foldermk da duoc dat mat khau truy cap"
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
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$username" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat Username."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau: "
read matkhau
if [ "$matkhau" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap mat khau"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$matkhau" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat mat khau mac dinh."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
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



rm -rf /etc/nginx/pwprotect/$website/.htpasswd_$foldermk

#sudo apt-get install -y apache2-utils
sudo htpasswd -c -b /etc/nginx/pwprotect/$website/.htpasswd_$foldermk $username $matkhau
systemctl reload nginx

clear
echo "========================================================================="
echo "Thay thong tin dang nhap cho $foldermk thanh cong"
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
###################################
#Su Dung Mat Khau Truy Cap Mac Dinh
###################################
elif [ "$chooseacction" = "sudungmkmacdinh" ]; then
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon dung dang nhap mac dinh cho $foldermk ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
sed -i 's/.*htpasswd.*/auth_basic_user_file\ \/etc\/nginx\/.htpasswd;/g' /etc/nginx/pwprotect/$website/$foldermk.conf

rm -rf /etc/nginx/pwprotect/$website/.htpasswd_$foldermk
systemctl reload nginx

clear
echo "========================================================================= "
echo "Config bao ve folder $foldermk theo mac dinh thanh cong"
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
;;
esac
clear
echo "========================================================================= "
echo "Cancel"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
###################################
#tatmatkhautruycap
###################################
elif [ "$chooseacction" = "tatmatkhautruycap" ]; then
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon tat mat khau truy cap $foldermk ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Please wait ..."
        sleep 1
        cat > "/tmp/abcdfrfrf.sh" <<END
#!/bin/sh
sed -i '/$foldermk.conf/d' /etc/nginx/conf.d/$website.conf 
END
        chmod +x /tmp/abcdfrfrf.sh
        /tmp/abcdfrfrf.sh
        rm -f /tmp/abcdfrfrf.sh
        rm -rf /etc/nginx/pwprotect/$website/$foldermk.conf
        rm -rf /etc/nginx/pwprotect/$website/$foldermk
        
        systemctl reload nginx
        
        clear
        echo "========================================================================= "
        echo "Tat mat khau truy cap $foldermk thanh cong"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
        clear
        echo "========================================================================= "
        echo "Cancel"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac

clear
/etc/lemp/menu/tienich/lemp-tien-ich.sh
else 
clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh
fi
fi
fi
#####################################################################################

if [ -f /etc/nginx/pwprotect/$website/$foldermk.conf ]; then
 if [ ! "$(grep "/etc/nginx/.htpasswd" /etc/nginx/pwprotect/$website/$foldermk.conf)" == "" ]; then
prompt="Nhap lua chon cua ban: "
options=( "Su Dung Mat Khau Truy Cap Khac" "Tat Mat Khau Truy Cap" "Thoat")
echo "========================================================================="
echo "Folder $foldermk da duoc dat mat khau truy cap mac dinh"
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
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$username" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat Username."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau: "
read matkhau
if [ "$matkhau" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap mat khau"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$matkhau" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat mat khau mac dinh."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
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

rm -rf /etc/nginx/pwprotect/$website/.htpasswd_$foldermk


#sudo apt-get install -y apache2-utils
sudo htpasswd -c -b /etc/nginx/pwprotect/$website/.htpasswd_$foldermk $username $matkhau


chmod -R 644 /etc/nginx/pwprotect/$website/.htpasswd_$foldermk
cat > "/tmp/abcdfrfrf.sh" <<END
#!/bin/sh
sed -i 's/.*htpasswd.*/auth_basic_user_file\ \/etc\/nginx\/pwprotect\/$website\/.htpasswd_$foldermk;/g' /etc/nginx/pwprotect/$website/$foldermk.conf 
END
chmod +x /tmp/abcdfrfrf.sh
/tmp/abcdfrfrf.sh
rm -f /tmp/abcdfrfrf.sh

systemctl reload nginx

clear
echo "========================================================================="
echo "Thay thong tin dang nhap cho $foldermk thanh cong"
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
###################################
#tatmatkhautruycap
###################################
elif [ "$chooseacction" = "tatmatkhautruycap" ]; then
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon tat mat khau truy cap $foldermk ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Please wait ..."
        sleep 1
        cat > "/tmp/abcdfrfrf.sh" <<END
#!/bin/sh
sed -i '/$foldermk.conf/d' /etc/nginx/conf.d/$website.conf 
END
        chmod +x /tmp/abcdfrfrf.sh
        /tmp/abcdfrfrf.sh
        rm -f /tmp/abcdfrfrf.sh
        rm -rf /etc/nginx/pwprotect/$website/$foldermk.conf

        systemctl reload nginx

        clear
        echo "========================================================================= "
        echo "Tat mat khau truy cap $foldermk thanh cong"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *) 
        clear
        echo "========================================================================= "
        echo "Cancel"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac

clear
/etc/lemp/menu/tienich/lemp-tien-ich.sh
else 
clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh
fi
fi
fi
###############################################################################################
prompt="Nhap lua chon cua ban: "
echo "========================================================================="
echo "Lua chon mat khau khi truy cap $foldermk"
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

cat > "/etc/nginx/pwprotect/$website/$foldermk.conf" <<END
    location /$foldermk {
		auth_basic "Authorization Required";
		auth_basic_user_file  /etc/nginx/.htpasswd;
		# PHP Handler
	}
END


	
if [ "$(grep Protect-Folders /etc/nginx/conf.d/$website.conf)" == "" ]; then
sed -i "/.*block.conf*./a\#Config\ to\ Protect-Folders" /etc/nginx/conf.d/$website.conf
sed -i "s/.*Protect-Folders*./\n&/" /etc/nginx/conf.d/$website.conf
fi
sed -i "/.*Protect-Folders*./ainclude \/etc\/nginx\/pwprotect\/$website\/$foldermk.conf;" /etc/nginx/conf.d/$website.conf

systemctl reload nginx

clear
echo "========================================================================="
echo "Dat mat khau bao ve folder $foldermk cua $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $userdefault | Password: $passdefault"
/etc/lemp/menu/tienich/lemp-tien-ich.sh

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
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$matkhau" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc dung chu cai va so de dat mat khau mac dinh."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi

if [[ ! ${#matkhau} -ge 6 ]]; then
clear
echo "========================================================================="
echo "Mat khau toi thieu phai co 6 ki tu."
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi


echo "-------------------------------------------------------------------------"
echo "Please wait ...."
sleep 1
if [ ! -d /etc/nginx/pwprotect/$website ]; then
mkdir -p /etc/nginx/pwprotect/$website
fi
rm -rf /etc/nginx/pwprotect/$website/.htpasswd_$foldermk


#sudo apt-get install -y apache2-utils
sudo htpasswd -c -b /etc/nginx/pwprotect/$website/.htpasswd_$foldermk $username $matkhau


chmod -R 644 /etc/nginx/pwprotect/$website/.htpasswd_$foldermk

cat > "/etc/nginx/pwprotect/$website/$foldermk.conf" <<END
    location /$foldermk {
		auth_basic "Authorization Required";
		auth_basic_user_file  /etc/nginx/pwprotect/$website/.htpasswd_$foldermk;
		# PHP Handler
	}
END

if [ "$(grep Protect-Folders /etc/nginx/conf.d/$website.conf)" == "" ]; then
sed -i "/.*block.conf*./a\#Config\ to\ Protect-Folders" /etc/nginx/conf.d/$website.conf
sed -i "s/.*Protect-Folders*./\n&/" /etc/nginx/conf.d/$website.conf
fi
sed -i "/.*Protect-Folders*./ainclude \/etc\/nginx\/pwprotect\/$website\/$foldermk.conf;" /etc/nginx/conf.d/$website.conf

systemctl reload nginx

clear
echo "========================================================================="
echo "Dat mat khau bao ve folder $foldermk cua $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin truy cap: "
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
/etc/lemp/menu/tienich/lemp-tien-ich.sh

exit
fi
