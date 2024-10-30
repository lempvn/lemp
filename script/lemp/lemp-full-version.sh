#!/bin/sh 
. /home/lemp.conf
curTime=$(date +%d)
checktruenumber='^[0-9]+$'
if [ $(id -u) != "0" ]; then
    printf "Co loi ! LEMP chi chay tren user root !\n"
    exit
fi



if [ ! -f /tmp/00-all-nginx-version.txt ]; then
touch -a -m -t 201601180130.09 /tmp/00-all-nginx-version.txt  
fi

fileTime=$(date -r /tmp/00-all-nginx-version.txt +%d)
if [ ! "$fileTime" == "$curTime" ]; then
#rm -rf /tmp/00-all-nginx-version.txt
#wget -q https://lemp.echbay.com/script/lemp/00-all-nginx-version.txt -O /tmp/00-all-nginx-version.txt
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/00-all-nginx-version.txt -O /tmp/00-all-nginx-version.txt
touch /tmp/00-all-nginx-version.txt
Nginx1=`cat /etc/lemp/nginx.version`
checksize=$(du -sb /tmp/00-all-nginx-version.txt | awk 'NR==1 {print $1}')
if [ $checksize -gt 14 ]; then
Nginx3=`cat /tmp/00-all-nginx-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`
cat >> "/tmp/lemp_check_nginx" <<END
		if [  "$(grep $Nginx1 /tmp/00-all-nginx-version.txt | sed 's/|//' | sed 's/|//')" == "$Nginx1" ]; then
			if [ ! "$Nginx1" == "$Nginx3" ]; then
			echo "========================================================================="
			echo "Update for Nginx Found !  "
			echo "-------------------------------------------------------------------------"
			echo "Your Version: $Nginx1   |   Newest version: $Nginx3"
			echo "-------------------------------------------------------------------------"
			echo "How to update: LEMP menu => Update System => Change Nginx Version "
			
			fi
		fi
END
chmod +x /tmp/lemp_check_nginx
/tmp/lemp_check_nginx
#rm -rf /tmp/lemp_check_nginx
fi
fi



if [ ! -f /tmp/lemp.newversion ]; then
touch -a -m -t 201602180130.09 /tmp/lemp.newversion  
fi



fileTime2=$(date -r /tmp/lemp.newversion +%d)
if [ ! "$fileTime2" == "$curTime" ]; then
#rm -rf /tmp/lemp.newversion
#wget -q https://lemp.echbay.com/script/lemp/lemp.newversion -O /tmp/lemp.newversion
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/version -O /tmp/lemp.newversion
touch /tmp/lemp.newversion
LOCALVER=`cat /etc/lemp/lemp.version`
checksize=$(du -sb /tmp/lemp.newversion | awk 'NR==1 {print $1}')
###
	if [ $checksize -gt 2 ]; then
	REMOVER=`cat /tmp/lemp.newversion`
	cat >> "/tmp/lemp_check_lemp_version" <<END
		if [ ! "$LOCALVER" == "$REMOVER" ]; then
			echo "========================================================================="
			echo "Update for LEMP found !  "
			echo "-------------------------------------------------------------------------"
			echo "Your Version: $LOCALVER   |   Newest version: $REMOVER"
			echo "-------------------------------------------------------------------------"
			echo "How to update: LEMP menu => Update System => Update LEMP "
			
		fi
END
	chmod +x /tmp/lemp_check_lemp_version
	/tmp/lemp_check_lemp_version
	#rm -rf /tmp/lemp_check_lemp_version
	fi
fi

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

#rm -rf /tmp/*ip*
#rm -rf /tmp/showthongbao 
#find /etc/lemp/menu -type f -exec chmod 755 {} \;
prompt="Nhap lua chon cua ban:"
options=("Them Website & Code" "Xoa website" "Backup & Restore Code" "Quan Ly Database" "Quan Ly phpMyAdmin" "Quan Ly Zend OPcache" "Quan Ly Memcached" "Quan Ly Redis Cache" "Quan Ly FTP Server" "Quan Ly Swap" "Quan Ly Cronjob"  "Quan Ly File Log" "Config Cau Hinh PHP" "Wordpress Blog Tools" "Quan Ly CSF Firewall" "Quan Ly IPtables Firewall" "Quan Ly BitTorrent Sync" "Quan Ly VPS Backup" "Linux Malware Detect" "Cai Dat File Manager" "Cai Dat Net2FTP" "Cai Dat NetData" "Cai Dat SSL (Let's Enctypt)" "Check & Block IP DOS" "Tien ich - Addons" "Update System" "Clear All Caches" "User & Password Mac Dinh" "Server Status" "Thoat")

echo "========================================================================="
echo "    LEMP - Quan Ly VPS/Server by LEMP.VN ($(cat /etc/lemp/lemp.version))                "
echo "========================================================================="
echo "                          LEMP Menu                             "
echo "========================================================================="

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

	1) clear && /etc/lemp/menu/lemp-befor-them-website-menu.sh;;
    2) /etc/lemp/menu/lemp-befor-xoa-website.sh;;
    3) clear && /etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh;;
    4) clear && /etc/lemp/menu/4_database/lemp-befor-them-xoa-database.sh;;
    5) clear && /etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh;;
    6) clear && /etc/lemp/menu/opcache/lemp-before-opcache.sh;;
    7) clear && /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh;;
    8) clear && /etc/lemp/menu/redis/lemp-redis-befor-menu;;
    9) clear &&/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh;;
    10 )clear && /etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh;;
    11) clear && /etc/lemp/menu/crontab/lemp-cronjob-menu.sh;;
    12) clear && /etc/lemp/menu/downloadlog/lemp-eroor-menu;;
    13) clear && /etc/lemp/menu/config-php/lemp-befor-lemp-config-php.ini-menu;;
    14) clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh;;
    #14) clear && /etc/lemp/menu/pagespeed/before-lemp-pagespeed-menu.sh;;"Nginx Pagespeed Manage" 
    15) /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-before-menu.sh;;
    16) clear && /etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh;;
    17) clear && /etc/lemp/menu/17_bitsync/lemp-bitsync-menu;;
    18) clear && /etc/lemp/menu/backup/lemp-befor-rsync.sh;;
    19) clear && /etc/lemp/menu/lemp-maldet-menu.sh;;
    20) clear && /etc/lemp/menu/20_file-manager/lemp-web-upload-menu;;
    21) clear && /etc/lemp/menu/21_net2ftp/lemp-net2ftp-menu;;
    22) clear && /etc/lemp/menu/22_netdata/lemp-netdata-menu.sh;;
    23) clear && /etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh;;
    24) clear && /etc/lemp/menu/lemp-kiem-tra-ddos.sh;;
    25) clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh;;
    26) clear && /etc/lemp/menu/lemp-update-upgrade-service-menu.sh;;
    27) /etc/lemp/menu/clear-cache/lemp-clear-cache-xoa-cache-server.sh;;
    28) /etc/lemp/menu/user-secure/dat-mat-khau-bao-ve-folder-mac-dinh.sh;;
    29) clear && /etc/lemp/menu/vps-info/lemp-vps-info.sh;;
	30) clear && cat /etc/motd && killall -g lemp;; 
	0) clear && cat /etc/motd && killall -g lemp;; 
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac
done
 
