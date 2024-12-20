#!/bin/bash 
. /home/lemp.conf
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
svram=$( free -m | awk 'NR==2 {print $2}' )
time=$(date +"%m-%d-%Y-%H-%M")
checknumbera='^[0-9]+$'
if ! [[ $svram =~ $checknumbera ]] ; then 
clear
echo "========================================================================="
echo "LEMP gap loi khi chay chuc nang nay"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai"
 /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
 exit
fi
if ! [[ $cpucores =~ $checknumbera ]] ; then 
clear
echo "========================================================================="
echo "LEMP gap loi khi chay chuc nang nay"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai"
 /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
 exit
fi

if [ ! -d /home/$mainsite/public_html ]; then
clear
echo "========================================================================="
echo "LEMP gap loi khi chay chuc nang nay"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai"
 /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
 exit
fi

echo "========================================================================="
echo "Su dung chuc nang nay de config lai MySQL theo cau hinh server."
echo "-------------------------------------------------------------------------"
echo "LEMP se tu dong config dua theo so thong so CPU & RAM cua Server."
echo "-------------------------------------------------------------------------"
echo "Khi nang hoac ha cap Server, Ban nen chay chuc nang nay !"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon re-config MySQL ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo -n "Nhap [ OK ] de xac nhan: " 
read xacnhan
if [ ! "$xacnhan" = "OK" ]; then
clear
echo "========================================================================="
echo "Ban phai nhap OK de xac nhan !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
    echo "-------------------------------------------------------------------------"
    echo "Please wait ... "; sleep 2
   if [[ $svram -ge 64 && $svram -le 449  ]] ; then 
heso1=1
elif [[ $svram -ge 450 && $svram -le 1099  ]] ; then
heso1=1
elif [[ $svram -ge 1100 && $svram -le 1999  ]] ; then
heso1=3
elif [[ $svram -ge 2000 && $svram -le 2999  ]] ; then
heso1=6
elif [[ $svram -ge 3000 && $svram -le 5000  ]] ; then
heso1=8
else
heso1=10
fi
if [[ $svram -ge 64 && $svram -le 449  ]] ; then 
heso2=1
elif [[ $svram -ge 450 && $svram -le 1099  ]] ; then
heso2=2
elif [[ $svram -ge 1100 && $svram -le 1999  ]] ; then
heso2=3
elif [[ $svram -ge 2000 && $svram -le 2999  ]] ; then
heso2=4
elif [[ $svram -ge 3000 && $svram -le 5000  ]] ; then
heso2=6
else
heso2=10
fi
if [[ $svram -ge 64 && $svram -le 449  ]] ; then 
heso3=1
elif [[ $svram -ge 450 && $svram -le 1099  ]] ; then
heso3=2
elif [[ $svram -ge 1100 && $svram -le 1999  ]] ; then
heso3=3
elif [[ $svram -ge 2000 && $svram -le 2999  ]] ; then
heso3=4
elif [[ $svram -ge 3000 && $svram -le 5000  ]] ; then
heso3=5
else
heso3=6
fi
if [[ $svram -ge 64 && $svram -le 449  ]] ; then 
heso4=1
elif [[ $svram -ge 450 && $svram -le 1099  ]] ; then
heso4=1
elif [[ $svram -ge 1100 && $svram -le 1999  ]] ; then
heso4=2
elif [[ $svram -ge 2000 && $svram -le 2999  ]] ; then
heso4=2
elif [[ $svram -ge 3000 && $svram -le 5000  ]] ; then
heso4=3
else
heso4=4
fi
mysqlengine=`grep "default-storage-engine =" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}'`
if [ -z $mysqlengine ]; then
mysqlengine=innoDB
fi
mv /etc/mysql/mariadb.conf.d/100-lotaho.cnf /etc/mysql/mariadb.conf.d/100-lotaho.cnf_bak_$time
    cat > "/etc/mysql/mariadb.conf.d/100-lotaho.cnf" <<END

;/etc/mysql/conf.d
[mysqld]
pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
log-error = /var/log/mysql/error.log
;datadir = /home/mysql/
innodb_file_per_table
character-set-server = utf8mb4
collation-server  = utf8mb4_general_ci
init-connect = 'SET NAMES utf8mb4'

;slow_query_log = 1
;slow_query_log_file = /var/log/mysql/slow.log
;long_query_time = 2

thread_cache_size = 32
table_open_cache = 2048
sort_buffer_size = 8M
innodb = force
;innodb_buffer_pool_size = 1G
innodb_buffer_pool_size = 512M
innodb_log_file_size = 1GB
innodb_stats_on_metadata = OFF
innodb_buffer_pool_instances = 8
innodb_log_buffer_size = 10M
innodb_flush_log_at_trx_commit = 2
innodb_thread_concurrency = 6
join_buffer_size = 8M
tmp_table_size = 128M
key_buffer_size = 128M
max_allowed_packet = 64M
max_heap_table_size = 128M
read_rnd_buffer_size = 16M
read_buffer_size = 2M
bulk_insert_buffer_size = 64M
max_connections = 512
myisam_sort_buffer_size = 128M
explicit_defaults_for_timestamp = 1
open_files_limit = 65535
table_definition_cache = 1024
table_open_cache = 2048
log_bin_trust_function_creators = 1
disable_log_bin

END


echo "-------------------------------------------------------------------------"
echo "Hoan thanh re-config ... "; sleep 2
echo "-------------------------------------------------------------------------"
echo "Restart MySQL voi config moi"
echo "-------------------------------------------------------------------------"
service mysql restart
echo "-------------------------------------------------------------------------"
echo "Check MySQl voi Config moi"; sleep 2
echo "-------------------------------------------------------------------------"

if [ -f /var/lib/mysql/lempCheckDB/db.opt ]; then
rm -rf /var/lib/mysql/lempCheckDB
fi
 cat > "/tmp/config.temp" <<END
CREATE DATABASE lempCheckDB COLLATE utf8_general_ci;
END
mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp

if [ ! -f /var/lib/mysql/lempCheckDB/db.opt ]; then
mv /etc/mysql/mariadb.conf.d/100-lotaho.cnf /etc/mysql/mariadb.conf.d/100-lotaho.cnf_fail_$time
mv /etc/mysql/mariadb.conf.d/100-lotaho.cnf_bak_$time /etc/mysql/mariadb.conf.d/100-lotaho.cnf 
rm -rf /var/lib/mysql/ib_logfile0
rm -rf /var/lib/mysql/ib_logfile1
cat > "/tmp/startmysql" <<END
systemctl start mariadb.service
service mysql start
END
chmod +x /tmp/startmysql
/tmp/startmysql
rm -rf /tmp/startmysql
clear
echo "========================================================================="
echo "Re-config MySQL that bai !"
echo "-------------------------------------------------------------------------"
echo "LEMP se giu nguyen config MySQL nhu ban dau"
 /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
else
rm -rf /var/lib/mysql/lempCheckDB
clear
echo "========================================================================="
echo "Config lai MySQL thanh cong ! "
echo "-------------------------------------------------------------------------"
echo "File config cu: /etc/mysql/mariadb.conf.d/100-lotaho.cnf_bak_$time "
 /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
 fi
    ;;
*)
clear
 /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
  exit
;;
esac

