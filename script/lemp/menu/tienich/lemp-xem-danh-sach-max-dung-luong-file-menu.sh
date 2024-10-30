#!/bin/bash
printf "=========================================================================\n"
prompt="Lua chon cua ban:"
options=("Tim File Va Folder Trong public_html Cua Domain" "Tim File Va Folder Trong Folder Home")
PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in
    1) /etc/lemp/menu/tienich/lemp-xem-danh-sach-max-dung-luong-file-domain.sh;;
    2) /etc/lemp/menu/tienich/lemp-danh-sach-max-dung-luong-file-folder-home.sh;;
$(( ${#options[@]}+1 )) ) echo "";  clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh;;
     *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done


