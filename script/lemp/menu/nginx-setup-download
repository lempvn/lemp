#!/bin/bash

. /opt/vps_lemp/script/lemp/nginx-setup.conf


echo "=========================================================================="
echo "Download Nginx Module ... "
echo "=========================================================================="

#
cd /usr/local/lemp

# /usr/local/lemp/echo-nginx-module
#rm -rf echo-nginx-module*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/echo-nginx-module.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/echo-nginx-module.zip echo-nginx-module.zip
unzip -oq echo-nginx-module.zip
rm -rf echo-nginx-module.zip

# /usr/local/lemp/ngx_http_substitutions_filter_module
rm -rf ngx_http_substitutions_filter_module*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/ngx_http_substitutions_filter_module.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/ngx_http_substitutions_filter_module.zip ngx_http_substitutions_filter_module.zip
unzip -oq ngx_http_substitutions_filter_module.zip
rm -rf ngx_http_substitutions_filter_module.zip

# /usr/local/lemp/ngx_cache_purge-master
rm -rf ngx_cache_purge*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/ngx_cache_purge.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/ngx_cache_purge.zip ngx_cache_purge.zip
unzip -oq ngx_cache_purge.zip

rm -rf ngx_cache_purge.zip
# /usr/local/lemp/headers-more-nginx-module
rm -rf headers-more-nginx-module*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/headers-more-nginx-module.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/headers-more-nginx-module-master.zip headers-more-nginx-module.zip
unzip -oq headers-more-nginx-module.zip
rm -rf headers-more-nginx-module.zip

# /usr/local/lemp/openssl-1.0.2h
#rm -rf ${opensslversion}
#wget -q --no-check-certificate https://lemp.com/script/lemp/module-nginx/${opensslversion}.tar.gz
if [ -f /opt/vps_lemp/script/lemp/module-nginx/${opensslversion}.tar.gz ]; then
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/${opensslversion}.tar.gz ${opensslversion}.tar.gz
else
wget -q --no-check-certificate https://www.openssl.org/source/${opensslversion}.tar.gz
fi
tar -xzxf ${opensslversion}.tar.gz
rm -rf ${opensslversion}.tar.gz

# $moduledir/${zlibversion}
rm -rf ${zlibversion}
#wget -q --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/${zlibversion}.tar.gz
if [ -f /opt/vps_lemp/script/lemp/module-nginx/${zlibversion}.tar.gz ]; then
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/${zlibversion}.tar.gz ${zlibversion}.tar.gz
else
wget -q --no-check-certificate https://www.zlib.net/${zlibversion}.tar.gz
fi
tar -xzxf ${zlibversion}.tar.gz
rm -rf ${zlibversion}.tar.gz

wget -q --no-check-certificate https://github.com/cloudflare/zlib/archive/gcc.amd64.zip -O zlib-cloudflare.zip
unzip -oq zlib-cloudflare.zip
rm -rf zlib-cloudflare.zip

# /usr/local/lemp/${pcreVersionInstall}
rm -rf ${pcreVersionInstall}
#wget -q --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/${pcreVersionInstall}.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/${pcreVersionInstall}.zip ${pcreVersionInstall}.zip
unzip -oq ${pcreVersionInstall}.zip
rm -rf ${pcreVersionInstall}.zip

# /usr/local/lemp/ngx_http_redis-0.3.8
rm -rf ngx_http_redis-0.3.8
#wget -q --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/ngx_http_redis-0.3.8.tar.gz
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/ngx_http_redis-0.3.8.tar.gz ngx_http_redis-0.3.8.tar.gz
tar -xzxf ngx_http_redis-0.3.8.tar.gz
rm -rf ngx_http_redis-0.3.8.tar.gz

# /usr/local/lemp/redis2-nginx-module
rm -rf redis2-nginx-module*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/redis2-nginx-module.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/redis2-nginx-module.zip redis2-nginx-module.zip
unzip -oq redis2-nginx-module.zip
rm -rf redis2-nginx-module.zip

# /usr/local/lemp/set-misc-nginx-module
rm -rf set-misc-nginx-module*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/set-misc-nginx-module.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/set-misc-nginx-module.zip set-misc-nginx-module.zip
unzip -oq set-misc-nginx-module.zip
rm -rf set-misc-nginx-module.zip

# /usr/local/lemp/ngx_devel_kit
rm -rf ngx_devel_kit*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/ngx_devel_kit.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/ngx_devel_kit.zip ngx_devel_kit.zip
unzip -oq ngx_devel_kit.zip
rm -rf ngx_devel_kit.zip

# /usr/local/lemp/ngx_http_concat
rm -rf ngx_http_concat
#wget -q --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/ngx_http_concat.tar.gz
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/ngx_http_concat.tar.gz ngx_http_concat.tar.gz
tar -xzxf ngx_http_concat.tar.gz
rm -rf ngx_http_concat.tar.gz

# /usr/local/lemp/srcache-nginx-module
rm -rf srcache-nginx-module*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/srcache-nginx-module.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/srcache-nginx-module-master.zip srcache-nginx-module.zip
unzip -oq srcache-nginx-module.zip
rm -rf srcache-nginx-module.zip

# /usr/local/lemp/memc-nginx-module
rm -rf memc-nginx-module*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/memc-nginx-module.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/memc-nginx-module.zip memc-nginx-module.zip
unzip -oq memc-nginx-module.zip
rm -rf memc-nginx-module.zip

# /usr/local/lemp/libatomic_ops-master
rm -rf libatomic_ops*
#wget --no-check-certificate https://lemp.echbay.com/script/lemp/module-nginx/libatomic_ops.zip
yes | cp -rf /opt/vps_lemp/script/lemp/module-nginx/libatomic_ops.zip libatomic_ops.zip
unzip -oq libatomic_ops.zip
rm -rf libatomic_ops.zip
# /usr/local/lemp/nginx-module-vts-master
#rm -rf nginx_module_vts*
#wget -q https://lemp.echbay.com/script/lemp/module-nginx/nginx_module_vts.tar.gz
#tar -xzxf nginx_module_vts.tar.gz
#rm -rf nginx_module_vts.tar.gz

cd /usr/local/lemp
#cai dat  nginx
wget -q http://nginx.org/download/nginx-${Nginx_VERSION}.tar.gz
tar -xzf nginx-${Nginx_VERSION}.tar.gz
#rm -rf /usr/local/lemp/nginx-${Nginx_VERSION}.tar.gz 
cd /usr/local/lemp/nginx-${Nginx_VERSION}
#sed -i 's/"Server: nginx"/"Server: Nginx-lemp"/g' /usr/local/lemp/nginx-${Nginx_VERSION}/src/http/ngx_http_header_filter_module.c
#sed -i 's/"Server: "/"Server: Nginx-lemp"/g' /usr/local/lemp/nginx-${Nginx_VERSION}/src/http/ngx_http_header_filter_module.c
#./configure --group=nginx --user=nginx \

. /opt/vps_lemp/script/lemp/nginx-setup.conf

echo $moduledir
echo $opensslversion
echo $withopensslopt
echo $zlibversion
echo $pcreVersionInstall
echo $Nginx_VERSION

./configure --user=www-data --group=www-data \
--pid-path=/var/run/nginx.pid \
--prefix=/usr/share/nginx \
--sbin-path=/usr/sbin/nginx \
--with-http_v2_module \
--with-http_ssl_module \
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
--with-zlib=$moduledir/${zlibversion} \
--with-openssl=$moduledir/${opensslversion} \
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
--add-module=$moduledir/set-misc-nginx-module-master --with-cc-opt="-Wno-error=implicit-fallthrough"


#
# cac module bi loi khi cai voi nginx
#--with-openssl-opt="enable-ec_nistp_64_gcc_128" \
#--with-openssl-opt="enable-tls1_3" \
#--add-module=$moduledir/redis2-nginx-module-master \
#--add-module=$moduledir/echo-nginx-module-master \
#--add-module=$moduledir/memc-nginx-module-master \
#--with-openssl-opt=$withopensslopt \


#--add-module=$moduledir/srcache-nginx-module-master --with-cc-opt="-Wno-error=pointer-sign" --with-cc-opt="-Wno-error=deprecated-declarations" \

#
make
sudo make install


# thu nghiem voi ngx_brotli
#/opt/vps_lemp/script/lemp/menu/ngx_brotli-download





mkdir -p /usr/share/nginx/modules






