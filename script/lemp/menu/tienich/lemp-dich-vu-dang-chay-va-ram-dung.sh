#!/bin/bash
. /home/lemp.conf
randomcode=`date |md5sum |cut -c '1-12'`
echo "========================================================================="
echo "Su dung chuc nang nay de xem cac service dang chay trong he thong "
echo "-------------------------------------------------------------------------"
echo "va dung luong Ram cac dich vu nay su dung. "
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon xem danh sach nay ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ...";sleep 1
rm -rf /home/$mainsite/private_html/ServiceandRamuseage*
python3 /etc/lemp/menu/tienich/lemp-tien-trinh-dang-chay-ram-use.sh > /home/$mainsite/private_html/ServiceandRamuseage-$randomcode.txt 
sed -i '/lemp/d' /home/$mainsite/private_html/ServiceandRamuseage-$randomcode.txt
sed -i '1s/^/====================================================================================================================================\n/' /home/$mainsite/private_html/ServiceandRamuseage-$randomcode.txt
sed -i '2s/^/List Service Running And Ram Useage  -  Created by LEMP\n/' /home/$mainsite/private_html/ServiceandRamuseage-$randomcode.txt
sed -i '3s/^/====================================================================================================================================\n/' /home/$mainsite/private_html/ServiceandRamuseage-$randomcode.txt
echo "============================================================The End=================================================================" >> /home/$mainsite/private_html/ServiceandRamuseage-$randomcode.txt

clear
clear
echo "========================================================================="
echo "Link xem Service dang chay & Ram su dung:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/ServiceandRamuseage-$randomcode.txt"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
       clear
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac
