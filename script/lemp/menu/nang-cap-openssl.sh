#!/bin/bash
. /home/lemp.conf

#
cd ~
echo "========================================================================="
echo "which openssl (/usr/bin/openssl): "$(which openssl)
echo "openssl version: "$(openssl version)
echo "========================================================================="

echo -n "Ban muon cap nhat lai OpenSSL ? [y/N] "
read selectServer
if [ "$selectServer" = "y" ]; then
echo "-------------------------------------------------------------------------"
echo "Ok ! please wait check OpenSSL new version ...."
sleep 1

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

# copy code tu file install sang
if [ "$okResetGit" = "y" ]; then
cd ~
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/menu/git-clone
chmod +x /root/git-clone
bash /root/git-clone
fi

. /opt/vps_lemp/script/lemp/nginx-setup.conf
echo "========================================================================="
echo "NEW openssl version: "${opensslversion}
echo "========================================================================="

# neu truoc do hoi nguoi dung ve viec cap nhat git, nguoi dung chon y roi thi o buoc nay dat y luon, do phai hoi lai
if [ "$okResetGit" = "y" ]; then
selectOpenSSL="y"
else
echo -n "Ban that su muon thay doi sang phien ban "${opensslversion}" ? [y/N] "
read selectOpenSSL
fi

if [ "$selectOpenSSL" = "y" ]; then
echo "Ok ! please wait update "${opensslversion}" ...."
sleep 1
cd /usr/local/lemp

#wget --no-check-certificate -q https://www.openssl.org/source/${opensslversion}.tar.gz
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/${opensslversion}.tar.gz ${opensslversion}.tar.gz
tar -xzf ${opensslversion}.tar.gz
rm -rf ${opensslversion}.tar.gz

cd ~
cd /usr/local/lemp/${opensslversion}
#exit

./config
make
sudo make install
sudo ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/
sudo ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/
sudo ln -s /usr/local/bin/openssl /usr/bin/openssl_latest
openssl_latest version
cd /usr/bin/
mv openssl openssl_old
mv openssl_latest openssl
openssl version
else
echo "Ban da huy thay doi phien ban "${opensslversion}
fi

else
echo "Ban da huy thay doi phien ban OpenSSL"
fi

#
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh

