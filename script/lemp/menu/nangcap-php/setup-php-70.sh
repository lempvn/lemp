#!/bin/bash

echo "change_php_config=1" > /tmp/change_php_config
echo "new_php_version=7.0" >> /tmp/change_php_config
echo "num_php_version=70" >> /tmp/change_php_config

/etc/lemp/menu/nangcap-php/setup-php-7-global.sh
