#!/bin/bash
. /home/lemp.conf
if [ -f /etc/csf/csf.conf ]; then
clear
echo "========================================================================="
echo "Phat hien CSF Firewall dang duoc cai dat tren VPS "
echo "-------------------------------------------------------------------------"
echo "LEMP se remove CSF sau do cai dat lai CSF de cap nhat port SSH moi"
sleep 8
yes | cp -rf /etc/csf/csf.conf /etc/lemp/csf.conf_bak
cd /etc/csf
sh uninstall.sh
cd
/etc/lemp/menu/cai-csf-firewall-cai-dat-CSF-FIREWALL.sh
fi
