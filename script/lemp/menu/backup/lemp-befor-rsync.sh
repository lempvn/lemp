#!/bin/bash 
. /home/lemp.conf
if [ ! -f ~/.ssh/id_rsa ]; then
ssh-keygen -f ~/.ssh/id_rsa -q -P ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
fi
if [ ! -f /usr/bin/sshpass ]; then
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install sshpass
fi
if [ ! -f ~/.ssh/config ]; then
echo "StrictHostKeyChecking no" >> ~/.ssh/config
else
	if [ "`grep StrictHostKeyChecking ~/.ssh/config`" == "" ]; then
	echo "StrictHostKeyChecking no" >> ~/.ssh/config
	fi
fi
if [ ! -f /etc/lemp/menu/backup/lemp-rsync-have-read.sh ]; then
clear
printf "=========================================================================\n"
printf "               LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                          Quan Ly VPS Backup \n"
printf "=========================================================================\n"
printf "\n"
echo "========================================================================="
echo "Su dung chuc nang nay de cai dat va cau hinh backup Server hien tai"
echo "-------------------------------------------------------------------------"
echo "sang VPS khac (VPS backup) bang Rsync. Viec sao luu du lieu server sang "
echo "-------------------------------------------------------------------------"
echo "VPS khac giup du lieu an toan hon la de truc tiep server dang su dung."
echo "-------------------------------------------------------------------------"
echo "Khi de du lieu backup tren VPS khac, du lieu backup van an toan ngay"
echo "-------------------------------------------------------------------------"
echo "ngay ca khi server dang su dung gap su co die hay khong cuu duoc du lieu."
echo "-------------------------------------------------------------------------"
echo "He dieu hanh VPS backup ho tro: Centos 6, Centos 7, Ubuntu, Debian. "
echo "-------------------------------------------------------------------------"
echo "LEMP khuyen dung Centos 6 de nhan ho tro nhieu nhat tu lemp."
echo "-------------------------------------------------------------------------"
echo "Luu y: Ban co the su dung 1 VPS backup de sao luu nhieu VPS chay LEMP"
echo "-------------------------------------------------------------------------"
touch /etc/lemp/menu/backup/lemp-rsync-have-read.sh
read -p "Nhan [Enter] de tiep tuc ..."
clear
fi
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
