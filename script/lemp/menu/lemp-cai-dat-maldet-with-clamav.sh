#!/bin/bash 
. /home/lemp.conf
printf "=========================================================================\n"
printf "Chuc nang nay se cai dat LMD va ClamAV cho VPS\n"
echo "-------------------------------------------------------------------------"
read -r -p "Ban chac chan muon cai dat LMD with ClamAV? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
#echo "Nhap email ban muon nhan thong bao tu Maldet"
#echo "-------------------------------------------------------------------------"
#echo -n "eMail cua ban [ENTER]:" 
#read uremail
#if [ "$uremail" = "" ]; then
#clear
#echo "========================================================================="
#echo "Ban nhap sai, vui long nhap chinh xac !"
#/etc/lemp/menu/lemp-maldet-menu.sh
#exit
#fi
#clear
#echo "========================================================================="
#echo "Linux Malware Detect (LMD) se gui email thong bao toi $uremail"
echo "Cai dat Linux Malware Detect...."
sleep 3
cd /root
mkdir -p maldet
cd /root/maldet
wget http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar xfz maldetect-current.tar.gz
rm maldetect-current.tar.gz
cd maldetect-*
./install.sh
cd
rm -rf /root/maldet
rm -rf /root/maldetect-current.tar.gz
#wget -q http://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/maldet -O /etc/cron.daily/maldet && chmod +x /etc/cron.daily/maldet

#sed -i 's/email_alert=0/email_alert=1/g' /usr/local/maldetect/conf.maldet
sed -i 's/quar_hits=0/quar_hits=1/g' /usr/local/maldetect/conf.maldet


#cat > "/tmp/maldet-email" <<END
#sed -i 's/email_addr="you@domain.com"/email_addr="$uremail"/g' /usr/local/maldetect/conf.maldet
#END
#chmod +x /tmp/maldet-email
#/tmp/maldet-email
#rm -rf /tmp/maldet-email

#if [ ! -f /etc/yum.repos.d/dag.repo ]; then
#cat > "/etc/yum.repos.d/dag.repo" <<END
#[dag]
#name=Dag RPM Repository for Red Hat Enterprise Linux
#baseurl=http://apt.sw.be/redhat/el$releasever/en/$basearch/dag/
#gpgcheck=1
#gpgkey=http://dag.wieers.com/packages/RPM-GPG-KEY.dag.txt
#enabled=1
#END
#fi
echo "========================================================================="
echo "========================================================================="
echo "Cai dat ClamAV...."
sleep 3
#yum install -y clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-devel clamav-lib 
#yum -q install clamav-server-systemd clamav-scanner-systemd 
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install clamav clamav-daemon clamav-freshclam
sudo freshclam

clear
if [ -f /usr/local/maldetect/conf.maldet ]; then
clear
echo "========================================================================= "
echo "Cai dat LMD with ClamAV thanh cong !"
/etc/lemp/menu/lemp-maldet-menu.sh
else
clear
echo "========================================================================= "
echo "Cai dat LMD with ClamAV that bai ! Ban vui long thu cai dat lai !"
/etc/lemp/menu/lemp-maldet-menu.sh
fi
;;
    *)
        ;;
esac
clear 
echo "========================================================================= "
echo "Huy bo cai dat Linux Malware Detect."
/etc/lemp/menu/lemp-maldet-menu.sh







