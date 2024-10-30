#!/bin/bash

. /home/lemp.conf

if [ -f /etc/lemp/Renew.SSL.Letencrypt ] && [ -f /etc/cron.d/lemp.autorenew.ssl.cron ]; then
clear
echo "========================================================================="
echo "Chuc nang tu dong gia han chung chi SSL Let's Encrypt da duoc BAT."
echo "-------------------------------------------------------------------------"
echo "LEMP se auto renew SSL 10 ngay truoc khi SSL het han."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi
echo "========================================================================="
echo "Su dung chuc nang nay BAT chuc nang tu dong gia han chung chi SSL cho"
echo "-------------------------------------------------------------------------"
echo "tat ca website dang su dung SSL Let's Encrypt."
echo "========================================================================="
  read -r -p "Ban muon BAT chuc nang tu dong gia han SSL ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo "Please wait ..."; sleep 3

cat > "/etc/lemp/Renew.SSL.Letencrypt" <<END
#!/bin/bash
/root/.acme.sh/acme.sh --renewAll
END
chmod +x /etc/lemp/Renew.SSL.Letencrypt
echo "SHELL=/bin/bash" > /etc/cron.d/lemp.autorenew.ssl.cron
echo "0 23 * * * root /etc/lemp/Renew.SSL.Letencrypt >/dev/null 2>&1" >> /etc/cron.d/lemp.autorenew.ssl.cron
systemctl restart cron.service
clear
echo "========================================================================="
echo "Hoan thanh cai dat tu dong gia han chung chi SSL Let's Encrypt."
echo "-------------------------------------------------------------------------"
echo "LEMP se auto renew SSL 10 ngay truoc khi SSL het han."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
;;
    *)
clear 
echo "========================================================================= "
echo "Cancel !"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
        ;;
esac
