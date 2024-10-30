#!/bin/bash
prompt="Lua chon phien ban Varnish (0-Thoat):"

if [ -f /etc/lemp/varnish.version ];then
current_varnish_version=$(cat /etc/lemp/varnish.version)
else
current_varnish_version=""
fi

if [ "$current_varnish_version" == "7.3" ]; then
    options=( "Varnish 7.3 (Current)" "Varnish 7.4" "Varnish 7.5" "Varnish 7.6" "Auto setup storage" "Uninstall Varnish" )
elif [ "$current_varnish_version" == "7.4" ]; then
    options=( "Varnish 7.3" "Varnish 7.4 (Current)" "Varnish 7.5" "Varnish 7.6" "Auto setup storage" "Uninstall Varnish" )
elif [ "$current_varnish_version" == "7.5" ]; then
    options=( "Varnish 7.3" "Varnish 7.4" "Varnish 7.5 (Current)" "Varnish 7.6" "Auto setup storage" "Uninstall Varnish" )
elif [ "$current_varnish_version" == "7.6" ]; then
    options=( "Varnish 7.3" "Varnish 7.4" "Varnish 7.5" "Varnish 7.6 (Current)" "Auto setup storage" "Uninstall Varnish" )
else
    options=( "Varnish 7.3 (Khuyen dung)" "Varnish 7.4" "Varnish 7.5" "Varnish 7.6" "Auto setup storage" "Uninstall Varnish" )
fi


printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                           Varnish Cache\n"
echo "========================================================================="
/etc/lemp/menu/varnish/disk-varnish.sh
echo "========================================================================="

if [ -f /etc/lemp/varnish.version ];then
printf "                Phien ban Varnish hien tai: $(cat /etc/lemp/varnish.version) \n"
else
printf "                 Varnish Cache chua duoc cai dat\n"
printf "               Hoac khong duoc cai dat thong qua LEMP \n"
fi
printf "=========================================================================\n"


PS3="$prompt"
select opt in "${options[@]}" ; do 

case "$REPLY" in
1) clear && /etc/lemp/menu/varnish/varnish73.sh;;
2) clear && /etc/lemp/menu/varnish/varnish74.sh;;
3) clear && /etc/lemp/menu/varnish/varnish75.sh;;
4) clear && /etc/lemp/menu/varnish/varnish76.sh;;
5) clear && /etc/lemp/menu/varnish/reset-disk-cache-varnish.sh;;
6) clear && /etc/lemp/menu/varnish/uninstall-varnish.sh;;
#0) clear && lemp;;
0) clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh;;
*) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
esac
done
