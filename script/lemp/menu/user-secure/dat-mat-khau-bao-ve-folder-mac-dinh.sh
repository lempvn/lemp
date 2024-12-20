#!/bin/bash

. /etc/lemp/pwprotect.default

if [ ! -d /etc/nginx/pwprotect ]; then
    mkdir -p /etc/nginx/pwprotect
fi

if [ -f /etc/nginx/.htpasswd ]; then
    echo "========================================================================="
    echo "Su dung User & Password mac dinh de bao ve: phpMyAdmin, NetData, Net2FTP"
    echo "-------------------------------------------------------------------------"
    echo "Backup Files, Folder, WP-Login.php, status.php, File Manager ..."
    echo "-------------------------------------------------------------------------" 
    echo "Thong tin Username va Mat khau hien tai:"
    echo "-------------------------------------------------------------------------"
    echo "Username: $userdefault | Password: $passdefault"
    echo "========================================================================="
    prompt="Nhap lua chon cua ban: "
    options=("Thay Thong Tin Dang Nhap Mac Dinh" "Giu Nguyen Thong Tin Hien Tai (Thoat)")
    PS3="$prompt"
    select opt in "${options[@]}"; do 
        case "$REPLY" in
            1) chooseacction="thaythongtindangnhapmacdinh"; break;;
            2) chooseacction="thoat"; lemp; break;;
            *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach"; continue;;
        esac  
    done

    if [ "$chooseacction" = "thaythongtindangnhapmacdinh" ]; then
        echo "========================================================================="
        echo "Su dung chuc nang nay de THAY thong tin username va mat khau mac dinh"
        echo "-------------------------------------------------------------------------"
        echo -n "Nhap username [ENTER]: " 
        read username
        if [ "$username" = "" ]; then
            clear
            echo "========================================================================="
            echo "Ban chua nhap username"
            exit
        fi
        checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
        if [[ ! "$username" =~ $checkpass ]]; then
            clear
            echo "========================================================================="
            echo "Ban chi duoc dung chu cai va so de dat Username."
            exit
        fi
        echo "-------------------------------------------------------------------------"
        echo -n "Nhap mat khau: "
        read matkhau
        if [ "$matkhau" = "" ]; then
            clear
            echo "========================================================================="
            echo "Ban chua nhap mat khau"
            exit
        fi

        checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
        if [[ ! "$matkhau" =~ $checkpass ]]; then
            clear
            echo "========================================================================="
            echo "Ban chi duoc dung chu cai va so de dat mat khau."
            exit
        fi

        echo "-------------------------------------------------------------------------"
        echo "Thong tin ban nhap: "
        echo "-------------------------------------------------------------------------"
        echo "Username: $username | Password: $matkhau"
        echo "-------------------------------------------------------------------------"
        echo "LEMP se config dang nhap mac dinh moi theo thong tin nay "
        echo "-------------------------------------------------------------------------"
        echo "please wait ...."; sleep 3

        rm -rf /etc/nginx/.htpasswd

        # Cai dat apache2-utils neu chua cai
        if ! dpkg -l | grep -qw apache2-utils; then
            sudo apt update
            sudo apt install -y apache2-utils
        fi

        htpasswd -c -b /etc/nginx/.htpasswd $username $matkhau

        chmod 644 /etc/nginx/.htpasswd
        cat > "/etc/lemp/pwprotect.default" <<END
userdefault="$username"
passdefault="$matkhau"
END
        cat > "/etc/lemp/defaulpassword.php" <<END
<?php
define('ADMIN_USERNAME','$username');   // Admin Username
define('ADMIN_PASSWORD','$matkhau');    // Admin Password
?>
END

        systemctl reload nginx

        clear
        echo "========================================================================="
        echo "Thay thong tin dang nhap mac dinh thanh cong."
        echo "-------------------------------------------------------------------------"
        echo "Username: $username | Password: $matkhau"
        exit
    else 
        clear && exit
    fi
fi

echo "========================================================================="
echo "Su dung chuc nang nay de tao thong tin User va Mat Khau mac dinh, su dung"
echo "-------------------------------------------------------------------------"
echo "de bao ve folder, phpMyAdmin, Backup files, NetData, Wp-login.php ..."
echo "-------------------------------------------------------------------------"
echo -n "Nhap username [ENTER]: " 
read username
if [ "$username" = "" ]; then
    clear
    echo "========================================================================="
    echo "Ban chua nhap username"
    exit
fi

checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$username" =~ $checkpass ]]; then
    clear
    echo "========================================================================="
    echo "Ban chi duoc dung chu cai va so de dat Username."
    exit
fi

echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau: "
read matkhau
if [ "$matkhau" = "" ]; then
    clear
    echo "========================================================================="
    echo "Ban chua nhap mat khau"
    exit
fi

checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$matkhau" =~ $checkpass ]]; then
    clear
    echo "========================================================================="
    echo "Ban chi duoc dung chu cai va so de dat mat khau."
    exit
fi

echo "-------------------------------------------------------------------------"
echo "Thong tin ban nhap: "
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
echo "-------------------------------------------------------------------------"
echo "LEMP se config  dang nhap mac dinh theo thong tin nay "
echo "-------------------------------------------------------------------------"
echo "please wait ...."; sleep 3
cat > "/etc/lemp/pwprotect.default" <<END
userdefault="$username"
passdefault="$matkhau"
END
cat > "/etc/lemp/defaulpassword.php" <<END
<?php
define('ADMIN_USERNAME','$username');   // Admin Username
define('ADMIN_PASSWORD','$matkhau');    // Admin Password
?>
END
rm -rf /etc/nginx/.htpasswd

# Cai dat apache2-utils neu chua cai
if ! dpkg -l | grep -qw apache2-utils; then
    sudo apt update
    sudo apt install -y apache2-utils
fi

htpasswd -c -b /etc/nginx/.htpasswd $username $matkhau

chmod 644 /etc/nginx/.htpasswd
clear
echo "========================================================================="
echo "Tao thong tin dang nhap mac dinh thanh cong."
echo "-------------------------------------------------------------------------"
echo "Username: $username | Password: $matkhau"
lemp
exit
