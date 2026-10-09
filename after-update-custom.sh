#!/bin/sh
# Description: (After Update feeds)

# Modify default IP (取消注释并修改为你需要的地址)
 sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
