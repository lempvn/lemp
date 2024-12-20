#!/bin/sh
. /home/lemp.conf
svram=$( free -m | awk 'NR==2 {print $2}' )
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	ramformariadb=$(calc $svram/10*6)
	ramforphpnginx=$(calc $svram-$ramformariadb)
	max_children=$(calc $ramforphpnginx/30)
	memory_limit=$(calc $ramforphpnginx/5*3)M
	mem_apc=$(calc $ramforphpnginx/5)M
	buff_size=$(calc $ramformariadb/10*8)M
	log_size=$(calc $ramformariadb/10*2)M
echo "=========================================================================="
echo "Dung chuc nang nay de nang cap MariaDB tu phien ban 5.5 len phien ban 10.0"
if [ ! "$(/sbin/service mysql status | awk 'NR==1 {print $3}')" == "running" ]; then 
echo "--------------------------------------------------------------------------"
echo "Ban hay backup tat ca database truoc khi thuc hien nang cap"
fi
echo "--------------------------------------------------------------------------"
read -r -p "Ban muon nang cap MariaDB len 10.0 ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
rpm -qa|grep  -i mariadb > /tmp/checkmariadb
abc456=`date |md5sum |cut -c '1-12'` 
if [ "$(service mysql status | awk 'NR==1 {print $3}')" == "running" ]; then   
echo "--------------------------------------------------------------------------"
echo "LEMP se sao luu tat ca Database truoc khi nang cap MariaDB"
echo "--------------------------------------------------------------------------"
echo "Please wait ...."
sleep 3
rm -rf /home/$mainsite/private_html/backup/AllDB
mkdir -p /home/$mainsite/private_html/backup/AllDB
cd /home/$mainsite/private_html/backup/AllDB
mysqldump -u root -p$mariadbpass --all-databases | gzip -9 > AllDB_$abc456.sql.gz
cd
fi
if [ -f /home/$mainsite/private_html/backup/AllDB/AllDB_$abc456.sql.gz ]; then
echo "--------------------------------------------------------------------------"
echo "Sao luu tat ca database thanh cong"
echo "--------------------------------------------------------------------------"
echo "Link file backup:"
echo "--------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/AllDB/AllDB_$abc456.sql.gz"
fi
echo "--------------------------------------------------------------------------"
echo "Bat dau nang cap MariaDB ... "
echo "--------------------------------------------------------------------------"
echo "Please wait ...."
sleep 3
#yum -y update
service mysql stop
rm -rf /etc/yum.repos.d/mariadb*
rm -rf /etc/yum.repos.d/MariaDB*
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
cat > "/etc/yum.repos.d/mariadb.repo" <<END
# MariaDB 10.0 CentOS repository list
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
END

if [ "$(grep mariadb /tmp/checkmariadb)" = "" ]; then
yum -y remove MariaDB-client MariaDB-common MariaDB-compat MariaDB-devel MariaDB-server MariaDB-shared perl-DBD-MySQL
else
yum -y remove mariadb-client mariadb-common mariadb-compat mariadb-devel mariadb-server mariadb-shared perl-DBD-MySQL
fi

yum clean all
#yum -y update
yum -y install MariaDB-client MariaDB-common MariaDB-compat MariaDB-devel MariaDB-server MariaDB-shared perl-DBD-MySQL
rm -rf /var/lib/mysql/ib_logfile*
rm -rf /var/lib/mysql/*.pid
rm -rf /var/lib/mysql/*.err
chkconfig --add mysql
chkconfig --levels 235 mysql on
/sbin/chkconfig mysql on
service mysql start
mysql_upgrade -p$mariadbpass
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
systemctl stop mariadb.service
service mysql stop
rm -rf /etc/yum.repos.d/mariadb*
rm -rf /etc/yum.repos.d/MariaDB*
if [ "$(grep mariadb /tmp/checkmariadb)" = "" ]; then
yum -y remove MariaDB-client MariaDB-common MariaDB-compat MariaDB-devel MariaDB-server MariaDB-shared perl-DBD-MySQL
else
yum -y remove mariadb-client mariadb-common mariadb-compat mariadb-devel mariadb-server mariadb-shared perl-DBD-MySQL
fi
cat > "/etc/yum.repos.d/mariadb.repo" <<END
# MariaDB 10.0 CentOS repository list 
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
END
yum clean all
#yum -y update
rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
yum -y install MariaDB-client MariaDB-common MariaDB-compat MariaDB-devel MariaDB-server MariaDB-shared perl-DBD-MySQL
rm -rf /var/lib/mysql/ib_logfile*
rm -rf /var/lib/mysql/*.pid
rm -rf /var/lib/mysql/*.err
service mysql start
systemctl start mysql
systemctl start mariadb.service
systemctl enable mysql
systemctl enable mariadb.service
mysql_upgrade -p$mariadbpass
fi


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
rm -f /etc/my.cnf.d/server.cnf
    cat > "/etc/my.cnf.d/server.cnf" <<END

[mysqld]
skip-host-cache
skip-name-resolve
collation-server = utf8_unicode_ci
init-connect='SET NAMES utf8'
character-set-server = utf8
skip-character-set-client-handshake

user = mysql
default-storage-engine = InnoDB
local-infile=0
ignore-db-dir=lost+found
character-set-server=utf8
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

#bind-address=127.0.0.1
back_log = $(calc 75*$heso2)
max_connections = $(calc 22*$heso2)
key_buffer_size = 32M
myisam_recover = FORCE,BACKUP
myisam_sort_buffer_size = $(calc 32*$heso1)M
join_buffer_size = $(calc 32*$heso2)K  
read_buffer_size = $(calc 32*$heso2)K 
sort_buffer_size = $(calc 64*$heso2)K 
table_definition_cache = 2048
table_open_cache = 2048
thread_cache_size = $(calc 8*$heso2)K
wait_timeout = 50
connect_timeout = 10
interactive_timeout = 40
optimizer_search_depth = 4
tmp_table_size = $(calc 16*$heso3)M
max_heap_table_size = $(calc 16*$heso3)M
max_allowed_packet = $(calc 16*$heso2)M
max_seeks_for_key = 1000

max_length_for_sort_data = 1024
net_buffer_length = 16384
max_connect_errors = 100000
concurrent_insert = 2
read_rnd_buffer_size = $(calc 1*$heso2)M
bulk_insert_buffer_size = 8M
query_cache_limit = 512K
query_cache_size = $(calc 16*$heso2)M
query_cache_type = 1
query_cache_min_res_unit = 2K


log_warnings=1
slow_query_log=0
long_query_time=1
log_error = /home/$mainsite/logs/mysql.log
log_queries_not_using_indexes = 0
slow_query_log_file = /home/$mainsite/logs/mysql-slow.log

# innodb settings
innodb_large_prefix=1
innodb_purge_threads=1
innodb_file_format = Barracuda
innodb_file_per_table = 1
innodb_open_files = $(calc 200*$heso2)
innodb_data_file_path= ibdata1:10M:autoextend
innodb_buffer_pool_size = $(calc 64*$heso2)M
skip-innodb_doublewrite # or commented out

## https://mariadb.com/kb/en/mariadb/xtradbinnodb-server-system-variables/#innodb_buffer_pool_instances
#innodb_buffer_pool_instances=2

innodb_log_files_in_group = 2
innodb_log_file_size = 48M
#innodb_log_buffer_size = 1M
innodb_flush_log_at_trx_commit = 2
innodb_thread_concurrency = $(calc 2*$cpucores)
innodb_lock_wait_timeout=50
innodb_flush_method = O_DIRECT
innodb_support_xa=1

# 200 * # DISKS
#innodb_io_capacity = 100 # 100 for HDD
innodb_read_io_threads = $(calc 4*$cpucores)
innodb_write_io_threads = $(calc 4*$cpucores)

# mariadb settings
[mariadb]

userstat = 0
#key_cache_segments = 0  # 1 to 64
aria_group_commit = none
aria_group_commit_interval = 0
aria_log_file_size = $(calc 11*$heso2)M
aria_log_purge_type = immediate 
aria_pagecache_buffer_size = 1M
aria_sort_buffer_size = 1M

[mariadb-5.5]
#ignore_db_dirs=
query_cache_strip_comments=0

innodb_read_ahead = linear
innodb_adaptive_flushing_method = estimate
innodb_flush_neighbor_pages=none
innodb_stats_update_need_lock = 0
innodb_log_block_size = 512

log_slow_filter =admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk

[mysqld_safe] 
socket=/var/lib/mysql/mysql.sock
log-error=/var/log/mysqld.log
#nice = -5
open-files-limit = 8192

[mysqldump]
quick
max_allowed_packet = 32M

[isamchk]
key_buffer = $(calc 16*$heso2)M
sort_buffer_size = $(calc 128*$heso2)K
read_buffer = $(calc 128*$heso2)K
write_buffer = $(calc 128*$heso2)K

[myisamchk]
key_buffer = $(calc 16*$heso2)M
sort_buffer_size = $(calc 128*$heso2)K
read_buffer = $(calc 128*$heso2)K
write_buffer = $(calc 128*$heso2)K

[mysqlhotcopy]
interactive-timeout

[mariadb-10.0]

innodb_buffer_pool_dump_at_shutdown=1
innodb_buffer_pool_load_at_startup=1
innodb_buffer_pool_populate=0
performance_schema=OFF
innodb_stats_on_metadata=OFF
innodb_sort_buffer_size=1M
query_cache_strip_comments=0
log_slow_filter =admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk

END
rm -rf /tmp/checkmariadb
chmod 777 /var/lib/php/session/
if [ ! "$(service mysql status | awk 'NR==1 {print $3}')" == "running" ]; then
rm -rf /var/lib/mysql/ib_logfile0
rm -rf /var/lib/mysql/ib_logfile1
service mysql start
fi
if [ ! "$(service mysql status | awk 'NR==1 {print $3}')" == "running" ]; then
clear
echo "========================================================================="
echo "Nang cap MariaDB that bai !"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
clear
echo "========================================================================="
echo "Ban da hoan thanh nang cap MariaDB len phien ban 10.0 !"
if [ -f /home/$mainsite/private_html/backup/AllDB/AllDB_$abc456.sql.gz ]; then
echo "--------------------------------------------------------------------------"
echo "Link file backup database:"
echo "--------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/AllDB/AllDB_$abc456.sql.gz"
fi
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh

;;
esac
clear
echo "========================================================================="
echo "Ban da cancel nang cap MariaDB len phien ban 10.0 !"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
