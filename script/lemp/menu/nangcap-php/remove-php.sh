#!/bin/bash

# Hien thi cac phien ban PHP da cai
echo "=================================================================================================="
echo "Ban dang thao tac go cai dat PHP tren he thong!"
echo "=================================================================================================="
echo "Luu y: "
echo "--------------------------------------------------------------------------------------------------"
echo "Ban khong the go cai dat PHP 8.2 vi day la phien ban PHP mac dinh chay LEMP tren he thong!"
echo "--------------------------------------------------------------------------------------------------"
echo "Ban nen xem lai con Website nao dang chay tren phien ban PHP ban dinh xoa hay khong neu con "
echo "ban nen thay doi phien ban PHP tren website do qua phien ban khac roi moi thao tac go cai dat PHP."
echo "--------------------------------------------------------------------------------------------------"
echo "=================================================================================================="
echo "List cac phien ban PHP co tren may:"
echo "=================================================================================================="
installed_versions=$(ls /etc/php/)

if [ -z "$installed_versions" ]; then
    echo "Khong co phien ban PHP nao duoc cai dat."
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
else
    installed_versions_array=($(echo "$installed_versions" | sort -V))
    for i in "${!installed_versions_array[@]}"; do
        echo "$((i + 1)). PHP ${installed_versions_array[i]}"
    done
fi

echo "========================================================================="
# Nhap lua chon cua nguoi dung
read -p "Nhap so tuong ung voi phien ban PHP ban muon go cai dat: " choice

# Kiem tra lua chon hop le
if [[ "$choice" -lt 1 || "$choice" -gt ${#installed_versions_array[@]} ]]; then
    echo "Lua chon khong hop le! Vui long chon lai."
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
    exit
fi

# Lay phien ban PHP tu lua chon
php_version="${installed_versions_array[$((choice - 1))]}"
echo "==========================================================================="
echo "Ban da chon PHP $php_version"
echo "==========================================================================="

if [[ "$php_version" == "8.2" ]]; then
    echo "Ban khong the go cai dat PHP 8.2 neu go thi LEMP se khong hoat dong!"
	echo "==========================================================================="
	echo "Vui long go cai dat phien ban PHP khac ngoai PHP 8.2."
	echo "==========================================================================="
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
fi

# Xac nhan thay doi voi nguoi dung
read -p "Ban co chac chan muon go cai dat phien ban PHP tren he thong khong? (y/N): " confirm

clear

# Cai dat PHP phien ban da chon
echo "========================================================================="
echo "Dang tien hanh go cai dat PHP phien ban $php_version tren he thong..."
echo "========================================================================="
echo "Vui long khong thoat chuong trinh cho den khi go cai dat xong!"
echo "========================================================================="
sleep 3
sudo DEBIAN_FRONTEND=noninteractive apt -yqq purge \
    php"$php_version" \
    php"$php_version"-curl \
    php"$php_version"-zip \
    php"$php_version"-soap \
    php"$php_version"-cli \
    php"$php_version"-snmp \
    php"$php_version"-pspell \
    php"$php_version"-gmp \
    php"$php_version"-ldap \
    php"$php_version"-bcmath \
    php"$php_version"-intl \
    php"$php_version"-imap \
    php"$php_version"-enchant \
    php"$php_version"-common \
    php"$php_version"-fpm \
    php"$php_version"-gd \
    php"$php_version"-mysql \
    php"$php_version"-opcache \
    php"$php_version"-pdo \
    php"$php_version"-xml \
    php"$php_version"-mbstring \
    php"$php_version"-xmlrpc \
    php"$php_version"-tidy \
    php"$php_version"-memcache \
    php"$php_version"-redis \
    php"$php_version"-memcached \
    php"$php_version"-imagick

rm -rf /etc/php/${php_version}
clear

echo "========================================================================="
echo "Go cai dat PHP $php_version thanh cong!"
echo "========================================================================="

lemp
