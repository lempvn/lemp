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
echo "========================================================================= "
echo "Scan tat ca website co the mat rat nhieu thoi gian "
echo "-------------------------------------------------------------------------"
echo "De scan nhanh hon, ban nen scan 1 website ban thay can scan."
echo "-------------------------------------------------------------------------"
read -r -p "Ban chac chan muon scan tat ca cac website ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 1
    clear 
echo "========================================================================= "
echo "Qua trinh scan se mat rat nhieu thoi gian tuy vao kich thuoc cua website"
echo "Vui long cho doi cho den khi scan hoan tat!"
echo "========================================================================= "
maldet -a /home
name123=$(cat /usr/local/maldetect/sess/session.last)
rm -rf /tmp/maldet.txt
cp /usr/local/maldetect/sess/session.$name123 /tmp/maldet-home.txt
sed -i '$d' /tmp/maldet-home.txt && sed -i '$d' /tmp/maldet-home.txt && sed -i '1d' /tmp/maldet-home.txt && sed -i '1d' /tmp/maldet-home.txt && sed -i '1d' /tmp/maldet-home.txt
clear
echo "========================================================================="
echo "Scan hoan thanh. Report for scan on: $(maldet --report list | grep SCAN | awk 'NR==1 {print $1,$2,$3}')"
echo "-------------------------------------------------------------------------"
cat /tmp/maldet-home.txt | grep '\S'
/etc/lemp/menu/lemp-maldet-menu.sh
;;
esac
clear
echo "========================================================================= "
echo "Huy bo scan tat ca cac website ! "
/etc/lemp/menu/lemp-maldet-menu.sh
