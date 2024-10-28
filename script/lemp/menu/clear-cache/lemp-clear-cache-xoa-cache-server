#!/bin/bash 

. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

prompt="Lua chon cua ban: "
options=("Zend Opcache" "Memcached" "Redis Cache" "Tat Ca Cache" "Huy Bo")
echo "========================================================================="
echo "LUA CHON LOAI CACHE BAN MUON CLEAR"
echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) luachonclearcache="zendcache"; break;;
    2) luachonclearcache="memcached"; break;;
    3) luachonclearcache="redisache"; break;;
    4) luachonclearcache="allcache"; break;;
    5) luachonclearcache="cancel"; break;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    esac  
done

if [ "$luachonclearcache" = "zendcache" ]; then
    if [ ! -f /etc/php/${PHP_VERSION}/mods-available/opcache.ini ]; then
        clear
        echo "========================================================================="
        echo "Zend Opcache hien dang tat."
        echo "-------------------------------------------------------------------------"
        echo "Ban khong can clear Zend Opcache"
        lemp
    fi
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."; sleep 1
    clear
    echo "========================================================================= "
    systemctl restart php${PHP_VERSION}-fpm.service  # Cap nhat voi phien ban PHP dang su dung
	echo "Clear Opcache thanh cong!"
    lemp
elif [ "$luachonclearcache" = "memcached" ]; then
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."; sleep 1
    clear
    echo "========================================================================= "
    echo "flush_all" | nc 127.0.0.1 11211
	echo "Clear Memcached thanh cong!"
    lemp
elif [ "$luachonclearcache" = "redisache" ]; then
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."; sleep 1
    clear
    echo "========================================================================= "
    ( echo "flushall" ) | redis-cli
	echo "Clear Redis cache thanh cong!"
    lemp
elif [ "$luachonclearcache" = "allcache" ]; then
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."; sleep 1
    clear
    echo "========================================================================= "
    if [ -f /etc/php/${PHP_VERSION}/mods-available/opcache.ini ]; then
        systemctl restart php${PHP_VERSION}-fpm.service  # Cap nhat voi phien ban PHP dang su dung
    fi
    echo "flush_all" | nc 127.0.0.1 11211
    ( echo "flushall" ) | redis-cli
	echo "Clear tat ca cache thanh cong!"
    lemp
else 
    clear && lemp
fi
