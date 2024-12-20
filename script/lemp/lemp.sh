#!/bin/bash
. /home/lemp.conf
curTime=$(date +%d)
checktruenumber='^[0-9]+$'
if [ $(id -u) != "0" ]; then
    printf "Co loi ! LEMP chi chay tren user root !\n"
    exit
fi


# Check LEMP Update
#/etc/lemp/menu/menucheck/check-lemp-update.sh
# Check nginx Update
#/etc/lemp/menu/menucheck/check-nginx-update.sh
#/etc/lemp/menu/menucheck/check-phpmyadmin-update.sh
#/etc/lemp/menu/menucheck/check-csf-on.sh
# kiem tra dung luong dia con lai
/etc/lemp/menu/menucheck/check-disk-usage.sh


if [ ! -f /etc/lemp/tatthongbao.csf ]; then
if [ ! -f /etc/csf/csf.conf ]; then
echo "========================================================================="
echo "NGUY HIEM ! BAN CHUA CAI DAT CSF FIREWALL DE BAO VE VPS/SERVER !"
echo "========================================================================="
echo "Canh bao nay tu dong tat sau khi ban cai dat CSF. Hoac tat bang cach dung"
echo "========================================================================="
echo "Chuc nang [ Tat/Bat Canh Bao Tren Menu ] trong [ Quan Ly CSF Firewall ] "
fi
fi
#rm -rf /tmp/*ip*
who am i| awk '{ print $5}' | sed 's/(//'| sed 's/)//' > /tmp/checkip
checksize=$(du -sb /tmp/checkip | awk 'NR==1 {print $1}')
if [ $checksize -gt 8 ]; then
if [ -f /etc/csf/csf.conf ]; then
checkip=$(cat /tmp/checkip)
	if [ ! -f /etc/csf/csf.ignore ]; then
	echo "" > /etc/csf/csf.ignore
	fi
if [ "$(grep $checkip /etc/csf/csf.ignore)" == "" ]; then 
cat >> "/tmp/addcheckip" <<END
echo "$checkip" >> /etc/csf/csf.ignore
echo "$checkip" >> /etc/csf/csf.allow
echo "========================================================================="
echo "Dia chi IP hien tai cua ban:  $checkip" 
echo "-------------------------------------------------------------------------"
echo "Dia chi IP nay khong co trong whitelist cua CSF Firewwall"
echo "-------------------------------------------------------------------------"
echo "LEMP da them IP nay vao CSF whitelist de khong bi CSF Firewall Block"
echo "-------------------------------------------------------------------------"
echo "De thay doi co hieu luc, CSF Firewall can khoi dong lai"
echo "========================================================================="
read -p "Nhan [Enter] de khoi dong lai CSF Firewall va Truy cap LEMP ..."
#iptables -I INPUT -p tcp --dport $priport -j ACCEPT
#iptables -A INPUT -p tcp -s $checkip --dport $priport -j ACCEPT
#service iptables save
#service iptables restart
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
clear
echo "========================================================================="
echo "IP: $checkip da duoc them vao CSF Firewall's Whitelist"
END
chmod +x /tmp/addcheckip
/tmp/addcheckip
fi
fi
fi

if [ ! -f /etc/lemp/minfreedisc.info ]; then
echo "1000" > /etc/lemp/minfreedisc.info
fi
minfreedisc=`cat /etc/lemp/minfreedisc.info`
if ! [[ $minfreedisc =~ $checktruenumber ]] ; then
echo "1000" > /etc/lemp/minfreedisc.info
fi 
if [ ! -f /tmp/checkdiscsize ]; then
touch -a -m -t 201602180130.09 /tmp/checkdiscsize 
fi
fileTime3=$(date -r /tmp/checkdiscsize +%d)
if [ ! "$fileTime3" == "$curTime" ]; then
touch /tmp/checkdiscsize
disfree=$(calc $(df $PWD | awk '/[0-9]%/{print $(NF-2)}')/1024)
	if [[ $disfree =~ $checktruenumber ]] ; then  
	  if [ "$disfree" -lt "$minfreedisc" ]; then
echo "========================================================================="
echo "CANH BAO: Hien tai server con $disfree MB dung luong trong ! "
	  fi
   fi
fi



rm -rf /tmp/*ip*
rm -rf /tmp/showthongbao 


#find /etc/lemp/menu -type f -exec chmod 755 {} \;
prompt="Nhap lua chon cua ban (0-Thoat): "
#options=("Thong tin thiet lap LEMP" "Them Website & Code" "Xoa website" "Backup & Restore Code" "Quan Ly Database" "Quan Ly phpMyAdmin" "Quan Ly Zend OPcache" "Quan Ly Memcached" "Quan Ly Redis Cache" "Quan Ly FTP Server" "Quan Ly Swap" "Quan Ly Cronjob"  "Quan Ly File Log" "Config Cau Hinh PHP" "Wordpress Blog Tools" "Quan Ly CSF Firewall" "Quan Ly IPtables Firewall" "Quan Ly BitTorrent Sync" "Quan Ly VPS Backup" "Linux Malware Detect" "Cai Dat File Manager" "Cai Dat Net2FTP" "Cai Dat NetData" "Cai Dat SSL (Let's Enctypt)" "Check & Block IP DOS" "Tien ich - Addons" "Update System" "Clear All Caches" "User & Password Mac Dinh" "Server Status" "Thoat")
options=("Them Website & Code" "Xoa website" "Backup & Restore Code" "Quan Ly Database" "Quan Ly phpMyAdmin" "Quan Ly Memcached" "Quan Ly Redis Cache" "Quan Ly FTP Server" "Quan Ly Swap" "Quan Ly Cronjob"  "Quan Ly File Log" "Config Cau Hinh PHP" "Thay doi phien ban PHP" "Wordpress Blog Tools" "Quan Ly CSF Firewall" "Quan Ly IPtables Firewall" "Quan Ly VPS Backup" "Linux Malware Detect" "Cai Dat NetData" "Cai Dat SSL (Let's Enctypt)" "Check & Block IP DOS" "Tien ich - Addons" "Clear All Caches" "User & Password Mac Dinh" "Server Status" "Bat/Tat IPv6")

echo "========================================================================="
echo "                  LEMP - Quan Ly VPS/Server by LEMP.VN                    "
echo "========================================================================="
echo "                             LEMP Menu                                   "
echo "========================================================================="

column_count=2
display_order=(1 14 2 15 3 16 4 17 5 18 6 19 7 20 8 21 9 22 10 23 11 24 12 25 13 26)  # Thứ tự hiển thị tùy chọn
# Số lượng tùy chọn
max_options=${#options[@]}

# In ra các tùy chọn với căn chỉnh đều
for ((i=0; i<${#display_order[@]}; i+=column_count)); do
    for ((j=0; j<column_count; j++)); do
        if [ $((i + j)) -lt ${#display_order[@]} ]; then
            index=${display_order[i + j]}
            if [ "$index" -le "$max_options" ]; then
                # Điều chỉnh chiều rộng cho phù hợp
                printf "%-4s %-40s" "$index." "${options[index - 1]}"
            fi
        fi
    done
    echo
done


PS3="$prompt"

# Lay lua chon tu nguoi dung
read -p "$PS3" choice

# Kiem tra lua chon va thuc thi hanh dong tuong ung
case "$choice" in
    1) clear && /etc/lemp/menu/lemp-befor-them-website-menu.sh;;
    2) /etc/lemp/menu/lemp-befor-xoa-website.sh;;
    3) clear && /etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh;;
    4) clear && /etc/lemp/menu/4_database/lemp-befor-them-xoa-database.sh;;
    5) clear && /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh;;
    6) clear && /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh;;
    7) clear && /etc/lemp/menu/redis/lemp-redis-before-menu.sh;;
    8) clear && /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh;;
    9) clear && /etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh;;
    10) clear && /etc/lemp/menu/crontab/lemp-cronjob-menu.sh;;
    11) clear && /etc/lemp/menu/downloadlog/lemp-error-menu.sh;;
    12) clear && /etc/lemp/menu/config-php/lemp-befor-lemp-config-php.ini-menu;;
    13) clear && /etc/lemp/menu/nangcap-php/lemp-change-ver-php.sh;;
    14) clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh;;
    15) /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-before-menu.sh;;
    16) clear && /etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh;;
    17) clear && /etc/lemp/menu/backup/lemp-befor-rsync.sh;;
    18) clear && /etc/lemp/menu/lemp-maldet-menu.sh;;
    19) clear && /etc/lemp/menu/22_netdata/lemp-netdata-menu.sh;;
    20) clear && /etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh;;
    21) clear && /etc/lemp/menu/lemp-kiem-tra-ddos.sh;;
    22) clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh;;
    23) /etc/lemp/menu/clear-cache/lemp-clear-cache-xoa-cache-server.sh;;
    24) /etc/lemp/menu/user-secure/dat-mat-khau-bao-ve-folder-mac-dinh.sh;;
    25) clear && /etc/lemp/menu/vps-info/lemp-vps-info.sh;;
    26) clear && /etc/lemp/menu/ipv6/bat_tat_ipv6.sh;;
    0) clear && cat /etc/motd && exit 0;;
    *) echo "Ban nhap sai, vui long nhap so tu 1 den 26!";;
esac

