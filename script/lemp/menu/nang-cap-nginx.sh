#!/bin/bash
. /home/lemp.conf

# them lenh kiem tra neu co git roi thi thoi khong tai lai nua
okResetGit="y"
if [ -d /opt/vps_lemp ]; then
echo "========================================================================="
echo "========================================================================="
echo "========================================================================="
echo -n "Ban co muon cap nhat lai git code moi khong? [y/N] "
read resetGit
if [ "$resetGit" = "y" ]; then
okResetGit="y"
echo "Ok ok! Chuan bi cap nhat lai code tu github..."
sleep 3
else
okResetGit="n"
fi
fi

if [ "$okResetGit" = "y" ]; then
# copy code tu file install sang
cd ~
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/menu/git-clone
chmod +x /root/git-clone
bash /root/git-clone
fi

#
cd ~
cd /tmp
rm -rf 00-all-nginx-version.txt
yes | cp -rf /opt/vps_lemp/script/lemp/00-all-nginx-version.txt 00-all-nginx-version.txt

nginx -V

. /opt/vps_lemp/script/lemp/nginx-setup.conf
echo "========================================================================="
echo "NEW nginx version: "${Nginx_VERSION}
echo "========================================================================="

# neu truoc do hoi nguoi dung ve viec cap nhat git, nguoi dung chon y roi thi o buoc nay dat y luon, do phai hoi lai
if [ "$okResetGit" = "y" ]; then
selectNginxVersion="y"
else
echo -n "Ban that su muon thay doi sang phien ban "${Nginx_VERSION}" ? [y/N] "
read selectNginxVersion
fi

if [ "$selectNginxVersion" = "y" ]; then
echo "Ok ! please wait install nginx-"${Nginx_VERSION}" ...."
sleep 1
else
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi

/opt/vps_lemp/script/lemp/menu/nginx-setup-ubuntu


cd ~

check_spdy_http2 () {
if [ ! "$(grep spdy /etc/nginx/conf.d/*.conf)" == "" ]; then 
sed -i 's/spdy/http2/g' /etc/nginx/conf.d/*.conf
fi
}
check_spdy_http2

systemctl restart nginx.service


#rm -rf /opt/vps_lemp/*
#rm -rf /opt/vps_lemp
sleep 1

clear
echo "========================================================================="
nginx -V
echo "Cai dat Nginx phien ban $Nginx_VERSION thanh cong !"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh

