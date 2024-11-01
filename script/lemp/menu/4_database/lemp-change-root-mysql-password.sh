#!/bin/bash 
. /home/lemp.conf
echo "========================================================================= "
echo "Su dung chuc nang nay de thay mat khau tai khoan user root cua MySQL"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon thay mat khau user root? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
sleep 1
echo "-------------------------------------------------------------------------"
echo -n "Nhap password moi [ENTER]: " 
read PASS1
if [ "$PASS1" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
if [ "$PASS1" = "$mariadbpass" ]; then
clear
echo "========================================================================="
echo "Password moi ban nhap giong password cu"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$PASS1" =~ $checkpass ]]; then
clear
echo "========================================================================="
echo "Doi mat khau User root cua MySQL that bai !"
echo "-------------------------------------------------------------------------"
echo "Ban chi duoc su dung so, chu cai de dat password !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi 
echo "-------------------------------------------------------------------------"
echo -n "Nhap lai password [ENTER]: " 
read PASS2
if [ "$PASS1" != "$PASS2" ]; then
clear
echo "========================================================================="
echo "Mat khau ban nhap hai lan khong giong nhau !"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi 
cat > "/tmp/changemariadbrootpass" <<END
mariadb-admin -u root -p$mariadbpass password $PASS1
END
chmod +x /tmp/changemariadbrootpass
/tmp/changemariadbrootpass 

cat > "/tmp/removelinemariadb" <<END
sed --in-place '/mariadbpass/d' /home/lemp.conf
END
chmod +x /tmp/removelinemariadb
/tmp/removelinemariadb 
 cat >> "/home/lemp.conf" <<END
mariadbpass="$PASS1"
END
rm -rf /tmp/removelinemariadb 
rm -rf /tmp/changemariadbrootpass 
echo "-------------------------------------------------------------------------"
echo "Please wait..."
sleep 1
clear
echo "========================================================================="
echo "Thay doi mat khau cho user Root cua MySQL thanh cong !"
echo "-------------------------------------------------------------------------"
echo "Mat khau moi da luu trong /home/lemp.conf"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
;;
esac
clear
echo "========================================================================="
echo "Ban da cancel thay doi mat khau user root cua MySQL !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh



