#!/bin/bash
. /home/lemp.conf

if [ ! -f /etc/proftpd/proftpd.conf ]; then
    clear
    echo "========================================================================= "
    echo "FTP Server chua duoc cai dat "
    echo "-------------------------------------------------------------------------"
    echo "Ban phai cai dat chuc nang Setup FTP server truoc"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

echo "========================================================================="
echo "Su dung chuc nang nay de xem thong tin tai khoan FTP cua website"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website

if [ -z "$website" ]; then
    clear
    echo "========================================================================="
    echo "Ban nhap sai, vui long nhap lai!"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
    clear
    echo "========================================================================="
    echo "Website $website khong ton tai tren he thong!"
    echo "-------------------------------------------------------------------------"
    echo "Ban hay nhap lai !"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$"
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
    website=$(echo "$website" | tr '[A-Z]' '[a-z]')
    clear
    echo "========================================================================="
    echo "$website co le khong phai la domain !!"
    echo "-------------------------------------------------------------------------"
    echo "Ban vui long nhap lai  !"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

if [ ! -f /etc/lemp/FTP-Account.info ] || [ -z "$(grep "/home/$website/" /etc/proftpd/sftp.passwd)" ]; then
    clear
    echo "========================================================================="
    echo "Website $website chua tao tai khoan FTP !"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

echo "========================================================================="
echo "Tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "$website da duoc tao tai khoan FTP"
echo "-------------------------------------------------------------------------"
echo "LEMP dang lay thong tin"
echo "-------------------------------------------------------------------------"
echo "Please wait...."
sleep 5
clear

echo "========================================================================="
echo "Thong tin dang nhap tai khoan FTP cua $website:"
echo "-------------------------------------------------------------------------"
echo "IP: $serverip"
echo "Port truy cap: 2222"
echo "-------------------------------------------------------------------------"

# Hien thi tat ca thong tin lien quan den tai khoan FTP theo dinh dang mong muon
grep "/home/$website/" /etc/lemp/FTP-Account.info | while IFS='|' read -r line; do
    # Tach thong tin tu dong
    account_info=$(echo "$line" | sed -E "s/.*(FTP Account for [^|]*)(\| Username: [^|]*)(\| Password: [^|]*)(\| dd [^|]*).*/\1\n\2\n\3\n\4/")
    printf "%s\n" "$account_info"
done
echo "-------------------------------------------------------------------------"
# Quay lai menu FTP
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
