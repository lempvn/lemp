#!/bin/bash 

. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de them park domain vao server"
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
echo "$domain co le khong phai la domain !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi 

echo "-------------------------------------------------------------------------"
echo -n "Nhap ten domain ban muon $domain park vao [ENTER]: " 
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
echo "$domain da ton tai tren he thong."
echo "-------------------------------------------------------------------------"
echo "Neu ban muon $domain chay song song voi $website"
echo "-------------------------------------------------------------------------"
echo "Hay remove $domain khoi server va thu lai  !!!"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi

if [ -f /etc/nginx/conf.d/$website.conf ]; then
echo "LEMP se them $domain vao he thong "
echo "-------------------------------------------------------------------------"
read -r -p "va cho $domain chay song song voi $website. Is it Ok  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Dang them $domain vao he thong....."
    sleep 1
    cat > "/tmp/parkdomain.sh" <<END
#!/bin/bash
    sed -i 's/server_name\ $website\;/server_name\ $website\ $domain\;/g' /etc/nginx/conf.d/$website.conf
END
chmod +x /tmp/parkdomain.sh
/tmp/parkdomain.sh
rm -f /tmp/parkdomain.sh
echo "..... Successfully !"
sleep 1
clear
echo "========================================================================="
systemctl restart nginx.service

echo "$domain da duoc them vao he thong va chay song song voi $website"
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
