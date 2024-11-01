#!/bin/bash 

. /home/lemp.conf

if [ -f /etc/csf/csf.conf ]; then
    if [ ! -s /etc/csf/csf.deny ]; then
        clear
        echo "=========================================================================="
        echo "Hien tai CSF Firewall chua block IP nao."
        /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        exit
    fi
else
    /etc/lemp/menu/CSF-Fiwall/lemp-tat-csf.sh
    exit
fi

echo "=========================================================================="
test_csf=$(csf -v | awk 'NR==1 {print $NF}')
if [ "$test_csf" == "enable" ]; then
    echo "Chuc nang nay se bat CSF Firewall neu ban dang tat no."
    echo "--------------------------------------------------------------------------"
fi

echo -n "Nhap dia chi IP ban muon bo chan [ENTER]: " 
read ipbochan

if [ "$test_csf" == "enable" ]; then
    csf -e
fi

if [ -z "$ipbochan" ]; then
    clear
    echo "=========================================================================="
    echo "Ban nhap sai, vui long nhap chinh xac."
    /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
    exit
fi

# Kiem tra dinh dang IP
if [[ ! "$ipbochan" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    clear
    echo "=========================================================================="
    echo "$ipbochan khong phai la dia chi IP hop le!"
    echo "--------------------------------------------------------------------------"
    echo "Vui long thu lai..."
    /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
    exit
fi

# Kiem tra neu IP co bi block trong csf.deny hay khong
if ! grep -q "$ipbochan" /etc/csf/csf.deny; then
    clear
    echo "=========================================================================="
    echo "IP: $ipbochan khong bi chan boi CSF Firewall."
    /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
    exit
fi

# Xoa IP khoi csf.deny
csf -dr "$ipbochan"
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh

clear
echo "=========================================================================="
echo "IP: $ipbochan bay gio co the truy cap VPS/Server!"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit

else
    echo "========================================================================== "
    echo "Chuc nang nay can CSF Firewall de hoat dong."
    echo "--------------------------------------------------------------------------"
    echo "CSF Firewall chua duoc cai dat tren server!"
    echo "--------------------------------------------------------------------------"
    read -r -p "Ban co muon cai dat CSF Firewall vao server? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            /etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf.sh
            clear
            echo "========================================================================== "
            echo "Cai dat va cau hinh thanh cong CSF Firewall!"
            /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
            ;;
        *)
            clear
            echo "========================================================================== "
            echo "Ban da huy bo cai dat CSF Firewall!"
            /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
            exit
            ;;
    esac
fi
