#!/bin/bash

/etc/lemp/menu/varnish/disk-cache-varnish.sh

systemctl restart varnish.service

#varnishd -V
df -Th

/etc/lemp/menu/varnish/install-varnish.sh
