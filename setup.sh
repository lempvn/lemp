#!/bin/sh
if [ $(id -u) != "0" ]; then
    echo "Co loi: Ban phai dang nhap bang user root!"
    exit
fi

if [ -f /var/cpanel/cpanel.config ]; then
echo "Server cua ban da cai san WHM/Cpanel, neu ban muon dung LEMP"
echo "Hay cai moi lai he dieu hanh cua ban"
echo "Chao tam biet !"
exit
fi

if [ -f /etc/psa/.psa.shadow ]; then
echo "Server cua ban da cai san Plesk, neu ban muon dung LEMP"
echo "Hay cai moi lai he dieu hanh cua ban"
echo "Chao tam biet !"
exit
fi

if [ -f /etc/init.d/directadmin ]; then
echo "Server cua ban da cai san DirectAdmin, neu ban muon dung LEMP"
echo "Hay cai moi lai he dieu hanh cua ban"
echo "Chao tam biet !"
exit
fi

if [ -f /etc/init.d/webmin ]; then
echo "Server cua ban da cai san webmin, neu ban muon dung LEMP"
echo "Hay cai moi lai he dieu hanh cua ban"
echo "Chao tam biet !"
exit
fi

if [ -f /home/lemp.conf ]; then
clear
echo "========================================================================="
echo "========================================================================="
echo "Server/VPS cua ban da cai san LEMP"
echo "Hay su dung lenh LEMP de truy cap LEMP menu"
echo "Chao tam biet !"
echo "========================================================================="
echo "========================================================================="
rm -rf install*
exit
fi

arch=`uname -m`
if [ ! "$arch" = "x86_64" ]; then
clear
echo "========================================================================="
echo "========================================================================="
echo "Hien tai! LEMP chi ho tro phien ban x64 bit"
echo "Vui long cai dat phien ban he dieu hanh x86_64 roi thu lai"
echo "Chao tam biet !"
echo "========================================================================="
echo "========================================================================="
rm -rf install*
exit
fi

cp /opt/vps_lemp/script/lemp/calc.sh /usr/local/bin/calc && chmod +x /usr/local/bin/calc
clear  
#rm -rf /root/lemp*

#prompt="Nhap lua chon cua ban: "
#options=("Tieng Viet" "Tieng Anh" "Huy Bo")
echo "========================================================================="
echo "LEMP Ho Tro cac phien ban Ubuntu 18 & Ubuntu 20 & Ubuntu 22"
#echo "LEMP Ho Tro Centos 6 & Centos 7 & Centos 8 x64"
echo "-------------------------------------------------------------------------"
echo "Ban nen su dung Ubuntu 22 de co hieu suat tot nhat."
echo "-------------------------------------------------------------------------"
#echo "LEMP ho tro 2 ngon ngu: Tieng Anh va Tieng Viet. "
#echo "-------------------------------------------------------------------------"
#echo "Trong qua trinh su dung, ban co the thay doi ngon ngu ngon ngu bang chuc "
#echo "-------------------------------------------------------------------------"
#echo "nang [ Change LEMP Language ] trong [ Update System ]."
#echo "========================================================================="
#echo "                   Chon Ngon Ngu Cho LEMP"
echo "========================================================================="

#PS3="$prompt"
#select opt in "${options[@]}"; do 
#case "$REPLY" in
#1) yourlanguage="vietnamese"; break;;
#2) yourlanguage="english"; break;;
#3) yourlanguage="Cancel"; break;;
#*) echo "Ban nhap sai, vui long nhap theo so thu tu trong danh sach";continue;;
#esac  
#done
yourlanguage="vietnamese"

current_os_version=$(lsb_release -sr)

#echo $current_os_version

cd ~

#if [ "$yourlanguage" = "english" ]; then
#echo "----------------------------------------------------------------------------"
#echo "Please wait ..."
#sleep 2
#wget -q --no-check-certificate https://lemp.com/script/lemp/centos${current_os_version}/lemp-setup && chmod +x lemp-setup && clear && ./lemp-setup
#wget -q --no-check-certificate https://lemp.echbay.com/script/lemp/centos${current_os_version}/lemp-setup && chmod +x lemp-setup && clear && ./lemp-setup

#cd /opt/vps_lemp/script/lemp/centos7 ; chmod +x lemp-setup ; clear ; bash lemp-setup
#yes | cp -rf /opt/vps_lemp/script/lemp/centos7/lemp-setup ~/lemp-setup ; chmod +x lemp-setup ; clear ; bash lemp-setup

#elif [ "$yourlanguage" = "vietnamese" ]; then
#echo "----------------------------------------------------------------------------"
#echo "Please wait ..."
#sleep 2
#wget -q --no-check-certificate https://lemp.echbay.com/script/lemp/centos${current_os_version}/lemp-setup && chmod +x lemp-setup && clear && ./lemp-setup
#if [ "$current_os_version" == "6" ]; then
#cd /opt/vps_lemp/script/lemp/centos6 ; chmod +x lemp-setup ; clear ; bash lemp-setup
#yes | cp -rf /opt/vps_lemp/script/lemp/centos6/lemp-setup ~/lemp-setup ; chmod +x lemp-setup ; clear ; bash lemp-setup
#elif [ "$current_os_version" == "7" ]; then
#cd /opt/vps_lemp/script/lemp/centos7 ; chmod +x lemp-setup ; clear ; bash lemp-setup
yes | cp -rf /opt/vps_lemp/script/lemp/ubuntu/lemp-setup.sh ~/lemp-setup ; chmod +x lemp-setup ; clear ; bash lemp-setup
#else
#cd /opt/vps_lemp/script/lemp/centos8 ; chmod +x lemp-setup ; clear ; bash lemp-setup
#yes | cp -rf /opt/vps_lemp/script/lemp/centos8/lemp-setup ~/lemp-setup ; chmod +x lemp-setup ; clear ; bash lemp-setup
#fi
#else 
#rm -rf /root/install* && rm -rf /root/lemp* && clear
#fi



