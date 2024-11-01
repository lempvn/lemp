#!/bin/bash 

. /home/lemp.conf
echo "========================================================================="
echo "Chuc nang nay de BAT/TAT [Block Exploits, SQL Injections] cho Website"
echo "-------------------------------------------------------------------------"
echo "Edit rules tai: /etc/nginx/conf/block.conf"
echo "========================================================================="

nhapdulieu () {
    echo -n "Nhap ten website: " 
    read website
    website=`echo $website | tr '[A-Z]' '[a-z]'`
    
    if [ -f /etc/lemp/net2ftpsite.info ]; then
        net2ftpsite=$(cat /etc/lemp/net2ftpsite.info)
        if [ "$website" = "$net2ftpsite" ]; then
            clear
            echo "========================================================================="
            echo "$website la domain Net2FTP"
            echo "-------------------------------------------------------------------------"
            echo "Ban khong the su dung chuc nang nay."
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
        fi
    fi
    
    if [ "$website" = "" ]; then
        echo "========================================================================="
        echo "Ban nhap sai, vui long nhap lai ! "
        echo "-------------------------------------------------------------------------"
        nhapdulieu
    fi
    
    kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}"
    if [[ ! "$website" =~ $kiemtradomain3 ]]; then
        website=`echo $website | tr '[A-Z]' '[a-z]'`
        echo "========================================================================="
        echo "$website co le khong phai ten domain !"
        echo "-------------------------------------------------------------------------"
        nhapdulieu
    fi
    
    if [ ! -f /etc/nginx/conf.d/$website.conf ] && [ ! -f /etc/nginx/conf.d/www.$website.conf ]; then
        echo "========================================================================="
        echo "Khong phat hien $website tren he thong  "
        echo "-------------------------------------------------------------------------"
        nhapdulieu
    fi

    if [ -f /etc/nginx/conf.d/www.$website.conf ] && [ "$(grep block.conf /etc/nginx/conf.d/www.$website.conf)" == "" ]; then
        clear
        echo "========================================================================="
        echo "Ban da thay doi config mac dinh trong Vhost cua $website"
        echo "-------------------------------------------------------------------------"
        echo "LEMP khong the thuc hien yeu cau cua ban"
        /etc/lemp/menu/lemp-block-exploits-sql-injections-menu.sh
        exit
    fi

    if [ -f /etc/nginx/conf.d/$website.conf ] && [ "$(grep block.conf /etc/nginx/conf.d/$website.conf)" == "" ]; then
        clear
        echo "========================================================================="
        echo "Ban da thay doi config mac dinh trong Vhost cua $website"
        echo "-------------------------------------------------------------------------"
        echo "LEMP khong the thuc hien yeu cau cua ban"
        /etc/lemp/menu/lemp-block-exploits-sql-injections-menu.sh
        exit
    fi

    check=0
    if [ -f /etc/nginx/conf.d/$website.conf ]; then
        if [ "$(grep "#include /etc/nginx/conf/block.conf;" /etc/nginx/conf.d/$website.conf)" == "" ]; then
            check=1
        fi
    fi

    if [ -f /etc/nginx/conf.d/www.$website.conf ]; then
        if [ "$(grep "#include /etc/nginx/conf/block.conf;" /etc/nginx/conf.d/www.$website.conf)" == "" ]; then
            check=1
        fi
    fi

    if [ ! "$check" == "1" ]; then
        echo "========================================================================="
        echo "$website hien tai dang TAT [Block Exploits, SQL Injections]"
        echo "-------------------------------------------------------------------------"
        read -r -p "Ban muon BAT chuc nang nay ?  [y/N] " response
        case $response in
            [yY][eE][sS]|[yY]) 
                echo "-------------------------------------------------------------------------"
                echo "Please wait..."   		
                sleep 1
                cat > "/tmp/blocksqlinection.sh" <<END
#!/bin/sh
if [ -f /etc/nginx/conf.d/$website.conf ]; then
    sed -i 's/.*block.conf.*/include \/etc\/nginx\/conf\/block.conf;/g' /etc/nginx/conf.d/$website.conf
fi
if [ -f /etc/nginx/conf.d/www.$website.conf ]; then
    sed -i 's/.*block.conf.*/include \/etc\/nginx\/conf\/block.conf;/g' /etc/nginx/conf.d/www.$website.conf
fi
END
                chmod +x /tmp/blocksqlinection.sh
                /tmp/blocksqlinection.sh
                rm -f /tmp/blocksqlinection.sh

                systemctl restart nginx.service
                clear
                echo "========================================================================="
                echo "BAT [Block Exploits, SQL Injections] cho $website thanh cong !"
                /etc/lemp/menu/tienich/lemp-tien-ich.sh
                ;;
            *)
                clear 
                echo "========================================================================="
                echo "Ban huy BAT [Block Exploits, SQL Injections] cho $website"
                /etc/lemp/menu/tienich/lemp-tien-ich.sh
                ;;
        esac
        exit
    fi

    echo "========================================================================="
    echo "$website hien tai dang BAT [Block Exploits, SQL Injections]"
    echo "-------------------------------------------------------------------------"
    read -r -p "Ban muon TAT chuc nang nay ? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "-------------------------------------------------------------------------"
            echo "Please wait..."
            sleep 1
            cat > "/tmp/blocksqlinection.sh" <<END
#!/bin/sh
if [ -f /etc/nginx/conf.d/$website.conf ]; then
    sed -i 's/.*block.conf.*/#include \/etc\/nginx\/conf\/block.conf;/g' /etc/nginx/conf.d/$website.conf
fi
if [ -f /etc/nginx/conf.d/www.$website.conf ]; then
    sed -i 's/.*block.conf.*/#include \/etc\/nginx\/conf\/block.conf;/g' /etc/nginx/conf.d/www.$website.conf
fi
END
            chmod +x /tmp/blocksqlinection.sh
            /tmp/blocksqlinection.sh
            rm -f /tmp/blocksqlinection.sh

            systemctl restart nginx.service
            clear
            echo "========================================================================="
            echo "TAT [Block Exploits, SQL Injections] cho $website thanh cong !"
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            ;;
        *)
            clear   
            echo "========================================================================="
            echo "Huy TAT [Block Exploits, SQL Injections] cho $website"
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            ;;
    esac
    exit
}

nhapdulieu
