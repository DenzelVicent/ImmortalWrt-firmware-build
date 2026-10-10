#!/bin/sh
# Description: (Before Update feeds)


# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> ./feeds.conf.default
# echo "src-git small https://github.com/kenzok8/small" >> ./feeds.conf.default

# 第三方包克隆已移至工作流的 "Clone custom packages" 步骤
# (在 feeds install 之后执行, 确保 luci-base 等 feed 包已安装, 依赖可解析)
