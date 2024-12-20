#!/bin/bash 
. /home/lemp.conf
if [ ! -f /usr/local/maldetect/conf.maldet ]; then
clear
echo "========================================================================= "
echo "LMD with ClamAV chua duoc cai dat tren VPS "
echo "-------------------------------------------------------------------------"
echo "Ban vui long cai dat LMD truoc khi chay chuc nang nay !"
/etc/lemp/menu/lemp-maldet-menu.sh
exit
fi
if [ -d "/home/$mainsite/private_html/maldet" ]; then
    rm -rf /home/$mainsite/private_html/maldet
    fi
	mkdir -p /home/$mainsite/private_html/maldet
	name123=`date |md5sum |cut -c '1-5'`
maldet --report list > /home/$mainsite/private_html/maldet/$name123.txt && sed -i '1d;2d;3d;4d;5d' /home/$mainsite/private_html/maldet/$name123.txt && sed -i '1s/^/---------------------------------------------------------------------------------------\n LINUX MAIWEAR DETECT (MALDET) SCAN LOG - CREATED BY lemp\n---------------------------------------------------------------------------------------\n\nTo View log Details Using command:  maldet --report  [SCAN ID]\nExample:  maldet --report 063015-2152.12615\n\n---------------------------------------------------------------------------------------\nLIST MALDET LOG:\n---------------------------------------------------------------------------------------\n/' /home/$mainsite/private_html/maldet/$name123.txt

if [ "$(grep "TIME:" /home/$mainsite/private_html/maldet/$name123.txt | awk 'NR==1 {print $1}')" == "" ]; then
clear
echo "========================================================================= "
echo "Ban chua scan VPS bang LMD !"
/etc/lemp/menu/lemp-maldet-menu.sh
else
echo "Please wait..."
sleep 3
clear
echo "========================================================================= "
echo "Link View MALDET log:"
echo "-------------------------------------------------------------------------"
echo "http://$mainsite:$priport/maldet/$name123.txt"
/etc/lemp/menu/lemp-maldet-menu.sh
fi



