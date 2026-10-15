#!/bin/sh
# 阶段: ./scripts/feeds update -a 之前 (工作流步骤 "Load custom feeds", cwd = openwrt/)
# 用途: 往 feeds.conf.default 追加或放开第三方 feed 源
# 约束: feed 名只能用字母数字下划线 —— scripts/feeds 的解析正则里名字捕获组是 (\w+)、
#       不含连字符, 带 `-` 会在 feeds update 时报 "Syntax error in feeds.conf.default"
#       (2026-10-10 的 CI 失败即此因, 不是仓库格式问题)。
# 不在这里 clone 包: 非 feed 格式的第三方包必须等 feeds install 之后才 clone,
#       否则依赖解析不到、包会被 make defconfig 静默跳过, 见 clone-packages.sh。

# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> ./feeds.conf.default
# echo "src-git small https://github.com/kenzok8/small" >> ./feeds.conf.default
