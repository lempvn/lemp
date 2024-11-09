#!/bin/bash

checktruenumber='^[0-9]+$'

kiemtraemail3="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~])+\.)*[-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,24}$";
svip=$(curl -s http://ipecho.net/plain)
phpmacdinh="8.2"
numPHPmacdinh="8.2"
echo "=========================================================================="
echo "Mac dinh server se duoc cai dat PHP "$phpmacdinh"."
echo "--------------------------------------------------------------------------"
echo "Neu muon su dung phien ban PHP khac, sau khi cai dat server xong"
echo "--------------------------------------------------------------------------"
echo "Ta dung chuc nang [ Change PHP Version ] trong [ Update System ] cua LEMP."
echo "--------------------------------------------------------------------------"
echo "LEMP ho tro: PHP 8.2, PHP 8.1, PHP 8.0, PHP 7.4"
cpuname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
cpufreq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
svram=$( free -m | awk 'NR==2 {print $2}' )
svhdd=$( df -h | awk 'NR==2 {print $2}' )
svswap=$( free -m | awk 'NR==4 {print $2}' )
free -m
df -h
echo "=========================================================================="
echo "Thong Tin Server:  "
echo "--------------------------------------------------------------------------"
echo "Server Type: $(virt-what | awk 'NR==1 {print $NF}')"
echo "CPU Type: $cpuname"
echo "CPU Core: $cpucores"
echo "CPU Speed: $cpufreq MHz"
echo "Memory: $svram MB"
echo "Disk: $svhdd"
echo "IP: $svip"
echo "--------------------------------------------------------------------------"
echo "Dien Thong Tin Cai Dat: "
echo "=========================================================================="
echo -n "Nhap Phpmyadmin Port [ENTER]: " 
read svport
if [ "$svport" = "80" ] || [ "$svport" = "443" ] || [ "$svport" = "22" ] || [ "$svport" = "3306" ] || [ "$svport" = "25" ] || [ "$svport" = "465" ] || [ "$svport" = "587" ] || [ "$svport" = "21" ]; then
	svport="1241"
echo "Phpmyadmin khong the trung voi port cua dich vu khac !"
echo "LEMP se dat phpmyadmin port la "$svport
fi
if [ "$svport" = "" ] ; then
clear
echo "=========================================================================="
echo "$svport khong duoc de trong."
echo "--------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !" 
bash /root/lemp-setup
exit
fi
if ! [[ $svport -ge 100 && $svport -le 65535  ]] ; then  
clear
echo "=========================================================================="
echo "$svport khong hop le!"
echo "--------------------------------------------------------------------------"
echo "Port hop le la so tu nhien nam trong khoang (100 - 65535)."
echo "--------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !" 
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /root/lemp-setup
exit
fi

echo "--------------------------------------------------------------------------"
echo -n "Nhap dia chi email quan ly [ENTER]: " 
read lempemail
if [ "$lempemail" = "" ]; then
clear
echo "=========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /root/lemp-setup
exit
fi

if [[ ! "$lempemail" =~ $kiemtraemail3 ]]; then
clear
echo "=========================================================================="
echo "$lempemail co le khong dung dinh dang email!"
echo "--------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /root/lemp-setup
exit
fi


prompt="Nhap lua chon cua ban: "
options=("MariaDB 11.4 (Recommendations)" "MariaDB 11.1" "MariaDB 10.11" "MariaDB 10.6" "MariaDB 10.5")
echo "=========================================================================="
echo "Lua Chon Cai Dat Phien Ban MariaDB"
echo "=========================================================================="
PS3="$prompt"

select opt in "${options[@]}"; do
    case "$REPLY" in
        1) mariadbversion="11.4"; break;;
        2) mariadbversion="11.1"; break;;
        3) mariadbversion="10.11"; break;;
        4) mariadbversion="10.6"; break;;
        5) mariadbversion="10.5"; break;;
        #0) mariadbversion="10.2"; break;;
        #*) mariadbversion="10.2"; break;;
        *) echo "Ban nhap sai! Ban vui long chon so trong danh sach"; continue;;
    esac
done


#if [ "$mariadbversion" = "10.1" ]; then
#phienbanmariadb=10.1
#elif [ "$mariadbversion" = "10.2" ]; then
#phienbanmariadb=10.2
#elif [ "$mariadbversion" = "10.3" ]; then
#phienbanmariadb=10.3
#elif [ "$mariadbversion" = "10.4" ]; then
#phienbanmariadb=10.4
#elif [ "$mariadbversion" = "10.5" ]; then
#phienbanmariadb=10.5
#else
#phienbanmariadb=10.2
#fi

if [ "$mariadbversion" = "11.4" ]; then
    phienbanmariadb=11.4
#elif [ "$mariadbversion" = "10.2" ]; then
#    phienbanmariadb=10.2
elif [ "$mariadbversion" = "11.1" ]; then
    phienbanmariadb=11.1
elif [ "$mariadbversion" = "10.11" ]; then
    phienbanmariadb=10.11
elif [ "$mariadbversion" = "10.6" ]; then
    phienbanmariadb=10.6
else
    phienbanmariadb=10.5
fi

# auto mysql root password
#passrootmysql=`date | md5sum | cut -c '1-20' | fold -w1 | awk '{if (NR % 2) print toupper($0); else print tolower($0);}' ORS=''`
passrootmysql=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 24)
#echo $passrootmysql

# v1
#echo "-------------------------------------------------------------------------"
#echo "Mat khau root MySQL toi thieu 8 ki tu va chi su dung chu cai va so."
#echo "-------------------------------------------------------------------------"
#echo -n "Nhap mat khau root MySQL [ENTER]: " 
#read passrootmysql
#if [[ ! ${#passrootmysql} -ge 8 ]]; then
#clear
#echo "========================================================================="
#echo "Mat khau tai khoan root MySQL toi thieu phai co 8 ki tu."
#echo "-------------------------------------------------------------------------"
#echo "Ban vui long thu lai !"
#echo "-------------------------------------------------------------------------"
#read -p "Nhan [Enter] de tiep tuc ..."
#clear
#bash /root/lemp-setup
#exit
#fi  

#checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
#if [[ ! "$passrootmysql" =~ $checkpass ]]; then
#clear
#echo "========================================================================="
#echo "Ban chi duoc dung chu cai va so de dat mat khau MySQL !"
#echo "-------------------------------------------------------------------------"
#echo "Ban vui long thu lai !"
#echo "-------------------------------------------------------------------------"
#read -p "Nhan [Enter] de tiep tuc ..."
#clear
#bash /root/lemp-setup
#exit
#fi  
echo "$passrootmysql" > /tmp/passrootmysql

###############################################################################
#Download Nginx, LEMP & phpMyadmin Version
cd /tmp
#rm -rf 00-all-nginx-version.txt
#rm -rf lemp.newversion
#rm -rf 00-all-phpmyadmin-version.txt
###########################
#download_version_nginx () {
#wget --no-check-certificate -q https://vps.vn/script/lemp/00-all-nginx-version.txt
yes | cp -rf /opt/vps_lemp/script/lemp/00-all-nginx-version.txt /tmp/00-all-nginx-version.txt
#}
#download_version_nginx
#checkdownload_version_nginx=`cat /tmp/00-all-nginx-version.txt`
#if [ -z "$checkdownload_version_nginx" ]; then
#download_version_nginx
#fi
###########################
#download_version_phpmyadmin () {
#wget --no-check-certificate -q https://vps.vn/script/lemp/00-all-phpmyadmin-version.txt
yes | cp -rf /opt/vps_lemp/script/lemp/00-all-phpmyadmin-version.txt 00-all-phpmyadmin-version.txt
#}
#download_version_phpmyadmin
#checkdownload_version_phpmyadmin=`cat /tmp/00-all-phpmyadmin-version.txt`
#if [ -z "$checkdownload_version_phpmyadmin" ]; then
#download_version_phpmyadmin
#fi
###########################
#download_version_lemp () {
#wget -q --no-check-certificate https://vps.vn/script/lemp/lemp.newversion
yes | cp -rf /opt/vps_lemp/script/lemp/lemp.newversion lemp.newversion
#}
#download_version_lemp
#checkdownload_version_lemp=`cat /tmp/lemp.newversion`
#if [ -z "$checkdownload_version_lemp" ]; then
#download_version_lemp
#fi
###########################
cd

phpmyadmin_version=`cat /tmp/00-all-phpmyadmin-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`
Nginx_VERSION=`cat /tmp/00-all-nginx-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`
lemp_version=`cat /tmp/lemp.newversion`

echo "================================================================"
echo $phpmyadmin_version
echo $Nginx_VERSION
echo $lemp_version
echo "================================================================"

. /opt/vps_lemp/script/lemp/nginx-setup.conf

# End Download Nginx, LEMP & phpMyadmin Version
###############################################################################

clear

echo "=========================================================================="
echo "OS Version: "$(lsb_release -cs)
echo "--------------------------------------------------------------------------"
echo "LEMP Se Cai Dat Server Theo Thong Tin:"
echo "=========================================================================="
echo "eMail Quan Ly: $lempemail"
echo "--------------------------------------------------------------------------"
echo "phpMyAdmin Port: $svport"
echo "--------------------------------------------------------------------------"
echo "phpMyAdmin Version: $phpmyadmin_version"
echo "--------------------------------------------------------------------------"
echo "MariaDB Version: $phienbanmariadb"
echo "--------------------------------------------------------------------------"
echo "Mat khau tai khoan root MySQL: $passrootmysql"
echo "--------------------------------------------------------------------------"
echo "Nginx Version: $Nginx_VERSION"
echo "--------------------------------------------------------------------------"
echo "PHP Version: "$phpmacdinh
echo "--------------------------------------------------------------------------"
echo "LEMP Version: $lemp_version"
echo "=========================================================================="
prompt="Nhap lua chon cua ban: "
options=( "Dong Y" "Khong Dong Y")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) xacnhanthongtin="dongy"; break;;
    2) xacnhanthongtin="khongdongy"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done

if [ "$xacnhanthongtin" = "dongy" ]; then
echo "--------------------------------------------------------------------------"
echo "Chuan Bi Cai Dat LEMP ..."
sleep 2
else 
clear
#rm -rf /root/install
bash /root/lemp-setup
exit
fi


#download_nginx_conf () {
#wget --no-check-certificate -q https://vps.vn/script/lemp/nginx.conf -O /tmp/nginx.conf
yes | cp -rf /opt/vps_lemp/script/lemp/nginx.conf /tmp/nginx.conf
#}
#download_nginx_conf
#checkdownload_nginx_conf=`cat /tmp/nginx.conf`
#if [ -z "$checkdownload_nginx_conf" ]; then
#download_nginx_conf
#fi

cat >> "/root/.bash_profile" <<END
. /root/.bashrc

END

#IPlempcheck=$(echo "$SSH_CONNECTION" | cut -d " " -f 1)
#timeloginlempcheck=$(date +"%d %b %Y, %a %r")
#echo "Someone with IP address $IPlempcheck has logged in to $svip on $timeloginlempcheck." 


#echo "Someone with IP address $IPlempcheck has logged in to $svip on $timeloginlempcheck."


#cat >> "/root/.bash_profile" <<END
#IPlempcheck="\$(echo \$SSH_CONNECTION | cut -d " " -f 1)"
#timeloginlempcheck=$(date +"%d %b %Y, %a %r")
#echo "Someone with IP address $IPlempcheck has logged in to $svip on $timeloginlempcheck." | mail -s "Email Notifications From LEMP On $svip" "$lempemail"
#END

echo "$svport" > /tmp/priport.txt

#if [ -s /etc/selinux/config ]; then
#sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#fi

#/opt/vps_lemp/script/lemp/menu/yum-first-install

#rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
#if [ -f /etc/yum.repos.d/epel.repo ]; then
#sudo sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
#fi



#if [ "$phienbanmariadb" = "10.0" ] || [ "$phienbanmariadb" = "10.1" ] || [ "$phienbanmariadb" = "10.2" ] || [ "$phienbanmariadb" = "10.3" ] || [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ]; then
#fi

# https://mariadb.com/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/
#if [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ]; then
#if [ "$phienbanmariadb" = "10.6" ]; then

#cat > "/etc/yum.repos.d/mariadb.repo" <<END
#[mariadb-main]
#name = MariaDB Server
#baseurl = https://downloads.mariadb.com/MariaDB/mariadb-$phienbanmariadb/yum/rhel/\$releasever/\$basearch
#gpgkey = file:///etc/pki/rpm-gpg/MariaDB-Server-GPG-KEY
#gpgcheck = 1
#enabled = 1


#[mariadb-maxscale]
# To use the latest stable release of MaxScale, use "latest" as the version
# To use the latest beta (or stable if no current beta) release of MaxScale, use "beta" as the version
#name = MariaDB MaxScale
#baseurl = https://downloads.mariadb.com/MaxScale/2.4/centos/\$releasever/\$basearch
#gpgkey = file:///etc/pki/rpm-gpg/MariaDB-MaxScale-GPG-KEY
#gpgcheck = 1
#enabled = 1

#[mariadb-tools]
#name = MariaDB Tools
#baseurl = https://downloads.mariadb.com/Tools/rhel/\$releasever/\$basearch
#gpgkey = file:///etc/pki/rpm-gpg/MariaDB-Enterprise-GPG-KEY
#gpgcheck = 1
#enabled = 1
#END
#else

#cat > "/etc/yum.repos.d/mariadb.repo" <<END
# MariaDB $phienbanmariadb CentOS repository list 
# http://downloads.mariadb.org/mariadb/repositories/
#[mariadb]
#name = MariaDB
#baseurl = http://yum.mariadb.org/$phienbanmariadb/centos7-amd64
#gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
#gpgcheck=1
#END
#fi

ubuntu_name=$(lsb_release -cs)

if [ "$phienbanmariadb" = "11.4" ]; then
    echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://vn-mirrors.vhost.vn/mariadb/repo/${phienbanmariadb}/ubuntu ${ubuntu_name} main" | sudo tee /etc/apt/sources.list.d/mariadb.list

elif [ "$phienbanmariadb" = "11.1" ]; then
    echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://vn-mirrors.vhost.vn/mariadb/repo/${phienbanmariadb}/ubuntu ${ubuntu_name} main" | sudo tee /etc/apt/sources.list.d/mariadb.list

elif [ "$phienbanmariadb" = "10.11" ]; then
    echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://vn-mirrors.vhost.vn/mariadb/repo/${phienbanmariadb}/ubuntu ${ubuntu_name} main" | sudo tee /etc/apt/sources.list.d/mariadb.list

elif [ "$phienbanmariadb" = "10.5" ]; then
    echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://vn-mirrors.vhost.vn/mariadb/repo/${phienbanmariadb}/ubuntu ${ubuntu_name} main" | sudo tee /etc/apt/sources.list.d/mariadb.list

elif [ "$phienbanmariadb" = "10.6" ]; then
    echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://vn-mirrors.vhost.vn/mariadb/repo/${phienbanmariadb}/ubuntu ${ubuntu_name} main" | sudo tee /etc/apt/sources.list.d/mariadb.list

fi

sudo apt update

#sudo ufw disable

mkdir -p /usr/local/lemp
cd /usr/local/lemp

#groupadd nginx
#useradd -g nginx -d /dev/null -s /usr/sbin/nologin nginx

sudo DEBIAN_FRONTEND=noninteractive apt -yqq install libxml2-dev libxslt1-dev libgd-dev libgeoip-dev libgoogle-perftools-dev libperl-dev

sudo DEBIAN_FRONTEND=noninteractive apt -yqq  install fuse libfuse3-dev libpcre3-dev bzip2 uuid-dev libbz2-dev cmake gcc g++ git libattr1-dev zlib1g-dev wget unzip lsb-release ca-certificates apt-transport-https software-properties-common

sudo DEBIAN_FRONTEND=noninteractive apt -yqq  install build-essential autoconf automake gcc g++ make pcre2-utils libpcre3-dev zlib1g zlib1g-dev libssl-dev openssl tar expect lsof libedit-dev pkg-config
sudo DEBIAN_FRONTEND=noninteractive apt -yqq  install unzip zip rar unrar rsync psmisc screen
#sudo apt -y install sendmail sendmail-bin sendmail-cf m4
#systemctl start sendmail.service
#systemctl enable sendmail.service

cd
#git --version | awk 'NR==1 {print $3}' > /tmp/gitversion
#if [ -f /tmp/gitversion ]; then
#sed -i 's/\.//g' /tmp/gitversion
#if [ $(cat /tmp/gitversion) -lt 253 ]; then
#if [ ! "$(cat /tmp/gitversion)" = "253" ]; then
#sudo yum -y remove git
#cd /usr/src
#wget -q --no-check-certificate https://github.com/vpsvn/vps-vps-software/raw/master/git-2.5.3.tar.gz
#tar xzf git-2.5.3.tar.gz
#cd /usr/src/git-2.5.3
#make prefix=/usr/local/git all
#make prefix=/usr/local/git install
#echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
#source /etc/bashrc
#cd
#fi
#else
#cd /usr/src
#wget -q --no-check-certificate https://github.com/vpsvn/vps-vps-software/raw/master/git-2.5.3.tar.gz
#tar xzf git-2.5.3.tar.gz
#cd /usr/src/git-2.5.3
#make prefix=/usr/local/git all
#make prefix=/usr/local/git install
#echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
#source /etc/bashrc
#cd
#fi


/opt/vps_lemp/script/lemp/menu/nginx-setup-ubuntu.sh
/opt/vps_lemp/script/lemp/menu/nginx-setup-done.sh
# check ssl/ tls in serrver
#openssl s_client -connect $svip:443 -ssl2
#openssl s_client -connect $svip:443 -ssl3
#openssl s_client -connect $svip:443 -tls1
#openssl s_client -connect $svip:443 -tls1_1
#openssl s_client -connect $svip:443 -tls1_2
#sleep 30
#exit


#sudo yum makecache fast
sudo apt update
#if [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ]; then
#sudo yum -y install perl-DBI libaio libsepol lsof boost-program-options
#sudo yum -y install --repo="mariadb-main" MariaDB-server
#else
#sudo yum -y install --repo="mariadb" MariaDB-server
#sudo yum -y install MariaDB-client MariaDB-common MariaDB-compat MariaDB-devel MariaDB-server MariaDB-shared perl-DBD-MySQL
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install mariadb-server mariadb-client
#fi

#sudo yum -y install exim syslog-ng cronie cronie-anacron

#yum-config-manager --enable remi-php$numPHPmacdinh
#sudo yum -y install php php-curl php-soap php-cli php-snmp php-pspell redis php-pecl-redis php-gmp php-ldap php-bcmath php-intl php-imap perl-libwww-perl perl-LWP-Protocol-https php-pear-Net-SMTP php-enchant php-common php-fpm php-gd php-devel php-mysql php-pear php-pecl-memcached php-pecl-memcache php-opcache php-pdo php-zlib php-xml php-mbstring php-mcrypt php-xmlrpc php-tidy
#sudo yum -y install php php-curl php-pecl-zip php-zip php-soap php-cli php-snmp php-pspell php-pecl-redis php-gmp php-ldap php-bcmath php-intl php-imap perl-libwww-perl perl-LWP-Protocol-https php-pear-Net-SMTP php-enchant php-common php-fpm php-gd php-devel php-mysql php-pear php-pecl-memcached php-pecl-memcache php-opcache php-pdo php-zlib php-xml php-mbstring php-mcrypt php-xmlrpc php-tidy
#if [ -f /etc/lemp/menu/nangcap-php/install-php.sh ]; then
#	/etc/lemp/menu/nangcap-php/install-php.sh
#else
echo "Install php module..."
#sudo apt -y install php-pear
#sudo pear install Mail
#sudo pear install Net_SMTP
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install php8.2 php8.2-curl php8.2-zip php8.2-soap php8.2-cli php8.2-snmp php8.2-pspell php8.2-gmp php8.2-ldap php8.2-bcmath php8.2-intl php8.2-imap libwww-perl liblwp-protocol-https-perl php8.2-enchant php8.2-common php8.2-fpm php8.2-gd php8.2-mysql php-pear php8.2-opcache php8.2-pdo php8.2-xml php8.2-mbstring php8.2-xmlrpc php8.2-tidy php8.2-memcache php8.2-redis php8.2-memcached php8.2-imagick

# Thay doi phien ban php tren he thong thanh ban php8.2
sudo update-alternatives --set php /usr/bin/php8.2
#sudo apt -y install php php-curl php-pecl-zip php-zip php-soap php-cli php-snmp php-pspell php-gmp php-ldap php-bcmath php-intl php-imap perl-libwww-perl perl-LWP-Protocol-https php-pear-Net-SMTP php-enchant php-common php-fpm php-gd php-devel php-mysql php-pear php-opcache php-pdo php-zlib php-xml php-mbstring php-mcrypt php-xmlrpc php-tidy



#sudo yum -y install memcached

#sudo yum -y install ImageMagick ImageMagick-devel ImageMagick-c++ ImageMagick-c++-devel 
#yes "" | pecl install imagick
# neu cai dat thanh cong imagick -> include vao
#if [ -f /usr/lib64/php/modules/imagick.so ]; then
#echo "extension=imagick.so" > /etc/php.d/imagick.ini
#else
#rm -rf /etc/php.d/imagick.ini
#fi

clear
echo "=========================================================================="
echo "Cai Dat Hoan Tat, Bat Dau Qua Trinh Cau Hinh...... "
echo "=========================================================================="
sleep 3
	ramformariadb=$(calc $svram/10*6)
	ramforphpnginx=$(calc $svram-$ramformariadb)
	max_children=$(calc $ramforphpnginx/30)
	memory_limit=$(calc $ramforphpnginx/5*3)M
	mem_apc=$(calc $ramforphpnginx/5)M
	buff_size=$(calc $ramformariadb/10*8)M
	log_size=$(calc $ramformariadb/10*2)M
#systemctl enable exim.service 
#systemctl enable syslog-ng.service
#systemctl start exim.service 
#systemctl start syslog-ng.service
#systemctl disable httpd.service
#systemctl enable nginx.service 
#systemctl start nginx.service 
systemctl enable php8.2-fpm.service 
systemctl start php8.2-fpm.service
systemctl enable mariadb.service
systemctl start mariadb.service

#chkconfig --add mysql
#chkconfig --levels 235 mysql on
#systemctl enable mysql
#service mysql start
#systemctl enable redis.service
#systemctl start redis.service
mkdir -p /home/lemp.demo/public_html
cd /home/lemp.demo/public_html
#wget https://vps.vn/script/lemp/robots.txt
#wget --no-check-certificate -q https://lemp.com/script/lemp/html/install/vietnam/index.html
cp -rf /opt/vps_lemp/script/lemp/html/install/vietnam/index.html index.html
cd
mkdir /home/lemp.demo/private_html

# tao thu muc log va cac file log de phong truong hop cac ung dung khong the tu tao
mkdir -p /home/lemp.demo/logs
chmod 777 /home/lemp.demo/logs
touch /home/lemp.demo/logs/mysql-slow.log
touch /home/lemp.demo/logs/mysql.log
touch /home/lemp.demo/logs/php-fpm-error.log
touch /home/lemp.demo/logs/php-fpm-slow.log
touch /home/lemp.demo/logs/php-fpm.log
chmod 777 /home/lemp.demo/logs/*

mkdir -p /var/log/nginx
#chown -R nginx:nginx /var/log/nginx
#chown -R nginx:nginx /var/lib/php/session

sudo DEBIAN_FRONTEND=noninteractive apt -yqq install memcached

systemctl enable memcached.service
systemctl start memcached.service

#rm -rf /etc/sysconfig/memcached
#cat > "/etc/sysconfig/memcached" <<END
#PORT="11211"
#USER="memcached"
#MAXCONN="10024"
#CACHESIZE="20"
#OPTIONS=""
#END

lemp_setup_cleanup_config_file () {
# remove blank in last line
sed -i -e "s/\s*$//" $1
# remove blank in first line
sed -i -e "s/^\s*//" $1
# remove blank line
sed -i -e "/^$/d" $1
sed -i -e '/^\s*$/d' $1
# remove comment line
sed -i -e '/^\s*#.*$/d' $1
}

#rm -rf /etc/nginx/conf.d
mkdir -p /etc/nginx/conf.d
yes | cp -rf /opt/vps_lemp/script/lemp/conf-webserver/lemp.demo.txt /etc/nginx/conf.d/lemp.demo.conf
# config
cat > "/tmp/lempSetConfigFile" <<END
#!/bin/bash 
sed -i 's/tmp_listen_svport/listen   $svport/g' /etc/nginx/conf.d/lemp.demo.conf
END
chmod +x /tmp/lempSetConfigFile
sh /tmp/lempSetConfigFile
rm -f /tmp/lempSetConfigFile
# cleanup
lemp_setup_cleanup_config_file "/etc/nginx/conf.d/lemp.demo.conf"

systemctl restart nginx

if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
pmmaxchildren=4
pmstartservers=2
pmminspareservers=1
pmmaxspareservers=3
pmmaxrequests=150
###############################################
elif [[ $svram -ge 450 && $svram -le 1300  ]] ; then
pmmaxchildren=10
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=400
###############################################
elif [[ $svram -ge 1302 && $svram -le 1800  ]] ; then
pmmaxchildren=15
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=500
###############################################
elif [[ $svram -ge 1801 && $svram -le 2800  ]] ; then
pmmaxchildren=20
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=500
###############################################
elif [[ $svram -ge 2801 && $svram -le 5000  ]] ; then
pmmaxchildren=33
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=500

###############################################
else
pmmaxchildren=50
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=500
fi



rm -f /etc/php/8.2/fpm/pool.d/www.conf
yes | cp -rf /opt/vps_lemp/script/lemp/conf-webserver/www.txt /etc/php/8.2/fpm/pool.d/www.conf
# config
cat > "/tmp/lempSetConfigFile" <<END
#!/bin/bash 
sed -i 's/tmp_pmmaxchildren/$pmmaxchildren/g' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/tmp_pmstartservers/$pmstartservers/g' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/tmp_pmminspareservers/$pmminspareservers/g' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/tmp_pmmaxspareservers/$pmmaxspareservers/g' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/tmp_pmmaxrequests/$pmmaxrequests/g' /etc/php/8.2/fpm/pool.d/www.conf
END
chmod +x /tmp/lempSetConfigFile
sh /tmp/lempSetConfigFile
rm -f /tmp/lempSetConfigFile
# cleanup
lemp_setup_cleanup_config_file "/etc/php/8.2/fpm/pool.d/www.conf"

systemctl restart php8.2-fpm

#rm -rf /etc/php.ini
#yes | cp -rf /opt/vps_lemp/script/lemp/conf-webserver/php.ini /etc/php.ini
# config
#cat > "/tmp/lempSetConfigFile" <<END
#!/bin/bash 
#sed -i 's/tmp_memory_limit/$memory_limit/g' /etc/php.ini
#END
#chmod +x /tmp/lempSetConfigFile
#sh /tmp/lempSetConfigFile
#rm -f /tmp/lempSetConfigFile
# cleanup
#lemp_setup_cleanup_config_file "/etc/php.ini"


if [ ! -d /home/0-LEMP-SHORTCUT ];then
#wget --no-check-certificate -q https://lemp.com/script/lemp/check-imagick.php.zip -O /home/lemp.demo/private_html/check-imagick.php
yes | cp -rf /opt/vps_lemp/script/lemp/check-imagick.php.zip /home/lemp.demo/private_html/check-imagick.php
mkdir -p /home/0-LEMP-SHORTCUT
mkdir -p /home/lemp.demo/private_html/backup
ln -s /home/lemp.demo/private_html/backup /home/0-LEMP-SHORTCUT/Backup\ \(Website\ +\ Database\)
ln -s /etc/nginx/conf.d /home/0-LEMP-SHORTCUT/Vhost\ \(Vitual\ Host\)
echo "This is shortcut to Backup ( Code & Database ) and Vitual Host in VPS" > /home/0-LEMP-SHORTCUT/readme.txt
echo "Please do not delete it" >>  /home/0-LEMP-SHORTCUT/readme.txt
fi

#rm -rf /etc/php.d/*opcache*
#yes | cp -rf /opt/vps_lemp/script/lemp/conf-webserver/opcache.ini /etc/php.d/opcache.ini
# cleanup
#lemp_setup_cleanup_config_file "/etc/php.d/opcache.ini"


#rm -rf /etc/sysctl.conf
#yes | cp -rf /opt/vps_lemp/script/lemp/conf-webserver/sysctl.txt /etc/sysctl.conf
# cleanup
#lemp_setup_cleanup_config_file "/etc/sysctl.conf"


#rm -rf /etc/php-fpm.conf
yes | cp -rf /opt/vps_lemp/script/lemp/conf-webserver/php-fpm.txt /etc/php/8.2/fpm/pool.d/php-fpm.conf
# cleanup
lemp_setup_cleanup_config_file "/etc/php/8.2/fpm/pool.d/php-fpm.conf"

systemctl restart php8.2-fpm

if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
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

if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
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

if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
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

if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
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

if ! [[ $cpucores =~ $checktruenumber ]] ; then
cpucores=1
fi 

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


# fixed ERROR for MariaDB config (xu ly loi config tren cac phien ban MariaDB khac nhau)
#if [ "$phienbanmariadb" = "10.2" ] ; then
# ERROR: Field doesn't have a default value -> Loi sql_mode trong phien ban 10.2++
#cat > "/tmp/lempSetConfigFile" <<END
#!/bin/bash 
#sed -i -e "/sql_mode=/d" /etc/my.cnf.d/server.cnf
#sed -i '/^skip-character-set-client-handshake.*/a sql_mode=NO_ENGINE_SUBSTITUTION' /etc/my.cnf.d/server.cnf
#END
#chmod +x /tmp/lempSetConfigFile
#sh /tmp/lempSetConfigFile
#rm -f /tmp/lempSetConfigFile
#fi

#if [ "$phienbanmariadb" = "10.3" ] || [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ] ; then
# https://mariadb.com/kb/en/upgrading-from-mariadb-102-to-mariadb-103/
#cat > "/tmp/lempSetConfigFile" <<END
##!/bin/bash 
#sed -i 's/innodb_support_xa=/\#innodb_support_xa=/g' /etc/my.cnf.d/server.cnf
#END
#chmod +x /tmp/lempSetConfigFile
#sh /tmp/lempSetConfigFile
#rm -f /tmp/lempSetConfigFile
#fi


#if [ "$phienbanmariadb" = "10.0" ] || [ "$phienbanmariadb" = "10.1" ] || [ "$phienbanmariadb" = "10.2" ] ; then
#cat >> "/etc/my.cnf.d/server.cnf" <<END

#[mariadb-$phienbanmariadb]
#innodb_buffer_pool_dump_at_shutdown=1
#innodb_buffer_pool_load_at_startup=1
#innodb_buffer_pool_populate=0
#performance_schema=OFF
#innodb_stats_on_metadata=OFF
#innodb_sort_buffer_size=1M
#query_cache_strip_comments=0
#log_slow_filter =admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk

#END
#fi

#if [ "$phienbanmariadb" = "10.3" ] || [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ] ; then
#cat >> "/etc/my.cnf.d/server.cnf" <<END

#[mariadb-$phienbanmariadb]
#innodb_buffer_pool_dump_at_shutdown=1
#innodb_buffer_pool_load_at_startup=1
#innodb_buffer_pool_populate=0
#performance_schema=OFF
#innodb_stats_on_metadata=OFF
#innodb_sort_buffer_size=1M
#query_cache_strip_comments=0
#log_slow_filter =admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk

#END
#fi


cat >> "/etc/security/limits.conf" <<END
* soft nofile 65536
* hard nofile 65536
nginx soft nofile 65536
nginx hard nofile 65536
* soft core 0 
* hard core 0
END

ulimit  -n 65536


mkdir -p /etc/lemp
echo "" > /etc/lemp/pwprotect.default

cat > "/etc/lemp/nginx.version" <<END
${Nginx_VERSION}
END

cat > "/etc/lemp/lemp.version" <<END
${lemp_version}
END

cat > "/etc/lemp/phpmyadmin.version" <<END
${phpmyadmin_version}
END


#cat > "/etc/redis/redis.conf" <<END
#maxmemory 40mb
#maxmemory-policy allkeys-lru
#END

yes | sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install redis

sed -i '1i maxmemory 64mb\nmaxmemory-policy allkeys-lru' /etc/redis/redis.conf

systemctl restart redis.service

if [ ! "$(grep LANG=en_US.utf-8 /etc/environment)" == "LANG=en_US.utf-8" ]; then
  echo -e "LANG=en_US.utf-8\nLC_ALL=en_US.utf-8" >> /etc/environment
fi


#rm -f /home/lemp.conf
cat > "/home/lemp.conf" <<END
mainsite="lemp.demo"
priport="$svport"
serverip="$svip"
END

#rm -f /var/lib/mysql/ib_logfile0
#rm -f /var/lib/mysql/ib_logfile1
#rm -f /var/lib/mysql/ibdata1

#if [ "$phienbanmariadb" = "10.4" ] ; then
#sudo systemctl enable --now mariadb
#fi
systemctl restart mariadb.service

# Download mysql_secure_installation
#rm -f /bin/mysql_secure_installation
#download_mysql_secure_installation () {
#wget --no-check-certificate -q https://vps.vn/script/lemp/mysql_secure_installation -O /bin/mysql_secure_installation && chmod +x /bin/mysql_secure_installation
#yes | cp -rf /opt/vps_lemp/script/lemp/mysql_secure_installation /bin/mysql_secure_installation && chmod +x /bin/mysql_secure_installation
#}
#download_mysql_secure_installation
#checkmysql_secure_installation=`cat /bin/mysql_secure_installation`
#if [ -z "$checkmysql_secure_installation" ]; then
#download_mysql_secure_installation
#fi

download_mysql_secure_installation () {
    cp /opt/vps_lemp/script/lemp/mysql_secure_installation.sh /bin/mysql_secure_installation && chmod +x /bin/mysql_secure_installation
}

# Chay lenh tai/copy
download_mysql_secure_installation


#wget --no-check-certificate -q https://lemp.com/script/lemp/Softwear/wp-cli.phar

#yes | cp -rf /opt/vps_lemp/script/lemp/Softwear/wp-cli.phar wp-cli.phar
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#wget -q --no-check-certificate https://github.com/vpsvn/vps-vps-software/raw/main/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
#clear
#echo "=========================================================================="
#echo "Dat Mat Khau Cho Tai Khoan root Cua MYSQL ... "
#echo "=========================================================================="

/bin/mysql_secure_installation

cat >> "/home/lemp.conf" <<END
emailmanage="$lempemail"
END

systemctl restart mariadb.service
#service mysql restart

clear
echo "=========================================================================="
echo "Cai dat phpMyAdmin... "
echo "=========================================================================="
sleep 2
cd /home/lemp.demo/private_html/
#wget -q https://gist.github.com/ck-on/4959032/raw/0b871b345fd6cfcd6d2be030c1f33d1ad6a475cb/ocp.php
wget -q https://gist.githubusercontent.com/ck-on/4959032/raw/0b871b345fd6cfcd6d2be030c1f33d1ad6a475cb/ocp.php
#wget --no-check-certificate -q https://lemp.com/script/lemp/memcache.php.zip -O /home/lemp.demo/private_html/memcache.php
yes | cp -rf /opt/vps_lemp/script/lemp/memcache.php.zip /home/lemp.demo/private_html/memcache.php

wget -q https://files.phpmyadmin.net/phpMyAdmin/${phpmyadmin_version}/phpMyAdmin-${phpmyadmin_version}-all-languages.zip
unzip -q phpMyAdmin-*.zip > /dev/null 2>&1
yes | cp -rf phpMyAdmin-*/* .
#rm -rf phpMyAdmin-*
#randomblow=`date |md5sum |cut -c '1-32'`;
randomblow=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 32)
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomblow'|" config.sample.inc.php > config.inc.php
cd
mkdir -p /var/lib/php/session
#chown -R nginx:nginx /var/lib/php
clear
echo "=========================================================================="
echo "Dang Tao LEMP Menu...... "
echo "=========================================================================="
#rm -rf /etc/motd

#wget --no-check-certificate -q https://vps.vn/script/lemp/motd -O /etc/motd
yes | cp -rf /opt/vps_lemp/script/lemp/motd.sh /etc/motd


# Download lemp_main_menu
#download_lemp_main_menu () {
#wget --no-check-certificate -q https://vps.vn/script/lemp/lemp -O /bin/lemp && chmod +x /bin/lemp

yes | cp -rf /opt/vps_lemp/script/lemp/lemp.sh /bin/lemp && chmod +x /bin/lemp

#}
#download_lemp_main_menu
#checklemp_main_menu=`cat /bin/lemp`
#if [ -z "$checklemp_main_menu" ]; then
#download_lemp_main_menu
#fi



cd /etc/lemp/

# Download LEMP data
download_lemp_data () {
#rm -rf menu.zip
#wget --no-check-certificate -q https://vps.vn/script/lemp/menu.zip
#unzip -q menu.zip
#rm -rf menu.zip
mkdir -p /etc/lemp/menu ; chmod 755 /etc/lemp/menu
yes | cp -rf /opt/vps_lemp/script/lemp/menu/. /etc/lemp/menu/
}
#download_lemp_data
#if [ ! -f /etc/lemp/menu/lemp-tien-ich ]; then
#download_lemp_data
#fi

#wget --no-check-certificate -q https://lemp.com/script/lemp/errorpage_html.zip
#unzip -q errorpage_html.zip
#rm -rf errorpage_html.zip
#cp -r /etc/lemp/errorpage_html /home/lemp.demo/
mkdir -p /home/lemp.demo/errorpage_html ; chmod 755 /home/lemp.demo/errorpage_html
yes | cp -rf /opt/vps_lemp/script/lemp/errorpage_html/. /home/lemp.demo/errorpage_html/
mkdir -p /etc/lemp/errorpage_html ; chmod 755 /etc/lemp/errorpage_html
yes | cp -rf /opt/vps_lemp/script/lemp/errorpage_html/. /etc/lemp/errorpage_html/

# tao thu muc cho phpmyadmin dung lam cache
mkdir -p /home/lemp.demo/private_html/tmp ; chmod 777 /home/lemp.demo/private_html/tmp

cd
# Chmod 755 Menu
#/opt/vps_lemp/script/lemp/menu/chmod-755-menu

# Download /etc/nginx/conf
cd /etc/nginx/
#download_etc_nginx_conf () {
#rm -rf conf.zip
#wget --no-check-certificate -q https://lemp.com/script/lemp/conf.zip
#unzip -q conf.zip
#rm -rf conf.zip
mkdir -p /etc/nginx/conf ; chmod 755 /etc/nginx/conf
yes | cp -rf /opt/vps_lemp/script/lemp/conf/. /etc/nginx/conf/
#}
#download_etc_nginx_conf
#if [ ! -f /etc/nginx/conf/staticfiles.conf ]; then
#download_etc_nginx_conf
#fi
find /etc/nginx/conf -type f -exec chmod 644 {} \;
cd

###################################################
# Dat mat khau bao ve phpmyadmin, backup files
clear
echo "=========================================================================="
echo "Tao Username & Password bao ve phpMyadmin, backup files  ... "
echo "=========================================================================="
sleep 3
cp -r /etc/lemp/menu/lemp-tao-mat-khau-bao-ve-folder.py /usr/local/bin/htpasswd.py
chmod 755 /usr/local/bin/htpasswd.py
rm -rf /etc/nginx/.htpasswd
#matkhaubv=`date |md5sum |cut -c '1-16'`
matkhaubv=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 24)
usernamebv=`echo "${lempemail};" | sed 's/\([^@]*\)@\([^;.]*\)\.[^;]*;[ ]*/\1 \2\n/g' | awk 'NR==1 {print $1}'`
htpasswd.py -c -b /etc/nginx/.htpasswd $usernamebv $matkhaubv
chmod -R 644 /etc/nginx/.htpasswd
cat > "/etc/lemp/pwprotect.default" <<END
userdefault="$usernamebv"
passdefault="$matkhaubv"
END
#wget --no-check-certificate -q https://lemp.com/script/lemp/Softwear/status.zip -O /home/lemp.demo/public_html/status.php
yes | cp -rf /opt/vps_lemp/script/lemp/Softwear/status.zip /home/lemp.demo/private_html/status.php
#rm -rf /etc/lemp/defaulpassword.php
cat > "/etc/lemp/defaulpassword.php" <<END
<?php
define('ADMIN_USERNAME','$usernamebv');   // Admin Username
define('ADMIN_PASSWORD','$matkhaubv');    // Admin Password
?>
END
sed -i "s/lemp@lemp.com/${lempemail}/g" /home/lemp.demo/private_html/status.php
###################################################

# Cai dat CSF


#if [ -f /etc/sysconfig/iptables ]; then
#systemctl enable iptables 
#systemctl enable ip6tables
#systemctl start iptables
#systemctl start ip6tables
#systemctl start iptables.service

#iptables -I INPUT -p tcp --dport 80 -j ACCEPT
#iptables -I INPUT -p tcp --dport 22 -j ACCEPT
#iptables -I INPUT -p tcp --dport 21 -j ACCEPT
#iptables -I INPUT -p tcp --dport 25 -j ACCEPT
#iptables -I INPUT -p tcp --dport 443 -j ACCEPT
#iptables -I INPUT -p tcp --dport 465 -j ACCEPT
#iptables -I INPUT -p tcp --dport 587 -j ACCEPT
#iptables -I INPUT -p tcp --dport $svport -j ACCEPT
#iptables -I INPUT -p tcp --dport 11211 -j ACCEPT

#FIREWALLLIST="21 22 25 80 443 465 587 $svport 11211"
#echo $FIREWALLLIST
#for PORT in ${FIREWALLLIST}; do
#	if [ ! "$(iptables -L -n | grep :$PORT | awk 'NR==1 {print $1}')" == "ACCEPT" ]; then
#		iptables -I INPUT -p tcp --dport ${PORT} -j ACCEPT
#		iptables -I INPUT -p udp --dport ${PORT} -j ACCEPT
#	else
#		echo $PORT
#	fi
#done 

# add ca ssh port hien tai neu no khong phai port 22
#current_ssh_port=${SSH_CLIENT##* }
#echo "current_ssh_port: "$current_ssh_port
#if [ ! "$current_ssh_port" = "22" ]; then
#iptables -I INPUT -p tcp --dport $current_ssh_port -j ACCEPT
#fi

#service iptables save
#fi

# Mo cac port duoc liet ke trong FIREWALLLIST
#FIREWALLLIST="21 22 25 80 443 465 587 $svport 11211"
#echo $FIREWALLLIST
#for PORT in ${FIREWALLLIST}; do
#    if ! ufw status | grep -qw "$PORT"; then
#        ufw allow $PORT/tcp
#        ufw allow $PORT/udp
#    else
#        echo "Port $PORT da duoc mo"
#    fi
#done

FIREWALLLIST_TCP="21 22 25 80 443 465 587 $svport"

# Mo cong TCP
for PORT in ${FIREWALLLIST_TCP}; do
    if ! ufw status | grep -qw "$PORT"; then
        ufw allow $PORT/tcp
    else
        echo "Port $PORT da duoc mo tren TCP"
    fi
done


# Mo port SSH neu khong phai la port 22
current_ssh_port=${SSH_CLIENT##* }
echo "current_ssh_port: "$current_ssh_port
if [ ! "$current_ssh_port" = "22" ]; then
    ufw allow $current_ssh_port/tcp
fi

# Tai lai cau hinh ufw
sudo ufw reload



# auto update system
#/etc/lemp/menu/auto-update-system.sh "first-setup"


clear
#echo "=========================================================================="
#echo "Setup CSF Firewall ... "
#echo "=========================================================================="
sleep 3
#/etc/lemp/menu/cai-csf-firewall-cai-dat-CSF-FIREWALL.sh
#systemctl start memcached.service
#systemctl enable memcached.service 
#rm -rf /root/install*
#rm -rf /root/lemp-setup
#rm -rf rm -rf /etc/sysconfig/memcached
cat >> "/home/LEMP-manage-info.txt" <<END
=========================================================================
                           VPS MANAGE INFOMATION                         
=========================================================================

phpMyAdmin: http://$svip:$svport

Quan Ly Zend Opcache: http://$svip:$svport/ocp.php

Quan Ly Memcache: http://$svip:$svport/memcache.php

Xem Server Status: http://$svip:$svport/status.php

Thong tin dang nhap phpMyadmin, quan ly Zend Opcache, status.php, download backup files ...

Username: $usernamebv
Password: $matkhaubv 

Lenh truy cap LEMP: lemp

LUU Y: 

De VPS co hieu suat tot nhat - Hay bat: Zend Opcache, Memcached, 
va su dung cac Plugin cache(wp super cache....) cho website. 

Neu VPS dang bat Zend Opcache, khi edit file PHP, do cac file php duoc cache vao RAM  
nen ban can clear Zend Opcache de thay doi duoc cap nhat. 

Chuc ban se thanh cong cung LEMP .
END
# increase SSH login speed
if [ -f /etc/ssh/sshd_config ]; then 
sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
fi
#Change default folder ssh login
#if [ -f /root/.bash_profile ]; then
#sed -i "/.*#\ .bash_profile.*/acd /home" /root/.bash_profile
#fi


cat > "/tmp/finishedemail.sh" <<END
#!/bin/bash 
echo -e 'Subject: LEMP - Chuc mung cai dat thanh cong $svip!

Chao ban!

Chuc mung ban da hoan thanh qua trinh cai dat va cau hinh server $svip bang LEMP.
Sau day la thong tin quan ly server cua ban:

+ Lenh goi LEMP: lemp
+ Link phpMyAdmin: http://$svip:$svport
+ Quan Ly Zend Opcache: http://$svip:$svport/ocp.php
+ Quan Ly Memcached: http://$svip:$svport/memcache.php
+ Xem Server Status: http://$svip:$svport/status.php
+ Thong tin dang nhap quan ly phpMyadmin,ocp.php, memcache.php, status.php, download backup files ... : 
Username: $usernamebv  
Password: $matkhaubv 

Luu Y:

+ Sau khi cai dat xong, neu server chua tao SWAP (RAM ao), ban tao them SWAP bang chuc nang [ Quan Ly Swap ] (Bat buoc).
+ De dat mat khau bao mat phpMyAdmin, backup files, ...: dung chuc nang [ BAT/TAT Bao Ve phpMyAdmin ] trong [ Quan Ly phpMyAdmin ]
+ De cai dat File Manager: Dung chuc nang [ Cai Dat File Manager ] 
+ Sau khi them website vao server, cai dat FTP server va tao tai khoan FTP cho tung website tren server bang chuc nang [ Quan Ly FTP Server ].
  Mac dinh ban khong the dang nhap FTP vao server bang tai khoan root. Neu muon dang nhap, ban phai dung sFTP voi thong tin dang nhap:
  Host: sftp://$svip  - User: root - Password: Your_password - Port: 22 (hoac port SSH ban da thay)
+ Neu server Timezone khong trung voi gio cua ban, cai dat lai time zone cho Server bang chuc nang [ Cai Dat Server Timezone ] trong [ Tien Ich - Addons ]
+ Sau khi Upload code len server. Ban phai chay chuc nang [ Fix Loi Chmod, Chown ] trong [ Tien Ich - Addons ] de thiet lap phan quyen cho website. 
  Neu website su dung code wordpress, thiet lap phan quyen cho website bang chuc nang [ Fix loi Permission ] trong [ Wordpress Blog Tools ]
+ Tuy theo so luong website, dung luong code ma ban cau hinh lai Zend Opcache, Memcached, Redis Cache bang chuc nang [ Quan Ly Memcached ], [ Quan Ly Zend Opcache ] , [ Quan Ly Redis Cache ] cho phu hop.
+ De bao mat, moi khi co dang nhap SSH va Server, LEMP se gui email thong bao toi dia chi email $lempemail .
  Thay email hoac tat chuc nang nay bang [ BAT/TAT Email Thong Bao Login ] trong [ Tien ich - Addons ].  
  
LEMP --- https://lemp' | exim  $lempemail
END
#chmod +x /tmp/finishedemail.sh
#/tmp/finishedemail.sh
#rm -f /tmp/finishedemail.sh
clear

systemctl restart nginx
systemctl restart php8.2-fpm

. /home/lemp.conf

cat > "/tmp/config.temp" <<END
drop database sys;
END

mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp


echo "=========================================================================="
echo "LEMP da hoan tat qua trinh cai dat Server. "
echo "=========================================================================="
echo "Lenh goi LEMP: lemp"
echo "--------------------------------------------------------------------------"
echo "Link phpMyAdmin: http://$svip:$svport"
echo "--------------------------------------------------------------------------"
echo "Quan Ly Zend Opcache: http://$svip:$svport/ocp.php"
echo "--------------------------------------------------------------------------"
echo "Quan Ly Memcached: http://$svip:$svport/memcache.php"
echo "--------------------------------------------------------------------------"
echo "Xem Server Status: http://$svip:$svport/status.php"
echo "--------------------------------------------------------------------------"
echo "Thong tin username & password bao ve phpMyAdmin, ocp.php, status.php ..."
echo "--------------------------------------------------------------------------"
echo "Username: $usernamebv  | Password: $matkhaubv"
echo "--------------------------------------------------------------------------"
echo "Thay thong tin dang nhap nay: LEMP menu ==> User & Password Mac Dinh. "
echo "=========================================================================="
echo "Thong tin quan ly duoc luu tai: /home/LEMP-manage-info.txt "
echo "--------------------------------------------------------------------------"
echo "va gui kem luu y su dung LEMP toi: $lempemail"
echo "=========================================================================="
echo "Server se tu khoi dong lai sau 3 giay.... "
sleep 3
echo "=========================================================================="
echo "Tien hanh reboot lai..."
reboot
exit

