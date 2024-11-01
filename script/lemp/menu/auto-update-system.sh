#!/bin/bash
. /home/lemp.conf


#
firstSetup=$1


#
#if [ -f /etc/yum/yum-cron.conf ]; then
#echo "========================================================================="
#echo "yum-cron has been install!"
#/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
#exit
#fi

#
# chkconfig yum-updatesd off
yum -y install yum-cron

#
if [ ! -f /etc/yum/yum-cron.conf ]; then
echo "========================================================================="
echo "ERROR! yum-cron can not install..."
if [ "$firstSetup" = "" ]; then
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
fi

#
curTime=$(date +%d%H%M)
echo "curTime: "$curTime
yes | cp /etc/yum/yum-cron.conf /etc/yum/yum-cron.conf-$curTime.bak

#
grep -o '^[^#]*' /etc/yum/yum-cron.conf > /etc/yum/yum-cron.conf.test
if [ -f /etc/yum/yum-cron.conf.test ]; then
rm -rf /etc/yum/yum-cron.conf
mv /etc/yum/yum-cron.conf.test /etc/yum/yum-cron.conf
fi


# fixed config
echo "Config for: /etc/yum/yum-cron.conf"
cat > "/etc/yum/yum-cron.conf" <<END
[commands]
update_cmd = default
update_messages = yes
download_updates = yes
# apply_updates = no
apply_updates = yes
# random_sleep = 360
random_sleep = 0
[emitters]
system_name = None
# emit_via = stdio
emit_via = email
output_width = 80
[email]
email_from = root@localhost
# email_to = root
email_to = $emailmanage
email_host = localhost
[groups]
group_list = None
group_package_types = mandatory, default
[base]
#exclude = kernel* owncloud* php* httpd*
exclude = php*
debuglevel = -2
mdpolicy = group:main
END


#
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then
service yum-cron restart
chkconfig yum-cron on
else
/bin/systemctl restart yum-cron.service
systemctl enable yum-cron
fi

# xem log
echo "Update system log:"
sudo tail -50 /var/log/yum.log

#
if [ "$firstSetup" = "" ]; then
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
fi
