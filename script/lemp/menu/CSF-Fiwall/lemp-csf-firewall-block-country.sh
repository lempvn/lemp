#!/bin/bash 
. /home/lemp.conf
rm -rf /tmp/lempcheckcountrycode*
echo "========================================================================="
if [ -f /etc/csf/csf.conf ]; then
test_csf=$(csf -v | awk 'NR==1 {print $NF}')
if [ "$test_csf" == "enable" ]; then
echo "Chuc nang nay se bat CSF Firewall neu ban dang tat no."
echo "-------------------------------------------------------------------------" 
fi
echo "Su dung chuc nang nay de block mot dat nuoc truy cap website tren server."
echo "-------------------------------------------------------------------------" 
echo "Ban can nhap ma nuoc gom 2 chu cai. Ban co the nhap nhieu dat nuoc bang"
echo "-------------------------------------------------------------------------" 
echo "cach su dung dau [,] va khong co [space] giua cac ma nuoc. VD: “CN,RU,DE” "
echo "-------------------------------------------------------------------------" 
echo "de block China, Russia va Germany."
echo "-------------------------------------------------------------------------" 
echo "Xem danh sach ma nuoc tai: https://datahub.io/core/country-list/r/0.html"
echo "========================================================================="
echo -n "Nhap ma nuoc [ENTER]: " 
read countrycode
countrycode=`echo $countrycode | tr '[a-z]' '[A-Z]'`
countrycode=`echo $countrycode | sed 's/\///' | sed 's/\///' | sed 's/\///'`
echo "$countrycode" > /tmp/lempcheckcountrycode
sed -i 's/,$//' /tmp/lempcheckcountrycode
sed -i 's/,$//' /tmp/lempcheckcountrycode
sed -i 's/,$//' /tmp/lempcheckcountrycode
sed -i 's/,$//' /tmp/lempcheckcountrycode
sed -i 's/,$//' /tmp/lempcheckcountrycode
sed -i 's/,$//' /tmp/lempcheckcountrycode
sed -i 's/,$//' /tmp/lempcheckcountrycode
cat /tmp/lempcheckcountrycode | awk -F, '{for (i=1;i<=NF;i++)print $i}' > /tmp/lempcheckcountrycode_list
if [ ! "$(grep ";" /tmp/lempcheckcountrycode)" = "" ]; then
clear
echo "========================================================================= "
echo "Ban khong the su dung phim [ ; ]"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
if [ "$countrycode" = "" ]; then
clear
echo "========================================================================="
echo "You typed wrong, please fill accurately"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi

if [ ! "$(grep "\ " /tmp/lempcheckcountrycode)" = "" ]; then
clear
echo "========================================================================= "
echo "Ban khong the su dung phim [ space ]."
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
if [ ! "$(grep "\." /tmp/lempcheckcountrycode)" = "" ]; then
clear
echo "========================================================================= "
echo "Ban khong the su dung phim [ . ]"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
rm -rf /tmp/lempcheckcountrycode_list_show
rm -rf /tmp/lempcheckcountrycode_code_trung_nhau
rm -rf /tmp/lempcheckcountrycode_code_trung_nhau2
country_list=`cat /tmp/lempcheckcountrycode_list`

for manuoc in $country_list; do
 
 if [ ! ${#manuoc}  == "2" ]; then 
clear
echo "========================================================================= "
echo "Ma nuoc $manuoc khong ton tai."
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi

if [ "$(grep "|${manuoc}|" /etc/lemp/menu/CSF-Fiwall/lemp-country-code.sh)" = "" ]; then
clear
echo "========================================================================= "
echo "Ma nuoc $manuoc khong ton tai."
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
else
echo "$(grep "|${manuoc}|" /etc/lemp/menu/CSF-Fiwall/lemp-country-code.sh | sed "s/|${manuoc}|//")" >> /tmp/lempcheckcountrycode_list_show
fi

echo "${manuoc}" >> /tmp/lempcheckcountrycode_code_trung_nhau
grep "${manuoc}" /tmp/lempcheckcountrycode_code_trung_nhau > /tmp/lempcheckcountrycode_code_trung_nhau2
codetrungnhau=`cat /tmp/lempcheckcountrycode_code_trung_nhau2`
if [ ! ${#codetrungnhau} = "2" ]; then 
clear
echo "========================================================================= "
echo "Ma nuoc $manuoc xuat hien nhieu hon 1 lan trong danh sach ban nhap."
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi

done
sonuoc=`cat /tmp/lempcheckcountrycode_list_show | wc -l`
if [ ! "$sonuoc" = 1 ]; then
nuoc=countries
hoithoai1=`echo "Danh sach cac nuoc ban muon block boi CSF Firewall:"`
hoithoai2=`echo "Ban muon block $sonuoc nuoc trong danh sach ?"`
else
nuoc=country
hoithoai1=`echo "Nuoc ban muon block boi CSF Firewall:"`
hoithoai2=`echo "Ban muon block dat nuoc nay ?"`
fi
echo "========================================================================="
echo "$hoithoai1"
echo "-------------------------------------------------------------------------"
cat /tmp/lempcheckcountrycode_list_show | pr -2 -t
echo "========================================================================="
  read -r -p "$hoithoai2 [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ...";sleep 1
sed -i "s/.*CC_DENY\ =.*/CC_DENY = \"$(cat /tmp/lempcheckcountrycode)\"/g" /etc/csf/csf.conf
if [ "$test_csf" == "enable" ]; then
csf -e
fi
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
clear
echo "========================================================================="
echo "Cau hinh CSF Firewall block $sonuoc $nuoc hoan thanh."
echo "-------------------------------------------------------------------------"
echo "$nuoc List:"
echo "-------------------------------------------------------------------------"
cat /tmp/lempcheckcountrycode_list_show | pr -2 -t
rm -rf /tmp/lempcheckcountrycode*
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
;;
    *)
clear 
echo "========================================================================= "
echo "Cancel !"
rm -rf /tmp/lempcheckcountrycode*
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        ;;
esac
else
echo "========================================================================= "
echo "Chuc nang nay can CSF Firewall de hoat dong"
echo "-------------------------------------------------------------------------"
echo "CSF Firewall chua duoc cai dat tren server! "
echo "-------------------------------------------------------------------------"
read -r -p "Ban co muon cai dat CSF Firewall vao server [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf.sh
;;
esac
clear
echo "========================================================================= "
echo "Ban huy bo cai dat CSF Firewall ! "
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi




