#!/bin/sh

DATABASE_PASS=$(cat /tmp/passrootmysql)

# Thiet lap mat khau cho nguoi dung root
mariadb-admin -u root password "$DATABASE_PASS"

# Dam bao rang khong ai co the truy cap vao may chu ma khong can mat khau
mariadb -u root -p"$DATABASE_PASS" -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DATABASE_PASS');"

# Xoa nguoi dung an danh
mariadb -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"

# Xoa co so du lieu thu nghiem
mariadb -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test_%'"

# Lam cho cac thay doi co hieu luc
mariadb -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES;"


 cat >> "/home/lemp.conf" <<END
mariadbpass="$DATABASE_PASS"
END
rm -rf /tmp/passrootmysql
#wget --no-check-certificate -q https://lemp.echbay.com/script/lemp/mysql_secure_installation.bak -O /bin/mysql_secure_installation
#wget --no-check-certificate -q https://raw.githubusercontent.com/itvn9online/lemp-free/master/script/lemp/mysql_secure_installation_bak -O /bin/mysql_secure_installation
yes | cp -rf /opt/vps_lemp/script/lemp/mysql_secure_installation_bak.sh /bin/mysql_secure_installation && chmod +x /bin/mysql_secure_installation
