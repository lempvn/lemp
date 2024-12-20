#!/bin/bash
# Kiem tra xem so luong tham so dau vao co dung la 3 khong
. /home/lemp.conf

echo "========================================================================="
echo "Ban dang thao tac thay doi phien ban PHP cho Website!"
echo "========================================================================="
echo -n "Nhap domain ban muon thay doi phien ban PHP [ENTER]: " 
read website
website=$(echo "$website" | tr '[A-Z]' '[a-z]')

if [ -z "$website" ]; then
    clear
    echo "========================================================================="
    echo "Ban nhap sai, vui long nhap chinh xac"
    /etc/lemp/menu/nangcap-php/lemp-change-ver-php.sh
    exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$"
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
    website=$(echo "$website" | tr '[A-Z]' '[a-z]')
    clear
    echo "========================================================================="
    echo "$website khong dung dinh dang domain!"
    echo "-------------------------------------------------------------------------"
    echo "Vui long thu lai !"
    /etc/lemp/menu/nangcap-php/lemp-change-ver-php.sh
    exit
fi

# Kiem tra xem website co ton tai trong cau hinh nginx khong
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
    clear
    echo "========================================================================="
    echo "Website $website khong ton tai tren he thong!"
    echo "-------------------------------------------------------------------------"
    echo "Ban hay nhap lai!"
    /etc/lemp/menu/nangcap-php/lemp-change-ver-php.sh
    exit
fi

# Chuyen ten website thanh user name quan ly website
convert_to_username() {
    echo "$website" | sed 's/\./_/g'
}

# Goi ham va luu gia tri tra ve vao bien moi
webuser=$(convert_to_username "$website")
#echo "Original website: $website"
#echo "Converted webuser: $webuser"

for version in $(ls /etc/php/); do
    if [ -f /etc/php/$version/fpm/pool.d/${webuser}.conf ]; then
		echo "========================================================================="
        echo "Website $website dang chay ban PHP $version"
	    echo "========================================================================="
        break
    fi
done

# Hien thi cac phien ban PHP da cai
echo "========================================================================="
echo "Cac phien ban PHP co tren may:"
echo "========================================================================="
installed_versions=$(ls /etc/php/)

if [ -z "$installed_versions" ]; then
    echo "Khong co phien ban PHP nao duoc cai dat."
    lemp
else
    installed_versions_array=($(echo "$installed_versions" | sort -V))
    for i in "${!installed_versions_array[@]}"; do
        echo "$((i + 1)). PHP ${installed_versions_array[i]}"
    done
fi

echo "========================================================================="
# Nhap lua chon cua nguoi dung
read -p "Nhap so tuong ung voi phien ban PHP ban muon thay doi cho website $website: " choice

# Kiem tra lua chon hop le
if [[ "$choice" -lt 1 || "$choice" -gt ${#installed_versions_array[@]} ]]; then
    echo "Lua chon khong hop le! Vui long nhap lai."
    /etc/lemp/menu/nangcap-php/lemp-change-ver-php.sh
    exit
fi

# Lay phien ban PHP tu lua chon
php_version="${installed_versions_array[$((choice - 1))]}"
echo "Ban da chon PHP $php_version"

# Xac nhan thay doi voi nguoi dung
read -p "Ban co chac chan muon thay doi phien ban PHP cho website $website sang PHP $php_version khong? (y/N): " confirm

# Neu nguoi dung khong dong y thi thoat
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Ban da huy thao tac."
    exit
fi

# Xoa file .conf cua website hien tai
rm /etc/php/*/fpm/pool.d/${webuser}.conf

cat >> "/etc/php/${php_version}/fpm/pool.d/php-fpm.conf" <<END  
[global]
error_log = /home/lemp.demo/logs/php-fpm.log
emergency_restart_threshold = 10
emergency_restart_interval = 1m
process_control_timeout = 10s
events.mechanism = epoll
END

echo "Da them noi dung vao $conf_file"

# Kiem tra xem file cau hinh cho PHP da ton tai chua
if [ ! -f "/etc/php/${php_version}/fpm/pool.d/${webuser}.conf" ]; then
    # Tao file cau hinh moi neu chua ton tai
    cat > "/etc/php/${php_version}/fpm/pool.d/${webuser}.conf" << END
[${webuser}]
listen = /var/run/${webuser}.sock
user = ${webuser}
group = ${webuser}

listen.owner = ${webuser}
listen.group = www-data
listen.mode = 0660

pm = dynamic
pm.max_children = 33
pm.start_servers = 3
pm.min_spare_servers = 2
pm.max_spare_servers = 6
pm.max_requests = 500
pm.status_path = /php_status
request_terminate_timeout = 100s
pm.process_idle_timeout = 10s;
request_slowlog_timeout = 4s
slowlog = /home/lemp.demo/logs/php-fpm-slow.log
rlimit_files = 131072
rlimit_core = unlimited
catch_workers_output = yes
env[HOSTNAME] = \\$HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp
php_admin_value[error_log] = /home/lemp.demo/logs/php-fpm-error.log
php_admin_flag[log_errors] = on
php_value[session.save_handler] = files
END
    echo "Da them noi dung vao file cau hinh cho ${webuser}"
else
    echo "File cau hinh cho ${webuser} da ton tai. Khong them noi dung moi."
fi

# Restart dich vu PHP-FPM va Nginx

systemctl restart php${version}-fpm.service
systemctl restart php${php_version}-fpm.service
systemctl restart nginx.service
clear
echo "==========================================================================================================="
echo "Hoan tat viec thay doi phien ban PHP cho website $website sang ban PHP $php_version."
echo "==========================================================================================================="
lemp
