#!/bin/sh

if [ ! -f /etc/lemp/tatthongbao.csf ]; then
    if [ ! -f /etc/csf/csf.conf ]; then
        echo "========================================================================="
        echo "NGUY HIEM ! BAN CHUA CAI DAT CSF FIREWALL DE BAO VE VPS/SERVER !"
        echo "========================================================================="
        echo "Canh bao nay tu dong tat sau khi ban cai dat CSF. Hoac tat bang cach dung"
        echo "========================================================================="
        echo "Chuc nang [ Tat/Bat Canh Bao Tren Menu ] trong [ Quan Ly CSF Firewall ] "
    else
        # Thong bao khi CSF da duoc cai dat
        echo "========================================================================="
        echo "CSF Firewall da duoc cai dat."
        echo "========================================================================="
    fi
fi

rm -rf /tmp/*ip*
who am i | awk '{ print $5}' | sed 's/(//' | sed 's/)//' > /tmp/checkip
checksize=$(du -sb /tmp/checkip | awk 'NR==1 {print $1}')
if [ $checksize -gt 8 ]; then
    if [ -f /etc/csf/csf.conf ]; then
        checkip=$(cat /tmp/checkip)
        if [ ! -f /etc/csf/csf.ignore ]; then
            echo "" > /etc/csf/csf.ignore
        fi
        if [ "$(grep $checkip /etc/csf/csf.ignore)" == "" ]; then 
            cat >> "/tmp/addcheckip" <<END
echo "$checkip" >> /etc/csf/csf.ignore
echo "$checkip" >> /etc/csf/csf.allow
echo "========================================================================="
echo "Dia chi IP hien tai cua ban:  $checkip" 
echo "-------------------------------------------------------------------------"
echo "Dia chi IP nay khong co trong whitelist cua CSF Firewwall"
echo "-------------------------------------------------------------------------"
echo "LEMP da them IP nay vao CSF whitelist de khong bi CSF Firewall Block"
echo "-------------------------------------------------------------------------"
echo "De thay doi co hieu luc, CSF Firewall can khoi dong lai"
echo "========================================================================="
read -p "Nhan [Enter] de khoi dong lai CSF Firewall va Truy cap LEMP ..."
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
clear
echo "========================================================================="
echo "IP: $checkip da duoc them vao CSF Firewall's Whitelist"
END
            chmod +x /tmp/addcheckip
            /tmp/addcheckip
        fi
    fi
fi
