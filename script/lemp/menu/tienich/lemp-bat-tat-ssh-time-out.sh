#!/bin/bash 
. /home/lemp.conf

if [ ! -f /etc/ssh/sshd_config ]; then
    clear
    echo "========================================================================="
    echo "Khong tim thay file /etc/ssh/sshd_config"
    echo "-------------------------------------------------------------------------"
    echo "LEMP khong the chay duoc tinh nang nay!"
    echo "-------------------------------------------------------------------------"
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
    exit
fi

if [ "$(grep lempsshconfig /etc/ssh/sshd_config)" == "" ]; then
    echo "========================================================================="
    echo "Dung chuc nang nay de config thoi gian auto thoat ket noi SSH toi server"
    echo "-------------------------------------------------------------------------"
    echo "SSH Timeout BAT: Ket noi SSH toi server thoat voi config mac dinh"
    echo "-------------------------------------------------------------------------"
    echo "SSH Timeout TAT: Ket noi SSH toi server thoat sau 24 gio khong thao tac."
    echo "========================================================================="
    echo "SSH Timeout status: Dang BAT"
    echo "-------------------------------------------------------------------------"
    read -r -p "Ban muon TAT SSH Timeout ? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Please wait ... "
        sleep 3
        sed -i '1 i\#lempsshconfig\ #Do\ not\ edit\ or\ remove\ this\ line\ or\ lemp\ will\ not\ run' /etc/ssh/sshd_config
        sed -i "s/.*TCPKeepAlive.*/TCPKeepAlive\ no/g" /etc/ssh/sshd_config
        sed -i "s/.*ClientAliveInterval.*/ClientAliveInterval\ 30/g" /etc/ssh/sshd_config
        sed -i "s/.*ClientAliveCountMax.*/ClientAliveCountMax\ 100/g" /etc/ssh/sshd_config

        # Kiem tra phien ban Ubuntu (hoac he dieu hanh khac neu can)
        if [ "$(lsb_release -rs)" == "20.04" ]; then
            systemctl restart sshd
        else 
            systemctl restart sshd
        fi

        clear
        echo "========================================================================="
        echo "TAT SSH Timeout thanh cong! "
        echo "-------------------------------------------------------------------------"
        echo "Trinh SSH chi ngat ket noi toi Server sau 24 h neu khong co thao tac."
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
        clear
        echo "========================================================================="
        echo "You choosed NO "
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        exit
        ;;
    esac
fi

if [ ! "$(grep lempsshconfig /etc/ssh/sshd_config)" == "" ]; then
    echo "========================================================================="
    echo "Dung chuc nang nay de config thoi gian auto thoat ket noi SSH toi server"
    echo "-------------------------------------------------------------------------"
    echo "SSH Timeout BAT: Ket noi SSH toi server thoat voi config mac dinh"
    echo "-------------------------------------------------------------------------"
    echo "SSH Timeout TAT: Ket noi SSH toi server thoat sau 24 gio khong thao tac."
    echo "========================================================================="
    echo "SSH Timeout status: Dang TAT"
    echo "-------------------------------------------------------------------------"
    read -r -p "Ban muon BAT SSH Timeout ? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Please wait ... "
        sleep 3
        sed -i '/lempsshconfig/d' /etc/ssh/sshd_config
        sed -i "s/.*TCPKeepAlive.*/#TCPKeepAlive\ no/g" /etc/ssh/sshd_config
        sed -i "s/.*ClientAliveInterval.*/#ClientAliveInterval\ 30/g" /etc/ssh/sshd_config
        sed -i "s/.*ClientAliveCountMax.*/#ClientAliveCountMax\ 100/g" /etc/ssh/sshd_config

        # Khoi dong lai dich vu SSH
        if [ "$(lsb_release -rs)" == "20.04" ]; then
            systemctl restart sshd
        else 
            systemctl restart sshd
        fi

        clear
        echo "========================================================================="
        echo "BAT SSH Timeout thanh cong! "
        echo "-------------------------------------------------------------------------"
        echo "Ket noi SSH toi server thoat voi config mac dinh"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
        clear
        echo "========================================================================="
        echo "You choosed NO "
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        exit
        ;;
    esac
fi
