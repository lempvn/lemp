#!/bin/bash
. /home/lemp.conf
random=`date |md5sum |cut -c '1-10'`
minimumsize=1024000
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
echo "-------------------------------------------------------------------------"
if [ -f /var/log/exim/main.log ]; then
ls -t /var/log/exim/main.log* > /tmp/eximlog.list
wc -l /tmp/eximlog.list | awk 'NR==1 {print $1}' > /tmp/countnumber
else
clear
echo "========================================================================= "
echo "Khong co du lieu trong Exim log file"
/etc/lemp/menu/downloadlog/lemp-error-menu.sh
fi
checksize=$(du -sb $(cat /tmp/eximlog.list)  | tail -1 | cut -f 1)
	if [ $checksize -ge $minimumsize ]; then

	rm -rf /home/$mainsite/private_html/server-log/exim.log*
	rm -rf /tmp/eximdownload
	mkdir -p /tmp/eximdownload
	\cp -uf /var/log/exim/main.log* /tmp/eximdownload
	cd /tmp/eximdownload
	rm -rf /tmp/getlisteximtmp
	ls > /tmp/getlisteximtmp
	exim231=$(cat /tmp/getlisteximtmp)
	for abcddd in $exim231 
     do
	sed -i '1s/^/========================================================================= \n\n/' $abcddd
	sed -i '2s/^/Exim Log - Created by LEMP \n\n/' $abcddd
	sed -i '3s/^/========================================================================= \n\n/' $abcddd
	done
	zip -r exim.log.zip *.*
	\cp -uf exim.log.zip /home/$mainsite/private_html/server-log/
rm -rf /tmp/*exim*
	cd /home/$mainsite/private_html/server-log
    mv exim.log.zip exim.log-$random.zip
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link download Exim Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/exim.log-$random.zip"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  else
ls -t /var/log/exim/main.log* > /tmp/eximlog.list
listemximlog=$(cat /tmp/eximlog.list)
for eximday in $listemximlog 
do    
rm -rf /tmp/chenkitu.tmp
cat > "/tmp/chenkitu.tmp" <<END
echo "" >> /tmp/eximlog.tmp
echo "" >> /tmp/eximlog.tmp
echo "=====================================================================================" >> /tmp/eximlog.tmp
echo "=====================================================================================" >> /tmp/eximlog.tmp
echo "Log File: $eximday" >> /tmp/eximlog.tmp
echo "=====================================================================================" >> /tmp/eximlog.tmp
echo "=====================================================================================" >> /tmp/eximlog.tmp
echo "" >> /tmp/eximlog.tmp
echo "" >> /tmp/eximlog.tmp
END
sed -i 's/\/var\/log\/exim\///g' /tmp/chenkitu.tmp
chmod +x /tmp/chenkitu.tmp
/tmp/chenkitu.tmp
rm -rf /tmp/chenkitu.tmp
cat $eximday >> /tmp/eximlog.tmp
done

    rm -rf /home/$mainsite/private_html/server-log/exim.log*
	\cp -uf /tmp/eximlog.tmp /home/$mainsite/private_html/server-log/
	cd /home/$mainsite/private_html/server-log
	sed -i '1s/^/========================================================================= \n\n/' eximlog.tmp
	sed -i '2s/^/Exim Log - Created by LEMP \n\n/' eximlog.tmp
	sed -i '3s/^/========================================================================= \n\n/' eximlog.tmp
	mv eximlog.tmp  exim.log-$random.txt
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	rm -rf /tmp/*exim*
	clear
	echo "========================================================================= "
     if [ ! "$(cat /tmp/countnumber)" == "1" ]; then
	echo "Co tat ca $(cat /tmp/countnumber) file log. LEMP tu dong noi thanh mot file duy nhat."
    echo "-------------------------------------------------------------------------"
    fi
	echo "Link Xem Exim Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/exim.log-$random.txt"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  fi 
