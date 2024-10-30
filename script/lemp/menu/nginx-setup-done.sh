#!/bin/bash

# Download init & config file for nginx
#rm -f /etc/init.d/nginx
#download_initd_nginx () {
#wget --no-check-certificate -q https://lemp.echbay.com/script/lemp/nginx -O /etc/init.d/nginx && chmod +x /etc/init.d/nginx
#yes | cp -rf /opt/vps_lemp/script/lemp/nginx /etc/init.d/nginx && chmod +x /etc/init.d/nginx
#}
#download_initd_nginx
#checkdownload_initd_nginx=`cat /etc/init.d/nginx`
#if [ -z "$checkdownload_initd_nginx" ]; then
#download_initd_nginx
#fi

cat > "/lib/systemd/system/nginx.service" << END
# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target

END

systemctl daemon-reload
systemctl enable nginx.service
systemctl restart nginx.service


chmod +x /usr/sbin/nginx
#rm -rf /etc/nginx/nginx.conf
mv /tmp/nginx.conf /etc/nginx/nginx.conf

echo "=========================================================================="
echo "Cai Dat Hoan Tat Nginx "
echo "=========================================================================="
#exit
nginx -V

# End Download init & config file for nginx
