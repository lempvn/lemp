#!/bin/bash
clear
printf "=========================================================================\n"
printf "            LEMP - Manage VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                         Fix Loi Session                              \n"
printf "=========================================================================\n"
printf "                          \n"
printf "Chuc nang nay se sua loi khong truy cap duoc Phpmyadmin do loi Session \n"
printf "Neu VPS/Server bi loi nay, truy cap Phpmyadmin se duoc duoc thong bao: \n"
printf "                          \n"
printf "Cannot start session without errors\n"
echo "-------------------------------------------------------------------------"
printf "Please check errors given in your PHP and/or \n"
echo "-------------------------------------------------------------------------"
printf "Webserver log file and configure your PHP installation properly.\n"
printf "                          \n"
printf "=========================================================================\n"

read -p "Nhan [Enter] de fix loi ..."
chmod 777 /var/lib/php/session/
clear
echo "========================================================================="
echo "Loi Session da duoc fix thanh cong "
echo "-------------------------------------------------------------------------"
echo "Ban co the truy cap Phpmyadmin de kiem tra."
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh
