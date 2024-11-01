#!/bin/sh
. /home/lemp.conf

echo "========================================================================="
echo "Su dung chuc nang nay de xem thong tin chi tiet ve server. Cac thong tin"
echo "-------------------------------------------------------------------------"
echo "ban co the xem: Dia chi dat server, Disc, RAM, CPU, cong nghe ao hoa.... "
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon xem thong tin server ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ...";sleep 1

randomcode=`date |md5sum |cut -c '1-14'`
rm -rf /home/$mainsite/private_html/servervpsinfo*
curl -ss ipinfo.io > /etc/lemp/ipvpsinfo.txt
sed -i 's/,//g' /etc/lemp/ipvpsinfo.txt
sed -i 's/"//g' /etc/lemp/ipvpsinfo.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "KIEM TRA THONG TIN SERVER BOI LEMP" > /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "THONG TIN DIA CHI IP SERVER" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "IP Server: $serverip" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Host name: $(cat /etc/lemp/ipvpsinfo.txt | awk 'NR==3 {print $2,$3,$4,$5,$6}')" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "City: $(cat /etc/lemp/ipvpsinfo.txt | awk 'NR==4 {print $2,$3,$4,$5,$6}')" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Region: $(cat /etc/lemp/ipvpsinfo.txt | awk 'NR==5 {print $2,$3,$4,$5,$6}')" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Country: $(cat /etc/lemp/ipvpsinfo.txt | awk 'NR==6 {print $2,$3,$4,$5,$6}')" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Latitude/Longitude: $(cat /etc/lemp/ipvpsinfo.txt | awk 'NR==7 {print $2,$3,$4,$5,$6}')" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Network: $(cat /etc/lemp/ipvpsinfo.txt | awk 'NR==8 {print $2,$3,$4,$5,$6}')" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt

###################
echo "" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "THONG TIN CO BAN" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
tencpu=$(cat /proc/cpuinfo|grep name|head -1|awk '{ $1=$2=$3=""; print }')
soloi=$(cat /proc/cpuinfo|grep MHz|wc -l)
tocdo=$(cat /proc/cpuinfo|grep MHz|head -1|awk '{ print $4 }')
ramsize=$(free -m | awk 'NR==2'|awk '{ print $2 }')
swap=$(free -m | awk 'NR==4'| awk '{ print $2 }')
tocdohdd=$( (dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync &&rm -f test_$$) 2>&1 | tail -1| awk '{ print $(NF-1) $NF }')
echo "Cong nghe ao hoa : $(virt-what)" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "CPU model : $tencpu"  >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "So loi CPU : $soloi"  >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Toc do CPU : $tocdo MHz"  >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Dung luong RAM : $ramsize MB"  >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Dung luong Swap : $swap MB"  >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "Toc do I/O : $tocdohdd"  >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
##########################
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "THONG TIN DISC" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
df -h >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
#######################
echo "" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "THONG TIN CHI TIET CPU" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=========================================================================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
cat /proc/cpuinfo >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
echo "=================================== The End =============================================" >> /home/$mainsite/private_html/servervpsinfo-$randomcode.txt
rm -rf /etc/lemp/ipvpsinfo.txt


clear
echo "========================================================================="
echo "Link Xem Thong Tin Server:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/servervpsinfo-$randomcode.txt"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
       clear
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac




