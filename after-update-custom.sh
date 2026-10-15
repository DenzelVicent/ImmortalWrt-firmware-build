#!/bin/sh
# Description: (After Update feeds)

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# Set DHCP IP Address start and end
# 默认无需显式配置: dnsmasq 包模板 package/network/services/dnsmasq/files/dhcp.conf
# （由 Makefile 装成 /etc/config/dhcp）出厂值为 start=100 / limit=150 / leasetime=12h，
# 即地址池 .100-.249 共 150 个。下面两行的作用只是把池扩满整个 /24（.2-.254）。
#sed -i "s/option start.*/option start \'2\'/g" package/network/services/dnsmasq/files/dhcp.conf
#sed -i "s/option limit.*/option limit \'253\'/g" package/network/services/dnsmasq/files/dhcp.conf
