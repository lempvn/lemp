#!/bin/bash 
. /home/lemp.conf
if [ -f /etc/php.d/opcache.ini ]; then
clear
echo "========================================================================="
echo "               LEMP - Manage VPS/Server by LEMP.VN      "       
echo "========================================================================="
echo "                        Cau hinh Zend OPcache"
echo "========================================================================="
echo ""
echo ""
cleartime=$(grep opcache.revalidate_freq /etc/php.d/opcache.ini | grep -o '[0-9]*')
echo "Truy cap http://$serverip:$priport/ocp.php xem luong RAM ma Opcache can."
echo "========================================================================="
echo "RAM cho Opcache phai la so tu nhien nam trong khoang (20 - $(calc $( free -m | awk 'NR==2 {print $2}' )/5))."
echo "-------------------------------------------------------------------------"
echo -n "Nhap luong RAM ban config cho Opcache dung [ENTER]: " 
read opcacheram

if [ "$opcacheram" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, hay nhap chinh xac."
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi

if ! [[ $opcacheram -ge 20 && $opcacheram -le $(calc $( free -m | awk 'NR==2 {print $2}' )/5)  ]] ; then  
clear
echo "========================================================================="
echo "$opcacheram khong dung!"
echo "-------------------------------------------------------------------------"
echo "RAM cho Opcache phai la so tu nhien nam trong khoang (20 - $(calc $( free -m | awk 'NR==2 {print $2}' )/5))."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi  
echo "-------------------------------------------------------------------------"
echo "LEMP dang dem so luong file php tren VPS"
sleep 1
echo "========================================================================="
echo "So File PHP hien tai trong folder HOME cua VPS: $(find /home -type f | grep php | wc -l) files"
echo "MAX FILES la so file PHP lon nhat ma Zend Opcache co the cache"
echo "MAX FILES phai la so tu nhien nam trong khoang (2000 - 50000)."
echo "-------------------------------------------------------------------------"
echo -n "Nhap MAX FILES [ENTER]: " 
read filephp
if [ "$filephp" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, hay nhap chinh xac."
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi

if ! [[ $filephp -ge 2000 && $filephp -le 50000  ]] ; then 
clear
echo "========================================================================="
echo "$filephp khong dung!"
echo "-------------------------------------------------------------------------"
echo "MAX FILES phai la so tu nhien nam trong khoang (2000 - 50000)."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi  
echo "========================================================================="
echo "Thoi gian auto clear PHP cache hien tai la: $cleartime giay"
echo "Thoi gian tu dong clear php cache cang lon thi hieu suat VPS cang tot"
echo "Gia tri nay phai nam trong khoang (30 - 999999)."
echo "-------------------------------------------------------------------------"
echo -n "Nhap thoi gian tu dong Clear PHP Cache [ENTER]: " 
read timeclear
if [ "$timeclear" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi

if ! [[ $timeclear -ge 30 && $timeclear -le 999999  ]] ; then 
clear
echo "========================================================================="
echo "$timeclear khong chinh xac !"
echo "-------------------------------------------------------------------------"
echo "Thoi gian tu dong clear Zend Opcache phai nam trong khoang (30 - 9999999)."
echo "-------------------------------------------------------------------------"
echo "Ban vui long nhap lai !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi  



echo "Please wait....";sleep 2
sed --in-place '/opcache.memory_consumption/d' /etc/php.d/opcache.ini
sed --in-place '/opcache.max_accelerated_files/d' /etc/php.d/opcache.ini
sed --in-place '/opcache.revalidate_freq/d' /etc/php.d/opcache.ini
###
echo "opcache.memory_consumption=$opcacheram" >> /etc/php.d/opcache.ini
echo "opcache.max_accelerated_files=$filephp" >> /etc/php.d/opcache.ini
echo "opcache.revalidate_freq=$timeclear" >> /etc/php.d/opcache.ini

if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
else 
systemctl restart php-fpm.service
fi
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/sbin/service php-fpm status | awk 'NR==1 {print $3}')
if [ "$test_php" == "stopped" ]; then
clear
echo "========================================================================="
echo "Ban config sai ! Vui long config lai ."
echo "-------------------------------------------------------------------------"
echo "Website dang bi loi 502  !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/bin/systemctl status  php-fpm.service | awk 'NR==3 {print $2}')
if [ "$test_php" == "inacctive" ]; then
clear
echo "========================================================================="
echo "Ban config sai ! Vui long config lai ."
echo "-------------------------------------------------------------------------"
echo "Website dang bi loi 502  !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/bin/systemctl status  php-fpm.service | awk 'NR==3 {print $2}')
if [ "$test_php" == "failed" ]; then
clear
echo "========================================================================="
echo "Ban config sai ! Vui long config lai ."
echo "-------------------------------------------------------------------------"
echo "Website dang bi loi 502  !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
fi
clear
echo "========================================================================="
echo "Config Zend Opcache su dung $opcacheram MB RAM thanh cong."
echo "-------------------------------------------------------------------------"
echo "Max PHP file Zend Opcache co the cache = $filephp"
echo "-------------------------------------------------------------------------"
echo "PHP cached se duoc tu dong clear moi $timeclear giay"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
fi
clear
echo "========================================================================= "
echo "Zend OPcache dang disable tren VPS"
echo "-------------------------------------------------------------------------"
echo "Hay bat Zend Opcache len de VPS co hieu suat tot nhat!"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
