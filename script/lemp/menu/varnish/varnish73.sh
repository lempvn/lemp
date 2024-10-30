#!/bin/bash

# https://packagecloud.io/varnishcache
# https://packagecloud.io/varnishcache/varnish73/packages/ubuntu/bionic/varnish_7.3.2-1~bionic_amd64.deb?distro_version_id=190

/etc/lemp/menu/varnish/install-varnish-begin.sh
echo "7.3" >> /etc/lemp/varnish.version

# Xac dinh phien ban cua Ubuntu
OS_VERSION=$(lsb_release -c | awk '{print $2}')

# Kiem tra va cai dat kho Varnish
if [ "$OS_VERSION" == "jammy" ]; then
    echo "Cai dat kho Varnish cho Ubuntu Jammy..."
    curl -s https://packagecloud.io/install/repositories/varnishcache/varnish73/script.deb.sh | sudo bash
    echo "Cai dat Varnish 7.3.2 cho Ubuntu Jammy..."
    sudo apt-get install varnish=7.3.2-1~jammy
elif [ "$OS_VERSION" == "focal" ]; then
    echo "Cai dat kho Varnish cho Ubuntu Focal..."
    curl -s https://packagecloud.io/install/repositories/varnishcache/varnish73/script.deb.sh | sudo bash
    echo "Cai dat Varnish 7.3.2 cho Ubuntu Focal..."
    sudo apt-get install varnish=7.3.2-1~focal
elif [ "$OS_VERSION" == "bionic" ]; then
    echo "Cai dat kho Varnish cho Ubuntu Bionic..."
    curl -s https://packagecloud.io/install/repositories/varnishcache/varnish73/script.deb.sh | sudo bash
    echo "Cai dat Varnish 7.3.2 cho Ubuntu Bionic..."
    sudo apt-get install varnish=7.3.2-1~bionic
else
    echo "Phien ban Ubuntu khong ho tro: $OS_VERSION"
    exit 1
fi

echo "Hoan tat cai dat Varnish!"

/etc/lemp/menu/varnish/install-varnish-end.sh