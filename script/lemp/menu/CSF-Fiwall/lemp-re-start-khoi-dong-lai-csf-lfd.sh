#!/bin/bash
systemctl restart lfd.service
systemctl restart csf.service
csf -r
clear
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh