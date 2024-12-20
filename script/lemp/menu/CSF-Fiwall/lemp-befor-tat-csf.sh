#!/bin/bash

. /home/lemp.conf

if [ -f /etc/csf/csf.conf ]; then
    test_csf=$(systemctl is-active csf)
    
    if [ "$test_csf" == "inactive" ]; then
        clear
        echo "========================================================================= "
        echo "CSF dang tat tren server!"
        /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
    else
        clear
        echo "========================================================================= "
        echo "CSF Firewall nen duoc bat de bao ve VPS/Server!"
        echo "-------------------------------------------------------------------------"
        read -r -p "Ban muon tat CSF FireWall? [y/N] " response
        case $response in
            [yY][eE][sS]|[yY]) 
                csf -x
                clear
                echo "========================================================================= "
                echo "Tat CSF firewall thanh cong!"
                /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
                ;;
            *)
                clear
                echo "========================================================================= "
                echo "Ban huy bo viec tat CSF Firewall!"
                /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
                exit
                ;;
        esac
    fi
else
    /etc/lemp/menu/CSF-Fiwall/lemp-tat-csf.sh
    exit
fi
