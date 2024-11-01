#!/bin/bash 

# Kiem tra xem file cau hinh csf co ton tai khong
if [ -f /etc/csf/csf.conf ]; then
    # Kiem tra xem co IP nao bi block trong csf.deny khong
    if [ ! -s /etc/csf/csf.deny ]; then
        clear
        echo "========================================================================="
        echo "Hien tai CSF Firewall chua block IP nao."
        /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        exit
    fi
else
    /etc/lemp/menu/CSF-Fiwall/lemp-tat-csf.sh
    exit
fi

if [ -f /etc/csf/csf.conf ]; then
    echo "========================================================================="
    test_csf=$(csf -v | awk 'NR==1 {print $NF}')
    
    # Kiem tra neu CSF dang enable
    if [ "$test_csf" == "enable" ]; then
        echo "Chuc nang nay se bat CSF Firewall neu ban dang tat no."
        echo "-------------------------------------------------------------------------" 
    fi
    
    read -r -p "Ban chac chan muon unblock tat ca IP? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "Dang xu ly, vui long doi..."
            sleep 1
            if [ "$test_csf" == "enable" ]; then
                csf -e
            fi
            csf -df
            clear 
            echo "========================================================================= "
            echo "Tat ca cac IP bi chan boi CSF da duoc unblock"
            /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
            ;;
        *)
            clear 
            echo "========================================================================= "
            echo "Ban da huy thao tac unblock tat ca IP"
            /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
            ;;
    esac
else
    echo "========================================================================= "
    echo "Chuc nang nay can CSF Firewall de hoat dong"
    echo "-------------------------------------------------------------------------"
    echo "CSF Firewall chua duoc cai dat tren server!"
    echo "-------------------------------------------------------------------------"
    read -r -p "Ban co muon cai dat CSF Firewall vao server? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            /etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf.sh
            clear
            echo "========================================================================= "
            echo "Cai dat va cau hinh thanh cong CSF Firewall"
            /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
            ;;
    esac
    clear
    echo "========================================================================= "
    echo "Ban da huy bo viec cai dat CSF Firewall!"
    /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
    exit
fi
