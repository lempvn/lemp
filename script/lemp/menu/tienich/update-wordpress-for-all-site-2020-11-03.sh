#!/bin/bash
if [ ! -f /tmp/server_wp_all_update ] && [ -f /home/lemp.conf ]; then
. /home/lemp.conf
fi



# chuc nang cap nhat wordress cho toan bo website tren server



# TEST Only
for_test_only () {
/etc/lemp/menu/tienich/update-wordpress-for-all-site.sh

if [ -L /home/user25575/domains/cabki.vn/public_html ]; then
echo "dir"
fi
if [ -L /home/user25575/domains/cabki.vn/private_html ]; then
echo "a"
fi
}
# END TEST




cd ~

chmodUser=""

# cau hinh linh dong theo tung loai host
if [ -f /tmp/server_wp_all_update ]; then

#DirSetup="/home"
#MaxCheck=3
. /tmp/server_wp_all_update

else

echo -n "Dir for check and update (default /home): "
read DirSetup
if [ "$DirSetup" = "" ]; then
DirSetup="/home"
fi

if [ ! -d $DirSetup ]; then
echo $DirSetup" not exist!"
exit
fi

echo -n "Max dir for foreah (maximum 10, default 3): "
read MaxCheck
if [ "$MaxCheck" = "" ]; then
MaxCheck=3
elif [ "$MaxCheck" -gt 10 ]; then
MaxCheck=10
fi

#if [ -f /etc/init.d/directadmin ] && [ ! "$DirSetup" = "/home" ]; then
if [ ! "$DirSetup" = "/home" ]; then
echo -n "chmod to user (default: auto detect): "
read chUser
chmodUser=$chUser
fi

fi

echo "OK OK, check and update wordpres website in: "$DirSetup
echo "Max for: "$MaxCheck
echo "Will begin after 3s..."
#sleep 3
#exit



# install rsync if not exist
#current_os_version=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))

rm -rf /root/test_rsync_for_wp_all_update
echo "hello world"... > /tmp/test_rsync_for_wp_all_update
rsync -ah /tmp/test_rsync_for_wp_all_update /root

#
if [ ! -f /root/test_rsync_for_wp_all_update ]; then
echo "Install rsync"
yum -y install rsync > /dev/null 2>&1
fi

rsync -ah /tmp/test_rsync_for_wp_all_update /root
if [ ! -f /root/test_rsync_for_wp_all_update ]; then
echo "Rsync ERROR......."
exit
fi


# cap nhat cho cac file download
curTime=$(date +%d)
echo "curTime: "$curTime





# kiem tra va xoa cac file download cu
check_and_remmove_file_download(){

# $1 -> ten file can kiem tra -> thuong la .zip
# $2 -> thu muc con (neu co)

if [ ! "$2" = "" ]; then
mkdir -p /root/wp-all-update$2
cd /root/wp-all-update$2
else
cd /root/wp-all-update
fi

# kiem tra xem file download wordress co chua
if [ -f $1 ]; then
fileTime2=$(date -r $1 +%d)
echo "fileTime2: "$fileTime2

# neu file duoc download lau roi -> cap nhat lai
if [ ! "$fileTime2" == "$curTime" ]; then
rm -rf $1
else
echo "download "$1" exist"
fi

fi

cd ~

}


#
mkdir -p /root/wp-all-update
#cd /root/wp-all-update

# timestamp
#timest=$(date +%s)
#echo "timest: "$timest


download_and_unzip_file(){

# $1 -> URL file download
# $2 -> ten file download xong con luu lai -> thuong la .zip
# $3 -> luu vao thu muc con (neu co)
# $4 -> xoa thu muc cu (neu co)

check_and_remmove_file_download $2 $3

if [ ! "$3" = "" ]; then
mkdir -p /root/wp-all-update$3
cd /root/wp-all-update$3
else
cd /root/wp-all-update
fi

if [ ! -f $2 ]; then
#echo "Download: "$1
echo "Download: "$2
wget --no-check-certificate -q $1 -O $2 && chmod 755 $2

# khong download duoc -> thoat
if [ ! -f $2 ]; then
echo $2" not exist"
exit
fi

# thay doi thoi gian tao file cung voi server, de con kiem tra cap nhat lai code
echo "Set timestamp: "$2
touch -d "$(date)" $2

# giai nen
unzip -o $2 > /dev/null 2>&1
#else
#echo $2" exist"
fi

cd ~

}


# wordpres
download_and_unzip_file "https://wordpress.org/latest.zip" "wp.zip" ""

# echbaydotcom
download_and_unzip_file "https://github.com/itvn9online/echbaydotcom/archive/master.zip" "echbaydotcom.zip" ""
download_and_unzip_file "https://github.com/itvn9online/echbaytwo/archive/master.zip" "echbaytwo.zip" ""

# download wordpress plugin hay dung nhat
download_wordpress_plugin(){
download_and_unzip_file "https://downloads.wordpress.org/plugin/"$1".zip" $1".zip" "/plugins"
}
download_wordpress_plugin "classic-editor"
download_wordpress_plugin "tinymce-advanced"
download_wordpress_plugin "contact-form-7"
download_wordpress_plugin "flamingo"
download_wordpress_plugin "wordpress-seo"
download_wordpress_plugin "elementor"
download_wordpress_plugin "post-duplicator"
download_wordpress_plugin "widget-shortcode"
download_wordpress_plugin "wp-mail-smtp"
download_wordpress_plugin "wp-smtp"
download_wordpress_plugin "redirection"
download_wordpress_plugin "really-simple-ssl"

download_wordpress_plugin "echbay-admin-security"
download_wordpress_plugin "echbay-facebook-messenger"
download_wordpress_plugin "echbay-optimize-images"
download_wordpress_plugin "echbay-phonering-alo"
download_wordpress_plugin "echbay-search-everything"
download_wordpress_plugin "echbay-tag-manager"

download_wordpress_plugin "woocommerce"
download_wordpress_plugin "wordpress-importer"
download_wordpress_plugin "wordfence"
download_wordpress_plugin "wpforms-lite"
download_wordpress_plugin "duplicate-post"
download_wordpress_plugin "all-in-one-wp-migration"
download_wordpress_plugin "google-sitemap-generator"
download_wordpress_plugin "wp-super-cache"
download_wordpress_plugin "w3-total-cache"
download_wordpress_plugin "litespeed-cache"
download_wordpress_plugin "wp-fastest-cache"
download_wordpress_plugin "autoptimize"
#download_wordpress_plugin "aaaaaaaaaaa"

#exit


rsync_wp_plugin(){

# $1 -> thu muc nguon
# $2 -> thu muc dich

#echo $1
#echo $2

#download_wordpress_plugin $1

#echo $2/wp-content/plugins/$1
if [ -d "$2/wp-content/plugins/$1" ] && [ -d "/root/wp-all-update/plugins/$1" ]; then
echo "rsync "$1"..."
rsync -ah --delete /root/wp-all-update/plugins/$1/* $2/wp-content/plugins/$1/ > /dev/null 2>&1
fi
}


# don dep code sau khi download
cd ~

# xoa thu muc wp-content
if [ -d /root/wp-all-update/wordpress/wp-content ]; then
rm -rf /root/wp-all-update/wordpress/wp-content/*
rm -rf /root/wp-all-update/wordpress/wp-content
fi

# khong ton tai wordpress -> thoat
if [ ! -d /root/wp-all-update/wordpress ]; then
echo "wordpress not exist"
exit
fi

#
if [ -d /root/wp-all-update/echbaydotcom-master ]; then
rm -rf /root/wp-all-update/echbaydotcom-master/.gitattributes
rm -rf /root/wp-all-update/echbaydotcom-master/.gitignore
# chinh lai thoi gian cap nhat
if [ -f /root/wp-all-update/echbaydotcom-master/readme.txt ]; then
	touch -d "$(date)" /root/wp-all-update/echbaydotcom-master/readme.txt
fi
fi

#
if [ -d /root/wp-all-update/echbaytwo-master ]; then
rm -rf /root/wp-all-update/echbaytwo-master/.gitattributes
rm -rf /root/wp-all-update/echbaytwo-master/.gitignore
# chinh lai thoi gian cap nhat
if [ -f /root/wp-all-update/echbaytwo-master/index.php ]; then
	touch -d "$(date)" /root/wp-all-update/echbaytwo-master/index.php
fi
fi

# phan quyen cho nginx quan ly
id -u nginx
if [ $? -eq 0 ]; then
	chown -R nginx:nginx /root/wp-all-update
fi



#exit
cd ~


# tim tat ca thu muc trong home
get_all_dir_in_dir(){
#echo $2

# do sau toi da se kiem tra
if [ $2 -lt $3 ]; then
	for d in $1
	do
		# neu la thu muc thi kiem tra tiep
		if [ -d $d ]; then
			# neu la shortcut thi bo qua
			if [ -L $d ]; then
				echo $d
				echo "---------------------------- It is a symlink!"
			else
				# tim it nhat 3 file va 3 thu muc bat buoc phai co cua wp
				if [ -f $d/wp-config.php ] && [ -f $d/wp-settings.php ] && [ -f $d/wp-blog-header.php ] && [ -d $d/wp-admin ] && [ -d $d/wp-content ] && [ -d $d/wp-includes ]; then
					echo $d
					# tim duoc website wp
					echo "++++++++++++++++++++++++++++ It is a wordpress website"
					
					echo "Begin rsync! Please wait..."
					
					# wordpres core
					if [ -d /root/wp-all-update/wordpress ]; then
						echo "rsync wordpress CORE..."
						if [ -d /root/wp-all-update/wordpress/wp-admin ]; then
							rsync -ah --delete /root/wp-all-update/wordpress/wp-admin/* $d/wp-admin/ > /dev/null 2>&1
						fi
						if [ -d /root/wp-all-update/wordpress/wp-includes ]; then
							rsync -ah --delete /root/wp-all-update/wordpress/wp-includes/* $d/wp-includes/ > /dev/null 2>&1
						fi
						rsync -ah /root/wp-all-update/wordpress/* $d/ > /dev/null 2>&1
					fi
					
					# echbaydotcom
					if [ -d /root/wp-all-update/echbaydotcom-master ] && [ -d "$d/wp-content/echbaydotcom" ]; then
						echo "rsync echbaydotcom..."
						rsync -ah --delete /root/wp-all-update/echbaydotcom-master/* $d/wp-content/echbaydotcom/ > /dev/null 2>&1
						#chown -R nginx:nginx $d/wp-content/echbaydotcom
					fi
					
					# echbaytwo
					if [ -d /root/wp-all-update/echbaytwo-master ] && [ -d "$d/wp-content/themes/echbaytwo" ]; then
						echo "rsync echbaytwo..."
						rsync -ah --delete /root/wp-all-update/echbaytwo-master/* $d/wp-content/themes/echbaytwo/ > /dev/null 2>&1
						#chown -R nginx:nginx $d/wp-content/themes/echbaytwo
					fi
					
					# wordpres plugin -> chay vong lap va update tat ca neu co
					if [ -d /root/wp-all-update/plugins ]; then
						for d_plugins in /root/wp-all-update/plugins/*
						do
							if [ -d $d_plugins ]; then
								d_pl=$(basename $d_plugins)
								#echo $d_pl
								rsync_wp_plugin $d_pl $d
							fi
						done
					fi
					
					echo "Rsync all DONE!"
					
					if [ ! "$4" = "" ]; then
						id -u $4
						if [ $? -eq 0 ]; then
							echo "chown user: "$4
							
							# voi DirectAdmin -> chuyen quyen cho user
							if [ -f /etc/init.d/directadmin ]; then
								chown -R $4:$4 $d
								chown -R $4:$4 $d/*
							else
								# voi lemp, HOCVPS -> phan quyen cho user va nginx
								id -u nginx
								if [ $? -eq 0 ]; then
									chown -R $4:nginx $d
									chown -R $4:nginx $d/*
								else
									chown -R $4:$4 $d
									chown -R $4:$4 $d/*
								fi
							fi
						else
							echo "user "$4" not exist"
						fi
					fi
					
				else
					#echo $d
					stt=$2
					let "stt+=1"
					#echo $stt
					get_all_dir_in_dir $d"/*" $stt $3
				fi
			fi
		fi
	done
fi
}


# lap tim cac website trong thu muc home
for d_home in $DirSetup/*
do
	# neu la thu muc -> tim cac file wp trong nay
	if [ -d $d_home ]; then
		echo $d_home
		
		# tai khoan de chmod file sau khi update
		if [ "$chmodUser" = "" ]; then
			host_user=$(basename $d_home)
		else
			host_user=$chmodUser
		fi
		#echo $host_user
		
		get_all_dir_in_dir $d_home"/*" 0 $MaxCheck $host_user
		
		echo "========================================"
	fi
done

cd ~


if [ ! -f /tmp/server_wp_all_update ] && [ -f /home/lemp.conf ]; then
/etc/lemp/menu/tienich/lemp-tien-ich.sh
fi


