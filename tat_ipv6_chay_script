#!/bin/bash

# Kiem tra trang thai cua IPv6
ipv6_status=$(sysctl net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')

# Neu IPv6 dang bat (ipv6_status = 0), tat no
if [ "$ipv6_status" -eq 0 ]; then
    echo "IPv6 dang bat. Dang tat IPv6..."
    # Vo hieu hoa IPv6
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sysctl -w net.ipv6.conf.lo.disable_ipv6=1
    echo "IPv6 da duoc tat."
    ipv6_status=1 # Cap nhat lai trang thai
else
    clear
    echo "========================================================================="
    echo "IPv6 da tat truoc do, khong can thay doi."
    lemp
fi

# Cap nhat cau hinh sysctl de ap dung thay doi sau khi khoi dong lai
if grep -q "net.ipv6.conf.all.disable_ipv6" /etc/sysctl.conf; then
    # Neu da co dong nay thi thay doi gia tri
    sed -i "s/net.ipv6.conf.all.disable_ipv6 = .*/net.ipv6.conf.all.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
    sed -i "s/net.ipv6.conf.default.disable_ipv6 = .*/net.ipv6.conf.default.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
    sed -i "s/net.ipv6.conf.lo.disable_ipv6 = .*/net.ipv6.conf.lo.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
else
    # Neu chua co thi them vao
    echo "net.ipv6.conf.all.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf
    echo "net.ipv6.conf.lo.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf
fi

# Ap dung lai cac thiet lap sysctl ngay lap tuc
sysctl -p > /dev/null 2>&1

echo "Qua trinh tat IPv6 da hoan tat."
