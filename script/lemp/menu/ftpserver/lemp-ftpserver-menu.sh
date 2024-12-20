#!/bin/bash
. /home/lemp.conf 
if [ ! -f /etc/lemp/menu/ftpserver/lemp-ftpserver-read.sh ]; then
clear
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                            Quan Ly FTP Server \n"
printf "=========================================================================\n"
echo ""

echo "========================================================================="
echo "Su dung chuc nang nay de cai dat FTP Server cho Server"
echo "-------------------------------------------------------------------------"
echo "Sau khi cai dat FTP Server xong, ban co the tao tai khoan FTP cho tung"
echo "-------------------------------------------------------------------------"
echo "Website tren server. Mac dinh, ban khong the ket noi FTP vao Server bang "
echo "-------------------------------------------------------------------------"
echo "tai khoan root. Neu muon dang nhap tai khoan root, ban phai su dung sFTP"
echo "-------------------------------------------------------------------------"
echo "Ban dang nhap SFTP bang tai khoan root theo thong tin:"
echo "-------------------------------------------------------------------------"
echo "Host: sftp://$serverip"
echo "-------------------------------------------------------------------------"
echo "User: root | Password: Your_password "
echo "-------------------------------------------------------------------------"
echo "Port: Port SFTP (mac dinh 2222)"
echo "-------------------------------------------------------------------------"
touch /etc/lemp/menu/ftpserver/lemp-ftpserver-read.sh
read -p "Nhan [Enter] de tiep tuc ..."
clear
fi

if [ ! -f /etc/pure-ftpd/pure-ftpd.conf ]; then
/etc/lemp/menu/ftpserver/ftpserver-menu-khong.sh
else
/etc/lemp/menu/ftpserver/ftpserver-menu-co.sh
fi
