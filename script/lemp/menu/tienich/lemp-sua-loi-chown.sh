#!/bin/bash
clear

printf "=========================================================================\n"
printf "            LEMP - Manage VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                       Fix Loi chmod & chown                               \n"
printf "=========================================================================\n"
printf "Ban phai dung chuc nang nay de chmod website sau khi upload code len VPS!\n"
printf "                          \n"
printf "Chuc nang nay chua loi Can't Write do chmod, chown sai \n"
printf "Sua loi khong the cai dat, nang cap plugins,themes do loi Chmod \n"
printf "FIX loi hoi mat khau FTP khi cai update plugins, themes tat ca cac code\n"
printf "Tat ca cac folder public_html se duoc chmod 755 sau khi fix loi \n"
printf "=========================================================================\n"

read -p "Nhan [Enter] de fix loi ..."
chown -R www-data:www-data /home
clear
echo "========================================================================="
echo "Loi Chmod & Chown da duoc fix thanh cong "
echo "-------------------------------------------------------------------------"
echo "Ban co the truy cap website de kiem tra."
/etc/lemp/menu/tienich/lemp-tien-ich.sh

