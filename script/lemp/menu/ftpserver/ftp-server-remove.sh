#!/bin/bash 

if [ -f /etc/proftpd/proftpd.conf ]; then
    echo "========================================================================= "
    read -r -p "Ban muon remove FTP server ? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "Chuan bi Remove FTP Server ... "
            sleep 1
            sudo DEBIAN_FRONTEND=noninteractive apt -yqq purge proftpd proftpd-basic proftpd-core proftpd-doc proftpd-mod-crypto proftpd-mod-wrap 
            rm -rf /etc/proftpd
            rm -rf /etc/lemp/FTP-Account.info
            
            # Tao lai tep FTP-Account.info neu no khong ton tai
            if [ ! -f /etc/lemp/FTP-Account.info ]; then
                {
                    echo "========================================================================="
                    echo "KHONG DUOC XOA FILE NAY! "
                    echo "-------------------------------------------------------------------------"
                    echo "Neu ban xoa file nay, LEMP se khong chay !"
                    echo "-------------------------------------------------------------------------"
                    echo "Tat ca FTP User cho cac Domain tren VPS duoc liet ke phia duoi:"
                    echo "========================================================================="
                    echo ""
                } > /etc/lemp/FTP-Account.info
            fi
            
            clear
            # Xoa cong 2222 bang ufw
            sudo ufw delete allow 2222/tcp

            ;;
        *)
            clear 
            echo "========================================================================= "
            echo "Huy bo remove FTP Server "
            /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
            ;;
    esac
    
    clear 
    echo "========================================================================= "
    echo "LEMP hoan thanh remove FTP Server "
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
else
    clear
    echo "========================================================================= "
    echo "Ban chua cai dat FTP server "
    /etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
    exit
fi
