#!/bin/bash 
printf "=========================================================================\n"
printf "Chuc nang nay se xoa sach LMD va ClamAV tren VPS cua ban.\n"
echo "-------------------------------------------------------------------------"
read -r -p "Ban chac chan muon remove LMD? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    sleep 1
echo "Remove Linux Malware Detect... "
sleep 1
rm -rf /usr/local/maldetect* /etc/cron.d/maldet_pub /etc/cron.daily/maldet /usr/local/sbin/maldet /usr/local/sbin/lmd
#yum remove -y clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
sudo DEBIAN_FRONTEND=noninteractive apt -yqq purge clamav clamav-daemon clamav-freshclam

#rpm -e --nodeps `rpm -aq | grep -i clamav` 
cd
clear
clear
echo "========================================================================= "
echo "Remove Linux Malware Detect hoan thanh! "

/etc/lemp/menu/lemp-maldet-menu.sh
;;
    *)

        ;;
esac
       clear 
echo "========================================================================= "
echo "Huy bo remove Linux Malware Detect."
/etc/lemp/menu/lemp-maldet-menu.sh
