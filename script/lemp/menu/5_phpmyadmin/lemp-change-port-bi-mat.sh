#!/bin/bash
. /home/lemp.conf
port=$(grep -w "listen ${portbimat}" /etc/nginx/conf.d/lemp.demo.conf | sed 's/[^0-9]*//g')

echo "========================================================================= "
echo "Su dung chuc nang nay de thay doi port bi mat (Phpmyadmin port)"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon thay doi port bi mat ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo -n "Nhap port bi mat hien tai cua ban [ENTER]: " 
read portbimat

if [[ ! ${portbimat} =~ ^[0-9]+$ ]] ;then 
clear
echo "========================================================================="
echo "Port ban nhap: ${portbimat} khong phai la so tu nhien."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
exit
fi


if [ $port != $portbimat ]; then
clear
echo "========================================================================= "
echo "Port bi mat ban nhap khong chinh xac"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo -n "Nhap port bi mat moi ban muon thay cho port $portbimat [ENTER]:" 
read portbimatmoi

if [[ ! ${portbimatmoi} =~ ^[0-9]+$ ]] ;then 
clear
echo "========================================================================="
echo "Port ban nhap: ${portbimatmoi} khong phai la so tu nhien."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
exit
fi

if [ "$portbimat" = "$portbimatmoi" ]; then
clear
echo "========================================================================="
echo "Port moi ban muon thay trung voi port bi mat cu !"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai"
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
exit
fi 


cat > "/tmp/changeport-run" <<END
sed -i 's/listen   $portbimat;/listen   $portbimatmoi;/g' /etc/nginx/conf.d/$mainsite.conf
sed -i 's/priport="$portbimat"/priport="$portbimatmoi"/g' /home/lemp.conf
END

chmod +x /tmp/changeport-run
/tmp/changeport-run

rm -rf /tmp/changeport-run

echo "-------------------------------------------------------------------------"
echo "Please wait....";sleep 1

sudo ufw deny $portbimat/tcp

sudo ufw allow $portbimatmoi/tcp


systemctl restart nginx.service

 
clear
echo "========================================================================="
echo "Thay doi port bi mat cho VPS thanh cong !"
echo "-------------------------------------------------------------------------"
echo "Tu bay gio port bi mat da duoc thay bang: $portbimatmoi "
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
;;
esac
clear
echo "========================================================================="
echo "Ban da cancle thay doi port bi mat !"
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh

