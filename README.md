# PonWrt 固件云编译 (Airoha AN7581)

本分支用于云编译 [PonWrt](https://github.com/pbs05/ponwrt) 固件，目标设备为 Nokia XG-040G-MD (Airoha AN7581 平台)。

## 仓库结构

```
├── .github/workflows/
│   └── build-ponwrt.yml        # GitHub Actions 编译工作流
├── configs/
│   ├── nokia-xg-040g-md.config # 设备专用编译配置
│   └── release.config          # 公共发布配置 (与设备配置合并)
├── before-update-custom.sh     # feeds 更新前执行的自定义脚本
├── after-update-custom.sh      # feeds 更新后执行的自定义脚本
└── feeds.conf.default          # 自定义 feeds 源配置
```

## 编译流程

1. 克隆 PonWrt 源码 (`pbs05/ponwrt` master 分支)
2. 覆盖 feeds 配置并执行自定义脚本
3. 更新并安装 feeds
4. 使用 `kconfig.pl` 合并设备配置与发布配置
5. 编译固件并发布到 GitHub Release

## 触发方式

- **手动触发**: GitHub Actions 页面点击 "Run workflow"
- **定时编译**: 编辑 workflow 文件取消 `schedule` 注释

## 自定义配置

- 修改 `configs/nokia-xg-040g-md.config` 调整软件包和内核模块
- 修改 `configs/release.config` 调整公共配置项
- 修改 `after-update-custom.sh` 自定义默认 IP、DHCP 等
