#!/bin/bash
. /home/lemp.conf

rm -rf /tmp/checktmp
echo "Check /tmp by lemp" > /tmp/checktmp
if [ ! -f /tmp/checktmp ]; then
clear
echo "========================================================================="
echo "Your Server has a problem with /tmp "
echo "-------------------------------------------------------------------------"
echo "Please fix it before use this function"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi
rm -rf /tmp/checktmp
echo "-------------------------------------------------------------------------"
echo "LEMP dang kiem tra. Please wait ..."
#checkketnoi=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://lemp.com/script/lemp/Softwear/00-all-netdata-version.txt" )
#checkketnoi=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/Softwear/00-all-netdata-version.txt" )
#if [[ "$checkketnoi" == "000" ]]; then
#clear
#echo "========================================================================="
#echo "Khong the kiem tra phien ban update NetData"
#echo "-------------------------------------------------------------------------"
#echo "Ban vui long thu lai"
#echo "Can not check NetData version"
#echo "-------------------------------------------------------------------------"
#echo "Please try again !"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi
rm -rf /tmp/00-all-netdata*
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

if [ ! -f /etc/lemp/netdata.version ]; then
clear
printf "=========================================================================\n"
echo "Khong the kiem tra phien ban update NetData"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
else
LOCALVER=`cat /etc/lemp/netdata.version`
REMOVER=`cat /tmp/00-all-netdata-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`

fi

#if [ "$LOCALVER" == "$REMOVER" ]; then
#clear
#rm -f /tmp/00-all-netdata-version.txt
#echo "========================================================================="
#echo "Ban dang su dung phien ban moi nhat NetData ma LEMP ho tro ."
#/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
#exit
#fi

printf "=========================================================================\n"
printf "Da phat hien update cho NetData\n"
printf "=========================================================================\n"
read -r -p "Ban chac chan muon update NetData ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo "Chuan bi update NetData..... "
sleep 1
killall netdata
cd /usr/local/lemp
rm -rf netdata-*
#wget --no-check-certificate -q https://lemp.com/script/lemp/Softwear/netdata_$REMOVER.zip
#wget --no-check-certificate -q https://github.com/vpsvn/vps-vps-software/raw/main/netdata_$REMOVER.zip
#unzip -o -q netdata_$REMOVER.zip
#rm -rf /usr/local/lemp/netdata_$REMOVER.zip
#cd /usr/local/lemp/netdata
#yes "" | ./netdata-installer.sh


#wget https://github.com/netdata/netdata/releases/latest/download/netdata-latest.tar.gz
#tar -xzf netdata-latest.tar.gz
#rm -rf netdata-latest.tar.gz
#cd netdata-*
#yes "" | ./netdata-installer.sh

# one click
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && sh /tmp/netdata-kickstart.sh

cd
sed -i "s/#.*access =.*/    access log = none/g" /opt/netdata/netdata-configs/netdata.conf

sudo sed -i 's/# bind to = \*/bind to = 127.0.0.1/' /opt/netdata/netdata-configs/netdata.conf

# stop netdata
#killall netdata
# copy netdata to init.d
#yes | cp -rf /usr/local/lemp/netdata/system/netdata-init-d /etc/init.d/netdata && chmod +x /etc/init.d/netdata
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
#yes | cp -rf /usr/local/lemp/netdata/system/netdata.service /etc/systemd/system/ && chmod +x /etc/systemd/system/netdata.service
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

# Dung netdata
killall netdata

# Sao chep netdata.service vao systemd
#yes | cp -rf /usr/local/lemp/netdata/system/netdata.service /etc/systemd/system/ && chmod +x /etc/systemd/system/netdata.service

# Cho systemd biet co dich vu moi
#sudo systemctl daemon-reload

# Bat netdata khoi dong cung he thong
sudo systemctl enable netdata

# Bat dau netdata
sudo systemctl start netdata

# Khoi dong lai netdata
sudo systemctl restart netdata

# Tai lai nginx
sudo systemctl reload nginx


echo "NetData latest version" > /etc/lemp/netdata.version
rm -rf /tmp/00-all-netdata-version.txt
clear
printf "=========================================================================\n"
printf "Nang cap NetData len phien ban moi nhat thanh cong\n"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
 ;;
    *)
        clear
printf "=========================================================================\n"
echo "Ban da huy bo update NetData"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
        ;;
esac
clear && /etc/lemp/menu/22_netdata/lemp-netdata-menu.sh



