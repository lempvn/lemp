#!/bin/bash
. /home/lemp.conf

# Kiem tra trang thai cua nginx
if [ "$(systemctl is-active nginx)" == "active" ]; then
    clear
    echo "========================================================================"
    echo "Restarting Nginx service..."
    systemctl restart nginx
    /etc/lemp/menu/tienich/lemp-restart-service.sh
else
    clear
    echo "========================================================================"
    echo "Nginx service is not running"
    echo "------------------------------------------------------------------------"
    echo "LEMP trying to start it"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5; clear
    echo "-------------------------------------------------------------------------"
    systemctl start nginx
    clear
    echo "========================================================================"
    echo "Checking Nginx service once again!"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5; clear

    # Kiem tra lai trang thai sau khi khoi dong
    if [ "$(systemctl is-active nginx)" == "active" ]; then
        clear
        echo "========================================================================"
        echo "Nginx service started successfully."
        /etc/lemp/menu/tienich/lemp-restart-service.sh
    else
        clear
        echo "========================================================================"
        echo "LEMP cannot start Nginx Service"
        sleep 4
        clear
        echo "========================================================================="
        echo "Rat tiec, LEMP khong the khoi dong lai Nginx!"
        /etc/lemp/menu/tienich/lemp-restart-service.sh
    fi
fi
