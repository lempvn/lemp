#!/bin/bash
prompt="Lua chon cua ban (0-Thoat):" 
#options=( "Update System" "Update lemp" "Change Nginx Version" "Change phpMyAdmin Version" "Upgrade MariaDB to 10.0 Version" "Change PHP Version" "Change lemp Language" "Thoat")
#options=( "Update System" "Update lemp" "Update Nginx" "Change phpMyAdmin Version" "Change PHP Version" "Change lemp Language" "Update OpenSSL version" "Reset code form git" "List soft version")
options=( "Update System" "Update LEMP (nang cap scrip se chinh sua sau)" "Update Nginx" "Change phpMyAdmin Version" "Change PHP Version" "Update OpenSSL version" \
"Pull code form git" "Reset code form git" "List soft version" "Nginx quiche" "Auto update system")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                        Update / Upgrade Service \n"
printf "=========================================================================\n"


PS3="$prompt"
select opt in "${options[@]}" ; do 
 
    case "$REPLY" in


	1) /etc/lemp/menu/update-he-thong.sh;; # done
	2) /etc/lemp/menu/nang-cap-scripts.sh;;
	3) /etc/lemp/menu/nang-cap-nginx.sh;;
#	3) /etc/lemp/menu/lemp-befor-nang-cap-nginx.sh;;
	4) /etc/lemp/menu/lemp-nang-cap-phpmyadmin.sh;; # doi lai link gan xong
#	5) /etc/lemp/menu/nang-cap-mariaDB/lemp-before-nang-cap-mariadb.sh;;
	5) clear && /etc/lemp/menu/nangcap-php/lemp-updown-php.sh;;
#	6) clear && /etc/lemp/menu/lemp-thay-doi-ngon-ngu-menu.sh;;
	6) clear && /etc/lemp/menu/nang-cap-openssl.sh;;
	7) clear && /etc/lemp/menu/git-pull.sh;;
	8) clear && /etc/lemp/menu/git-reset.sh;;
	9) clear && /etc/lemp/menu/list-all-soft-version.sh;;
	10) clear && /etc/lemp/menu/nginx-quiche.sh;;
	11) clear && /etc/lemp/menu/auto-update-system.sh;;
	0) clear && lemp;;
        *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done



