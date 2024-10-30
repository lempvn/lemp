#!/bin/bash 
. /home/lemp.conf
if [ ! -f /usr/local/maldetect/conf.maldet ]; then
/etc/lemp/menu/lemp-cai-dat-maldet-with-clamav.sh
else
/etc/lemp/menu/lemp-remove-maldet-with-clamav.sh
fi
