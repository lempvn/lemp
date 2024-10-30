#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/lemp*
echo "-------------------------------------------------------------------------"
echo "Please wait. LEMP dang kiem tra ..."; sleep 1

# Kiem tra trang thai cua Memcached
if systemctl is-active --quiet memcached; then
    echo "Memcached: Running | Ram Usage: $(grep -oP '(?<=-m )\d+' /etc/memcached.conf) MB" > /tmp/lemp-memcached-info.txt
else
    echo "Memcached: Stopped" > /tmp/lemp-memcached-info.txt
fi

# Kiem tra File Manager
#if [ ! -f /etc/lemp/uploadsite ]; then 
#    echo "File Manager: Not Installed" > /tmp/lemp-filemanager-info.txt
#else
#    uploadsite=$(cat /etc/lemp/uploadsite)
#    echo "File Manager: Installed | Domain: $uploadsite" > /tmp/lemp-filemanager-info.txt
#fi

# Kiem tra Net2FTP
#if [ ! -f /etc/lemp/net2ftpsite.info ]; then 
#    echo "Net2FTP: Not Installed" > /tmp/lemp-net2ftp-info.txt
#else
#    net2ftpsite=$(cat /etc/lemp/net2ftpsite.info)
#    echo "Net2FTP: Installed | Domain: $net2ftpsite" > /tmp/lemp-net2ftp-info.txt
#fi

# Kiem tra NetData
if [ ! -f /etc/lemp/netdatasite.info ]; then 
    echo "NetData: Not Installed" > /tmp/lemp-netdata-info.txt
else
    netdatasite=$(cat /etc/lemp/netdatasite.info)
    if systemctl is-active --quiet netdata; then
        echo "NetData: Installed & Enabled | Domain: $netdatasite" > /tmp/lemp-netdata-info.txt
    else
        echo "NetData: Installed But Disabled | Domain: $netdatasite" > /tmp/lemp-netdata-info.txt
    fi
fi

# Kiem tra CSF Firewall
if [ ! -f "/etc/csf/csf.conf" ]; then
    echo "CSF Firewall: Not Installed" > /tmp/lemp-csf-firewall-info.txt
else
    csf -v > /tmp/lempcheckcscfstatus
    if grep -q "disabled" /tmp/lempcheckcscfstatus; then
        echo "CSF Firewall: Installed but Disabled" > /tmp/lemp-csf-firewall-info.txt
    else
        echo "CSF Firewall: Installed | Version: $(csf -v | awk 'NR==1 {print $2}' | sed 's/v//')" > /tmp/lemp-csf-firewall-info.txt
    fi
fi

# Kiem tra MySQL/MariaDB
if [ -f /var/lib/mysql/lempCheckDB/db.opt ]; then
    rm -rf /var/lib/mysql/lempCheckDB
fi

cat > "/tmp/config.temp" <<END
CREATE DATABASE lempCheckDB COLLATE utf8_general_ci;
END

mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp

if [ ! -f /var/lib/mysql/lempCheckDB/db.opt ]; then
    clear
    echo "========================================================================"
    echo "MySQL service is not running"
    echo "------------------------------------------------------------------------"
    echo "LEMP trying to start it"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5
    systemctl start mariadb.service
    clear
    echo "========================================================================"
    echo "Check MySQL service once again!"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5
    mariadb -u root -p$mariadbpass < /tmp/config.temp
    if [ ! -f /var/lib/mysql/lempCheckDB/db.opt ]; then
        clear
        echo "========================================================================"
        echo "LEMP cannot start MySQL Service"
        sleep 4
        echo "MySQL Status: Stopped" > /tmp/lemp-mysql-info.txt
    else
        rm -rf /var/lib/mysql/lempCheckDB
        echo "MySQL Status: Running" > /tmp/lemp-mysql-info.txt
    fi
else
    rm -rf /var/lib/mysql/lempCheckDB
    echo "MySQL Status: Running" > /tmp/lemp-mysql-info.txt
fi

# Kiem tra Nginx
if systemctl is-active --quiet nginx; then
    echo "Nginx Status: Running" > /tmp/lemp-nginx-info.txt
else
    clear
    echo "========================================================================"
    echo "Nginx service is not running"
    echo "------------------------------------------------------------------------"
    echo "LEMP trying to start it"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5
    systemctl start nginx
    clear
    echo "========================================================================"
    echo "Check Nginx service once again!"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5
    if systemctl is-active --quiet nginx; then
        echo "Nginx Status: Running" > /tmp/lemp-nginx-info.txt
    else
        clear
        echo "========================================================================"
        echo "LEMP cannot start Nginx Service"
        sleep 4
        echo "Nginx Status: Stopped" > /tmp/lemp-nginx-info.txt
    fi
fi

# Kiem tra PHP-FPM

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

if systemctl is-active --quiet php${PHP_VERSION}-fpm; then
    echo "PHP Status: Running" > /tmp/lemp-php-info.txt
    echo "PHP version: $(php -i | grep 'PHP Version' | awk 'NR==1 {print $4}')" >> /tmp/lemp-php-info.txt
else
    clear
    echo "========================================================================"
    echo "PHP-FPM service is not running"
    echo "------------------------------------------------------------------------"
    echo "LEMP trying to start it"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5
    systemctl start php${PHP_VERSION}-fpm
    clear
    echo "========================================================================"
    echo "Check PHP-FPM service once again!"
    echo "------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 5
    if systemctl is-active --quiet php${PHP_VERSION}-fpm; then
        echo "PHP Status: Running" > /tmp/lemp-php-info.txt
        echo "PHP version: $(php -i | grep 'PHP Version' | awk 'NR==1 {print $4}')" >> /tmp/lemp-php-info.txt
    else
        clear
        echo "========================================================================"
        echo "LEMP cannot start PHP${PHP_VERSION}-FPM Service"
        sleep 4
        echo "PHP Status: Stopped" >> /tmp/lemp-php-info.txt
    fi
fi
