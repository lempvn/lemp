#!/bin/bash
echo "Please wait....";sleep 1
touch /var/cache/ngx_pagespeed/cache.flush
clear
echo "========================================================================= "
echo "Clear Pagespeed cache thanh cong."
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
