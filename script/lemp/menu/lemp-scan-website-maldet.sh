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
echo "Su dung chuc nang nay scan malware cho website"
echo "-------------------------------------------------------------------------"
nhapdulieu() {
echo -n "Nhap ten website [ENTER]: " 
read website
if [ "$website" = "" ]; then
echo "-------------------------------------------------------------------------"
echo "Ban nhap khong chinh xac, ban vui long nhap lai!"
echo "-------------------------------------------------------------------------"
nhapdulieu
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
echo "-------------------------------------------------------------------------"
echo "$website khong dung dinh dang domain!"
echo "-------------------------------------------------------------------------"
nhapdulieu
fi


if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
echo "-------------------------------------------------------------------------"
echo "Khong tim thay domain $website"
echo "-------------------------------------------------------------------------"
nhapdulieu
fi
echo "-------------------------------------------------------------------------"
echo "Tim thay $website tren server "
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon scan $website ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
    echo "-------------------------------------------------------------------------"
        echo "Please wait ..."
    sleep 1 
clear
echo "========================================================================="
echo "Qua trinh scan se mat rat nhieu thoi gian tuy vao kich thuoc cua website"
echo "Vui long cho doi cho den khi scan hoan tat!"
echo "========================================================================= "
maldet -a /home/$website
name123=$(cat /usr/local/maldetect/sess/session.last)
rm -rf /tmp/maldet.txt
cp /usr/local/maldetect/sess/session.$name123 /tmp/maldet-last.txt
sed -i '$d' /tmp/maldet-last.txt && sed -i '$d' /tmp/maldet-last.txt && sed -i '1d' /tmp/maldet-last.txt && sed -i '1d' /tmp/maldet-last.txt && sed -i '1d' /tmp/maldet-last.txt
clear
echo "========================================================================="
echo "Scan hoan thanh. Report for scan on: $(maldet --report list | grep SCAN | awk 'NR==1 {print $1,$2,$3}')"
echo "-------------------------------------------------------------------------"
cat /tmp/maldet-last.txt | grep '\S'
/etc/lemp/menu/lemp-maldet-menu.sh
        ;;
    *)
clear
echo "========================================================================="
echo "Huy bo Scan $website "
/etc/lemp/menu/lemp-maldet-menu.sh
        ;;
esac
}
nhapdulieu











