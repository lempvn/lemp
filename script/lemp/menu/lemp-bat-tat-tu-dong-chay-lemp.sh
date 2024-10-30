#!/bin/bash 

. /home/lemp.conf
if [ ! -f /root/.bash_profile ]; then
    clear
    echo "========================================================================="
    echo "Can not find file /root/.bash_profile"
    echo "-------------------------------------------------------------------------"
    echo "LEMP can not run this function on this server"
    echo "-------------------------------------------------------------------------"
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
    exit
fi

if [ "$(grep "/bin/lemp" /root/.bash_profile)" == "" ]; then
    echo "========================================================================="
    echo "Su dung chuc nang nay de BAT/TAT chuc nang tu dong chay LEMP khi login"
    echo "-------------------------------------------------------------------------"
    echo "SSH vao Server. Hien tai chuc nang nay dang TAT."
    echo "========================================================================="
    read -r -p "Ban muon BAT chuc nang nay ? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "-------------------------------------------------------------------------"
            echo "Please wait ... "
            sleep 1
            # Them lenh vao dau tep
            sed -i "1i\/bin/lemp" /root/.bash_profile
            clear
            echo "========================================================================="
            echo "BAT chuc nang Auto Run LEMP thanh cong ! "
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
else
    echo "========================================================================="
    echo "Su dung chuc nang nay de BAT/TAT chuc nang tu dong chay LEMP khi login"
    echo "-------------------------------------------------------------------------"
    echo "SSH vao Server. Hien tai chuc nang nay dang BAT."
    echo "========================================================================="
    read -r -p "Ban muon TAT chuc nang nay ? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "-------------------------------------------------------------------------"
            echo "Please wait ... "
            sleep 1
            sed -i '/\/bin\/lemp/d' /root/.bash_profile
            clear
            echo "========================================================================="
            echo "TAT chuc nang Auto Run LEMP thanh cong ! "
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
