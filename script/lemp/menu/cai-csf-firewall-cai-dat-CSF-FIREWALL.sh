#!/bin/bash 
. /home/lemp.conf

rm -rf csf.tgz
wget --no-check-certificate https://download.configserver.com/csf.tgz
tar -xvf csf.tgz
cd csf
	echo "Running installer."
	sh install.sh &>/dev/null
	if [ "0" = "$?" ]; then
	    clear
		echo "Installer finished..."
		sleep 3
	else
	clear
		echo "Install Failed"
		sleep 3
		exit 2
	fi
cd
rm -rf csf.tgz
rm -rf /etc/csf/csf.deny

cd ~

wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz

cd csf/

sudo bash install.sh

systemctl restart csf.service
systemctl enable csf.service

cd ~

rm csf.tgz

cat > "/etc/csf/csf.deny" <<END
###############################################################################
# Copyright 2006-2018, Way to the Web Limited
# URL: http://www.configserver.com
# Email: sales@waytotheweb.com
###############################################################################
# The following IP addresses will be blocked in iptables
# One IP address per line
# CIDR addressing allowed with a quaded IP (e.g. 192.168.254.0/24)
# Only list IP addresses, not domain names (they will be ignored)
#
# Note: If you add the text "do not delete" to the comments of an entry then
# DENY_IP_LIMIT will ignore those entries and not remove them
#
# Advanced port+ip filtering allowed with the following format
# tcp/udp|in/out|s/d=port,port,...|s/d=ip
#
# See readme.txt for more information regarding advanced port filtering

END
sed -i 's/LF_TRIGGER = "0"/LF_TRIGGER = "10"/g' /etc/csf/csf.conf
		
	# Disable Auto Update
    sed -i 's/AUTO_UPDATES = "1"/AUTO_UPDATES = "0"/g' /etc/csf/csf.conf
    
    # Setting LF_TRIGGER_PERM to 15 minutes
    sed -ie "s/^LF_TRIGGER_PERM = .*/LF_TRIGGER_PERM = \"900\"/g" /etc/csf/csf.conf
    
    # Disable Testing
    sed -i 's/TESTING = "1"/TESTING = "0"/g' /etc/csf/csf.conf
    
    # Setting LF_DSHIELD=86400
    sed -i 's/LF_DSHIELD = "0"/LF_DSHIELD = "86400"/g' /etc/csf/csf.conf
    
    # Setting LF_SPAMHAUS=604800" # 1 day ban if on SpamHaus list
    sed -i 's/LF_SPAMHAUS = "0"/LF_SPAMHAUS = "86400"/g' /etc/csf/csf.conf

    sed -i 's/LF_EXPLOIT = "300"/LF_EXPLOIT = "86400"/g' /etc/csf/csf.conf
    
    sed -i 's/LF_DIRWATCH = "300"/LF_DIRWATCH = "86400"/g' /etc/csf/csf.conf
    
    sed -i 's/LF_INTEGRITY = "3600"/LF_INTEGRITY = "0"/g' /etc/csf/csf.conf

    sed -i 's/LF_PARSE = "5"/LF_PARSE = "20"/g' /etc/csf/csf.conf

    sed -i 's/LF_PARSE = "600"/LF_PARSE = "20"/g' /etc/csf/csf.conf

    sed -i 's/PS_LIMIT = "10"/PS_LIMIT = "15"/g' /etc/csf/csf.conf
    
    sed -i 's/PT_USERPROC = "10"/PT_USERPROC = "0"/g' /etc/csf/csf.conf

    sed -i 's/PT_USERTIME = "1800"/PT_USERTIME = "0"/g' /etc/csf/csf.conf

    sed -i 's/PT_LOAD = "30"/PT_LOAD = "600"/g' /etc/csf/csf.conf

    sed -i 's/PT_LOAD_AVG = "5"/PT_LOAD_AVG = "15"/g' /etc/csf/csf.conf

    sed -i 's/PT_LOAD_LEVEL = "6"/PT_LOAD_LEVEL = "8"/g' /etc/csf/csf.conf

    sed -i 's/LF_DISTATTACK = "0"/LF_DISTATTACK = "1"/g' /etc/csf/csf.conf

    sed -i 's/LF_DISTFTP = "0"/LF_DISTFTP = "1"/g' /etc/csf/csf.conf

    sed -i 's/LF_DISTFTP_ALERT = "1"/LF_DISTFTP_ALERT = "0"/g' /etc/csf/csf.conf

    sed -i 's/LF_DISTFTP_UNIQ = "3"/LF_DISTFTP_UNIQ = "6"/g' /etc/csf/csf.conf

    sed -i 's/LF_DISTFTP_PERM = "3600"/LF_DISTFTP_PERM = "6000"/g' /etc/csf/csf.conf

    sed -i 's/DENY_IP_LIMIT = \"100\"/DENY_IP_LIMIT = \"200\"/' /etc/csf/csf.conf

    sed -i 's/DENY_TEMP_IP_LIMIT = \"100\"/DENY_TEMP_IP_LIMIT = \"1000\"/' /etc/csf/csf.conf

    #sed -i 's/SYNFLOOD = "0"/SYNFLOOD = "1"/g' /etc/csf/csf.conf

    sed -i 's/LF_SSHD = "5"/LF_SSHD = "20"/g' /etc/csf/csf.conf

    sed -i 's/LF_SSHD_PERM = "1"/LF_SSHD_PERM = "900"/g' /etc/csf/csf.conf

    sed -i 's/UDPFLOOD_BURST = “150”/UDPFLOOD_BURST = “240”/g' /etc/csf/csf.conf   

    sed -i 's/LF_FTPD_PERM = "1"/LF_FTPD_PERM = "300" /g' /etc/csf/csf.conf  

    sed -ie "s/^LF_SMTPAUTH = .*/LF_SMTPAUTH = \"20\"/g" /etc/csf/csf.conf

    sed -ie "s/^LF_SMTPAUTH_PERM = .*/LF_SMTPAUTH_PERM = \"300\"/g" /etc/csf/csf.conf

    sed -i 's/LF_EXIMSYNTAX_PERM = "1"/LF_EXIMSYNTAX_PERM = "300"/g' /etc/csf/csf.conf 

    sed -i 's/LF_POP3D = "0"/LF_POP3D = "5"/g' /etc/csf/csf.conf 
    
    # DISable email alert
    sed -i 's/CT_EMAIL_ALERT = "1"/CT_EMAIL_ALERT = "0"/g' /etc/csf/csf.conf 
    sed -i 's/LT_EMAIL_ALERT = "1"/LT_EMAIL_ALERT = "0"/g' /etc/csf/csf.conf 
    sed -i 's/LF_DISTSMTP_ALERT = "1"/LF_DISTSMTP_ALERT = "0"/g' /etc/csf/csf.conf 
    
    sed -i 's/LF_WEBMIN_EMAIL_ALERT = "1"/LF_WEBMIN_EMAIL_ALERT = "0"/g' /etc/csf/csf.conf
   sed -i 's/LF_SU_EMAIL_ALERT = "1"/LF_SU_EMAIL_ALERT = "0"/g' /etc/csf/csf.conf
    sed -i 's/LF_EMAIL_ALERT = "1"/LF_EMAIL_ALERT = "0"/g' /etc/csf/csf.conf
    sed -i 's/LF_CONSOLE_EMAIL_ALERT = "1"/LF_CONSOLE_EMAIL_ALERT = "0"/g' /etc/csf/csf.conf
        # Disabling email warning for SSH login
        sed -ie "s/^LF_SSH_EMAIL_ALERT = \"1\"/LF_SSH_EMAIL_ALERT = \"0\"/g" /etc/csf/csf.conf
        
    sed -i 's/LF_POP3D_PERM = "1"/LF_POP3D_PERM = "300"/g' /etc/csf/csf.conf 
    
  
    sed -ie "s/^LF_MODSEC = .*/LF_MODSEC = \"0\"/g" /etc/csf/csf.conf
    
    
    sed -ie "s/^LF_MODSEC_PERM = .*/LF_MODSEC_PERM = \"300\"/g" /etc/csf/csf.conf
    
    # Setting HTTP auth failure detection to 0 (disabled)
    sed -ie "s/^LF_HTACCESS = .*/LF_HTACCESS = \"0\"/g" /etc/csf/csf.conf
    sed -ie "s/^LF_HTACCESS_PERM = .*/LF_HTACCESS_PERM = \"300\"/g" /etc/csf/csf.conf
    
    # Track RAM for Process disable
    sed -i 's/.*PT_USERMEM = ".*/PT_USERMEM = "0"/g' /etc/csf/csf.conf
    sed -i 's/.*PT_LIMIT = ".*/PT_LIMIT = "300"/g' /etc/csf/csf.conf
    
    
    
    #sed -i 's/CONNLIMIT = ""/CONNLIMIT = "21;15,22;15,25;15,80;250,443;350,587;15"/g' /etc/csf/csf.conf  
    
    
    #sed -i 's/PORTFLOOD = ""/PORTFLOOD = "80;tcp;400;3,3306;tcp;400;3,443;tcp;400;3"/g' /etc/csf/csf.conf  
	
    # RESTRICT_SYSLOG = "0" default
	sed -i 's/^RESTRICT_SYSLOG = "0"/RESTRICT_SYSLOG = "1"/g' /etc/csf/csf.conf
   
	# LF_PERMBLOCK_INTERVAL
    sed -i 's/LF_PERMBLOCK_INTERVAL = "86400"/LF_PERMBLOCK_INTERVAL = "3600"/g' /etc/csf/csf.conf
    
    # LF_PERMBLOCK_COUNT
    sed -i 's/LF_PERMBLOCK_COUNT = "4"/LF_PERMBLOCK_COUNT = "20"/g' /etc/csf/csf.conf
    
	 # Time block IP
    sed -i 's/CT_BLOCK_TIME = "1800"/CT_BLOCK_TIME = "30"/g' /etc/csf/csf.conf
    
    # Time block IP
    sed -i 's/PS_BLOCK_TIME = "3600"/PS_BLOCK_TIME = "3620"/g' /etc/csf/csf.conf
    
    # Setting CT_LIMIT=300
    sed -i 's/CT_LIMIT = "0"/CT_LIMIT = "300"/g' /etc/csf/csf.conf
    
    # Enable CSF.Allow
    sed -i 's/IGNORE_ALLOW = "0"/IGNORE_ALLOW = "1"/g' /etc/csf/csf.conf  
    
    sed -ie "s/^CT_LIMIT = .*/CT_LIMIT = \"300\"/g" /etc/csf/csf.conf
    
    # Setting CT_BLOCK_TIME=900
    sed -ie "s/^CT_BLOCK_TIME = .*/CT_BLOCK_TIME = \"900\"/g" /etc/csf/csf.conf
        
        # Setting skip time_wait to on
        sed -ie "s/^CT_SKIP_TIME_WAIT = .*/CT_SKIP_TIME_WAIT = \"1\"/g" /etc/csf/csf.conf
       
        
        # PortScan Block
        sed -ie "s/^PS_INTERVAL = .*/PS_INTERVAL = \"300\"/g" /etc/csf/csf.conf
           
    
# csf.pignore

if [ ! `grep -i "/usr/sbin/mysqld" /etc/csf/csf.pignore` &>/dev/null ]; then
 echo "exe:/usr/sbin/mysqld" >> /etc/csf/csf.pignore
  echo "exe:/usr/sbin/mysql" >> /etc/csf/csf.pignore
  echo "exe:/usr/sbin/mysqld_safe" >> /etc/csf/csf.pignore
  echo "exe:/usr/bin/redis-server" >> /etc/csf/csf.pignore
  echo "exe:/usr/bin/memcached" >> /etc/csf/csf.pignore
fi



if [ ! `grep -i "/usr/sbin/nginx" /etc/csf/csf.pignore` &>/dev/null ]; then
 echo "exe:/usr/sbin/nginx" >> /etc/csf/csf.pignore
fi

if [ ! `grep -i "/usr/local/bin/wp" /etc/csf/csf.pignore` &>/dev/null ]; then
 echo "exe:/usr/local/bin/wp" >> /etc/csf/csf.pignore
fi

if [ ! `grep -i "/usr/sbin/php-fpm" /etc/csf/csf.pignore` &>/dev/null ]; then
 echo "exe:/usr/sbin/php-fpm" >> /etc/csf/csf.pignore
fi
echo "user:nginx" >> /etc/csf/csf.pignore  
echo "user:mysql" >> /etc/csf/csf.pignore  
echo "user:redis" >> /etc/csf/csf.pignore  
echo "user:memcached" >> /etc/csf/csf.pignore 
###
# CSF.DIRWATCH
###
	# SSHD config
    if [ ! `grep -E "^/etc/ssh/sshd_config" /etc/csf/csf.dirwatch` &>/dev/null ]; then
        echo "/etc/ssh/sshd_config" >> /etc/csf/csf.dirwatch
    fi
	# csf.suignore
    if [ ! `grep -E "^/etc/csf/csf.suignore" /etc/csf/csf.dirwatch` &>/dev/null ]; then
        echo "/etc/csf/csf.suignore" >> /etc/csf/csf.dirwatch
    fi
	# csf.ignore
    if [ ! `grep -E "^/etc/csf/csf.ignore" /etc/csf/csf.dirwatch` &>/dev/null ]; then
        echo "/etc/csf/csf.ignore" >> /etc/csf/csf.dirwatch
    fi
    
###
# CSF.IGNORE: a list of IP's and CIDR addresses that lfd should ignore and not block if detected
###
#serverip=$(wget http://ipecho.net/plain -O - -q ; echo)
 echo "$serverip" >> /etc/csf/csf.ignore
 Gateway=$(ip route show default | awk '/default/ {print $3}')  #route -n | awk '{if($4=="UG")print $2}'
            echo "$Gateway # Gateway (do not remove)" >> /etc/csf/csf.ignore
# DNS resolvers -- add only for port 53 (TCP/UDP)
	for IP in $(grep -E "^nameserver " /etc/resolv.conf | awk '{print $2}'); do
			if [ ! `grep -E "^$IP" /etc/csf/csf.allow` &>/dev/null ]; then
			echo "$IP:tcp:in:s=53 # DNS Server (do not remove)" >> /etc/csf/csf.allow
			echo "$IP:udp:in:s=53 # DNS Server (do not remove)" >> /etc/csf/csf.allow 
			echo "$IP:tcp:out:s=53 # DNS Server (do not remove)" >> /etc/csf/csf.allow
			echo "$IP:udp:out:s=53 # DNS Server (do not remove)" >> /etc/csf/csf.allow
		fi
	done
    
    #for IP in $(ifconfig | grep -E "^ +inet addr:" | awk '{print $2}' | awk -F: '{print $2}'); do
	for IP in $(ip a | grep -E "inet " | awk '{print $2}' | cut -d/ -f1); do
        if [ ! `grep -E "^$IP" /etc/csf/csf.ignore` &>/dev/null ]; then
            echo "$IP # local IP (do not remove)" >> /etc/csf/csf.ignore
        else
            echo -e "\t$IP already in csf.ignore, skipping."
        fi
    done   
     for IP in $(hostname -I); do
        if [ ! `grep -E "^$IP" /etc/csf/csf.ignore` &>/dev/null ]; then
            echo "$IP # local IP (do not remove)" >> /etc/csf/csf.ignore
        else
            echo -e "\t$IP already in csf.ignore, skipping."
        fi
    done  
if [ -f /etc/lemp/csf.conf_bak ]; then
cp /etc/lemp/csf.conf_bak /etc/csf/csf.conf_bak
fi
################################################
	# Googlebot
	if [ ! `grep -E "^\.googlebot\.com" /etc/csf/csf.rignore` &>/dev/null ]; then
        echo ".googlebot.com # GoogleBot" >> /etc/csf/csf.rignore
    fi

	# Yahoo! Crawler
    if [ ! `grep -E "^\.crawl\.yahoo\.com" /etc/csf/csf.rignore` &>/dev/null ]; then
        echo ".crawl.yahoo.com # Yahoo! Crawler" >> /etc/csf/csf.rignore
    fi

    if [ ! `grep -E "^\.search\.msn\.com" /etc/csf/csf.rignore` &>/dev/null ]; then
        echo ".search.msn.com   # MSN Crawler" >> /etc/csf/csf.rignore
    fi
##################################################
cat > "/tmp/csf-port" <<END
sed -i 's/20,21,22,25,53,80,110,143,443,465,587,993,995/20,21,22,25,53,80,110,143,443,465,587,993,995,6379,11211,30000:50000,$priport/g' /etc/csf/csf.conf
sed -i 's/20,21,22,25,53,80,110,113,443,587,993,995/20,21,22,25,53,80,110,113,443,587,11211,993,995,6379,465,587,3306,3307,8080,$priport/g' /etc/csf/csf.conf
END
chmod +x /tmp/csf-port
/tmp/csf-port
rm -rf /tmp/csf-port

#####################################################
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
rm -f csf.tgz
rm -rf csf
rm -rf /root/csf.tgz
