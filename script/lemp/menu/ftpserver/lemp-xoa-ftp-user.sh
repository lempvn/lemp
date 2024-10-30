#!/bin/bash
. /home/lemp.conf

if [ ! -f /etc/proftpd/proftpd.conf ]; then
    clear
    echo "========================================================================= "
    echo "FTP server chua duoc cai dat tren server. "
    echo "-------------------------------------------------------------------------"
    echo "Ban phai cai dat chuc nang Setup FTP server truoc"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

echo "========================================================================="
echo "Su dung chuc nang nay de quan ly tai khoan FTP cua website"
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

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$"
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
    website=$(echo "$website" | tr '[A-Z]' '[a-z]')
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

# Kiem tra tai khoan FTP
accounts=$(grep "/home/$website/" /etc/lemp/FTP-Account.info)
if [ -z "$accounts" ]; then
    clear
    echo "========================================================================="
    echo "Website $website chua tao tai khoan FTP!"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

echo "========================================================================="
echo "Thong tin tai khoan FTP cua $website:"
echo "-------------------------------------------------------------------------"

# Hien thi tat ca thong tin lien quan den tai khoan FTP
echo "$accounts" | while IFS='|' read -r line; do
    # Tach thong tin tu dong
    account_info=$(echo "$line" | sed -E "s/.*(FTP Account for [^|]*)(\| Username: [^|]*)(\| Password: [^|]*)(\| dd [^|]*).*/\1\n\2\n\3\n\4/")
    printf "%s\n" "$account_info"
done

echo "-------------------------------------------------------------------------"
echo -n "Nhap ten tai khoan FTP ban muon xoa: "
read ftpuser

if [ -z "$ftpuser" ]; then
    clear
    echo "========================================================================="
    echo "Ban khong nhap tai khoan nao, vui long nhap lai!"
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

# Kiem tra xem tai khoan FTP co ton tai khong
if ! grep -q "^$ftpuser:" /etc/proftpd/sftp.passwd; then
    clear
    echo "========================================================================="
    echo "Tai khoan FTP $ftpuser khong ton tai! Vui long kiem tra lai."
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi

read -r -p "Ban chac chan muon xoa tai khoan $ftpuser? [y/N] " response

case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Please wait ..."
        sleep 1
        
        # Xoa tai khoan FTP
        sed -i "/^$ftpuser:[^:]*:[^:]*:[^:]*:[^:]*:\/home\/$website\/public_html:/d" /etc/proftpd/sftp.passwd # Xoa khoi danh sach nguoi dung FTP sftp.passw
        sed -i "/FTP Account for $website | Username: $ftpuser | Password:/d" /etc/lemp/FTP-Account.info  # Xoa khoi file thong tin tai khoan
        
        clear
        echo "========================================================================="
        echo "Xoa tai khoan FTP $ftpuser cua $website thanh cong!"
        /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
        exit
        ;;
    *)
        clear
        echo "========================================================================="
        echo "Ban da huy xoa tai khoan FTP cho $website!"
        /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
        exit
        ;;
esac
