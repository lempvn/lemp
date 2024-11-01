
#!/bin/bash 

. /home/lemp.conf
checktruenumber='^[0-9]+$'
if [ ! -f /etc/lemp/minfreedisc.info ]; then
echo "1000" > /etc/lemp/minfreedisc.info
fi
minfreedisc=`cat /etc/lemp/minfreedisc.info`
if ! [[ $minfreedisc =~ $checktruenumber ]] ; then
echo "1000" > /etc/lemp/minfreedisc.info
fi 
disfreehientai=$(calc $(df $PWD | awk '/[0-9]%/{print $(NF-2)}')/1024)
if ! [[ $disfreehientai =~ $checktruenumber ]] ; then
clear
echo "========================================================================="
echo "Rat tiec ! "
echo "-------------------------------------------------------------------------"
echo "LEMP khong the chay chuc nang nay tren server cua ban"
echo "-------------------------------------------------------------------------"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [ "$disfreehientai" -lt "1000" ]; then
clear
echo "========================================================================="
echo "Rat tiec ! FFREE DISC hien tai < 1000 MB"
echo "-------------------------------------------------------------------------"
echo "Ban khong the su dung chuc nang nay "
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi

echo "========================================================================="
echo "Hien tai FREE DISC server: $disfreehientai MB | FREE DISC Canh Bao: $minfreedisc MB"
echo "========================================================================="
echo "Su dung chuc nang nay de cau hinh canh bao FULL DISC tren LEMP menu"
echo "-------------------------------------------------------------------------"
echo "Khi Free Disc cua server nho hon FREE DISC Canh Bao, LEMP se thong bao" 
echo "-------------------------------------------------------------------------"
echo "tren Main Menu. Gia tri ban chon phai > 1000 va < ${disfreehientai}"
echo "========================================================================="
echo -n "Nhap FREE DISC Canh Bao [ENTER]: " 
read minfreedisca

if [ "$minfreedisca" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap gia tri FREE DISC Canh Bao!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi

if ! [[ ${minfreedisca} -ge 1000 && ${minfreedisca} -le ${disfreehientai} ]] ; then  
clear
echo "========================================================================="
echo "$minfreedisca khong dung!"
echo "-------------------------------------------------------------------------"
echo "Gia tri ban nhap phai la so tu nhien nam trong khoang (1000 - ${disfreehientai}) "
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "-------------------------------------------------------------------------"  
echo "LEMP se canh bao DISC FULL khi dung luong disc cua server < ${minfreedisca} MB"
echo "-------------------------------------------------------------------------" 
echo "Please wait ..." ; sleep 2
echo "${minfreedisca}" > /etc/lemp/minfreedisc.info 
clear
echo "========================================================================="
echo "Cau hinh canh bao FULL DISC cho server hoan tat"
echo "-------------------------------------------------------------------------" 
echo "Dung luong FREE DISC Canh Bao: ${minfreedisca} MB "
/etc/lemp/menu/tienich/lemp-tien-ich.sh
