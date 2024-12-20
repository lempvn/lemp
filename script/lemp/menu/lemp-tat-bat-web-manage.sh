#!/bin/bash

. /home/lemp.conf
if [ ! -f /etc/lemp/uploadsite ]; then
clear
echo "========================================================================="
echo "Ban chua cai dat File Manager cho VPS !"
/etc/lemp/menu/20_file-manager/lemp-web-upload-menu
exit
fi
uploadsite=$(cat /etc/lemp/uploadsite)
if [ -f /home/$uploadsite/public_html/index.php ]; then 
echo "========================================================================="
echo "Hien tai File Manager dang BAT"
echo "========================================================================="
read -r -p "Ban co muon TAT no khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "Please wait....";sleep 1
	mv /home/$uploadsite/public_html/index.php /home/$uploadsite/public_html/index.bak
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service nginx restart
service php-fpm restart
else 
systemctl restart nginx.service
systemctl restart php-fpm.service
fi
	rm -f /home/$uploadsite/public_html/index.html
    cat > "/home/$uploadsite/public_html/index.html" <<END
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
echo "File Manager da duoc TAT thanh cong !"
/etc/lemp/menu/20_file-manager/lemp-web-upload-menu
        ;;
    *)
clear
 echo "========================================================================="
echo "Ban lua chon NO  !"
/etc/lemp/menu/20_file-manager/lemp-web-upload-menu
        ;;
esac
exit
fi
echo "========================================================================="
echo "Hien tai File Manager dang TAT"
echo "========================================================================="
read -r -p "Ban co muon BAT len khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "Please wait....";sleep 1
	mv /home/$uploadsite/public_html/index.bak /home/$uploadsite/public_html/index.php
	rm -f /home/$uploadsite/public_html/index.html
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service nginx restart
service php-fpm restart
else 
systemctl restart nginx.service
systemctl restart php-fpm.service
fi
clear
        echo "========================================================================="
        echo "File Manager da duoc BAT thanh cong !"
/etc/lemp/menu/20_file-manager/lemp-web-upload-menu
        ;;
    *)
               clear
 echo "========================================================================="
echo "Ban lua chon NO!"
/etc/lemp/menu/20_file-manager/lemp-web-upload-menu

        ;;
esac
exit
fi
