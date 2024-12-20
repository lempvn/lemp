#!/bin/bash
. /home/lemp.conf
if [ ! -d /home/$mainsite/private_html/backup/AllDB ]; then
mkdir -p /home/$mainsite/private_html/backup/AllDB
fi
if [ ! -f /home/DBinfo.txt ]; then
echo "========================================================================="  > /home/DBinfo.txt
echo "THONG TIN DATABASE TREN VPS"  >> /home/DBinfo.txt
echo "========================================================================="  >> /home/DBinfo.txt
echo "" >> /home/DBinfo.txt
echo "" >> /home/DBinfo.txt
fi


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
echo "MySQL service is Down"
echo "------------------------------------------------------------------------"
echo "LEMP trying to start it"
echo "------------------------------------------------------------------------"
echo "Please wait ..."
sleep 5
rm -rf /var/lib/mysql/ib_logfile0
rm -rf /var/lib/mysql/ib_logfile1
cat > "/tmp/startmysql" <<END
systemctl restart mariadb.service
service mysql start
END
chmod +x /tmp/startmysql
/tmp/startmysql
rm -rf /tmp/startmysql
clear
echo "========================================================================"
echo "Check MySQL service once again !"
echo "------------------------------------------------------------------------"
echo "Please wait ..."
sleep 5
cat > "/tmp/config.temp" <<END
CREATE DATABASE lempCheckDB COLLATE utf8_general_ci;
END
mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp
	if [ ! -f /var/lib/mysql/lempCheckDB/db.opt ]; then
	clear
	echo "========================================================================="
	echo "Sorry, MySQL service dang stopped. LEMP khong the bat MySQL len duoc!"
	lemp
	else
	rm -rf /var/lib/mysql/lempCheckDB
	clear
	/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
	fi
else
rm -rf /var/lib/mysql/lempCheckDB
clear
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
fi

