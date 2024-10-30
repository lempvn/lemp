#!/bin/bash 
. /home/lemp.conf
if [ -f /etc/lemp/netdatasite.info ]; then
clear
echo "========================================================================="
echo "Ban da cai dat Netdata cho server !"
echo "-------------------------------------------------------------------------"
echo "Domain Netdata la: $(cat /etc/lemp/netdatasite.info)"
echo "-------------------------------------------------------------------------"
echo "Hay tro $(cat /etc/lemp/netdatasite.info) toi $serverip"
echo "-------------------------------------------------------------------------"
echo "va truy cap domain nay tren trinh duyet de su dung NetData"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi

#checkketnoi=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://lemp.com/script/lemp/Softwear/00-all-netdata-version.txt" )
checkketnoi=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://github.com/netdata/netdata/releases/latest/download/netdata-latest.tar.gz" )
if [[ "$checkketnoi" == "000" ]]; then
clear
echo "========================================================================="
echo "Can not check NetData version"
echo "-------------------------------------------------------------------------"
echo "Please try again !"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi

cd /tmp
#download_version_netdata () {
#wget --no-check-certificate -q https://lemp.com/script/lemp/Softwear/00-all-netdata-version.txt
#wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/Softwear/00-all-netdata-version.txt
#}
#download_version_netdata
#checkdownload_version_netdata=`cat /tmp/00-all-netdata-version.txt`
#if [ -z "$checkdownload_version_netdata" ]; then
#download_version_netdata
#fi

cd

#NetData_VERSION=`cat /tmp/00-all-netdata-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`

echo "========================================================================="
echo "Su dung chuc nang nay de cai dat NetData cho server"
echo "-------------------------------------------------------------------------"
echo "Domain cho NetData phai la domain moi, chua duoc add vao he thong"
echo "-------------------------------------------------------------------------"
echo "Ban nen su dung Sub-domain cho NetData."
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten Domain [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi

if [ -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Phat hien $website da ton tai tren he thong!"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi
backend=lemp-`date |md5sum |cut -c '1-12'`
echo "========================================================================="
echo "Chuan bi cai dat NetData cho $website"
echo "-------------------------------------------------------------------------"
echo "De bao mat, cac Search Engine se bi chan khi ket noi toi $website" 
echo "-------------------------------------------------------------------------"
echo "$website se khong xuat hien tren Google, bing..."
echo "-------------------------------------------------------------------------"
echo "De bao mat, ban khong the truy cap http://$serverip:19999 cho NetData."
echo "-------------------------------------------------------------------------"
echo "please wait... "; sleep 8

sudo DEBIAN_FRONTEND=noninteractive apt -yqq install libuuid1 uuid-dev zlib1g-dev autoconf automake pkg-config libelf-dev libsystemd-dev liblz4-dev libzstd-dev libuv1-dev libcap-dev

cd /usr/local/lemp
rm -rf netdata
#wget --no-check-certificate -q https://lemp.com/script/lemp/Softwear/netdata_$NetData_VERSION.zip
#wget --no-check-certificate -q https://github.com/vpsvn/vps-vps-software/raw/main/netdata_$NetData_VERSION.zip
#wget https://github.com/netdata/netdata/releases/latest/download/netdata-latest.tar.gz
#tar -xzf netdata-latest.tar.gz
#rm -rf netdata-latest.tar.gz
#cd netdata-*
#yes "" | ./netdata-installer.sh

# one click
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && sh /tmp/netdata-kickstart.sh --no-updates

cd

sed -i "s/#.*access =.*/    access log = none/g" /opt/netdata/netdata-configs/netdata.conf

sudo sed -i 's/# bind to = \*/bind to = 127.0.0.1/' /opt/netdata/netdata-configs/netdata.conf

    cat > "/etc/nginx/conf.d/$website.conf" <<END
upstream $backend {
    server 127.0.0.1:19999;
    keepalive 64;
}
 
server {
    server_name $website;
    location / {
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Server \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass http://$backend;
        proxy_http_version 1.1;
        proxy_pass_request_headers on;
        proxy_set_header Connection "keep-alive";
        proxy_store off;
    }
error_page 502  /502.html;
        location = /502.html {
                root /etc/netdata;
                internal;
        }
}

END
mkdir -p /etc/netdata/
echo "<br><br><br><br><br><br><br><b><center> Please enable NetData to view this page</center></b>" > /etc/netdata/502.html

# stop netdata
#killall netdata
# copy netdata to init.d
#cp /usr/local/lemp/netdata/system/netdata-init-d /etc/init.d/netdata && chmod +x /etc/init.d/netdata
# enable netdata at boot
#chkconfig --add netdata
#chkconfig --levels 235 netdata on
# start netdata
#service netdata start
#service netdata restart
# reload nginx
#service nginx reload
#else 
# stop netdata
#killall netdata
# copy netdata.service to systemd
#cp /usr/local/lemp/netdata/system/netdata.service /etc/systemd/system/ && chmod +x /etc/systemd/system/netdata.service
# let systemd know there is a new service
#systemctl daemon-reload
# enable netdata at boot
#systemctl enable netdata
# start netdata
#systemctl start netdata
#service netdata start
#service netdata restart
# reload nginx
#systemctl reload nginx

# stop netdata
killall netdata

# Sao chep netdata.service vao systemd
#yes | cp -rf /usr/local/lemp/netdata-*/system/netdata.service /etc/systemd/system/ && chmod +x /etc/systemd/system/netdata.service

# Cho systemd biet co dich vu moi
#sudo systemctl daemon-reload

# Bat netdata khoi dong cung he thong
sudo systemctl enable netdata

# Bat dau netdata
sudo systemctl start netdata

# Khoi dong lai netdata
sudo systemctl restart netdata

# Tai lai nginx
sudo systemctl restart nginx


echo "$website" > /etc/lemp/netdatasite.info
echo "netdata-latest (ban moi nhat)" > /etc/lemp/netdata.version
rm -rf /tmp/00-all-netdata-version.txt
clear

echo "========================================================================="
echo "Cai dat NetData netdata-latest(ban moi nhat) cho $website thanh cong"
echo "-------------------------------------------------------------------------"
echo "Hay tro $website toi $serverip"
echo "-------------------------------------------------------------------------"
echo "Va truy cap domain nay tren trinh duyet de su dung NetData"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
