#!/bin/bash

. /home/lemp.conf
echo "========================================================================="
echo "Please wait ..."; sleep 3
/root/.acme.sh/acme.sh --list | awk '{print $1}' | sed 's/Main_Domain//' > /etc/lemp/.tmp/list_domain_SSL
domainlist=$(cat /etc/lemp/.tmp/list_domain_SSL)
rm -rf /etc/lemp/.tmp/thanh_cong_SSL
curTime=$(date +%s)
for domain in $domainlist; do
if [ -f /root/.acme.sh/${domain}_ecc/$domain.conf ] && [ -f /etc/nginx/auth-acme/$domain/$domain.crt ]; then
echo "Check SSL by LEMP" > /home/$domain/public_html/lemp.check
checkurlsttSSL=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://$domain/lemp.check")
rm -rf /home/$domain/public_html/lemp.check
if [[  "$checkurlsttSSL" == "200" ]]; then
check_ssl () {
	data=`echo | openssl s_client -servername $domain -connect $domain:${2:-443} 2>/dev/null |
	openssl x509 -noout -enddate | sed -e 's#notAfter=##'`
	ssldate=`date -d "${data}" '+%s'`
	nowdate=`date '+%s'`
	diff="$((${ssldate}-${nowdate}))"
	echo $((${diff}/86400))
}
thoigianconlai=$(check_ssl $domain)
echo "$domain [$thoigianconlai]" >> /etc/lemp/.tmp/thanh_cong_SSL
else
echo "$domain" >> /etc/lemp/.tmp/that_bai_SSL
fi
fi
done;

if [ ! -f /etc/lemp/.tmp/thanh_cong_SSL ]; then
clear
echo "========================================================================="
echo "Hien tai khong co website nao cai dat SSL Let's Encrypt."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi

if [ -n /etc/lemp/.tmp/thanh_cong_SSL ]; then
clear
echo "========================================================================="
echo "Danh sach website cai dat thanh cong SSL Let's Encrypt:"
echo "-------------------------------------------------------------------------"
cat /etc/lemp/.tmp/thanh_cong_SSL | pr -2 -t
rm -rf /etc/lemp/.tmp/thanh_cong_SSL
rm -rf /etc/lemp/.tmp/that_bai_SSL
else
clear
echo "========================================================================="
echo "Hien tai khong co website nao cai dat SSL Let's Encrypt."
rm -rf /etc/lemp/.tmp/thanh_cong_SSL
rm -rf /etc/lemp/.tmp/that_bai_SSL
fi
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
