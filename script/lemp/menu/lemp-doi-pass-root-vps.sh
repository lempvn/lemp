#!/bin/bash
echo "========================================================================= "
echo "Su sung chuc nang nay de thay mat khau user root cho server"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon thay mat khau cho user root? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
sleep 1
echo "-------------------------------------------------------------------------"
echo "Nhap password ban muon thay doi cho user root"
passwd root
clear
clear
echo "========================================================================= "

echo "Ban da thay mat khau cho user root thanh cong."
echo "========================================================================= "
echo "Se quay tro lai menu tien ich sau 3s"
sleep 3

/etc/lemp/menu/tienich/lemp-tien-ich.sh
;;
esac
#clear
echo "========================================================================="
echo "Ban da cancel thay doi mat khau user root!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh