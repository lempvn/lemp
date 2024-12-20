#!/bin/bash 
. /home/lemp.conf
if [ ! -f /usr/local/maldetect/conf.maldet ]; then
clear
echo "========================================================================= "
echo "LMD with ClamAV chua duoc cai dat tren server "
echo "-------------------------------------------------------------------------"
echo "Ban vui long cai dat LMD truoc khi chay chuc nang nay !"
/etc/lemp/menu/lemp-maldet-menu.sh
exit
fi
maldet --report list > /tmp/maldet.txt
if [ ! -f /usr/local/maldetect/sess/session.last ]; then
clear
echo "========================================================================= "
echo "Ban chua scan server bang LMD !"
/etc/lemp/menu/lemp-maldet-menu.sh
else
#name123=$(maldet --report list | awk 'END {print $NF}')
name123=$(cat /usr/local/maldetect/sess/session.last)
rm -rf /tmp/maldet.txt
echo "-------------------------------------------------------------------------"
echo "Please wait..."
sleep 1
rm -rf /tmp/maldet123.txt
cp /usr/local/maldetect/sess/session.$name123 /tmp/maldet123.txt
name123=$(cat /usr/local/maldetect/sess/session.last)
rm -rf /tmp/maldet.txt
cp /usr/local/maldetect/sess/session.$name123 /tmp/maldet123.txt
sed -i '$d' /tmp/maldet123.txt && sed -i '$d' /tmp/maldet123.txt && sed -i '1d' /tmp/maldet123.txt && sed -i '1d' /tmp/maldet123.txt && sed -i '1d' /tmp/maldet123.txt
clear
echo "========================================================================="
echo "Report for last scan on: $(maldet --report list | grep SCAN | awk 'NR==1 {print $1,$2,$3}')"
echo "-------------------------------------------------------------------------"
cat /tmp/maldet123.txt | grep '\S'
/etc/lemp/menu/lemp-maldet-menu.sh
exit
fi

