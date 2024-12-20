#!/bin/bash 
. /home/lemp.conf

# Hien thi thong tin ban dau
echo "========================================================================="
echo "Su dung chuc nang nay de ALLOW/DENY chay script trong writable folder"
echo "-------------------------------------------------------------------------"
echo "Thu muc: uploads, images, cache, media, logs, tmp - Script: PHP, PL, PY, JSP, SH, CGI"
echo "-------------------------------------------------------------------------"
echo "Chinh sua quy tac tai: /etc/nginx/conf/deny-script-writeable-folder.conf"
echo "========================================================================="

# Ham nhap ten website
nhapwebsite() {
    echo -n "Nhap ten website: "  
    read website
    website=$(echo "$website" | tr '[:upper:]' '[:lower:]')  # Chuyen doi thanh chu thuong

    # Kiem tra xem website co phai la Net2FTP khong
    if [ -f /etc/lemp/net2ftpsite.info ]; then
        net2ftpsite=$(cat /etc/lemp/net2ftpsite.info)
        if [ "$website" = "$net2ftpsite" ]; then
            #clear
            echo "========================================================================="
            echo "$website la domain Net2FTP"
            echo "-------------------------------------------------------------------------"
            echo "Ban khong the su dung chuc nang nay."
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            exit
        fi
    fi

    # Kiem tra ten website da nhap
    if [ -z "$website" ]; then
        echo "-------------------------------------------------------------------------"
        echo "Ban chua nhap ten website"
        echo "-------------------------------------------------------------------------"
        nhapwebsite
        return
    fi

    # Kiem tra dinh dang domain
    kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}"
    if [[ ! "$website" =~ $kiemtradomain3 ]]; then
        echo "-------------------------------------------------------------------------"
        echo "$website co ve khong phai la domain!"
        echo "-------------------------------------------------------------------------"
        nhapwebsite
        return
    fi

    # Kiem tra file cau hinh cua website
    if [ ! -f /etc/nginx/conf.d/$website.conf ] && [ ! -f /etc/nginx/conf.d/www.$website.conf ]; then
        echo "-------------------------------------------------------------------------"
        echo "Khong tim thay $website tren server"
        echo "-------------------------------------------------------------------------"
        nhapwebsite
        return
    fi

    # Kiem tra cau hinh block.conf
    for conf_file in /etc/nginx/conf.d/$website.conf /etc/nginx/conf.d/www.$website.conf; do
        if [ -f "$conf_file" ]; then
            if ! grep -q block.conf "$conf_file"; then
                #clear
                echo "========================================================================="
                echo "Ban da thay doi cau hinh Vhost mac dinh cua $website"
                echo "-------------------------------------------------------------------------"
                echo "LEMP khong the thuc hien yeu cau cua ban."
                /etc/lemp/menu/lemp-block-exploits-sql-injections-menu.sh
                exit
            fi
        fi
    done

    # Kiem tra cau hinh deny-script-writeable-folder.conf
    for conf_file in /etc/nginx/conf.d/$website.conf /etc/nginx/conf.d/www.$website.conf; do
        if [ -f "$conf_file" ]; then
            if ! grep -q deny-script-writeable-folder.conf "$conf_file"; then
                check="bat"
            fi
        fi
    done

    # Xu ly cho phep hoac khong cho phep chay script
    if [ ! "$check" == "bat" ]; then
        echo "========================================================================="
        echo "$website hien tai KHONG CHO PHEP chay Script trong writable folder"
        echo "-------------------------------------------------------------------------"
        read -r -p "CHO PHEP chay Script trong writable folder? [y/N] " response
        case $response in
            [yY][eE][sS]|[yY]) 
                echo "-------------------------------------------------------------------------"
                echo "Vui long doi..."   		
                sleep 1  
                cat > "/tmp/chanrunscriptuploadfolder.sh" <<END
#!/bin/sh
# Xoa cac dong lien quan den writable-directories va deny-script-writeable-folder trong cau hinh
for conf_file in /etc/nginx/conf.d/$website.conf /etc/nginx/conf.d/www.$website.conf; do
    if [ -f "\$conf_file" ]; then
        sed -i '/writable-directories/d' "\$conf_file" 
        sed -i '/deny-script-writeable-folder/d' "\$conf_file" 
    fi
done
END
                chmod +x /tmp/chanrunscriptuploadfolder.sh
                /tmp/chanrunscriptuploadfolder.sh
                rm -f /tmp/chanrunscriptuploadfolder.sh
                
				# Restart Nginx
				if systemctl is-active --quiet nginx; then
					systemctl reload nginx
				else
					systemctl restart nginx
				fi


                #clear
                echo "========================================================================="
                echo "Cau hinh CHO PHEP chay Script trong writable folder cho $website thanh cong!"
                /etc/lemp/menu/tienich/lemp-tien-ich.sh
                ;;
            *)
                #clear
                echo "========================================================================="
                echo "Huy thay doi cau hinh Vhost cho $website"
                /etc/lemp/menu/tienich/lemp-tien-ich.sh
                ;;
        esac
        exit
    fi

    echo "========================================================================="
    echo "$website hien tai CHO PHEP chay Script trong writable folder"
    echo "-------------------------------------------------------------------------"
    read -r -p "KHONG CHO PHEP chay Script trong writable folder? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "-------------------------------------------------------------------------"
            echo "Vui long doi..."
            sleep 1
            rm -rf /tmp/chanrunscriptuploadfolder.sh
            cat > "/tmp/chanrunscriptuploadfolder.sh" <<END
#!/bin/sh
# Cap nhat cau hinh de khong cho phep chay script trong writable folder
for conf_file in /etc/nginx/conf.d/$website.conf /etc/nginx/conf.d/www.$website.conf; do
    if [ -f "\$conf_file" ]; then
        if ! grep -q deny-script-writeable-folder.conf "\$conf_file"; then
            sed -i "/.*block.conf*./a#Deny scripts inside writable-directories" "\$conf_file"
            sed -i "/.*writable-directories*./ainclude /etc/nginx/conf/deny-script-writeable-folder.conf;" "\$conf_file"
        else
            sed -i 's/.*deny-script-writeable-folder.conf.*/include \/etc\/nginx\/conf\/deny-script-writeable-folder.conf;/g' "\$conf_file"
        fi
    fi
done
END
            chmod +x /tmp/chanrunscriptuploadfolder.sh
            /tmp/chanrunscriptuploadfolder.sh
            rm -f /tmp/chanrunscriptuploadfolder.sh
            
				# Restart Nginx
				if systemctl is-active --quiet nginx; then
					systemctl reload nginx
				else
					systemctl restart nginx
				fi

            #clear
            echo "========================================================================="
            echo "Cau hinh KHONG cho phep chay script trong writable folder cho $website thanh cong"
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            ;;
        *)
            #clear
            echo "========================================================================="
            echo "Huy thay doi cau hinh Vhost cho $website"
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            ;;
    esac
    exit
}

# Goi ham nhap website
nhapwebsite
