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
countryblicklist=`grep "CC_DENY =\ " /etc/csf/csf.conf | awk 'NR==1 {print $3}' | cut -d \" -f 2`
countryblicklistchieudoc=`grep "CC_DENY =\ " /etc/csf/csf.conf | awk 'NR==1 {print $3}' | cut -d \" -f 2 | awk -F, '{for (i=1;i<=NF;i++)print $i}'`
if [ "$countryblicklist" = "" ]; then
clear
echo "========================================================================="
echo "Hien tai CSF Firewall khong block dat nuoc nao. "
echo "-------------------------------------------------------------------------"
echo "Ban khong can su dung chuc nang nay."
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
else

for manuoc in $countryblicklistchieudoc; do
echo "$(grep "|${manuoc}|" /etc/lemp/menu/CSF-Fiwall/lemp-country-code.sh | sed "s/|${manuoc}|//")" >> /tmp/lempcheckcountrycode_list_show
done

sonuoc=`cat /tmp/lempcheckcountrycode_list_show | wc -l`
if [ ! "$sonuoc" = 1 ]; then
nuoc=countries
hoithoai1=`echo "Hien tai CSF Firewall dang block $sonuoc nuoc:"`
hoithoai2=`echo "Ban muon unblock $sonuoc nuoc nay ?"`
hoithoai3=`echo "Unblock tat ca cac nuoc thanh cong !"`
else
nuoc=country
hoithoai1=`echo "Hien tai CSF Firewall dang block:"`
hoithoai2=`echo "Ban muon unblock dat nuoc nay ?"`
hoithoai3=`echo "Unblock $(cat /tmp/lempcheckcountrycode_list_show) thanh cong !"`
fi
echo "$hoithoai1"
echo "-------------------------------------------------------------------------"
cat /tmp/lempcheckcountrycode_list_show | pr -2 -t
echo "========================================================================="
  read -r -p "$hoithoai2 [y/N] " response

case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ...";sleep 1
sed -i "s/.*CC_DENY\ =.*/CC_DENY = \"\"/g" /etc/csf/csf.conf
if [ "$test_csf" == "enable" ]; then
csf -e
fi
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
clear
echo "========================================================================="
echo "$hoithoai3"
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
fi
else
echo "========================================================================= "
echo "Chuc nang nay can CSF Firewall de hoat dong."
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

