#!/bin/sh

cd ~

sudo curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

/etc/lemp/menu/tienich/lemp-tien-ich.sh
