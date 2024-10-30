#!/bin/bash
. /home/lemp.conf

# Kiem tra xem pure-ftpd da duoc cai dat chua
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
echo "Su dung chuc nang nay de tao FTP user cho website"
echo "-------------------------------------------------------------------------"
echo -n "Nhap website ban muon them FTP user [ENTER]: " 
read website

if [ "$website" = "" ]; then
    clear
    echo "========================================================================="
    echo "Ban nhap sai, vui long nhap lai!"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

# Kiem tra dinh dang domain
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
    website=$(echo "$website" | tr '[A-Z]' '[a-z]')
    clear
    echo "========================================================================="
    echo "$website co ve khong phai la domain!"
    echo "-------------------------------------------------------------------------"
    echo "Ban vui long nhap lai!"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

# Kiem tra xem website co ton tai trong cau hinh nginx khong
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
    clear
    echo "========================================================================="
    echo "Website $website khong ton tai tren he thong!"
    echo "-------------------------------------------------------------------------"
    echo "Ban hay nhap lai!"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

# Tao file chua thong tin nguoi dung FTP neu chua ton tai
if [ ! -f /etc/proftpd/sftp.passwd ]; then
touch /etc/proftpd/sftp.passwd
chown proftpd:root /etc/proftpd/sftp.passwd
chmod 600 /etc/proftpd/sftp.passwd
fi

# Kiem tra xem da tao tai khoan FTP cho website chua
#if [ ! -z "$(pure-pw list | grep "/home/$website/")" ]; then
#    clear
#    echo "========================================================================="
#    echo "Ban da tao tai khoan FTP cho $website" 
#    echo "-------------------------------------------------------------------------"
#    echo "Thong tin tai khoan FTP:"
#    echo "-------------------------------------------------------------------------"
#    echo "IP: $serverip "
#	echo "Port truy cap: 2222"
#    echo "-------------------------------------------------------------------------"
#    echo "User: $(grep "/home/$website/" /etc/lemp/FTP-Account.info | awk 'NR==1 {print $7}') | Password: $(grep "/home/$website/" /etc/lemp/FTP-Account.info | awk 'NR==1 {print $10}')"
#    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
#fi

echo "-------------------------------------------------------------------------"
echo "Tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "$website chua tao tai khoan FTP"
echo "-------------------------------------------------------------------------"
echo "LEMP se tao tai khoan FTP cho $website ngay bay gio"
echo "-------------------------------------------------------------------------"
echo "Please wait..."; sleep 6

# Tao ten dang nhap va mat khau
#echo "$website" > /tmp/lempftp.txt
#sed -i 's/\./_/g' /tmp/lempftp.txt
#sed -i 's/\-/_/g' /tmp/lempftp.txt
#username=$(cat /tmp/lempftp.txt | tr -d '_' | cut -c1-30)
#password=$(date | md5sum | cut -c '3-23')

# Tao tai khoan FTP
#( echo "${password}" ; echo "${password}" ) | pure-pw useradd "${username}" -u nginx -g nginx -d "/home/${website}" -m 
#pure-pw mkdb

read -p "Nhap ten user truy cap FTP cua ban: " username

# Kiem tra ten nguoi dung chi chua cac ky tu hop le
if [[ ! "$username" =~ ^[a-zA-Z0-9_-]+$ ]]; then
	echo "==================================================================================================================="
    echo "Ten nguoi dung khong hop le. Chi duoc phep chua cac ky ty a-z, A-Z, 0-9, dau gach duoi (_) va dau gach ngang (-)."
	echo "==================================================================================================================="
	echo "Vui long chon va nhap lai!"
	echo "==================================================================================================================="
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
fi
#echo "$username"

# Kiem tra xem ten nguoi dung da ton tai trong file sftp.passwd hay chua
if grep -q "^$username:" /etc/proftpd/sftp.passwd; then
	echo "==================================================================================================================="
    echo "Ten nguoi dung $username da ton tai!"
	echo "==================================================================================================================="
	echo "Vui long chon va nhap lai!"
	echo "==================================================================================================================="
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
fi

# Kiem tra ten nguoi dung co ton tai tren he thong hay khong
if getent passwd "$username" > /dev/null 2>&1; then
	echo "==================================================================================================================="
    echo "Ten nguoi dung $username da ton tai!"
	echo "==================================================================================================================="
	echo "Vui long chon va nhap lai!"
	echo "==================================================================================================================="
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
fi

# Chuyen ten website thanh user name quan ly website 
convert_to_username() {
    # Thay the dau cham bang dau gach duoi de tao ten nguoi dung hop le
    webuser=$(echo "$website" | sed 's/\./_/g')

    # Tra ve webuser da chuyen doi
    echo "$webuser"
}

# Goi ham va luu gia tri tra ve vao bien moi
webuser=$(convert_to_username "$website")
echo "Original website: $website"
echo "Converted webuser: $webuser"

# Lay UID va GID tu webuser
user_info=$(getent passwd $webuser)

if [ -z "$user_info" ]; then
    echo "Nguoi dung $webuser khong ton tai."
    exit 1
fi

# Phan tach thong tin de lay UID va GID
USER_UID=$(echo "$user_info" | cut -d: -f3)
USER_GID=$(echo "$user_info" | cut -d: -f4)

# Hien thi UID va GID
echo "UID cua $webuser la: $USER_UID"
echo "GID cua $webuser la: $USER_GID"

# Tao ten dang nhap va mat khau
#echo "$website" | sed 's/\./_/g; s/-/_/g' > /tmp/lempftp.txt
#username=$(cat /tmp/lempftp.txt | cut -c1-30)
#password=$(openssl rand -base64 12)  # Tao mat khau ngau nhien


password=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 24)
hashed_password=$(openssl passwd -1 "$password")

# Duong dan thu muc home cho nguoi dung
home_directory="/home/$website/public_html"
auth_file="/etc/proftpd/sftp.passwd"
shell="/bin/bash"

echo "$username:$hashed_password:$USER_UID:$USER_GID::${home_directory}:${shell}" | sudo tee -a "$auth_file" > /dev/null

systemctl restart proftpd.service

# Tao file chua thong tin tai khoan FTP neu chua ton tai
if [ ! -f /etc/lemp/FTP-Account.info ]; then
    echo "=========================================================================" > /etc/lemp/FTP-Account.info
    echo "DUNG XOA FILE NAY " >> /etc/lemp/FTP-Account.info
    echo "-------------------------------------------------------------------------" >> /etc/lemp/FTP-Account.info
    echo "Neu ban xoa file nay, LEMP se khong chay !" >> /etc/lemp/FTP-Account.info
    echo "-------------------------------------------------------------------------" >> /etc/lemp/FTP-Account.info
    echo "Tat ca FTP User cho cac Domain tren VPS duoc liet ke phia duoi:" >> /etc/lemp/FTP-Account.info
    echo "=========================================================================" >> /etc/lemp/FTP-Account.info
    echo "" >> /etc/lemp/FTP-Account.info
fi

# Ghi thong tin tai khoan FTP vao file
echo "FTP Account for $website | Username: $username | Password: $password | dd /home/$website/public_html " >> /etc/lemp/FTP-Account.info

clear
echo "=========================================================================" 
echo "Tao tai khoan FTP cho $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Thong tin dang nhap:"
echo "-------------------------------------------------------------------------"
echo "IP: $serverip "
echo "Port truy cap: 2222"
echo "-------------------------------------------------------------------------"
echo "User: $username | Password: $password"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
