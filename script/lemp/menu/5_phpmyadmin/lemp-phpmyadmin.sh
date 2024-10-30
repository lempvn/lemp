#!/bin/bash

. /home/lemp.conf

if [ -f /home/$mainsite/private_html/index.php ]; then 
echo "========================================================================="
echo "Su dung chuc nang nay de BAT / TAT Phpmyadmin. "
echo "-------------------------------------------------------------------------"
echo "Phpmyadmin hien dang BAT, ai biet port $priport deu co the truy cap"
echo "========================================================================="
read -r -p "Ban co muon TAT no khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait....";sleep 1
	mv /home/$mainsite/private_html/index.php /home/$mainsite/private_html/index.bak
for service in $(systemctl list-units --type=service --state=running | grep php | awk '{print $1}'); do
    systemctl restart $service
done
	rm -f /home/$mainsite/private_html/index.html
    cat > "/home/$mainsite/private_html/index.html" <<END
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
echo "Phpmyadmin link da duoc TAT thanh cong !"
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
    *)
clear
 echo "========================================================================="
echo "Ban lua chon NO  !"
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
esac
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de BAT / TAT Phpmyadmin. "
echo "========================================================================="
echo "Phpmyadmin link hien dang TAT !"
echo "-------------------------------------------------------------------------"
read -r -p "Ban co muon BAT no len khong ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait....";sleep 1
	mv /home/$mainsite/private_html/index.bak /home/$mainsite/private_html/index.php
	rm -f /home/$mainsite/private_html/index.html
for service in $(systemctl list-units --type=service --state=running | grep php | awk '{print $1}'); do
    systemctl restart $service
done
clear
        echo "========================================================================="
        echo "Phpmyadmin link da duoc BAT thanh cong !"
echo "-------------------------------------------------------------------------"
               echo "Truy cap phpmyadmin qua: $mainsite:$priport  hoac $serverip:$priport"
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
        ;;
    *)
               clear
 echo "========================================================================="
echo "Ban lua chon NO!"
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh

        ;;
esac
exit
fi
