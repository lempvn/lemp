#!/bin/bash
. /home/lemp.conf
/etc/lemp/menu/vps-info/lemp-befor-vps-info.sh
UBUNTU_VERSION=$(grep VERSION /etc/os-release | cut -d'=' -f2 | tr -d '"')
clear
printf "=========================================================================\n"
printf "               LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                            Server Status \n"
printf "=========================================================================\n"
echo "IP: $serverip - Disc Free: $(calc $(df $PWD | awk '/[0-9]%/{print $(NF-2)}')/1024) MB"
echo "OS: UBUNTU "$UBUNTU_VERSION
echo "-------------------------------------------------------------------------"
if [ -f /etc/csf/csf.deny ]; then
if [ "$(cat /etc/csf/csf.deny | awk 'NR==2 {print $2}')" == "Copyright" ]; then
rm -rf /etc/csf/csf.deny
cat > "/etc/csf/csf.deny" <<END
END
fi
fi
echo "$(cat /tmp/lemp-php-info.txt)"
echo "$(cat /tmp/lemp-nginx-info.txt)"
$(nginx -v)
echo "$(cat /tmp/lemp-mysql-info.txt)"
if [ -f /home/$mainsite/private_html/index.php ]; then 
echo "-------------------------------------------------------------------------"
echo "PhpmyAdmin Link: On"
else
echo "-------------------------------------------------------------------------"
echo "PhpmyAdmin Link: Off"
fi
echo "$(cat /tmp/lemp-netdata-info.txt)"
echo "-------------------------------------------------------------------------"
#if [ -f "/etc/php.d/opcache.ini" ]; then
#ramzenduse=$(grep opcache.memory_consumption /etc/php.d/opcache.ini | grep -o '[0-9]*')
#cleartime=$(grep opcache.revalidate_freq /etc/php.d/opcache.ini | grep -o '[0-9]*')
#echo "Zend Opcache: On | Ram Usage: $ramzenduse MB | Auto Clear Time: $cleartime S"
#else
#echo "Zend Opcache: Off"
#fi
if [ -f "/tmp/lemp-memcached-info.txt" ]; then
echo "$(cat /tmp/lemp-memcached-info.txt)"
fi
if [ -f "/tmp/lemp-redis-info.txt" ]; then
echo "Redis: $(cat /tmp/lemp-redis-info.txt)"
fi
echo "-------------------------------------------------------------------------"
#CSF Stautus
echo "$(cat /tmp/lemp-csf-firewall-info.txt)"
if [ -f /root/.bash_profile ]; then
if [ "$(grep "/bin/lemp" /root/.bash_profile)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Auto Run LEMP (Khi Login SSH): TAT"
else
echo "-------------------------------------------------------------------------"
echo "Auto Run LEMP (Khi Login SSH): BAT"
fi
if [ "$(grep timeloginlempcheck /root/.bash_profile)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "eMail thong bao Login: TAT"
else
echo "-------------------------------------------------------------------------"
echo "eMail thong bao Login: BAT | eMail: $(grep "mail -s" /root/.bash_profile  | awk 'NR==1 {print $NF}')"
fi
fi

rm -rf /tmp/*lemp*
rm -rf /tmp/*vpsvn*
rm -rf /tmp/*check*
echo "$(ls /etc/nginx/conf.d | sed 's/.conf//' | sed 's/^www.//')" > /tmp/check123
sowebsitetrenserver=$(cat /tmp/check123)
websiterunning=$(cat /tmp/check123 | wc -l)
rm -rf /tmp/checksite-list
for website in $sowebsitetrenserver 
do
if [ -f /home/$website/public_html/index.php ]; then
echo "$website" >> /tmp/checksite-list
fi
if [ ! -f /home/$website/public_html/index.php ]; then
echo "$website" >> /tmp/checksiteempty
fi
done
if [ ! -f /tmp/checksite-list ]; then
websitedulieu=0
else
websitedulieu=$(cat /tmp/checksite-list | wc -l)
fi
if [ -f /tmp/checksiteempty ]; then
websitedatabaseempty=$(cat /tmp/checksiteempty | wc -l)
sowebsitedatabaseempty=$(echo "| Website No Data: $websitedatabaseempty") 
fi
rm -rf /tmp/*check*
echo "-------------------------------------------------------------------------"
echo "Total website: $websiterunning | Website Has Data: $websitedulieu $sowebsitedatabaseempty "
echo "========================================================================="
echo "Connections to:  Port 80: $(netstat -n | grep :80 |wc -l) | Port 443: $(netstat -n | grep :443 |wc -l)"
echo "========================================================================="
echo "Server Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,/ /g') - CPU Load Average: $(uptime | awk '{print $(NF-2),$(NF-1),$NF}' | sed 's/,/ /g')"
echo "RAM: $( free -m | grep Mem | awk '{print $2}') MB - Free: $( free -m | grep Mem | awk '{print $4}') MB - Cached: $( free -m | grep Mem | awk '{print $7}') MB || Free buffers: $(free -m | grep - | awk '{print $4}') MB"
echo "Swap: $(free -m | grep Swap | awk '{print $2}') MB - Swap free: $(free -m | grep Swap | awk '{print $4}') MB"
printf "=========================================================================\n"
read -p "Nhan [Enter] de quay tro lai LEMP menu ..."
clear
lemp
exit
fi

