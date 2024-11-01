#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de xem tat ca IPtables Firewall Rules cua server"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon xem cac Rules nay ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ...";sleep 1
rm -rf /home/$mainsite/private_html/IPtablesRules*
randomcode=`date |md5sum |cut -c '1-16'`
echo "============================================================================" > /home/$mainsite/private_html/IPtablesRules-$randomcode.txt
echo "IPtables Firewall Rules in Server: $serverip - Created by lemp " >> /home/$mainsite/private_html/IPtablesRules-$randomcode.txt
echo "============================================================================" >>/home/$mainsite/private_html/IPtablesRules-$randomcode.txt
echo "" >> /home/$mainsite/private_html/IPtablesRules-$randomcode.txt
iptables-save >> /home/$mainsite/private_html/IPtablesRules-$randomcode.txt

clear
echo "========================================================================= "
echo "Link View IPtables Firewall Rules:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/IPtablesRules-$randomcode.txt"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
    *)
       clear
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
esac


