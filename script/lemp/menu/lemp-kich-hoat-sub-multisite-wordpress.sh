#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Chuc nang nay se tao Vhost cho subdomain tren server sau khi ban da "
echo "-------------------------------------------------------------------------"
echo "tao Sub-Domain trong WP-ADMIN cua website cai dat Wordpress Multisite"
echo "-------------------------------------------------------------------------"   
echo -n "Nhap ten website: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co the khong dung dinh dang domain!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

if [ -f /home/$website/public_html/wp-config-sample.php ]; then
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website co code wordpress nhung chua cai dat !"
echo "-------------------------------------------------------------------------"
echo "Vu long cai dat wordpress va thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
fi

if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong phai wordpress blog !"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi


if [ ! "$(grep "define( 'SUBDOMAIN_INSTALL', false );" /home/$website/public_html/wp-config.php)" == "" ]; then
clear
echo "========================================================================="
echo "$website cai dat Wordpress Multisite dang Sub-directories"
echo "-------------------------------------------------------------------------"
echo "Ban khong the tao Subdomain cho $website"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi


if [ "$(grep "WP_ALLOW_MULTISITE" /home/$website/public_html/wp-config.php)" == "" ]; then
clear
echo "========================================================================="
echo "$website chua cai dat Wordpress Multisite"
echo "-------------------------------------------------------------------------"
echo "Ban phai cai dat Multisite truoc !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "LEMP dang check ... "
sleep 1;
echo "========================================================================="
echo "Tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "$website da cai dat wordpress multisite dang Sub-domain"
echo "========================================================================="
echo "TAO VHOST CHO SUBDOMAIN"
echo "========================================================================="
echo "Nhap sub ban da tao trong $website wp-admin. Chi nhap ten SUB ! "
echo "-------------------------------------------------------------------------"
echo "Vi du: Ten sub ban tao la lemp.vps.vn, Nhap: lemp"
echo "========================================================================="
echo -n "Nhap ten sub: " 
read subdomain
if [ "$subdomain" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

kiemtradata="^[a-zA-Z0-9][-a-zA-Z0-9]{0,61}[a-zA-Z0-9]$";
if [[ ! "$subdomain" =~ $kiemtradata ]]; then
	subdomain=`echo $subdomain | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$subdomain khong hop le ! "
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi 


if [ -f /etc/nginx/conf.d/$subdomain.$website.conf ]; then
clear
echo "========================================================================="
echo "$subdomain.$website da duoc kich hoat tren VPS "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
websiteto=`echo $website | tr '[A-Z]' '[a-z]'`
echo "========================================================================="
echo "LEMP se cau hinh Vhost tuy thuoc vao loai cache $website su dung"
echo "-------------------------------------------------------------------------"
echo "Ban phai lua chon dung, neu khong Subdomain se hoat dong khong chinh xac"
echo "========================================================================="
echo "CHON LOAI CACHE MA $websiteto DANG SU DUNG"
echo "========================================================================="

prompt="Nhap lua chon cua ban: "
options=( "WP Super Cache" "Redis Cache" "W3 Total Cache" "WP Rocket Cache" "Others")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) vhostconfig="supercache"; break;;
    2) vhostconfig="redis"; break;;
    3) vhostconfig="wptotalcache"; break;;
	4) vhostconfig="rocket"; break;;
    5) vhostconfig="normal"; break;;  
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################
#Redis Cache
###################################
if [ "$vhostconfig" = "redis" ]; then
	cat > "/etc/nginx/conf.d/$subdomain.$website.conf" <<END
server {
	    server_name www.$subdomain.$website;
	    rewrite ^(.*) http://$subdomain.$website\$1 permanent;
    	}
server {
	    listen   80;

    	access_log off;
    	error_log off;
    	# error_log /home/$website/logs/error.log;
    	root /home/$website/public_html;
include /etc/nginx/conf/ddos2.conf;
	index index.php index.html index.htm;
    	server_name $subdomain.$website;

#//////////////////////////////////////////////////////////////
#Ban chi co the chon 1 trong 4 rule AAA, BBB, CCC, DDD hoac EEE
#//////////////////////////////////////////////////////////////
#Chay ta ca cac website. neu ban su dung rule cua ban, xoa dong duoi hoac comment (them dau # vao truoc) (AAA)
include /etc/nginx/conf/all.conf;

#Neu ban su dung rule cua minh, comment hoac xoa rule o tren. Sau do uncoment (bo dau # ba dong duoi) sau do them rule vao giua. (BBB)
#location / {
#Uncomment 3 lines and set your rules here!
#}

# Rule cho wordpress + Plugin wp super cache. Neu ban su dung wordpress va wp super cache, uncomment dong duoi va comment hoac xoa dong AAA phia tren (CCC)
#include /etc/nginx/conf/supercache.conf;  

# Rule cho wordpress + Plugin W3 Total Cache. Neu ban su dung wordpress va W3 Total, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (DDD)
#include /etc/nginx/conf/w3total.conf;

# Rule cho wordpress + Plugin wp rocket Cache. Neu ban su dung wordpress va wp rocket, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (EEE)
#include /etc/nginx/conf/wprocket.conf;  

# Config Cache Static Files
include /etc/nginx/conf/staticfiles.conf;  

#Tang bao mat security, chong sql injection  ....(uncoment neu ban muon su dung). Boi vi mot so code website khong su dung duoc voi rule nay, nen mac dinh lemp de tat.
#Khong duoc xoa dong duoi, neu xoa LEMP se khong hoat dong !
#include /etc/nginx/conf/block.conf;
 
 
    	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include /etc/nginx/fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
		fastcgi_connect_timeout 60;
		fastcgi_send_timeout 180;
		fastcgi_read_timeout 180;
		fastcgi_buffer_size 256k;
		fastcgi_buffers 4 256k;
		fastcgi_busy_buffers_size 256k;
		fastcgi_temp_file_write_size 256k;
		fastcgi_intercept_errors on;
        fastcgi_param SCRIPT_FILENAME /home/$website/public_html\$fastcgi_script_name;
    	}
	

#include /etc/nginx/conf/phpstatus.conf;
include /etc/nginx/conf/drop.conf;

    }
END
###################################
#Super Cache
###################################
elif [ "$vhostconfig" = "supercache" ]; then
	cat > "/etc/nginx/conf.d/$subdomain.$website.conf" <<END
server {
	    server_name www.$subdomain.$website;
	    rewrite ^(.*) http://$subdomain.$website\$1 permanent;
    	}
server {
	    listen   80;

    	access_log off;
    	error_log off;
    	# error_log /home/$website/logs/error.log;
    	root /home/$website/public_html;
include /etc/nginx/conf/ddos2.conf;
	index index.php index.html index.htm;
    	server_name $subdomain.$website;

#//////////////////////////////////////////////////////////////
#Ban chi co the chon 1 trong 4 rule AAA, BBB, CCC, DDD hoac EEE
#//////////////////////////////////////////////////////////////
#Chay ta ca cac website. neu ban su dung rule cua ban, xoa dong duoi hoac comment (them dau # vao truoc) (AAA)
#include /etc/nginx/conf/all.conf;

#Neu ban su dung rule cua minh, comment hoac xoa rule o tren. Sau do uncoment (bo dau # ba dong duoi) sau do them rule vao giua. (BBB)
#location / {
#Uncomment 3 lines and set your rules here!
#}

# Rule cho wordpress + Plugin wp super cache. Neu ban su dung wordpress va wp super cache, uncomment dong duoi va comment hoac xoa dong AAA phia tren (CCC)
include /etc/nginx/conf/supercache.conf;  

# Rule cho wordpress + Plugin W3 Total Cache. Neu ban su dung wordpress va W3 Total, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (DDD)
#include /etc/nginx/conf/w3total.conf;

# Rule cho wordpress + Plugin wp rocket Cache. Neu ban su dung wordpress va wp rocket, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (EEE)
#include /etc/nginx/conf/wprocket.conf;  

# Config Cache Static Files
include /etc/nginx/conf/staticfiles.conf;  

#Tang bao mat security, chong sql injection  ....(uncoment neu ban muon su dung). Boi vi mot so code website khong su dung duoc voi rule nay, nen mac dinh lemp de tat.
#Khong duoc xoa dong duoi, neu xoa LEMP se khong hoat dong !
#include /etc/nginx/conf/block.conf;
 
 
    	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include /etc/nginx/fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
		fastcgi_connect_timeout 60;
		fastcgi_send_timeout 180;
		fastcgi_read_timeout 180;
		fastcgi_buffer_size 256k;
		fastcgi_buffers 4 256k;
		fastcgi_busy_buffers_size 256k;
		fastcgi_temp_file_write_size 256k;
		fastcgi_intercept_errors on;
        fastcgi_param SCRIPT_FILENAME /home/$website/public_html\$fastcgi_script_name;
    	}
	
#include /etc/nginx/conf/phpstatus.conf;
include /etc/nginx/conf/drop.conf;
    }
END
###################################
#W3 Total Cache
###################################
elif [ "$vhostconfig" = "wptotalcache" ]; then

	cat > "/etc/nginx/conf.d/$subdomain.$website.conf" <<END
server {
	    server_name www.$subdomain.$website;
	    rewrite ^(.*) http://$subdomain.$website\$1 permanent;
    	}
server {
	    listen   80;

    	access_log off;
    	error_log off;
    	# error_log /home/$website/logs/error.log;
    	root /home/$website/public_html;
include /etc/nginx/conf/ddos2.conf;
	index index.php index.html index.htm;
    	server_name $subdomain.$website;

#//////////////////////////////////////////////////////////////
#Ban chi co the chon 1 trong 4 rule AAA, BBB, CCC, DDD hoac EEE
#//////////////////////////////////////////////////////////////
#Chay ta ca cac website. neu ban su dung rule cua ban, xoa dong duoi hoac comment (them dau # vao truoc) (AAA)
#include /etc/nginx/conf/all.conf;

#Neu ban su dung rule cua minh, comment hoac xoa rule o tren. Sau do uncoment (bo dau # ba dong duoi) sau do them rule vao giua. (BBB)
#location / {
#Uncomment 3 lines and set your rules here!
#}

# Rule cho wordpress + Plugin wp super cache. Neu ban su dung wordpress va wp super cache, uncomment dong duoi va comment hoac xoa dong AAA phia tren (CCC)
#include /etc/nginx/conf/supercache.conf;  

# Rule cho wordpress + Plugin W3 Total Cache. Neu ban su dung wordpress va W3 Total, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (DDD)
include /etc/nginx/conf/w3total.conf;

# Rule cho wordpress + Plugin wp rocket Cache. Neu ban su dung wordpress va wp rocket, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (EEE)
#include /etc/nginx/conf/wprocket.conf;  

# Confif Cache Static Files
include /etc/nginx/conf/staticfiles.conf;  

#Tang bao mat security, chong sql injection  ....(uncoment neu ban muon su dung). Boi vi mot so code website khong su dung duoc voi rule nay, nen mac dinh lemp de tat.
#Khong duoc xoa dong duoi, neu xoa LEMP se khong hoat dong !
#include /etc/nginx/conf/block.conf;
 
 
    	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include /etc/nginx/fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
		fastcgi_connect_timeout 60;
		fastcgi_send_timeout 180;
		fastcgi_read_timeout 180;
		fastcgi_buffer_size 256k;
		fastcgi_buffers 4 256k;
		fastcgi_busy_buffers_size 256k;
		fastcgi_temp_file_write_size 256k;
		fastcgi_intercept_errors on;
        fastcgi_param SCRIPT_FILENAME /home/$website/public_html\$fastcgi_script_name;
    	}
    	
#include /etc/nginx/conf/phpstatus.conf;
include /etc/nginx/conf/drop.conf;

    }
END
###################################
#WP Rocket cache
###################################
elif [ "$vhostconfig" = "rocket" ]; then

	cat > "/etc/nginx/conf.d/$subdomain.$website.conf" <<END
server {
	    server_name www.$subdomain.$website;
	    rewrite ^(.*) http://$subdomain.$website\$1 permanent;
    	}
server {
	    listen   80;

    	access_log off;
    	error_log off;
    	# error_log /home/$website/logs/error.log;
    	root /home/$website/public_html;
include /etc/nginx/conf/ddos2.conf;
	index index.php index.html index.htm;
    	server_name $subdomain.$website;

#//////////////////////////////////////////////////////////////
#Ban chi co the chon 1 trong 4 rule AAA, BBB, CCC, DDD hoac EEE
#//////////////////////////////////////////////////////////////
#Chay ta ca cac website. neu ban su dung rule cua ban, xoa dong duoi hoac comment (them dau # vao truoc) (AAA)
#include /etc/nginx/conf/all.conf;

#Neu ban su dung rule cua minh, comment hoac xoa rule o tren. Sau do uncoment (bo dau # ba dong duoi) sau do them rule vao giua. (BBB)
#location / {
#Uncomment 3 lines and set your rules here!
#}

# Rule cho wordpress + Plugin wp super cache. Neu ban su dung wordpress va wp super cache, uncomment dong duoi va comment hoac xoa dong AAA phia tren (CCC)
#include /etc/nginx/conf/supercache.conf;  

# Rule cho wordpress + Plugin W3 Total Cache. Neu ban su dung wordpress va W3 Total, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (DDD)
#include /etc/nginx/conf/w3total.conf;

# Rule cho wordpress + Plugin wp rocket Cache. Neu ban su dung wordpress va wp rocket, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (EEE)
include /etc/nginx/conf/wprocket.conf;  

# Confif Cache Static Files
include /etc/nginx/conf/staticfiles.conf;  

#Tang bao mat security, chong sql injection  ....(uncoment neu ban muon su dung). Boi vi mot so code website khong su dung duoc voi rule nay, nen mac dinh lemp de tat.
#Khong duoc xoa dong duoi, neu xoa LEMP se khong hoat dong !
#include /etc/nginx/conf/block.conf;
 
 
    	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include /etc/nginx/fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
		fastcgi_connect_timeout 60;
		fastcgi_send_timeout 180;
		fastcgi_read_timeout 180;
		fastcgi_buffer_size 256k;
		fastcgi_buffers 4 256k;
		fastcgi_busy_buffers_size 256k;
		fastcgi_temp_file_write_size 256k;
		fastcgi_intercept_errors on;
        fastcgi_param SCRIPT_FILENAME /home/$website/public_html\$fastcgi_script_name;
    	}
    	
#include /etc/nginx/conf/phpstatus.conf;
include /etc/nginx/conf/drop.conf;

    }
END
#---------------------------------------------------------

else 
cat > "/etc/nginx/conf.d/$subdomain.$website.conf" <<END
server {
	    server_name www.$subdomain.$website;
	    rewrite ^(.*) http://$subdomain.$website\$1 permanent;
    	}
server {
	    listen   80;

    	access_log off;
    	error_log off;
    	# error_log /home/$website/logs/error.log;
    	root /home/$website/public_html;
include /etc/nginx/conf/ddos2.conf;
	index index.php index.html index.htm;
    	server_name $subdomain.$website;

#//////////////////////////////////////////////////////////////
#Ban chi co the chon 1 trong 4 rule AAA, BBB, CCC, DDD hoac EEE
#//////////////////////////////////////////////////////////////
#Chay ta ca cac website. neu ban su dung rule cua ban, xoa dong duoi hoac comment (them dau # vao truoc) (AAA)
include /etc/nginx/conf/all.conf;

#Neu ban su dung rule cua minh, comment hoac xoa rule o tren. Sau do uncoment (bo dau # ba dong duoi) sau do them rule vao giua. (BBB)
#location / {
#Uncomment 3 lines and set your rules here!
#}

# Rule cho wordpress + Plugin wp super cache. Neu ban su dung wordpress va wp super cache, uncomment dong duoi va comment hoac xoa dong AAA phia tren (CCC)
#include /etc/nginx/conf/supercache.conf;  

# Rule cho wordpress + Plugin W3 Total Cache. Neu ban su dung wordpress va W3 Total, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (DDD)
#include /etc/nginx/conf/w3total.conf;

# Rule cho wordpress + Plugin wp rocket Cache. Neu ban su dung wordpress va wp rocket, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (EEE)
#include /etc/nginx/conf/wprocket.conf;  

# Confif Cache Static Files
include /etc/nginx/conf/staticfiles.conf;  

#Tang bao mat security, chong sql injection  ....(uncoment neu ban muon su dung). Boi vi mot so code website khong su dung duoc voi rule nay, nen mac dinh lemp de tat.
#Khong duoc xoa dong duoi, neu xoa LEMP se khong hoat dong !
#include /etc/nginx/conf/block.conf;
 
 
    	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include /etc/nginx/fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
		fastcgi_connect_timeout 60;
		fastcgi_send_timeout 180;
		fastcgi_read_timeout 180;
		fastcgi_buffer_size 256k;
		fastcgi_buffers 4 256k;
		fastcgi_busy_buffers_size 256k;
		fastcgi_temp_file_write_size 256k;
		fastcgi_intercept_errors on;
        fastcgi_param SCRIPT_FILENAME /home/$website/public_html\$fastcgi_script_name;
    	}
	
#include /etc/nginx/conf/phpstatus.conf;
include /etc/nginx/conf/drop.conf;
    }
END
fi

 

systemctl restart nginx.service

clear
echo "========================================================================="
echo "Tao Vhost cho $subdomain.$website thanh cong ! "
echo "-------------------------------------------------------------------------"
echo "Ban co the truy cap $subdomain.$website de check! neu config sai,"
echo "-------------------------------------------------------------------------"
echo "Xoa $subdomain.$website.conf trong /etc/nginx/conf.d"
echo "-------------------------------------------------------------------------"
echo "va lam lai theo cac buoc tren!"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh

