#!/bin/bash 

. /home/lemp.conf
checktruenumber='^[0-9]+$'
if [ ! -f /etc/lemp/minfreedisc.info ]; then
echo "1000" > /etc/lemp/minfreedisc.info
fi
minfreedisc=`cat /etc/lemp/minfreedisc.info`
if [[ ! $minfreedisc =~ $checktruenumber ]] ; then
echo "1000" > /etc/lemp/minfreedisc.info
fi 

kiemtraemail3="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~])+\.)*[-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,24}$";
if [ ! -f /root/.bash_profile ]; then
clear
echo "========================================================================="
echo "Can not find file /root/.bash_profile"
echo "-------------------------------------------------------------------------"
echo "LEMP can not run this function on this server"
echo "-------------------------------------------------------------------------"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi

prompt="Nhap lua chon cua ban: "
options=( "Bat/Tat Thong Bao Login SSH Vao Server Qua Email" "Thay Doi Email Nhan Thong Bao" "Huy Bo")
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) cauhinh="battatemail"; break;;
    2) cauhinh="thaydoiemail"; break;;
    3) cauhinh="cancel"; break;;
    0) cauhinh="cancel"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################

###################################
if [ "$cauhinh" = "battatemail" ]; then

if [ "$(grep timeloginlempcheck /root/.bash_profile)" == "" ]; then
echo "========================================================================="
echo "Su dung chuc nang nay de BAT/TAT chuc nang gui thong bao qua email"
echo "-------------------------------------------------------------------------"
echo "moi khi co dang nhap SSH vao Server."
echo "-------------------------------------------------------------------------"
echo -n "Nhap dia chi email [ENTER]: " 
read lempemail
if [ "$lempemail" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi

if [[ ! "$lempemail" =~ $kiemtraemail3 ]]; then
clear
echo "========================================================================="
echo "$lempemail co le khong dung dinh dang email!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 4
rm -rf /tmp/checkautorunlemp
if [ ! "$(grep "/bin/lemp" /root/.bash_profile)" == "" ]; then
echo "1" > /tmp/checkautorunlemp
 sed -i '/\/bin\/lemp/d' /root/.bash_profile
fi
    cat >> "/root/.bash_profile" <<END
IPlempcheck="\$(echo \$SSH_CONNECTION | cut -d " " -f 1)"
timeloginlempcheck=\$(date +"%e %b %Y, %a %r")
echo 'Someone has IP address '\$IPlempcheck' login to $serverip on '\$timeloginlempcheck'.' | mail -s 'eMail Notifications From lemp On $serverip' ${lempemail}
END
#echo 'Someone has IP address '\$IPlempcheck' login to $serverip on '\$timeloginlempcheck'.' | mail -s 'eMail Notifications From lemp On $serverip' ${lempemail}

if [ -f /tmp/checkautorunlemp ]; then
echo "/bin/lemp" >> /root/.bash_profile
rm -rf /tmp/checkautorunlemp
fi

clear
clear
echo "========================================================================="
echo "Hoan thanh cau hinh gui email thong bao khi co dang nhap SSH vao Server"
echo "-------------------------------------------------------------------------"
echo "eMail nhan thong bao: $lempemail"
echo "-------------------------------------------------------------------------"
echo "Neu khong thay email trong thu muc Inbox. Ban hay check thu muc SPAM "
/etc/lemp/menu/tienich/lemp-tien-ich.sh
fi

if [ ! "$(grep timeloginlempcheck /root/.bash_profile)" == "" ]; then
echo "========================================================================="
echo "Su dung chuc nang nay de BAT/TAT chuc nang gui thong bao qua email"
echo "-------------------------------------------------------------------------"
echo "moi khi co dang nhap SSH vao Server."
echo "-------------------------------------------------------------------------"
echo "Hien tai eMail nhan thong bao: $(grep "mail -s" /root/.bash_profile  | awk 'NR==1 {print $NF}')"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon TAT email thong bao login ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ... "
    sleep 3
sed -i '/lempcheck/d' /root/.bash_profile
clear
echo "========================================================================="
echo "TAT chuc nang gui email thong bao login thanh cong! "
 /etc/lemp/menu/tienich/lemp-tien-ich.sh
    ;;
*)
clear
echo "========================================================================="
echo "You choosed NO "
 /etc/lemp/menu/tienich/lemp-tien-ich.sh
  exit
;;
esac
fi

###################################

###################################
elif [ "$cauhinh" = "thaydoiemail" ]; then

if [ "$(grep timeloginlempcheck /root/.bash_profile)" == "" ]; then
clear
echo "========================================================================="
echo "Ban chua cau hinh gui email thong bao khi co dang nhap SSH vao server"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
emailhientai=$(grep "mail -s" /root/.bash_profile | awk 'NR==1 {print $NF}')
echo "========================================================================="
echo "Su dung chuc nang nay de thay doi email nhan thong bao login ssh"
echo "-------------------------------------------------------------------------"
echo "Hien tai eMail nhan thong bao: $emailhientai"
echo "-------------------------------------------------------------------------"
echo -n "Nhap dia chi email moi [ENTER]: " 
read lempemailmoi
if [ "$lempemailmoi" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
if [[ ! "$lempemailmoi" =~ $kiemtraemail3 ]]; then
clear
echo "========================================================================="
echo "$lempemailmoi co le khong dung dinh dang email!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon thay email nhan thong bao login ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ... "
    sleep 3
sed -i "s/${emailhientai}/${lempemailmoi}/g" /root/.bash_profile
clear
echo "========================================================================="
echo "Thay dia chi email nhan thong bao login thanh cong! "
    echo "-------------------------------------------------------------------------"
    echo "Dia chi eMail moi la: ${lempemailmoi}"
    echo "-------------------------------------------------------------------------"
echo "Neu khong thay email trong thu muc Inbox. Ban hay check thu muc SPAM "
 /etc/lemp/menu/tienich/lemp-tien-ich.sh
    ;;
*)
clear
echo "========================================================================="
echo "You choosed NO "
 /etc/lemp/menu/tienich/lemp-tien-ich.sh
  exit
;;
esac
###################################
else 
clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh
fi
