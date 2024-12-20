#!/bin/bash

# link huong dan cai dat
# https://github.com/cloudflare/quiche/tree/master/extras/nginx#readme

cd ~

install_nginx_quiche(){
cd ~ ; /etc/lemp/menu/nginx-quiche.sh
}

# cai dat cmake 3++ ####################################################################
# https://gist.github.com/1duo/38af1abd68a2c7fe5087532ab968574e
install_cmake(){
cd ~
cd /tmp
wget https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz
tar zxvf cmake-3.*
cd cmake-3.*
./bootstrap --prefix=/usr/local
make -j$(nproc)
make install
cmake --version
}

# cai dat rustup, cargo ####################################################################
# https://doc.rust-lang.org/cargo/getting-started/installation.html
# https://rustup.rs/
install_rustup(){
cd ~ ; curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# can rebot sau khi cai dat
}

#
. /opt/vps_lemp/script/lemp/nginx-setup.conf
echo $moduledir
#exit
echo "Install after 3s"
sleep 3

#
/opt/vps_lemp/script/lemp/menu/nginx-setup-download

#
Nginx_VERSION="1.16.1"

rm -rf $moduledir/nginx-${Nginx_VERSION}
rm -rf $moduledir/nginx-${Nginx_VERSION}.tar.gz 

cd $moduledir
curl -O https://nginx.org/download/nginx-${Nginx_VERSION}.tar.gz
tar xzvf nginx-${Nginx_VERSION}.tar.gz

#
cd ~
if [ ! -d $moduledir/quiche ]; then
yum -y install git
cd $moduledir
git clone --recursive https://github.com/cloudflare/quiche
cd ~
else
cd ~ ; cd $moduledir/quiche && git pull ; cd ~
fi

#
cd $moduledir/nginx-${Nginx_VERSION}

patch -p01 < ../quiche/extras/nginx/nginx-1.16.patch

./configure --group=nginx --user=nginx \
--pid-path=/var/run/nginx.pid \
--prefix=$PWD \
--sbin-path=/usr/sbin/nginx \
--build="quiche-$(git --git-dir=../quiche/.git rev-parse --short HEAD)" \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_v3_module \
--with-openssl=../quiche/deps/boringssl \
--with-quiche=../quiche \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-http_xslt_module \
--with-http_addition_module \
--with-http_dav_module \
--with-http_geoip_module \
--with-http_image_filter_module \
--with-http_perl_module \
--with-ld-opt="-Wl,-E" \
--with-mail \
--with-mail_ssl_module \
--with-http_gunzip_module \
--with-file-aio \
--with-pcre=$moduledir/${pcreVersionInstall} \
--with-pcre-jit \
--with-google_perftools_module \
--with-debug \
--with-zlib=$moduledir/${zlibversion} \
--conf-path=/etc/nginx/nginx.conf \
--with-http_gzip_static_module \
--with-threads \
--with-stream \
--with-stream_ssl_module \
--with-http_realip_module \
--add-module=$moduledir/ngx_http_concat \
--add-module=$moduledir/ngx_cache_purge-master \
--add-module=$moduledir/ngx_devel_kit-master \
--add-module=$moduledir/set-misc-nginx-module-master \
--add-module=$moduledir/srcache-nginx-module-master \
--add-module=$moduledir/ngx_http_substitutions_filter_module-master \
--add-module=$moduledir/headers-more-nginx-module-master \
--add-module=$moduledir/ngx_http_redis-0.3.8 

#
make
make install

if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
systemctl restart nginx.service
else
service nginx restart
fi

cd ~

#
sleep 1

clear
echo "========================================================================="
nginx -V
