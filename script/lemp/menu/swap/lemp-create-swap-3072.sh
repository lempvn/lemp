#!/bin/bash
if [ -f /swapfile ]; then
clear
test_swap=$(free -m | grep Swap | awk '{print $2}')
echo "========================================================================= "
echo "Ban da tao Swap! Dung luong Swap: $test_swap MB"
echo "-------------------------------------------------------------------------"
echo "Ban phai xoa Swap cu truoc khi tao swap moi"
/etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de tao SWAP (RAM ao) cho Server. Recommend: "
echo "-------------------------------------------------------------------------"
echo "Dung luong SWAP = RAM neu server co RAM < 2 GB "
echo "-------------------------------------------------------------------------"
echo "Dung luong SWAP = 2 GB neu server co RAM > 2 GB "
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon tao swap dung luong 3 GB ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
check_swap=$(free -m | grep Swap | awk '{print $2}')
dd if=/dev/zero of=/swapfile bs=1024 count=3072k 
mkswap /swapfile  
swapon /swapfile
chown root:root /swapfile 
chmod 0600 /swapfile 
test_swap=$(free -m | grep Swap | awk '{print $2}')
if [ "$check_swap" == "$test_swap" ]; then
swapoff /swapfile
rm -rf /swapfile
clear 
echo "========================================================================= "
echo "Tao swap that bai"
echo "-------------------------------------------------------------------------"
echo "Server cua ban khong ho tro tao swap moi"
/etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh
else
  if [ "$(grep "/swapfile    none    swap    sw    0    0" /etc/fstab | awk '{print $1}')" == "" ]; then
echo "/swapfile    none    swap    sw    0    0" >> /etc/fstab  
  fi 
clear 
echo "========================================================================= "
echo "Tao swap thanh cong: 3 GB"
/etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh
exit
fi
        ;;
    *)
       clear
/etc/lemp/menu/swap/lemp-them-xoa-swap-vps-menu.sh
        ;;
esac


