#!/bin/sh
. /home/lemp.conf
ramzenduse=$(grep opcache.memory_consumption /etc/php.d/opcache.ini | grep -o '[0-9]*')
maxphpzen=$(grep opcache.max_accelerated_files /etc/php.d/opcache.ini | grep -o '[0-9]*')
cleartime=$(grep opcache.revalidate_freq /etc/php.d/opcache.ini | grep -o '[0-9]*')

opcache_include=$(grep zend_extension= /etc/php.d/opcache.ini)
#echo $opcache_include
if [ "$opcache_include" = "" ]; then
#echo "null"

# tao gian cach de phong file bi trim
echo "" >> /etc/php.d/opcache.*

# them file .so vao
if [ -f /usr/lib64/php/modules/opcache.so ]; then
echo "zend_extension=/usr/lib64/php/modules/opcache.so" >> /etc/php.d/opcache.*
else

duongdanopcache=$(find / -name 'opcache.so' | grep php/modules/opcache.so)
if [ ! "$duongdanopcache" = "" ]; then
echo "zend_extension=$duongdanopcache" >> /etc/php.d/opcache.*
fi

fi

fi

prompt="Nhap lua chon cua ban (0-Thoat):"
options=("Tat Opcache" "Cau Hinh Zend Opcache" "Them Website Vao BlackList" "Xoa Website Khoi Blacklist" "Clear Zend OPcache")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                      Quan Ly Zend OPcache (Enable)\n"
printf "=========================================================================\n"
echo "  RAM Usage: $ramzenduse MB - Max Files: $maxphpzen - Auto Clear Time: $cleartime seconds" 
printf "=========================================================================\n"
printf "Zend Opcache Manage: http://$serverip:$priport/ocp.php\n"
printf "=========================================================================\n"
cat /etc/lemp/opcache.blacklist > /tmp/check_zendblacklist
sed -i '/wp-content/d' /tmp/check_zendblacklist
if [ ! "$(grep home /tmp/check_zendblacklist)" == "" ]; then
echo "=========================================================================" > /home/$mainsite/private_html/OP-Blacklist.txt
echo "Zend Opcache Black List - Created by LEMP " >> /home/$mainsite/private_html/OP-Blacklist.txt
echo "=========================================================================" >> /home/$mainsite/private_html/OP-Blacklist.txt
echo "" >> /home/$mainsite/private_html/OP-Blacklist.txt
cat /etc/lemp/opcache.blacklist >> /home/$mainsite/private_html/OP-Blacklist.txt
cat > "/tmp/viewzendcacheblacklist" <<END	
sed -i 's/\/home\///g' /home/$mainsite/private_html/OP-Blacklist.txt
sed -i 's/\///g' /home/$mainsite/private_html/OP-Blacklist.txt
END
chmod +x /tmp/viewzendcacheblacklist
/tmp/viewzendcacheblacklist
rm -rf /tmp/viewzendcacheblacklist
sed -i '/wp-content/d' /home/$mainsite/private_html/OP-Blacklist.txt
else
echo "=========================================================================" > /home/$mainsite/private_html/OP-Blacklist.txt
echo "Zend Opcache Black List - Created by LEMP " >> /home/$mainsite/private_html/OP-Blacklist.txt
echo "=========================================================================" >> /home/$mainsite/private_html/OP-Blacklist.txt
echo "" >> /home/$mainsite/private_html/OP-Blacklist.txt
echo "Hien tai khong co website nao trong Zend Opcache Blacklist" >> /home/$mainsite/private_html/OP-Blacklist.txt
fi
printf "Blacklist: `cat /tmp/check_zendblacklist | wc -l` | Link View: http://$serverip:$priport/OP-Blacklist.txt\n"
printf "=========================================================================\n"
rm -rf /tmp/check_zendblacklist
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
	1 ) /etc/lemp/menu/opcache/lemp-tat-opcache.sh;;
	2 ) /etc/lemp/menu/opcache/lemp-opcache-change-size.sh;;
	3) /etc/lemp/menu/opcache/lemp-them-website-vao-blacklist.sh;;
	4) /etc/lemp/menu/opcache/lemp-xoa-website-khoi-blacklist.sh;;
	5) /etc/lemp/menu/opcache/lemp-clear-opcache.sh;;
	#$(( ${#options[@]}+1 )) ) echo "";  clear && /bin/lemp;;
	0) echo "";  clear && /bin/lemp;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;

    esac
done
