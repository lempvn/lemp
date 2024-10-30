#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/*vpsvn*
mkdir -p /tmp/saoluuwebsitethanhcongvpsvn
mkdir -p /tmp/saoluuwebsitethatbaivpsvn
ls /etc/nginx/conf.d > /tmp/lemp-websitelist
sed -i 's/\.conf//g' /tmp/lemp-websitelist 
 cat > "/tmp/lemp-replace" <<END
sed -i '/$mainsite/d' /tmp/lemp-websitelist
END
chmod +x /tmp/lemp-replace
/tmp/lemp-replace
rm -rf /tmp/lemp-replace
rm -rf /tmp/checksite-list
sowebsitetrenserver=$(cat /tmp/lemp-websitelist | wc -l)
listwebsite=$(cat /tmp/lemp-websitelist)
rm -rf /tmp/checksite-list
for checksite in $listwebsite 
do
if [ -f /home/$checksite/public_html/index.php ]; then
echo "$checksite" >> /tmp/checksite-list
fi
 done

if [ ! -f /tmp/checksite-list ]; then
rm -rf /tmp/*lemp*
rm -rf /tmp/*vpsvn*
clear
echo "========================================================================="
echo "Khong tim thay website co du lieu tren server"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
prompt="Nhap lua chon cua ban :"
options=("BAT/TAT Tu Dong Backup Website" "List Website BAT Tu Dong Backup")
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in
    1 ) /etc/lemp/menu/3_backup-restore/lemp-befor-chon-tat-bat-tu-dong-sao-luu-code.sh;;
    2 ) /etc/lemp/menu/3_backup-restore/lemp-danh-sach-website-tu-dong-sao-luu-code.sh;;
    $(( ${#options[@]}+1 )) ) echo "";  clear && /etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;

    esac
done
