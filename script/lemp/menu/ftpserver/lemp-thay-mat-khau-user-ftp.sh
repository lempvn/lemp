#!/bin/bash
. /home/lemp.conf

if [ ! -f /etc/proftpd/proftpd.conf ]; then
clear
echo "========================================================================= "
echo "FTP Server chua duoc cai dat "
echo "-------------------------------------------------------------------------"
echo "Ban phai cai dat chuc nang Setup FTP Server truoc"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
exit
fi

echo "========================================================================="
echo "Su dung chuc nang nay de thay mat khau tai khoan FTP cua website"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website

if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
    website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai la domain!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long nhap lai!"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
exit
fi

if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Website $website khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai!"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
exit
fi

if [ "$(grep "/home/$website/" /etc/lemp/FTP-Account.info)" == "" ]; then
clear
echo "========================================================================="
echo "Website $website chua tao tai khoan FTP!"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
fi

echo "========================================================================="
echo "Phat hien tai khoan FTP cho $website" 
echo "-------------------------------------------------------------------------"
echo "Thong tin tai khoan FTP hien tai:"
echo "-------------------------------------------------------------------------"

# Hien thi tat ca thong tin lien quan den tai khoan FTP theo dinh dang mong muon
grep "/home/$website/" /etc/lemp/FTP-Account.info | while IFS='|' read -r line; do
    # Tach thong tin tu dong
    account_info=$(echo "$line" | sed -E "s/.*(FTP Account for [^|]*)(\| Username: [^|]*)(\| Password: [^|]*)(\| dd [^|]*).*/\1\n\2\n\3\n\4/")
    echo -e "$account_info\n"
done

echo "-------------------------------------------------------------------------"
# Nhap ten nguoi dung can thay doi mat khau
read -p "Nhap ten user FTP can thay doi mat khau: " username

# Kiem tra xem tai khoan FTP co ton tai khong
if ! grep -q "^$username:" /etc/proftpd/sftp.passwd; then
    clear
    echo "========================================================================="
    echo "Tai khoan FTP $username khong ton tai! Vui long kiem tra lai."
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

# Tao mat khau moi ngau nhien
new_password=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 24)

# Bam mat khau moi bang OpenSSL
hashed_new_password=$(openssl passwd -1 "$new_password")

# Tim va thay the mat khau cu trong file sftp.passwd
sudo sed -i "s|^$username:[^:]*:|$username:$hashed_new_password:|" /etc/proftpd/sftp.passwd

# Hien thi thong tin mat khau moi
echo "Mat khau moi cho user $username la: $new_password"

# Cap nhat lai thong tin trong FTP-Account.info
#sed -i "/\/home\/$website/d" /etc/lemp/FTP-Account.info
#echo "FTP Account for $website | Username: $username | Password: $new_password | dd /home/$website/public_html " >> /etc/lemp/FTP-Account.info
# Cap nhat mat khau ma khong xoa thong tin khac
#sed -i "s|\(FTP Account for $website | Username: $username | Password:\) [^|]*|\1 $new_password|" /etc/lemp/FTP-Account.info
sed -i "s#\(FTP Account for $website | Username: $username | Password:\) [^|]*#\1 $new_password#" /etc/lemp/FTP-Account.info

clear
echo "========================================================================= "
echo "Thay mat khau tai khoan FTP cua $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin login moi:"
echo "-------------------------------------------------------------------------"
echo "IP: $serverip"
echo "Port truy cap: 2222"
echo "-------------------------------------------------------------------------"
echo "User: $username | Password: $new_password"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
