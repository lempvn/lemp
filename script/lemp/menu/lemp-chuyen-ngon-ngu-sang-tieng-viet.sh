#!/bin/sh
. /home/lemp.conf
if [ "$(grep LEMP.VN /bin/lemp)" != "" ]; then
clear
echo "========================================================================= "
echo "You are using Vietnamese Version"
echo "-------------------------------------------------------------------------"
echo "( Ban dang su dung ngon ngu Tieng Viet )"
/etc/lemp/menu/lemp-thay-doi-ngon-ngu-menu.sh
exit
fi

echo "========================================================================= "
echo "Su dung chuc nang nay de thay doi ngon ngu LEMP sang tieng Viet"
echo "-------------------------------------------------------------------------"
echo "LEMP ho tro Tieng Anh & Tieng Viet"
echo "========================================================================= "
read -r -p "Ban muon thay doi ngon ngu LEMP sang Tieng Viet ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo "Please wait ... "
sleep 1
echo "-------------------------------------------------------------------------"
wget -q --no-check-certificate https://github.com/vpsvn/lemp-version-2/raw/main/script/lemp/motd -O /etc/motd
wget -q --no-check-certificate https://github.com/vpsvn/lemp-version-2/raw/main/script/lemp/lemp -O /bin/lemp && chmod +x /bin/lemp
cd /etc/lemp/
rm -rf /etc/lemp/menu.zip
wget -q --no-check-certificate https://vps.vn/script/lemp/menu.zip

#Check menu.zip files

rm -rf /tmp/menu
unzip -q -o menu.zip -d /tmp
if [ ! -f /tmp/menu/lemp-tien-ich ]; then
rm -rf /tmp/menu
clear
echo "========================================================================="
echo "There's an error in changing language process"
echo "-------------------------------------------------------------------------"
echo "Please try again !"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
## Finish check menu.zip
rm -rf /tmp/menu
unzip -q -o menu.zip
rm -rf /etc/lemp/menu.zip
cd
wget -q --no-check-certificate https://github.com/vpsvn/lemp-version-2/raw/main/script/lemp/motd -O /etc/motd
download_main_menu () {
wget -q --no-check-certificate https://github.com/vpsvn/lemp-version-2/raw/main/script/lemp/lemp -O /bin/lemp && chmod +x /bin/lemp
}
download_main_menu
checklemp_mainmenu=`cat /bin/lemp`
if [ -z "$checklemp_mainmenu" ]; then
download_main_menu
fi
find /etc/lemp/menu -type f -exec chmod 755 {} \;
clear 
echo "========================================================================= "
echo "Change Language of LEMP to Vietnamese Finished"
echo "-------------------------------------------------------------------------"
echo "( Thay doi ngon ngu LEMP sang tieng Viet thanh cong )"
/etc/lemp/menu/lemp-thay-doi-ngon-ngu-menu.sh
       ;;
    *)
        echo ""
        ;;
esac
clear
clear
echo "========================================================================="
echo "Cancel Change Language for LEMP"
echo "-------------------------------------------------------------------------"
echo "Huy bo thay doi ngon ngu cho LEMP"
/etc/lemp/menu/lemp-thay-doi-ngon-ngu-menu.sh
