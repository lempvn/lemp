#!/bin/bash 
echo "========================================================================="
echo "Su dung chuc nang nay de TAT Nginx Pagespeed cho website"
echo "-------------------------------------------------------------------------"
nhapdulieu () {
echo -n "Nhap ten website [ENTER]: " 
read domain
if [ "$domain" = "" ]; then
echo "-------------------------------------------------------------------------"
echo "Ban nhap sai, vui long nhap lai"
echo "-------------------------------------------------------------------------"
nhapdulieu
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$domain" =~ $kiemtradomain3 ]]; then
	domain=`echo $domain | tr '[A-Z]' '[a-z]'`
echo "-------------------------------------------------------------------------"
echo "$domain khong dung dinh dang domain !"
echo "-------------------------------------------------------------------------"
nhapdulieu
fi
if [ ! -f /etc/nginx/conf.d/$domain.conf ]; then
if [ ! -f /etc/nginx/conf.d/www.$domain.conf ]; then
echo "-------------------------------------------------------------------------"
echo "Khong phat hien $domain tren he thong  "
echo "-------------------------------------------------------------------------"
nhapdulieu
fi
fi
if [ -f /etc/nginx/conf.d/www.$domain.conf ]; then
if [ "$(grep "include /etc/nginx/ngx_pagespeed.conf;" /etc/nginx/conf.d/www.$domain.conf)" == "#include /etc/nginx/ngx_pagespeed.conf;" ]; then
clear
echo "========================================================================="
echo "$domain da TAT disable Nginx Pagespeed tu truoc"
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
exit
fi
fi
if [ -f /etc/nginx/conf.d/$domain.conf ]; then
if [ "$(grep "include /etc/nginx/ngx_pagespeed.conf;" /etc/nginx/conf.d/$domain.conf)" == "#include /etc/nginx/ngx_pagespeed.conf;" ]; then
clear
echo "========================================================================="
echo "$domain da tat TAT Nginx Pagespeed tu truoc!"
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
exit
fi
fi
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon TAT Nginx Pagespeed cho $domain  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait...."; sleep 1
    cat > "/tmp/pagespeed.sh" <<END
#!/bin/sh
if [ -f /etc/nginx/conf.d/$domain.conf ]; then
sed -i 's/include \/etc\/nginx\/ngx_pagespeed.conf;/#include \/etc\/nginx\/ngx_pagespeed.conf;/g' /etc/nginx/conf.d/$domain.conf
else
sed -i 's/include \/etc\/nginx\/ngx_pagespeed.conf;/#include \/etc\/nginx\/ngx_pagespeed.conf;/g' /etc/nginx/conf.d/www.$domain.conf
fi
END
chmod +x /tmp/pagespeed.sh
/tmp/pagespeed.sh
rm -f /tmp/pagespeed.sh
clear
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service nginx restart
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
systemctl restart nginx.service
fi
clear
echo "========================================================================= "
echo "TAT Nginx Pagespeed cho $domain thanh cong!"
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
        ;;
    *)
        clear
echo "========================================================================= "
echo "Huy TAT Nginx Pagespeed cho $domain"
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
        ;;
esac
}
nhapdulieu
