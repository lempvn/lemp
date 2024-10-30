#!/bin/sh
. /home/lemp.conf
prompt="Lua chon cua ban (0-Thoat):"
options=("Bat Zend Opcache" "Cau Hinh Zend Opcache" "Them Website Vao BlackList" "Xoa Website Khoi Blacklist" "Clear Zend OPcache")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                          Zend OPcache Manage \n"
printf "=========================================================================\n"
printf "                    Zend Opcache Current: Disable\n"
printf "=========================================================================\n"
printf "Zend Opcache Manage Link: http://$serverip:$priport/ocp.php\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
	1 ) /etc/lemp/menu/opcache/lemp-bat-opcache.sh;;
	2 ) /etc/lemp/menu/opcache/lemp-opcache-change-size.sh;;
	3) /etc/lemp/menu/opcache/lemp-them-website-vao-blacklist.sh;;
	4) /etc/lemp/menu/opcache/lemp-xoa-website-khoi-blacklist.sh;;
	5) /etc/lemp/menu/opcache/lemp-clear-opcache.sh;;
	#$(( ${#options[@]}+1 )) ) echo "";  clear && /bin/lemp;;
	0) echo "";  clear && /bin/lemp;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;

    esac
done