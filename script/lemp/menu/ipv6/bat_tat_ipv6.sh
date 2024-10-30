#!/bin/bash

# Kiểm tra trạng thái của IPv6
ipv6_status=$(sysctl net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')

if [ "$ipv6_status" -eq 0 ]; then
    echo -n "IPv6 dang bat. Ban co muon tat IPv6 khong? (y/N): "
    read -r choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "-----------------------------------------------------------------"
        echo "Dang tat IPv6..."
        sleep 1
        # Vô hiệu hóa IPv6
        sysctl -w net.ipv6.conf.all.disable_ipv6=1
        sysctl -w net.ipv6.conf.default.disable_ipv6=1
        sysctl -w net.ipv6.conf.lo.disable_ipv6=1
        echo "-----------------------------------------------------------------"
        echo "IPv6 đã được tắt."
        ipv6_status=1 # Cập nhật lại trạng thái
    else
		clear
        echo "-----------------------------------------------------------------"
        echo "Khong thuc hien thay doi. IPv6 van dang bat."
		lemp
    fi
else
    echo -n "IPv6 dang tat. Ban co muon bat IPv6 khong? (y/N): "
    read -r choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "-----------------------------------------------------------------"
        echo "Dang bat IPv6..."
        sleep 1
        # Bật IPv6
        sysctl -w net.ipv6.conf.all.disable_ipv6=0
        sysctl -w net.ipv6.conf.default.disable_ipv6=0
        sysctl -w net.ipv6.conf.lo.disable_ipv6=0
        echo "-----------------------------------------------------------------"
        echo "IPv6 da duoc bat."
        ipv6_status=0 # Cập nhật lại trạng thái
    else
		clear
        echo "-----------------------------------------------------------------"
        echo "Khong thuc hien thay doi. IPv6 van dang tat."
		lemp
    fi
fi

# Cập nhật cấu hình sysctl
if grep -q "net.ipv6.conf.all.disable_ipv6" /etc/sysctl.conf; then
    # Nếu đã có dòng này thì thay đổi giá trị
    sed -i "s/net.ipv6.conf.all.disable_ipv6 = .*/net.ipv6.conf.all.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
    sed -i "s/net.ipv6.conf.default.disable_ipv6 = .*/net.ipv6.conf.default.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
    sed -i "s/net.ipv6.conf.lo.disable_ipv6 = .*/net.ipv6.conf.lo.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
else
    # Nếu chưa có thì thêm vào
    echo "net.ipv6.conf.all.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf 
    echo "net.ipv6.conf.default.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf 
    echo "net.ipv6.conf.lo.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf 
fi

# Áp dụng lại các thiết lập sysctl
sysctl -p > /dev/null 2>&1

echo "-----------------------------------------------------------------"
echo "Qua trinh cap nhat hoan tat."
echo "-----------------------------------------------------------------"
lemp