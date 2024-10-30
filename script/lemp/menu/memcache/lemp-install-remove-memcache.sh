#!/bin/bash
if [ -f /etc/memcached.conf ]; then
	/etc/lemp/menu/memcache/lemp-remove-memcache.sh
else
	/etc/lemp/menu/memcache/lemp-install-memcache.sh
fi

