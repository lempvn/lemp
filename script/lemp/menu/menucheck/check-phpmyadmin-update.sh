#!/bin/sh

curTime=$(date +%d)
#echo "curTime: "$curTime


if [ ! -f /tmp/00-all-phpmyadmin-version.txt ]; then
touch -a -m -t 201601180130.09 /tmp/00-all-phpmyadmin-version.txt  
fi

fileTime=$(date -r /tmp/00-all-phpmyadmin-version.txt +%d)
#echo "fileTime: "$fileTime

if [ ! "$fileTime" == "$curTime" ]; then
rm -rf /tmp/00-all-phpmyadmin-version.txt
#wget -q https://lemp.echbay.com/script/lemp/00-all-phpmyadmin-version.txt -O /tmp/00-all-phpmyadmin-version.txt
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/00-all-phpmyadmin-version.txt -O /tmp/00-all-phpmyadmin-version.txt
touch /tmp/00-all-phpmyadmin-version.txt
Nginx1=`cat /etc/lemp/phpmyadmin.version`
checksize=$(du -sb /tmp/00-all-phpmyadmin-version.txt | awk 'NR==1 {print $1}')
if [ $checksize -gt 14 ]; then
Nginx3=`cat /tmp/00-all-phpmyadmin-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`
cat >> "/tmp/lemp_check_phpmyadmin" <<END
		if [  "$(grep $Nginx1 /tmp/00-all-phpmyadmin-version.txt | sed 's/|//' | sed 's/|//')" == "$Nginx1" ]; then
			if [ ! "$Nginx1" == "$Nginx3" ]; then
			echo "========================================================================="
			echo "Update for phpmyadmin Found !  "
			echo "-------------------------------------------------------------------------"
			echo "Your Version: $Nginx1   |   Newest version: $Nginx3"
			echo "-------------------------------------------------------------------------"
			echo "How to update: LEMP menu => Update System => Change phpmyadmin Version "
			
			fi
		fi
END
chmod +x /tmp/lemp_check_phpmyadmin
/tmp/lemp_check_phpmyadmin
rm -rf /tmp/lemp_check_phpmyadmin
fi
fi



