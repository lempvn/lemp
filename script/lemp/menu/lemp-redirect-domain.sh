#!/bin/bash 

. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de them redirect domain vao server"
echo "-------------------------------------------------------------------------"
echo -n "Nhap domain moi [ENTER]: " 
read domain
domain=`echo $domain | tr '[A-Z]' '[a-z]'`
if [ "$domain" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$domain" =~ $kiemtradomain3 ]]; then
	domain=`echo $domain | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$domain co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi 


echo "-------------------------------------------------------------------------"
echo -n "Nhap ten domain ban muon $domain redirect toi [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi 


if [ -f /etc/nginx/conf.d/$domain.conf ]; then
clear
echo "========================================================================="
echo "Phat hien $domain da ton tai tren he thong"
echo "-------------------------------------------------------------------------"
echo "Neu ban muon $domain redirect sang $website"
echo "-------------------------------------------------------------------------"
echo "Hay remove $domain khoi he thong va thu lai !!!"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi

if [ -f /etc/nginx/conf.d/$website.conf ]; then
echo "-------------------------------------------------------------------------"
echo "LEMP se them $domain vao server"
echo "-------------------------------------------------------------------------"
read -r -p "Va redirect $domain toi $website. Is it Ok  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "Please wait....";sleep 1
        cat >> "/etc/nginx/conf.d/$website.conf" <<END
server {
	    server_name www.$domain $domain;
	    rewrite ^(.*) http://$website\$1 permanent;
    	}
END
	
echo "..... Thanh cong !"
clear
echo "========================================================================="
systemctl restart nginx.service
echo "$domain da duoc them vao he thong va redirect toi $website."
/etc/lemp/menu/lemp-them-website-menu.sh
     ;;
    *)
clear
        echo "========================================================================="
echo "Cancel !"
/etc/lemp/menu/lemp-them-website-menu.sh
        ;;
esac
else
clear
echo "========================================================================="
echo "Khong tim thay $website tren he thong!!!!!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long kiem tra va lam lai."
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi
