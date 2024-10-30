#!/bin/bash
. /home/lemp.conf
if [ -f /etc/cron.d/lemp-auto-start-mysql.cron ]; then
/etc/lemp/menu/tienich/lemp-tat-auto-start-mysql.sh
else
/etc/lemp/menu/tienich/lemp-bat-auto-start-mysql.sh
fi

