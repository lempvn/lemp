#!/bin/bash
if [ ! -f /usr/local/bin/htpasswd.py ]; then
cp -r /etc/lemp/menu/lemp-tao-mat-khau-bao-ve-folder.py /usr/local/bin/htpasswd.py
chmod 755 /usr/local/bin/htpasswd.py
fi
if [ ! -f /etc/lemp/pwprotect.default ]; then
echo "" > /etc/lemp/pwprotect.default
fi
if [ ! -d /etc/nginx/pwprotect ]; then
mkdir -p /etc/nginx/pwprotect
fi
if [ ! -f /etc/lemp/pwprotect.default ]; then
echo "" > /etc/lemp/pwprotect.default
fi
echo "========================================================================="
prompt="Lua chon cua ban: "
options=( "BAT/TAT Mat Khau Truy Cap Folder" "Tao Username Va Mat Khau Mac Dinh" "Huy bo")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) luachonacction="taomatkhau"; break;;
    2) luachonacction="taomatkhaumacdinh"; break;;
    3) chonphpversion="cancle"; break;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    esac  
done

###################################
if [ "$luachonacction" = "taomatkhau" ]; then
/etc/lemp/menu/lemp-dat-mat-khau-bao-ve-folder-website.sh
###################################
elif [ "$luachonacction" = "taomatkhaumacdinh" ]; then
/etc/lemp/menu/dat-mat-khau-bao-ve-folder-mac-dinh
###################################
else 
clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh
fi
