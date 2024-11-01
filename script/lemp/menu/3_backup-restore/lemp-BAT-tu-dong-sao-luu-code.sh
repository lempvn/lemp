#!/bin/bash
. /home/lemp.conf
re='^[0-9]+$'
website=$(cat /tmp/websiteautobackup)
randomcode=`date |md5sum |cut -c '1-12'` 

chonthoigianluubackupfile () {
prompt="Nhap lua chon cua ban: "
options=( "3 Ngay" "7 Ngay" "10 Ngay" "15 Ngay" "20 Ngay" "25 Ngay" "30 Ngay")
echo "========================================================================="
echo "Lua Chon Server Se Luu Tru File Backup Trong Thoi Gian Bao Lau"
echo "-------------------------------------------------------------------------"
echo "LEMP Se Tu Dong Xoa File Backup Cua WebSite Khi Dat Toi Gioi Han Nay" 
echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) songay="3ngay"; break;;
    2) songay="7ngay"; break;;
    3) songay="10ngay"; break;;
    4) songay="15ngay"; break;;
    5) songay="20ngay"; break;;
    6) songay="25ngay"; break;;
    7) songay="30ngay"; break;;     
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
if [ "$songay" = "3ngay" ]; then
songayxoa=3
elif [ "$songay" = "7ngay" ]; then
songayxoa=7
elif [ "$songay" = "10ngay" ]; then
songayxoa=10
elif [ "$songay" = "15ngay" ]; then
songayxoa=15
elif [ "$songay" = "20ngay" ]; then
songayxoa=20
elif [ "$songay" = "25ngay" ]; then
songayxoa=25
else
songayxoa=30
fi
}
chonthoigianluubackupfilehangtuan () {
prompt="Nhap lua chon cua ban: "
options=( "7 Ngay" "14 Ngay" "21 Ngay" "28 Ngay" "35 Ngay" "42 Ngay" "49 Ngay")
echo "========================================================================="
echo "Lua Chon Server Se Luu Tru File Backup Trong Thoi Gian Bao Lau"
echo "-------------------------------------------------------------------------"
echo "LEMP Se Tu Dong Xoa File Backup Cua WebSite Khi Dat Toi Gioi Han Nay"
echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) songay="7ngay"; break;;
    2) songay="14ngay"; break;;
    3) songay="21ngay"; break;;
    4) songay="28ngay"; break;;
    5) songay="35ngay"; break;;
    6) songay="42ngay"; break;;
    7) songay="49ngay"; break;;     
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
if [ "$songay" = "7ngay" ]; then
songayxoa=7
elif [ "$songay" = "14ngay" ]; then
songayxoa=14
elif [ "$songay" = "21ngay" ]; then
songayxoa=21
elif [ "$songay" = "28ngay" ]; then
songayxoa=28
elif [ "$songay" = "35ngay" ]; then
songayxoa=35
elif [ "$songay" = "42ngay" ]; then
songayxoa=42
else
songayxoa=49
fi
}
chongio()
{
echo -n "Ban muon LEMP tu dong backup $website vao may gio ?[0-23]: " 
read gio
if [ "$gio" = "" ]; then
echo "========================================================================="
echo "Ban chua nhap thoi gian backup"
echo "-------------------------------------------------------------------------"
echo "Thoi gian backup phai la so tu nhien nam trong khoang (0 - 23)."
echo "-------------------------------------------------------------------------"
chongio
fi
if ! [[ $gio =~ $re ]] ; then
echo "========================================================================="
echo "$gio khong dung!"
echo "-------------------------------------------------------------------------"
echo "Thoi gian backup phai la so tu nhien nam trong khoang (0 - 23)."
echo "-------------------------------------------------------------------------"
chongio
fi
if ! [[ $gio -ge 0 && $gio -le 23  ]] ; then 
echo "========================================================================="
echo "$gio khong dung!"
echo "-------------------------------------------------------------------------"
echo "Thoi gian backup phai la so tu nhien nam trong khoang (0 - 23)."
echo "-------------------------------------------------------------------------"
chongio
fi 
}
chonthu()
{
echo "-------------------------------------------------------------------------"
echo -n "Ban muon LEMP tu dong backup $website vao thu may ?[2-8]: " 
read thu
if [ "$thu" = "" ]; then
echo "========================================================================="
echo "Ban chua nhap ngay !"
echo "-------------------------------------------------------------------------"
echo "Ngay backup phai la so tu nhien nam trong khoang (2 - 8)."
chonthu
fi
if [ "$thu" = "8" ]; then
thu12="chu nhat"
day=0
fi
if [ "$thu" = "2" ]; then
thu12="thu 2"
day=1
fi
if [ "$thu" = "3" ]; then
thu12="thu 3"
day=2
fi
if [ "$thu" = "4" ]; then
thu12="thu 4"
day=3
fi
if [ "$thu" = "5" ]; then
thu12="thu 5"
day=4
fi
if [ "$thu" = "6" ]; then
thu12="thu 6"
day=5
fi
if [ "$thu" = "7" ]; then
thu12="thu 7"
day=6
fi
if ! [[ $thu =~ $re ]] ; then
echo "========================================================================="
echo "$thu khong dung!"
echo "-------------------------------------------------------------------------"
echo "Ngay backup phai la so tu nhien nam trong khoang (2 - 8)."
chonthu
fi
if ! [[ $thu -ge 2 && $thu -le 8  ]] ; then 
echo "========================================================================="
echo "$thu khong dung!"
echo "-------------------------------------------------------------------------"
echo "Ngay backup phai la so tu nhien nam trong khoang (2 - 8)."
chonthu
fi 
}

websiteTO=`echo $website | tr '[a-z]' '[A-Z]'`
echo "-------------------------------------------------------------------------"
echo "$websiteTO hien khong duoc bat che do tu dong backup"



prompt="Nhap lua chon cua ban: "
options=( "Backup 1 Tuan 1 Lan" "Backup 1 Ngay 1 Lan" "Huy Bo")
printf "=========================================================================\n"
printf "LUA CHON CACH THUC SAO LUU  \n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) cachsaoluu="hangtuan"; break;;
    2) cachsaoluu="hangngay"; break;;
    3) cachsaoluu="cancle"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done

###################################
#Sao luu hang tuan
###################################
if [ "$cachsaoluu" = "hangtuan" ]; then
echo "========================================================================="
chongio
echo "-------------------------------------------------------------------------"
echo "2: Thu 2, 3: Thu 3, 4: Thu 4, 5: Thu 5, 6: Thu 6, 7: Thu 7, 8: Chu nhat"
chonthu
chonthoigianluubackupfilehangtuan
echo "-------------------------------------------------------------------------"
echo "Thoi Gian Luu Tru Toi Da Cua 1 File Backup Tren Server La $songayxoa Ngay"
echo "-------------------------------------------------------------------------"
read -r -p "Cho phep LEMP backup $website vao $gio gio $thu12 hang tuan ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 2
    cat > "/bin/lemp-backupcode-$website" <<END
#!/bin/sh
. /home/lemp.conf
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
if [ ! -d /home/$mainsite/private_html/backup/$website ]; then
mkdir -p /home/$mainsite/private_html/backup/$website
fi
find /home/$mainsite/private_html/backup/$website/ -mtime +$songayxoa -exec rm {} \;
cd /home/$mainsite/private_html/backup/$website
for file in *.zip; do
time=\$(date -r /home/$mainsite/private_html/backup/$website/\$file +%H%M-%d%m%y)
    mv "\$file" "\`basename \$file .zip\`.zip.\$time"
done
cd
cd /home/$website/public_html/
zip -r -q $website.zip *
mv $website.zip /home/$mainsite/private_html/backup/$website/$website-$randomcode.zip
cd
END
chmod +x /bin/lemp-backupcode-$website
if [ ! -f /etc/cron.d/lemp.code.cron ]; then
echo "SHELL=/bin/bash" > /etc/cron.d/lemp.code.cron
echo "0 $gio * * $day root /bin/lemp-backupcode-$website >/dev/null 2>&1" >> /etc/cron.d/lemp.code.cron
else
  if [ "$(grep "SHELL=/bin/bash" /etc/cron.d/lemp.code.cron)" == "" ]; then
echo "SHELL=/bin/bash" > /etc/cron.d/lemp.code.cron 
  fi
echo "0 $gio * * $day root /bin/lemp-backupcode-$website >/dev/null 2>&1" >> /etc/cron.d/lemp.code.cron
fi
systemctl restart cron.service
#clear
echo "========================================================================="
echo "Thuc hien yeu cau auto backup $website thanh cong."
echo "-------------------------------------------------------------------------"
echo "Website se duoc auto backup vao: $gio gio $thu12 hang tuan."
echo "-------------------------------------------------------------------------"
echo "Link file backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$website/$website-$randomcode.zip"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
;;
*)
#clear
echo "========================================================================="
echo "Ban da huy bo yeu cau tu dong backup $website !"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
;;
esac
###################################
#Sao luu hang ngay
###################################
elif [ "$cachsaoluu" = "hangngay" ]; then
echo "========================================================================="
chongio
chonthoigianluubackupfile
echo "-------------------------------------------------------------------------"
echo "Thoi Gian Luu Tru Toi Da Cua 1 File Backup Tren Server La $songayxoa Ngay"
echo "-------------------------------------------------------------------------"
read -r -p "Cho phep lemp backup $website vao $gio gio hang ngay ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 2
    cat > "/bin/lemp-backupcode-$website" <<END
#!/bin/sh
. /home/lemp.conf
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
if [ ! -d /home/$mainsite/private_html/backup/$website ]; then
mkdir -p /home/$mainsite/private_html/backup/$website
fi
find /home/$mainsite/private_html/backup/$website/ -mtime +$songayxoa -exec rm {} \;
cd /home/$mainsite/private_html/backup/$website
for file in *.zip; do
time=\$(date -r /home/$mainsite/private_html/backup/$website/\$file +%H%M-%d%m%y)
    mv "\$file" "\`basename \$file .zip\`.zip.\$time"
done
cd
cd /home/$website/public_html/
zip -r -q $website.zip *
mv $website.zip /home/$mainsite/private_html/backup/$website/$website-$randomcode.zip
cd
END
chmod +x /bin/lemp-backupcode-$website
  if [ ! -f /etc/cron.d/lemp.code.cron ]; then
echo "SHELL=/bin/bash" > /etc/cron.d/lemp.code.cron
echo "0 $gio * * * root /bin/lemp-backupcode-$website >/dev/null 2>&1" >> /etc/cron.d/lemp.code.cron
else
  if [ "$(grep "SHELL=/bin/bash" /etc/cron.d/lemp.code.cron)" == "" ]; then
echo "SHELL=/bin/bash" > /etc/cron.d/lemp.code.cron 
  fi
echo "0 $gio * * * root /bin/lemp-backupcode-$website >/dev/null 2>&1" >> /etc/cron.d/lemp.code.cron
fi
systemctl restart cron.service
#clear
echo "========================================================================="
echo "Thuc hien yeu cau auto backup $website thanh cong."
echo "-------------------------------------------------------------------------"
echo "Website se duoc auto backup vao: $gio gio hang ngay."
echo "-------------------------------------------------------------------------"
echo "Link file backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$website/$website-$randomcode.zip"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
;;
*)
#clear
echo "========================================================================="
echo "Ban da huy bo yeu cau tu dong backup $website !"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
;;
esac
#Huy Bo
###################################
else 
#clear 
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
