#!/bin/bash
. /home/lemp.conf
rm -rf /home/$mainsite/private_html/ListFTPUser*.txt
random=$(date |md5sum |cut -c '1-4')
if [ ! -f /etc/pure-ftpd/pure-ftpd.conf ]; then
clear
echo "========================================================================= "
echo "Pure-FTPD server chua duoc cai dat tren server. "
echo "-------------------------------------------------------------------------"
echo "Ban phai cai dat chuc nang Setup FTP server truoc"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
exit
fi
pure-pw list > /tmp/checkuser.tmp
if [ "$(cat /tmp/checkuser.tmp)" == "" ]; then
rm -rf /tmp/listftpuser.tmp
clear
echo "========================================================================= "
echo "Ban chua tao mot tai khoan FTP nao !"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
else
echo "========================================================================= " > /home/$mainsite/private_html/ListFTPUser-$random.txt
echo " FTPUser      |      Domain   " >> /home/$mainsite/private_html/ListFTPUser-$random.txt
echo "========================================================================= " >> /home/$mainsite/private_html/ListFTPUser-$random.txt
echo " " >> /home/$mainsite/private_html/ListFTPUser-$random.txt
echo "" >> /home/$mainsite/private_html/ListFTPUser-$random.txt
pure-pw list >> /home/$mainsite/private_html/ListFTPUser-$random.txt
sed -i 's/\/.\///g' /home/$mainsite/private_html/ListFTPUser-$random.txt
sed -i 's/\/home\///g' /home/$mainsite/private_html/ListFTPUser-$random.txt
clear
echo "========================================================================= "
echo "Link view List FTP User on $serverip:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/ListFTPUser-$random.txt"
/etc/lemp/menu/ftpserver/lemp-ftpserver-menu.sh
fi 
