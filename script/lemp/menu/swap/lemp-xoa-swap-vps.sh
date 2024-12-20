#!/bin/bash
if [ -f /swapfile ]; then
echo "========================================================================="
echo "Chuc nang nay chi ho tro xoa Swap do lemp tao ra truoc do"
echo "-------------------------------------------------------------------------"
echo "Voi Swap co san tren he thong, lemp khong the can thiep duoc"
echo "========================================================================="
read -r -p "Ban muon xoa swap tren server? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
swapoff /swapfile
rm -rf /swapfile
clear
echo "========================================================================= "
echo "Ban xoa swap thanh cong.  "
echo "-------------------------------------------------------------------------"
echo "Bay gio ban co the tao swap moi! "
/etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh

;;
    *)
       clear
echo "========================================================================= "
echo "Ban huy bo xoa SWAP."
/etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh
        ;;
esac
clear
/etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh
else
clear
echo "========================================================================= "
echo "Ban chua tao swap tren VPS !"
echo "-------------------------------------------------------------------------"
echo "Hoac VPS khong ho tro ban tao them SWAP."
/etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh
exit
fi
