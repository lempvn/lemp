#!/bin/bash

. /home/lemp.conf
    rm -rf /tmp/*list*
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 2
   cd /home
find . -type f -print0 | xargs -0 du | sort -n | tail -5 | cut -f2 | xargs -I{} du -sh {} > /tmp/listfile
find . -type d -print0 | xargs -0 du | sort -n | tail -5 | cut -f2 | xargs -I{} du -sh {} > /tmp/listfolder
cd
clear
echo "========================================================================="
echo "5 File Lon Nhat Trong /home:"
echo "-------------------------------------------------------------------------"
cat /tmp/listfile
echo "-------------------------------------------------------------------------"
echo "5 Folder Lon Nhat Trong /home:"
cat /tmp/listfolder
rm -rf /tmp/*list*
/etc/lemp/menu/tienich/lemp-tien-ich.sh
