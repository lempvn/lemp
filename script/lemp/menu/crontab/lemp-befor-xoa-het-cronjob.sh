#!/bin/bash
. /home/lemp.conf

if [ ! -f /var/spool/cron/crontabs/root ]; then
/etc/lemp/menu/crontab/lemp-xoa-het-cronjob.sh
exit
fi

if [ "$(grep "auto-start-mysql" /var/spool/cron/crontabs/root | awk '{print $6}')" == "auto-start-mysql" ]; then
/etc/lemp/menu/crontab/lemp-xoa-het-cronjob-but-auto-start-mariadb.sh
exit
fi
if [ "$(grep "auto-start-mysql" /var/spool/cron/crontabs/root | awk '{print $6}')" == "" ]; then
/etc/lemp/menu/crontab/lemp-xoa-het-cronjob.sh
exit
fi
clear
echo "we can find cronjob for you"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
