#!/bin/bash
. /home/lemp.conf
if [ ! -f /usr/local/bin/htpasswd.py ]; then
cp -r /etc/lemp/menu/lemp-tao-mat-khau-bao-ve-folder.py /usr/local/bin/htpasswd.py
chmod 755 /usr/local/bin/htpasswd.py
fi
if [ ! -f /etc/lemp/pwprotect.default ]; then
echo "" > /etc/lemp/pwprotect.default
fi
chmod 777 /var/lib/php/session/
prompt="Lua chon cua ban (0-Thoat):"
if [ -f /home/$mainsite/private_html/index.php ]; then 
options=("TAT phpMyAdmin" "Open phpMyAdmin Port" "Close phpMyAdmin Port" "Thay Doi phpMyAdmin Port" "BAT/TAT Bao Ve phpMyAdmin")
else
options=("BAT phpMyAdmin" "Open phpMyAdmin Port" "Close phpMyAdmin Port" "Thay Doi phpMyAdmin Port" "BAT/TAT Bao Ve phpMyAdmin")
fi
if [ -f /etc/lemp/phpmyadmin.version ]; then
phpmyadminversion=`cat /etc/lemp/phpmyadmin.version`
versionshow=`echo "| Version: $phpmyadminversion"`
else
versionshow=`echo "| Version: Unknown"`
fi

printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                            Quan Ly phpMyAdmin \n"
printf "=========================================================================\n"
if [ -f /home/$mainsite/private_html/index.php ]; then 
printf "                phpMyAdmin Status: Enable $versionshow\n"
else
printf "                phpMyAdmin Status: Disable $versionshow\n"
fi
printf "=========================================================================\n"
printf "Link phpMyAdmin: http://$serverip:$priport\n"
printf "=========================================================================\n"
if [ "$(grep auth_basic_user_file /etc/nginx/conf.d/$mainsite.conf)" == "" ] ; then 
echo "Ban chua BAT tinh nang bao ve phpMyAdmin va cac file backup, ocp.php ..."
echo "-------------------------------------------------------------------------"
echo "Dung chuc nang [ BAT/TAT Bao Ve phpMyAdmin ] de bat tinh nang nay."
echo "-------------------------------------------------------------------------"
echo "Thong bao nay se tu dong TAT sau khi ban hoan thanh cau hinh bao mat !"
echo "========================================================================="
echo""
fi
PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1) /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin.sh;;
    2) /etc/lemp/menu/5_phpmyadmin/lemp-mo-phpmyadmin-port.sh;;
    3) /etc/lemp/menu/5_phpmyadmin/lemp-dong-phpmyadmin-port.sh;;
    4) /etc/lemp/menu/5_phpmyadmin/lemp-change-port-bi-mat.sh;;
    #5) /etc/lemp/menu/5_phpmyadmin/lemp-hien-link-phpmyadmin.sh;;
    5) /etc/lemp/menu/5_phpmyadmin/dat-mat-khau-bao-ve-phpmyadmin-backup-files.sh;;
    6) clear && /bin/lemp;;
    0) clear && lemp;;
    
  *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done

