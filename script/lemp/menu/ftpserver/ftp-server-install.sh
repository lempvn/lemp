#!/bin/bash
. /home/lemp.conf
if [ -f /etc/proftpd/proftpd.conf ]; then
clear
echo "========================================================================= "
echo "FTP server da duoc cai dat tren server. "
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
exit
fi

clear
echo "========================================================================= "
echo "Chuan bi cai dat FTP Server... "
sleep 3
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install proftpd proftpd-basic proftpd-core proftpd-doc proftpd-mod-crypto proftpd-mod-wrap

cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bak

rm -f /etc/proftpd/proftpd.conf
rm -f /etc/proftpd/modules.conf

cp -r /etc/lemp/menu/proftpd/proftpd.conf /etc/proftpd/proftpd.conf
cp -r /etc/lemp/menu/proftpd/modules.conf /etc/proftpd/modules.conf

touch /etc/proftpd/sftp.passwd

chown proftpd:root /etc/proftpd/sftp.passwd
chmod 600 /etc/proftpd/sftp.passwd
mkdir /etc/proftpd/keys

sudo ssh-keygen -t rsa -f /etc/proftpd/keys/sftp_host_rsa_key -N ""
sudo ssh-keygen -t dsa -f /etc/proftpd/keys/sftp_host_dsa_key -N ""

cp -r /etc/lemp/menu/proftpd/limits.conf /etc/proftpd/conf.d/limits.conf
cp -r /etc/lemp/menu/proftpd/sftpd.conf /etc/proftpd/conf.d/sftpd.conf
chown proftpd:root /etc/proftpd/conf.d/limits.conf

systemctl restart proftpd.service


# Cau hinh UFW

sudo ufw allow 2222/tcp


# Neu CSF FireWall duoc cai dat
if [ -f /etc/csf/csf.conf ]; then
clear
echo "-------------------------------------------------------------------------"
echo "Phat hien CSF FireWall dang duoc cai dat tren VPS"
echo "-------------------------------------------------------------------------"
echo "LEMP se khoi dong lai CSF Firewall ...."
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
sleep 5
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
fi

clear
echo "========================================================================= "
echo "Cai dat FTP server thanh cong"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
exit
