#!/bin/bash 
. /home/lemp.conf
if [ ! -f /etc/csf/csf.conf ]; then
/etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf.sh
else
/etc/lemp/menu/CSF-Fiwall/lemp-update-csf-firewall.sh
fi
