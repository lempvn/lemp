#!/bin/bash

if [ ! -d /usr/local/lemp/ngx_brotli ]; then
#mkdir -p /usr/local/lemp/ngx_brotli
git clone https://github.com/google/ngx_brotli.git
cd ngx_brotli
git submodule update --init --recursive
else
cd ~ ; cd /usr/local/lemp/ngx_brotli && git pull ; cd ~
fi
