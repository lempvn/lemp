#!/bin/bash 

. /home/lemp.conf
echo "========================================================================="
echo "Dung chuc nang nay config Vhost de su dung Plugin Cache. Hoac thay doi"
echo "-------------------------------------------------------------------------"
echo "sang plugin cache khac ( Vi du: muon chuyen tu W3 Total cache sang Redis) "  
echo "-------------------------------------------------------------------------"
echo "Khi do chuc nang nay se config lai Vhost tuong thich voi plugin cache moi"
echo "========================================================================="
echo -n "Nhap ten website: " 
read website
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "You typed wrong, please type in accurately! "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai ten domain !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Khong tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website co the khong phai wordpress web hoac chua cai dat WP"
echo "-------------------------------------------------------------------------"
echo "Vui long cai dat Wordpress code truoc hoac thu domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
    if [ "$(grep "include /etc/nginx/conf/wprocket.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da xoa 1 trong 3 dong: AAA, CCC, DDD, EEE trong Vhost cua $website"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien yeu cau cua ban"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
    if [ "$(grep "include /etc/nginx/conf/w3total.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da xoa 1 trong 3 dong: AAA, CCC, DDD, EEE trong Vhost cua $website"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien yeu cau cua ban"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
    if [ "$(grep "include /etc/nginx/conf/supercache.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da xoa 1 trong 3 dong: AAA, CCC, DDD, EEE trong Vhost cua $website"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien yeu cau cua ban"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
    if [ "$(grep "include /etc/nginx/conf/all.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da xoa 1 trong 3 dong: AAA, CCC, DDD, EEE trong Vhost cua $website"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien yeu cau cua ban"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
echo "-------------------------------------------------------------------------"
echo "Tim thay $website dang su dung wordpress code tren he thong"
printf "=========================================================================\n"
#prompt="Nhap lua chon cua ban: "
prompt="Lua chon cua ban: "
options=( "Cau hinh Vhost dung Redis Cache" "Cau hinh Vhost dung WP Super Cache" "Cau hinh Vhost dung W3 Total Cache" "Cau hinh Vhost dung WP Rocket Cache" "Huy bo")
printf "LUA CHON CACH CAU HINH VHOST\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) reconfigvhost="rediscache"; break;;
    2) reconfigvhost="supercache"; break;;
    3) reconfigvhost="w3total"; break;;
    4) reconfigvhost="rocket"; break;;
    5) reconfigvhost="cancel"; break;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    #*) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    esac  
done
###################################
#rediscache
###################################
if [ "$reconfigvhost" = "rediscache" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
echo "-------------------------------------------------------------------------"
  if [ "$(grep "include /etc/nginx/conf/all.conf;" /etc/nginx/conf.d/$website.conf)" == "include /etc/nginx/conf/all.conf;" ]; then
clear
echo "========================================================================="
echo "$website dang duoc config su dung Redis Cache"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
  if [ "$(grep "include /etc/nginx/conf/all.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da thay doi file cau hinh Vhost cua LEMP"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
cat > "/tmp/re-config-vhost.sh" <<END
#!/bin/sh
sed -i 's/.*all.conf.*/include \/etc\/nginx\/conf\/all.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*supercache.conf.*/#include \/etc\/nginx\/conf\/supercache.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*w3total.conf.*/#include \/etc\/nginx\/conf\/w3total.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*wprocket.conf.*/#include \/etc\/nginx\/conf\/wprocket.conf;/g' /etc/nginx/conf.d/$website.conf
END
chmod +x /tmp/re-config-vhost.sh
/tmp/re-config-vhost.sh
rm -f /tmp/re-config-vhost.sh

systemctl restart nginx.service

clear
echo "========================================================================="
echo "Cau hinh Vhost cua $website cho Redis Cache thanh cong"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
###################################
#supercache
###################################
elif [ "$reconfigvhost" = "supercache" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
echo "-------------------------------------------------------------------------"
  if [ "$(grep "include /etc/nginx/conf/supercache.conf;" /etc/nginx/conf.d/$website.conf)" == "include /etc/nginx/conf/supercache.conf;" ]; then
clear
echo "========================================================================="
echo "$website dang duoc config su dung WP Super Cache"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
  if [ "$(grep "include /etc/nginx/conf/supercache.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da thay doi file cau hinh Vhost cua LEMP"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
cat > "/tmp/re-config-vhost.sh" <<END
#!/bin/sh
sed -i 's/.*all.conf.*/#include \/etc\/nginx\/conf\/all.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*supercache.conf.*/include \/etc\/nginx\/conf\/supercache.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*w3total.conf.*/#include \/etc\/nginx\/conf\/w3total.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*wprocket.conf.*/#include \/etc\/nginx\/conf\/wprocket.conf;/g' /etc/nginx/conf.d/$website.conf
END
chmod +x /tmp/re-config-vhost.sh
/tmp/re-config-vhost.sh
rm -f /tmp/re-config-vhost.sh

systemctl restart nginx.service

clear
echo "========================================================================="
echo "Cau hinh Vhost cua $website cho WP Super Cache thanh cong"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
####################
#w3total
##################
elif [ "$reconfigvhost" = "w3total" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
echo "-------------------------------------------------------------------------"
  if [ "$(grep "include /etc/nginx/conf/w3total.conf;" /etc/nginx/conf.d/$website.conf)" == "include /etc/nginx/conf/w3total.conf;" ]; then
clear
echo "========================================================================="
echo "$website dang duoc config su dung W3 Total Cache"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
  if [ "$(grep "include /etc/nginx/conf/w3total.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da thay doi file cau hinh Vhost cua LEMP"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
cat > "/tmp/re-config-vhost.sh" <<END
#!/bin/sh
sed -i 's/.*all.conf.*/#include \/etc\/nginx\/conf\/all.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*supercache.conf.*/#include \/etc\/nginx\/conf\/supercache.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*w3total.conf.*/include \/etc\/nginx\/conf\/w3total.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*wprocket.conf.*/#include \/etc\/nginx\/conf\/wprocket.conf;/g' /etc/nginx/conf.d/$website.conf
END
chmod +x /tmp/re-config-vhost.sh
/tmp/re-config-vhost.sh
rm -f /tmp/re-config-vhost.sh

systemctl restart nginx.service

clear
echo "========================================================================="
echo "Cau hinh Vhost cua $website cho W3 Total Cache thanh cong"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
###################################
#rocket
###################################
elif [ "$reconfigvhost" = "rocket" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
echo "-------------------------------------------------------------------------"
  if [ "$(grep "include /etc/nginx/conf/wprocket.conf;" /etc/nginx/conf.d/$website.conf)" == "include /etc/nginx/conf/wprocket.conf;" ]; then
clear
echo "========================================================================="
echo "$website dang duoc config su dung WP Rocket Cache"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
  if [ "$(grep "include /etc/nginx/conf/wprocket.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da thay doi file cau hinh Vhost cua LEMP"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
  exit
  fi
cat > "/tmp/re-config-vhost.sh" <<END
#!/bin/sh
sed -i 's/.*all.conf.*/#include \/etc\/nginx\/conf\/all.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*supercache.conf.*/#include \/etc\/nginx\/conf\/supercache.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*w3total.conf.*/#include \/etc\/nginx\/conf\/w3total.conf;/g' /etc/nginx/conf.d/$website.conf
sed -i 's/.*wprocket.conf.*/include \/etc\/nginx\/conf\/wprocket.conf;/g' /etc/nginx/conf.d/$website.conf
END
chmod +x /tmp/re-config-vhost.sh
/tmp/re-config-vhost.sh
rm -f /tmp/re-config-vhost.sh

systemctl restart nginx.service

clear
echo "========================================================================="
echo "Cau hinh Vhost cua $website cho WP Rocket Cache thanh cong"
echo "-------------------------------------------------------------------------"
echo "*LUU Y: de kich hoat hoan toan cache nay, ban phai cai them plugin cua"
echo "-------------------------------------------------------------------------"
echo "Rocket tren website wordpress va nap file cau hinh *.json vao !!!"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
###################################
#Huy bo 
###################################
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
