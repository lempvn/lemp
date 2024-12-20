#!/bin/bash
. /home/lemp.conf
if [ ! -f /etc/php.d/opcache.ini ]; then
clear
echo "========================================================================="
echo "Zend Opcache dang tat"
echo "-------------------------------------------------------------------------"
echo "Ban phai bat Zend Opcache moi duoc su dung chuc nang nay"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
fi
if [  "$(grep home /etc/lemp/opcache.blacklist)" == "" ]; then
clear
echo "========================================================================="
echo "Hien tai Zend Opcache Blacklist chua co website nao"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
cat /etc/lemp/opcache.blacklist > /tmp/view-blacklist
cat > "/tmp/viewzendcacheblacklist" <<END	
sed -i 's/\/home\///g' /tmp/view-blacklist
sed -i 's/\///g' /tmp/view-blacklist
END
chmod +x /tmp/viewzendcacheblacklist
/tmp/viewzendcacheblacklist
rm -rf /tmp/viewzendcacheblacklist
echo "-------------------------------------------------------------------------"
echo "Please wait ..." 
sleep 1
clear
echo "========================================================================="
echo "Danh sach website trong Zend Opcache BlackList: "
echo "-------------------------------------------------------------------------"
cat /tmp/view-blacklist | pr -2 -t
rm -rf /tmp/view-blacklist
/etc/lemp/menu/opcache/lemp-before-opcache.sh
