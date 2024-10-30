#!/bin/bash
. /home/lemp.conf

if [ ! -f /etc/lemp/netdatasite.info ]; then
    clear
    echo "========================================================================="
    echo "Ban chua cai dat NetData tren server !"
    /etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
    exit
fi

if [ "$(systemctl is-active netdata.service)" == "active" ]; then
    netdatast=bat
else
    netdatast=tat
fi

if [ "$netdatast" = "bat" ]; then 
    echo "========================================================================="
    echo "Hien tai NetData dang BAT"
    echo "========================================================================="
    read -r -p "Ban co muon TAT no khong ? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "Please wait...."
            sleep 1
            systemctl stop netdata
            clear
            echo "========================================================================="
            echo "NetData da duoc TAT thanh cong !"
            /etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
            ;;
        *)
            clear
            echo "========================================================================="
            echo "Ban lua chon NO  !"
            /etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
            ;;
    esac
    exit
fi

echo "========================================================================="
echo "Hien tai NetData dang TAT"
echo "========================================================================="
read -r -p "Ban co muon BAT len khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "Please wait...."
        sleep 1
        systemctl start netdata
        clear
        echo "========================================================================="
        echo "NetData da duoc BAT thanh cong !"
        /etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
        ;;
    *)
        clear
        echo "========================================================================="
        echo "Ban lua chon NO!"
        /etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
        ;;
esac
exit
