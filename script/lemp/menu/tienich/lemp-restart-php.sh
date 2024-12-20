#!/bin/bash
. /home/lemp.conf

# Kiem tra va khoi dong lai PHP-FPM voi nhieu phien ban
if systemctl list-units --type=service | grep -q "php.*-fpm"; then
    echo "========================================================================"
    echo "Restarting PHP-FPM services..."
    echo "------------------------------------------------------------------------"

    # Lap qua cac dich vu PHP-FPM va kiem tra trang thai
    for service in $(systemctl list-units --type=service | grep "php.*-fpm" | awk '{print $1}'); do
        if [ "$(systemctl is-active $service)" == "active" ]; then
            echo "$service is running..."
            echo "Restarting $service..."
            systemctl restart "$service"
            
            if [ $? -eq 0 ]; then
                echo "$service restarted successfully."
            else
                echo "Failed to restart $service."
            fi
        else
            echo "$service is not running."
            echo "LEMP trying to start $service..."
            systemctl start "$service"
            
            sleep 5
            if [ "$(systemctl is-active $service)" == "active" ]; then
                echo "$service started successfully."
                echo "Restarting $service..."
                systemctl restart "$service"
            else
                echo "LEMP can not start $service."
            fi
        fi
    done
else
    echo "========================================================================"
    echo "No PHP-FPM services are running."
    echo "Please check your PHP installation."
    echo "========================================================================"
fi

# Quay lai lenh /etc/lemp/menu/tienich/lemp-restart-service.sh sau khi script ket thuc
/etc/lemp/menu/tienich/lemp-restart-service.sh
