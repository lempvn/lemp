#!/bin/bash
. /home/lemp.conf

# Kiem tra xem co so du lieu lempCheckDB da ton tai chua
if [ -f /var/lib/mysql/lempCheckDB/db.opt ]; then
    rm -rf /var/lib/mysql/lempCheckDB
fi

# Tao tam thoi cau hinh de tao co so du lieu
cat > "/tmp/config.temp" <<END
CREATE DATABASE lempCheckDB COLLATE utf8_general_ci;
END

# Thuc hien lenh tao co so du lieu
mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp

# Kiem tra lai xem co so du lieu da duoc tao hay chua
if [ ! -f /var/lib/mysql/lempCheckDB/db.opt ]; then
    clear
    echo "========================================================================"
    echo "MariaDB service is not running"
    echo "------------------------------------------------------------------------"
    echo "LEMP trying to start it"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5 ; clear

    # Xoa cac file log
    rm -rf /var/lib/mysql/ib_logfile0
    rm -rf /var/lib/mysql/ib_logfile1

    # Khoi dong lai MariaDB
    echo "Starting MariaDB service..."
    systemctl start mariadb.service

    clear
    echo "========================================================================"
    echo "Check MariaDB service once again!"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5 ; clear

    # Tao lai co so du lieu sau khi khoi dong lai
    cat > "/tmp/config.temp" <<END
CREATE DATABASE lempCheckDB COLLATE utf8_general_ci;
END

    mariadb -u root -p$mariadbpass < /tmp/config.temp
    rm -f /tmp/config.temp

    # Kiem tra xem co so du lieu da duoc tao chua
    if [ ! -f /var/lib/mysql/lempCheckDB/db.opt ]; then
        clear
        echo "========================================================================"
        echo "LEMP cannot start MariaDB service"
        sleep 4 ;
        clear
        echo "========================================================================="
        echo "Sorry, LEMP khong the khoi dong duoc MariaDB Service"
        /etc/lemp/menu/tienich/lemp-restart-service.sh
    else
        rm -rf /var/lib/mysql/lempCheckDB
        clear
        echo "========================================================================="
        echo "MariaDB service has been restarted successfully."
        systemctl restart mariadb.service
        echo "MariaDB is running now."
        /etc/lemp/menu/tienich/lemp-restart-service.sh
    fi
else
    rm -rf /var/lib/mysql/lempCheckDB
    clear
    echo "========================================================================="
    echo "Restarting MariaDB service..."
    systemctl restart mariadb.service
    echo "MariaDB service has been restarted successfully."
    /etc/lemp/menu/tienich/lemp-restart-service.sh
fi
