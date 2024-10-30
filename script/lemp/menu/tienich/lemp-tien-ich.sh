#!/bin/bash
prompt="Lua chon cua ban (0-Thoat): "
#options=( "Thay Password Root" "Fix Loi Chmod, Chown" "Find Top Largest Files & Folders" "Service Running & Ram Use" "Kiem Tra IP/Nameserver Website" \
#"File Size Converter " "Kiem Tra Thong Tin Server" "Cai Dat Server Timezone" "Install / Remove Imagick" "Cai Dat Htop" \
#"Backup Config File & Vhost" "Thay Doi Port SSH Number" "Config SSH Timeout" "Block Exploits, SQL Injections" "Deny Run Script In Upload Folder" \
#"Dat Mat Khau Bao Ve Folder" "BAT/TAT Email Thong Bao Login" "BAT/TAT Auto Run lemp" "Canh Bao Full Disc Tren Menu" "Restart Service" "TocDo.net" \
#"Varnish Cache" "Update All Website Wordpress" "Install Composer" "Go Bo (Remove) lemp" )
options=( "Thay Password Root" "Tim file va thu muc lon nhat" "Service Running & Ram Use" "Kiem Tra IP/Nameserver Website" \
"File Size Converter " "Kiem Tra Thong Tin Server" "Cai Dat Server Timezone" "Install / Remove Imagick" "Cai Dat Htop" \
"Backup Config File & Vhost" "Thay Doi Port SSH Number" "Config SSH Timeout" "Block Exploits, SQL Injections" "Deny Run Script In Upload Folder" \
"Dat Mat Khau Bao Ve Folder" "BAT/TAT Email Thong Bao Login" "BAT/TAT Auto Run lemp" "Canh Bao Full Disc Tren Menu" "Restart Service" "TocDo.net" \
"Varnish Cache" "Update All Website Wordpress" "Install Composer" "Cai dat them phien ban PHP" "Go cai dat phien ban PHP" "Go Bo (Remove) lemp" )
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                           Tien Ich - Addons\n"
printf "=========================================================================\n"

column_count=2
display_order=(1 14 2 15 3 16 4 17 5 18 6 19 7 20 8 21 9 22 10 23 11 24 12 25 13 26)  # Thứ tự hiển thị tùy chọn
# Số lượng tùy chọn
max_options=${#options[@]}

# In ra các tùy chọn với căn chỉnh đều
for ((i=0; i<${#display_order[@]}; i+=column_count)); do
    for ((j=0; j<column_count; j++)); do
        if [ $((i + j)) -lt ${#display_order[@]} ]; then
            index=${display_order[i + j]}
            if [ "$index" -le "$max_options" ]; then
                # Điều chỉnh chiều rộng cho phù hợp
                printf "%-4s %-40s" "$index." "${options[index - 1]}"
            fi
        fi
    done
    echo
done

PS3="$prompt"

# Lay lua chon tu nguoi dung
read -p "$PS3" choice


case "$choice" in
	1) /etc/lemp/menu/lemp-doi-pass-root-vps.sh;;
	#2) /etc/lemp/menu/tienich/lemp-sua-loi-chown.sh;; # tam thoi an di
	2) /etc/lemp/menu/tienich/lemp-xem-danh-sach-max-dung-luong-file-menu.sh;;
	3) /etc/lemp/menu/tienich/lemp-dich-vu-dang-chay-va-ram-dung.sh;;
	4) /etc/lemp/menu/tienich/lemp-tim-ip-nameserver-website.sh;;
	5) /etc/lemp/menu/lemp-chuyen-doi-don-vi-file-size-convert.sh;;
	6) /etc/lemp/menu/tienich/lemp-view-thong-tin-ip-vps.sh;;
	7) clear && /etc/lemp/menu/lemp-thay-doi-thong-tin-thoi-gian.sh;; 
	8) /etc/lemp/menu/tienich/lemp-before-imagick.sh;;
	#10) /etc/lemp/menu/tienich/lemp-before-ioncube.sh;;
	9) /etc/lemp/menu/tienich/lemp-cai-dat-htop.sh;;
	10) /etc/lemp/menu/lemp-sao-luu-sys.sh;;
	11) /etc/lemp/menu/thay-doi-port-ssh.sh;;
	12) /etc/lemp/menu/tienich/lemp-bat-tat-ssh-time-out.sh;;
	13) /etc/lemp/menu/lemp-block-exploits-sql-injections-menu.sh;;
	14) /etc/lemp/menu/lemp-chan-run-script-trong-folder-upload-menu.sh;;
	15) /etc/lemp/menu/lemp-dat-mat-khau-bao-ve-folder-website.sh;;
	16) /etc/lemp/menu/tienich/bat-tat-email-thong-bao-dang-nhap-server.sh;;
	17) /etc/lemp/menu/lemp-bat-tat-tu-dong-chay-lemp.sh;;
	18) /etc/lemp/menu/lemp-config-canh-bao-dung-luong-disc-trong-free-it.sh;;
	19) clear && /etc/lemp/menu/tienich/lemp-restart-service.sh;;
	20) clear && /etc/lemp/menu/tienich/toc-do-dot-net.sh;;
	21) clear && /etc/lemp/menu/varnish/install-varnish.sh;;
	22) clear && /etc/lemp/menu/tienich/update-wordpress-for-all-site.sh;;
	23) clear && /etc/lemp/menu/tienich/install-composer.sh;;
	24) clear && /etc/lemp/menu/nangcap-php/install-php.sh;;
	25) clear && /etc/lemp/menu/nangcap-php/remove-php.sh;;
	26) /etc/lemp/menu/go-bo-scripts.sh;;
#	23) clear && lemp;;
	0) clear && lemp;;

    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;
esac

