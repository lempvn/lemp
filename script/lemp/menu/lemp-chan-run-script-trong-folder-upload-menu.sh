#!/bin/bash 

. /home/lemp.conf

Show_menu () {
    prompt="Nhap lua chon cua ban: "
    options=( "Allow/Deny Chay Script Trong Writable Folder" "List Websites KHONG CHO Chay Script Trong Writeable Folder" "Exit" )
    echo "========================================================================="
    PS3="$prompt"
    select opt in "${options[@]}"; do 
        case "$REPLY" in
            1) luachon="tatbat"; break;;
            2) luachon="danhsach"; break;;
            3) luachon="cancle"; break;;
            *) echo "Ban nhap sai, vui long nhap so thu tu trong danh sach"; continue;;
        esac  
    done

    ###################################
    #
    ###################################
    if [ "$luachon" = "tatbat" ]; then
        /etc/lemp/menu/lemp-tat-bat-chan-run-script-trong-folder-upload-cho-website.sh
    ###################################
    #
    ###################################
    elif [ "$luachon" = "danhsach" ]; then
        /etc/lemp/menu/lemp-list-website-dang-chan-run-script-trong-folder-upload.sh
    ###################################
    #
    ###################################
    else 
        clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh
    fi
}

# Kiem tra trang thai dich vu Nginx
if systemctl is-active --quiet nginx; then
    Show_menu
else
    echo "-------------------------------------------------------------------------"
    systemctl start nginx
    if systemctl is-active --quiet nginx; then
        Show_menu
    else
        clear
        echo "========================================================================="
        echo "Rat tiec, Nginx dang dung. Hay bat len truoc khi dung chuc nang nay!"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
    fi
fi
