#!/bin/bash

. /home/lemp.conf
echo "========================================================================="
echo "Dung chuc nang nay de xem danh sach 5 file va folder dung luong lon nhat"
echo "-------------------------------------------------------------------------"
nhapduieu () {
echo -n "Nhap ten website [ENTER]: " 
read website
if [ "$website" = "" ]; then
echo "-------------------------------------------------------------------------"
echo "Ban chua nhap ten website"
echo "-------------------------------------------------------------------------"
nhapduieu
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
echo "-------------------------------------------------------------------------"
echo "Khong tim thay $website "
echo "-------------------------------------------------------------------------"
nhapduieu
fi   
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 2
rm -rf /tmp/*list*
clear  
cd /home/$website/public_html
find . -type f -print0 | xargs -0 du | sort -n | tail -5 | cut -f2 | xargs -I{} du -sh {} > /tmp/listfile
find . -type d -print0 | xargs -0 du | sort -n | tail -5 | cut -f2 | xargs -I{} du -sh {} > /tmp/listfolder
cd
echo "========================================================================="
echo "5 File Lon Nhat Trong /home/$website/public_html:"
echo "-------------------------------------------------------------------------"
cat /tmp/listfile
echo "-------------------------------------------------------------------------"
echo "5 Folder Lon Nhat Trong /home/$website/public_html:"
echo "-------------------------------------------------------------------------"
cat /tmp/listfolder
rm -rf /tmp/*list*
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
}
nhapduieu
