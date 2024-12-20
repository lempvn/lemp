#!/bin/bash
. /home/lemp.conf

# Kiem tra trang thai Memcached
if [ ! "$(systemctl is-active memcached.service)" == "active" ]; then
    clear
    echo "========================================================================= "
    echo "Memcached dang disable tren server."
    /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
    exit
fi

if [ -f /etc/memcached.conf ]; then
    echo "========================================================================="
    echo "Su dung chuc nang nay de cau hinh luong RAM toi da Memcached co the dung"
    echo "-------------------------------------------------------------------------"
    echo "RAM cho Memcached phai la so tu nhien nam trong khoang (20 - $(($(free -m | awk 'NR==2 {print $2}') / 7)))."
    echo "-------------------------------------------------------------------------"
    echo -n "Nhap luong RAM toi da cho Memcached [ENTER]: " 
    read memcacheram
    if [ "$memcacheram" = "" ]; then
        clear
        echo "========================================================================="
        echo "Ban nhap sai, vui long nhap lai "
        /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
        exit
    fi

    if ! [[ $memcacheram -ge 20 && $memcacheram -le $(($(free -m | awk 'NR==2 {print $2}') / 7)) ]]; then  
        clear
        echo "========================================================================="
        echo "$memcacheram khong dung!"
        echo "-------------------------------------------------------------------------"
        echo "phai la so tu nhien nam trong khoang (20 - $(($(free -m | awk 'NR==2 {print $2}') / 7)))."
        echo "-------------------------------------------------------------------------"
        echo "Ban hay lam lai !"
        /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
        exit
    fi  
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 1
    
    # Xoa file cau hinh cu
    rm -rf /etc/memcached.conf
    cat > "/etc/memcached.conf" <<END
# memcached default config file
# 2003 - Jay Bonci <jaybonci@debian.org>
# This configuration file is read by the start-memcached script provided as
# part of the Debian GNU/Linux distribution.

# Run memcached as a daemon. This command is implied, and is not needed for the
# daemon to run. See the README.Debian that comes with this package for more
# information.

-d
# Log memcached's output to /var/log/memcached
logfile /var/log/memcached.log

-p 11211

# Run the daemon as root. The start-memcached will default to running as root if no
# -u command is present in this config file
-u memcache

# Specify which IP address to listen on. The default is to listen on all IP addresses
# This parameter is one of the only security measures that memcached has, so make sure
# it's listening on a firewalled interface.
-l 127.0.0.1

# Limit the number of simultaneous incoming connections. The daemon default is 1024
-c 10024 

# Lock down all paged memory. Consult with the README and homepage before you do this
# -k

# Return error when memory is exhausted (rather than removing items)
# -M

# Maximize core file limit
# -r


# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
-m $memcacheram

# Use a pidfile
-P /var/run/memcached/memcached.pid

END

    # Khoi dong lai Memcached
    systemctl restart memcached.service
    clear
    echo "========================================================================="
    echo "Config thanh cong Memcached su dung $memcacheram MB RAM"
    /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
    exit
fi

clear
echo "========================================================================= "
echo "Khong phat hien Memcached tren VPS"
#/etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
exit
