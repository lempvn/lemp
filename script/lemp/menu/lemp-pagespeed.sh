#!/bin/bash 

echo -n "Nhap vao ten mien ban muon check roi an [ENTER]:" 
read domain
if [ "$domain" = "" ]; then
echo "Ban nhap sai, vui long nhap lai!"
exit
fi

if [ -f /etc/nginx/conf.d/$domain.conf ]; then
if [ -f /etc/lemppagespeed-enable/$domain ]; then
echo "$domain da duoc BAT ngx_pagespeed !"
read -r -p "Ban muon TAT ngx_pagespeed cho $domain  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "Dang TAT goole_pagespeed...."
    sleep 1
    cat > "/tmp/pagespeed.sh" <<END
#!/bin/sh
sed -i 's/include \/etc\/nginx\/ngx_pagespeed.conf;/#include \/etc\/nginx\/ngx_pagespeed.conf;/g' /etc/nginx/conf.d/$domain.conf
END
chmod +x /tmp/pagespeed.sh
/tmp/pagespeed.sh
rm -f /tmp/pagespeed.sh
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service nginx restart
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
systemctl restart nginx.service
fi
echo "..... Thanh cong !"
        ;;
    *)
        echo "Bye....!"
        ;;
esac
exit
fi

read -r -p "Ban muon BAT google_pagespeed cho $domain ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "Dang BAT google_pagespeed....."
    sleep 1
    cat > "/tmp/pagespeed.sh" <<END
#!/bin/sh
sed -i 's/#include \/etc\/nginx\/ngx_pagespeed.conf;/include \/etc\/nginx\/ngx_pagespeed.conf;/g' /etc/nginx/conf.d/$domain.conf
END

chmod +x /tmp/pagespeed.sh
/tmp/pagespeed.sh
rm -f /tmp/pagespeed.sh
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service nginx restart
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
systemctl restart nginx.service
fi
mkdir -p /etc/lemppagespeed-enable
    cat > "/etc/lemppagespeed-enable/$domain" <<END
1
END
echo "..... Thanh cong !"
        ;;
    *)
        echo "Bye....!"
        ;;
esac
exit
else
echo "Khong tim thay $domain trong he thong !!!!"
echo "Ban vui long kiem tra va lam lai."
exit
fi
