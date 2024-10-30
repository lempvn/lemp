#!/bin/bash

if [ ! -f /etc/lemp/varnish.version ]; then
touch /etc/lemp/varnish.version
fi

chown -R root:root /etc/lemp/varnish.version
chmod 644 /etc/lemp/varnish.version
> /etc/lemp/varnish.version
