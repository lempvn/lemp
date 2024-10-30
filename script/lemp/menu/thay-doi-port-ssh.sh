#!/bin/bash
. /home/lemp.conf

# Lay port SSH hien tai tu tep cau hinh
sshPortdefault=$(grep "Port" /etc/ssh/sshd_config | head -n 1)
portcu=$(grep Port /etc/ssh/sshd_config | awk 'END {print $2}')

# Kiem tra xem port SSH co phai la gia tri mac dinh hay khong
if [ ! "$sshPortdefault" == "#Port 22" ]; then
    clear
    echo "Ban da thay doi port SSH ma khong su dung LEMP"
    echo "-------------------------------------------------------------------------"
    echo "Chuc nang nay khong the hoat dong duoc!"
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
    exit
fi

# Kiem tra va hien thi port SSH hien tai
if [[ ${portcu} =~ ^[0-9]+$ ]]; then
    echo "========================================================================="
    echo "Port SSH hien tai la: $portcu"
fi

echo "========================================================================="
if [[ ! ${portcu} =~ ^[0-9]+$ ]]; then
    echo "Mac dinh khi ket noi toi server tren SSH ta su dung port 22"
    echo "-------------------------------------------------------------------------"
fi

echo "Su dung chuc nang nay de thay doi port SSH ta dang su dung"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon thay doi SSH port? [Y/N] " response

case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Port SSH moi phai khac $priport va nam giua (30000 - 50000)"
        echo "-------------------------------------------------------------------------"
        echo -n "Nhap port SSH moi ban muon su dung [ENTER]: " 
        read sshport

        if [[ ! ${sshport} =~ ^[0-9]+$ ]]; then 
            clear
            echo "========================================================================="
            echo "Port ban nhap: ${sshport} khong phai la so tu nhien."
            echo "-------------------------------------------------------------------------"
            echo "Ban hay lam lai!" 
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            exit
        fi

        if ! [[ $sshport -ge 30000 && $sshport -le 50000 ]]; then 
            clear
            echo "========================================================================="
            echo "Port ban nhap: ${sshport} khong hop le."
            echo "-------------------------------------------------------------------------"
            echo "Port SSH phai khac $priport va nam trong khoang (30000 - 50000)!" 
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            exit
        fi

        if [ "$priport" = "$sshport" ]; then
            clear
            echo "========================================================================="
            echo "Port SSH ban muon thay trung voi port phpMyAdmin!"
            echo "-------------------------------------------------------------------------"
            echo "Ban hay lam lai"
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            exit
        fi 

        if [ "$portcu" = "$sshport" ]; then
            clear
            echo "========================================================================="
            echo "Port SSH ban nhap trung voi port hien tai!"
            echo "-------------------------------------------------------------------------"
            echo "Ban hay lam lai"
            /etc/lemp/menu/tienich/lemp-tien-ich.sh
            exit
        fi 

        # Xoa port cu khoi tep cau hinh
        sed -i "/^Port $portcu/d" /etc/ssh/sshd_config

        # Xoa quy tac iptables cho port cu
        iptables -D INPUT -p tcp --dport $portcu -j ACCEPT
        iptables -D INPUT -p udp --dport ${portcu} -j ACCEPT

        # Them port SSH moi vao tep cau hinh
        echo "" >> /etc/ssh/sshd_config
        echo "Port $sshport" >> /etc/ssh/sshd_config
        echo "" >> /etc/ssh/sshd_config

        echo "-------------------------------------------------------------------------"
        echo "Vui long cho..."; sleep 1
        /etc/lemp/menu/cai-dat-remove-csf-ssh-port.sh

        # Them quy tac iptables cho port moi
        iptables -I INPUT -p tcp --dport $sshport -j ACCEPT
        iptables -I INPUT -p udp --dport ${sshport} -j ACCEPT

        # Luu va khoi dong lai dich vu
        iptables-save > /etc/iptables/rules.v4
        systemctl restart sshd.service

        clear
        echo "========================================================================="
        echo "Thay doi port SSH thanh cong! Port SSH moi la $sshport"
        echo "-------------------------------------------------------------------------"
        echo "Neu dang nhap bang command, ban can su dung lenh sau:"
        echo "-------------------------------------------------------------------------"
        echo "ssh root@$serverip -p $sshport"
        echo "-------------------------------------------------------------------------"
        echo "Upload qua SFTP:"
        echo "-------------------------------------------------------------------------"
        echo "Host: sftp://$serverip, User & Pass: Thong tin Root, Port: $sshport" 
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        exit
        ;;

    *) 
        clear
        echo "========================================================================="
        echo "Ban da huy thay doi SSH Port!"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        exit
        ;;
esac
