#!/bin/bash
. /home/lemp.conf
clear
echo "========================================================================="
echo "Ban khong the tai files boi mot trong cac nguyen nhan sau:"
echo "-------------------------------------------------------------------------"
echo "I. Ban dong port $priport trong [Quan ly PhpMyadmin]"
echo "-------------------------------------------------------------------------"
echo "Fix bang cach [Quan ly PhpMyadmin] va chon [Open Phpmyadmin Port]"
echo "-------------------------------------------------------------------------"
echo "II. CSF BLOCK IP cua ban truy cap port $priport"
echo "-------------------------------------------------------------------------"
echo "Fix bang cach:"
echo "-------------------------------------------------------------------------"
echo "Su dung chuc nang [Unblock all IP] trong [CSF Firewall Manage]"
echo "-------------------------------------------------------------------------"
echo "Hoac them IP cua ban vao Csf.allow bang chuc nang [Add IP to CSF.Allow]"
echo "========================================================================="
read -p "Nhan [Enter] de thoat ..."
clear
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
