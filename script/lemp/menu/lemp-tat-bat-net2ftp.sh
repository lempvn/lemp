#!/bin/bash

. /home/lemp.conf
if [ ! -f /etc/lemp/net2ftpsite.info ]; then
clear
echo "========================================================================="
echo "Ban chua cai dat Net2FTP tren server !"
/etc/lemp/menu/21_net2ftp/lemp-net2ftp-menu
exit
fi
net2ftpsite=$(cat /etc/lemp/net2ftpsite.info)
if [ -f /home/$net2ftpsite/public_html/index.php ]; then 
echo "========================================================================="
echo "Hien tai Net2FTP dang BAT"
echo "========================================================================="
read -r -p "Ban co muon TAT no khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "Please wait....";sleep 1
	mv /home/$net2ftpsite/public_html/index.php /home/$net2ftpsite/public_html/index.bak
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service nginx reload
service php-fpm restart
else 
systemctl reload nginx
systemctl restart php-fpm.service
fi
	rm -f /home/$net2ftpsite/public_html/index.html
    cat > "/home/$net2ftpsite/public_html/index.html" <<END
<!DOCTYPE html>
<html id="lemp" lang="en-US" dir="LTR" class="Public Cute Pig" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
<meta charset="utf-8"/>
<title>Cute Pig !!!</title>
</head>
<body>
<center><img src="https://vps.vn/script/lemp/pig.jpg"></center><br><br>
<center>What do you want?</center>
</body>
</html>
END
clear
echo "========================================================================="
echo "Net2FTP da duoc TAT thanh cong !"
/etc/lemp/menu/21_net2ftp/lemp-net2ftp-menu
        ;;
    *)
clear
 echo "========================================================================="
echo "Ban lua chon NO  !"
/etc/lemp/menu/21_net2ftp/lemp-net2ftp-menu
        ;;
esac
exit
fi
echo "========================================================================="
echo "Hien tai Net2FTP dang TAT"
echo "========================================================================="
read -r -p "Ban co muon BAT len khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "Please wait....";sleep 1
	mv /home/$net2ftpsite/public_html/index.bak /home/$net2ftpsite/public_html/index.php
	rm -f /home/$net2ftpsite/public_html/index.html
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service nginx reload
service php-fpm restart
else 
systemctl reload nginx
systemctl restart php-fpm.service
fi
clear
        echo "========================================================================="
        echo "Net2FTP da duoc BAT thanh cong !"
/etc/lemp/menu/21_net2ftp/lemp-net2ftp-menu
        ;;
    *)
               clear
 echo "========================================================================="
echo "Ban lua chon NO!"
/etc/lemp/menu/21_net2ftp/lemp-net2ftp-menu

        ;;
esac
exit
fi
