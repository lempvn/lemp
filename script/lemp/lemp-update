#!/bin/bash
. /home/lemp.conf

cd ~

if [ ! -d /etc/lemp/.tmp ]; then
mkdir -p /etc/lemp/.tmp
fi


#checkketnoi=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://lemp.vn/script/lemp/lemp.newversion" )
checkketnoi=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/version" )
#echo $checkketnoi
if [[ "$checkketnoi" == "000" ]]; then
clear
echo "========================================================================="
echo "Co loi xay ra trong qua trinh update"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
lemp
exit
fi

#
install_yum_cron_update(){
yum -y remove yum-updatesd
yum -y install yum-cron

current_os_version=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))
if [ "$current_os_version" == "6" ]; then
service yum-cron start
chkconfig yum-cron on
else
sudo systemctl enable yum-cron
sudo systemctl start yum-cron
systemctl restart yum-cron
fi
#cd /etc/yum
cat /var/log/cron | grep yum-daily
cat /var/log/yum.log | grep Updated
}

#
rm -rf /etc/lemp/.tmp/lemp-update-*

# update glibc
### Check GLIBC 2.17 tren centos6 - Fix loi LEMP tu phien ban 4.2.0.8 tro ve cai dat san tren server
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/lemp-update-glibc -O /etc/lemp/.tmp/lemp-update-glibc
chmod +x /etc/lemp/.tmp/lemp-update-glibc
bash /etc/lemp/.tmp/lemp-update-glibc
fi


## Bat dau thuc hien update LEMP
#wget -q https://lemp.vn/script/lemp/lemp-update-run -O /etc/lemp/.tmp/lemp-update-run && chmod +x /etc/lemp/.tmp/lemp-update-run
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/lemp-update-run -O /etc/lemp/.tmp/lemp-update-run
chmod +x /etc/lemp/.tmp/lemp-update-run
bash /etc/lemp/.tmp/lemp-update-run


