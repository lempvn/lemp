#!/bin/bash

# Danh sach cac phien ban PHP
php_versions=("7.0" "7.1" "7.2" "7.4" "8.0" "8.1" "8.2" "8.3")

# Hien thi cac phien ban da cai
echo "========================================================================="
echo "Cac phien ban PHP da cai tren may:"
echo "========================================================================="
installed_versions=$(dpkg --list | awk '/^ii[[:space:]]*php[0-9]+\.[0-9]+/ {print $2}' | sed 's/-.*//')
if [ -z "$installed_versions" ]; then
    echo "Khong co phien ban PHP nao duoc cai dat."
else
    echo "$installed_versions" | sort -u
fi

echo "========================================================================="
echo "Vui long chon phien ban PHP ban muon cai dat:"
for i in "${!php_versions[@]}"; do
    echo "$((i + 1)). PHP ${php_versions[i]}"
done

# Nhap lua chon cua nguoi dung
read -p "Nhap so tuong ung voi phien ban PHP ban muon cai dat: " choice

# Kiem tra lua chon hop le
if [[ "$choice" -lt 1 || "$choice" -gt ${#php_versions[@]} ]]; then
	echo "========================================================================="
    echo "Lua chon khong hop le! Vui long chon lai."
	echo "========================================================================="
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
    exit 1
fi

# Lay phien ban PHP tu lua chon
php_version="${php_versions[$((choice - 1))]}"

# Xac nhan voi nguoi dung
read -p "Ban co chac chan muon cai dat PHP phien ban $php_version khong? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Ban da huy cai dat."
    /etc/lemp/menu/tienich/lemp-tien-ich.sh
fi

# Cai dat PHP phien ban da chon
echo "Dang cai dat PHP phien ban $php_version..."
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install \
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
    libwww-perl \
    liblwp-protocol-https-perl \
    php"$php_version"-enchant \
    php"$php_version"-common \
    php"$php_version"-fpm \
    php"$php_version"-gd \
    php"$php_version"-mysql \
    php-pear \
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

clear
echo "========================================================================="
echo "Cai dat PHP phien ban $php_version thanh cong!"
echo "========================================================================="

lemp
