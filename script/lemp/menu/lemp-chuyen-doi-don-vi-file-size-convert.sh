#!/bin/bash 

. /home/lemp.conf

if [ ! -f /bin/sizeconvert ]; then
cp -r /etc/lemp/menu/lemp-calc-for-convert-file-size-chuyen-doi-don-vi.sh /bin/sizeconvert
chmod +x /bin/sizeconvert
sed -i 's/scale=0/scale=5/g' /bin/sizeconvert
fi

checknumber="^[0-9.]+$"
prompt="Nhap lua chon cua ban: "
#prompt="Type in your choice: "
options=( "Byte" "Kilobyte (KB)" "Megabyte (MB)" "Gigabyte (GB)" "Terabyte (TB)" "Huy Bo")
echo "========================================================================="
echo "Chuc nang nay dung de chuyen doi don vi: B to KB to MB to GB to TB"
echo "-------------------------------------------------------------------------"
echo "Hoac TB to GB to MB to KB to B."
echo "========================================================================="
echo "Lua chon don vi hien tai cua ban"
echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) donvicanchuyen="Byte"; break;;
    2) donvicanchuyen="Kilobyte"; break;;
    3) donvicanchuyen="Megabyte"; break;;
    4) donvicanchuyen="Gigabyte"; break;;
    5) donvicanchuyen="Terabyte"; break;;
    6) donvicanchuyen="Cancel"; break;;
    *) echo "Ban nhao sai, vui long chon so trong danh sach";continue;;
    #*) echo "You typed wrong, Please type in the ordinal number on the list";continue;;
    esac  
done
echo "-------------------------------------------------------------------------"
if [ "$donvicanchuyen" = "Byte" ]; then
echo -n "Nhap FileSize (Not include B): " 
read nhapso
nhapso=`echo $nhapso | tr '[A-Z]' '[a-z]'`
if [ "$nhapso" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
#echo "You typed wrong, please type in accurately!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [[ ! "$nhapso" =~ $checknumber ]]; then
clear
echo "========================================================================="
echo "$nhapso khong phai la so"
#echo "$nhapso maybe not a number!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
clear
echo "========================================================================="
echo "Byte: $nhapso B"
echo "========================================================================="
echo "Ket Qua Convert:"
echo "-------------------------------------------------------------------------"
echo "Kilobyte: $(sizeconvert ${nhapso}/1024) KB"
echo "-------------------------------------------------------------------------"
echo "Megabyte: $(sizeconvert ${nhapso}/1024/1024) MB"
echo "-------------------------------------------------------------------------"
echo "Gigabyte: $(sizeconvert ${nhapso}/1024/1024/1024) GB"
echo "-------------------------------------------------------------------------"
echo "Terabyte: $(sizeconvert ${nhapso}/1024/1024/1024/1024) TB"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
elif [ "$donvicanchuyen" = "Kilobyte" ]; then

echo -n "Nhap FileSize (Not include KB): " 
read nhapso
nhapso=`echo $nhapso | tr '[A-Z]' '[a-z]'`
if [ "$nhapso" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
#echo "You typed wrong, please type in accurately!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [[ ! "$nhapso" =~ $checknumber ]]; then
clear
echo "========================================================================="
echo "$nhapso khong phai la so"
#echo "$nhapso maybe not a number!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
clear
echo "========================================================================="
echo "Kilobyte: $nhapso KB"
echo "========================================================================="
echo "Ket Qua Convert:"
echo "-------------------------------------------------------------------------"
echo "Byte: $(sizeconvert ${nhapso}*1024) B"
echo "-------------------------------------------------------------------------"
echo "Megabyte: $(sizeconvert ${nhapso}/1024) MB"
echo "-------------------------------------------------------------------------"
echo "Gigabyte: $(sizeconvert ${nhapso}/1024/1024) GB"
echo "-------------------------------------------------------------------------"
echo "Terabyte: $(sizeconvert ${nhapso}/1024/1024/1024) TB"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
elif [ "$donvicanchuyen" = "Megabyte" ]; then
echo -n "Nhap FileSize (Not include MB): " 
read nhapso
nhapso=`echo $nhapso | tr '[A-Z]' '[a-z]'`
if [ "$nhapso" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
#echo "You typed wrong, please type in accurately!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [[ ! "$nhapso" =~ $checknumber ]]; then
clear
echo "========================================================================="
echo "$nhapso khong phai la so"
#echo "$nhapso maybe not a number!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
clear
echo "========================================================================="
echo "Megabyte: $nhapso MB"
echo "========================================================================="
echo "Ket Qua Convert:"
echo "-------------------------------------------------------------------------"
echo "Byte: $(sizeconvert ${nhapso}*1024*1024) B"
echo "-------------------------------------------------------------------------"
echo "Kilobyte: $(sizeconvert ${nhapso}*1024) KB"
echo "-------------------------------------------------------------------------"
echo "Gigabyte: $(sizeconvert ${nhapso}/1024) GB"
echo "-------------------------------------------------------------------------"
echo "Terabyte: $(sizeconvert ${nhapso}/1024/1024) TB"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
elif [ "$donvicanchuyen" = "Gigabyte" ]; then
echo -n "Nhap FileSize (Not include GB): " 
read nhapso
nhapso=`echo $nhapso | tr '[A-Z]' '[a-z]'`
if [ "$nhapso" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
#echo "You typed wrong, please type in accurately!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [[ ! "$nhapso" =~ $checknumber ]]; then
clear
echo "========================================================================="
echo "$nhapso khong phai la so"
#echo "$nhapso maybe not a number!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
clear
echo "========================================================================="
echo "Gigabyte: $nhapso GB"
echo "========================================================================="
echo "Ket Qua Convert:"
echo "-------------------------------------------------------------------------"
echo "Byte: $(sizeconvert ${nhapso}*1024*1024*1024) B"
echo "-------------------------------------------------------------------------"
echo "Kilobyte: $(sizeconvert ${nhapso}*1024*1024) KB"
echo "-------------------------------------------------------------------------"
echo "Megabyte: $(sizeconvert ${nhapso}*1024) MB"
echo "-------------------------------------------------------------------------"
echo "Terabyte: $(sizeconvert ${nhapso}/1024) TB"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
elif [ "$donvicanchuyen" = "Terabyte" ]; then
echo -n "Nhap FileSize (Not include TB): " 
read nhapso
nhapso=`echo $nhapso | tr '[A-Z]' '[a-z]'`
if [ "$nhapso" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
#echo "You typed wrong, please type in accurately!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [[ ! "$nhapso" =~ $checknumber ]]; then
clear
echo "========================================================================="
echo "$nhapso khong phai la so"
#echo "$nhapso maybe not a number!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
clear
echo "========================================================================="
echo "Terabyte: $nhapso TB"
echo "========================================================================="
echo "Ket Qua Convert:"
echo "-------------------------------------------------------------------------"
echo "Byte: $(sizeconvert ${nhapso}*1024*1024*1024*1024) B"
echo "-------------------------------------------------------------------------"
echo "Kilobyte: $(sizeconvert ${nhapso}*1024*1024*1024) KB"
echo "-------------------------------------------------------------------------"
echo "Megabyte: $(sizeconvert ${nhapso}*1024*1024) MB"
echo "-------------------------------------------------------------------------"
echo "GigabyteB: $(sizeconvert ${nhapso}*1024) GB"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
else 
clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh
fi
