#!/bin/sh

curTime=$(date +%d)
#echo "curTime: "$curTime


if [ ! -f /tmp/lemp.newversion ]; then
touch -a -m -t 201602180130.09 /tmp/lemp.newversion  
fi

fileTime2=$(date -r /tmp/lemp.newversion +%d)
#echo "fileTime2: "$fileTime2

if [ ! "$fileTime2" == "$curTime" ]; then
rm -rf /tmp/lemp.newversion
#wget -q https://lemp.echbay.com/script/lemp/lemp.newversion -O /tmp/lemp.newversion
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/version -O /tmp/lemp.newversion
touch /tmp/lemp.newversion
LOCALVER=`cat /etc/lemp/lemp.version`
checksize=$(du -sb /tmp/lemp.newversion | awk 'NR==1 {print $1}')
###
	if [ $checksize -gt 2 ]; then
	REMOVER=`cat /tmp/lemp.newversion`
	cat >> "/tmp/lemp_check_lemp_version" <<END
		if [ ! "$LOCALVER" == "$REMOVER" ]; then
			echo "========================================================================="
			echo "Update for LEMP found !  "
			echo "-------------------------------------------------------------------------"
			echo "Your Version: $LOCALVER   |   Newest version: $REMOVER"
			echo "-------------------------------------------------------------------------"
			echo "How to update: LEMP menu => Update System => Update LEMP "
			
		fi
END
	chmod +x /tmp/lemp_check_lemp_version
	/tmp/lemp_check_lemp_version
	rm -rf /tmp/lemp_check_lemp_version
	fi
fi



