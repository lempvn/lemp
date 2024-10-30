#!/bin/bash

# Thiet lap cau hinh bo nho dem Varnish
if [ ! -f /etc/default/varnish ]; then
    yes | cp -rf /etc/lemp/menu/varnish/sysconfig.txt /etc/default/varnish
fi
chmod 644 /etc/default/varnish

# Xoa dong dung luong cu
#sed -i -e "/VARNISH_STORAGE_SIZE=/d" /etc/default/varnish
# Xoa cac dong trong
#sed -i -e "/^$/d" /etc/default/varnish
# Xoa tat ca cac khoang trang o cuoi dong
#sed -i -e "s/ *$//" /etc/default/varnish

# Thay bang dong moi
checktruenumber='^[0-9]+$'

# Lay dung luong theo cau hinh cua nguoi dung
if [ -f /etc/lemp/varnish.storage ]; then
    varnish_size=$(cat /etc/lemp/varnish.storage)
else
    # Tinh dung luong Varnish cache dang su dung
    if [ -f /var/lib/varnish/varnish_storage.bin ]; then
        current_varnish_storage=$(ls -l /var/lib/varnish/varnish_storage.bin | awk '{print $5}')
        current_varnish_storage=$(($current_varnish_storage / 1024 / 1024 / 1024))
    else
        current_varnish_storage=0
    fi

    # Tinh toan dung luong o dia con dung
    disfree=$(df --block-size=1G / | awk 'NR==2 {print $4}')
    echo "Disk free: $disfree G"
    diskrecommended=$(($disfree / 2))  # Gia su ban muon de xuat 50% dung luong o dia mien phi

    varnish_size=$(($current_varnish_storage + $diskrecommended))
    varnish_size=$(($varnish_size - 3))
    echo "Disk cache recommended: ${varnish_size}G"
fi

if ! [[ $varnish_size =~ $checktruenumber ]]; then
    varnish_size=12
fi

# Ghi thong tin cau hinh vao tep /etc/default/varnish
cat > "/etc/default/varnish" << "END"
NFILES=131072
MEMLOCK=82000
NPROCS="unlimited"
RELOAD_VCL=1
VARNISH_VCL_CONF=/etc/varnish/default.vcl
VARNISH_LISTEN_PORT=80
VARNISH_ADMIN_LISTEN_ADDRESS=127.0.0.1
VARNISH_ADMIN_LISTEN_PORT=6082
VARNISH_SECRET_FILE=/etc/varnish/secret
VARNISH_MIN_THREADS=50
VARNISH_MAX_THREADS=5000
VARNISH_STORAGE_FILE=/var/lib/varnish/varnish_storage.bin
VARNISH_STORAGE_SIZE=${varnish_size}G
VARNISH_STORAGE="file,\${VARNISH_STORAGE_FILE},\${VARNISH_STORAGE_SIZE}"
VARNISH_TTL=120
DAEMON_OPTS="-a \${VARNISH_ADMIN_LISTEN_ADDRESS}:\${VARNISH_LISTEN_PORT} \
-f \${VARNISH_VCL_CONF} \
-T \${VARNISH_ADMIN_LISTEN_ADDRESS}:\${VARNISH_ADMIN_LISTEN_PORT} \
-p thread_pool_min=\${VARNISH_MIN_THREADS} \
-p thread_pool_max=\${VARNISH_MAX_THREADS} \
-S \${VARNISH_SECRET_FILE} \
-s \${VARNISH_STORAGE}"
END
