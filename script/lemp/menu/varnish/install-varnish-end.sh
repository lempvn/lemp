#!/bin/bash

sleep 2

/etc/lemp/menu/varnish/disk-cache-varnish.sh

systemctl start varnish.service
systemctl enable varnish.service
systemctl restart varnish.service

varnishd -V

/etc/lemp/menu/varnish/install-varnish.sh
