#!/bin/bash

echo "change_php_config=1" > /tmp/change_php_config
echo "new_php_version=7.2" >> /tmp/change_php_config
echo "num_php_version=72" >> /tmp/change_php_config

/etc/lemp/menu/nangcap-php/setup-php-7-global.sh
