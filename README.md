# PonWrt 固件云编译 (Airoha AN7581)

> 源码：[PonWrt](https://github.com/pbs05/ponwrt) | 基于 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt)

本仓库用于云编译 PonWrt 固件，当前编译目标为 Nokia XG-040G-MD (Airoha AN7581 平台)。

## 免责声明

PonWrt 是一个用于研究和开发的开源光猫固件项目。

刷写固件或修改 PON 相关配置存在风险，可能导致设备无法启动、配置或设备数据丢失、PON 无法注册等问题。操作前请务必备份原厂固件及设备相关数据。

使用者应自行确保相关操作符合当地法律法规及运营商相关规定。请勿将本项目用于未经授权的网络接入、冒用或复制他人设备身份，或干扰运营商网络正常运行。

因刷写、配置或使用本项目产生的设备故障、网络服务异常及其他后果，由使用者自行承担。

## 支持设备

| SoC | 设备 | Profile | 原厂校准/身份数据分区 |
| --- | --- | --- | --- |
| AN7581 | FiberHome HG5382A | `fiberhome_hg5382a` | `factory` |
| AN7581 | FiberHome HG5585F CT | `fiberhome_hg5585f-ct` | `factory` |
| AN7581 | FiberHome HG5585F CU | `fiberhome_hg5585f-cu` | `factory` |
| AN7581 | Gemtek XG2010G | `gemtek_xg2010g` | `dsd` |
| AN7581 | Nokia XG-040G-MD UBI | `nokia_xg-040g-md-ubi` | `bosa`、`ri` |
| AN7581 | Nokia XG-040G-TF UBI | `nokia_xg-040g-tf-ubi` | `bosa`、`ri` |
| AN7581 | UnionMan UNG00A | `unionman_ung00a` | `reservearea` |
| AN7581 | ZNXT ZN504XG-D | `znxt_zn504xg-d` | `reservearea` |
| AN7581 | ZNXT ZN515XG-D | `znxt_zn515xg-d` | `reservearea` |
| AN7583 | Nokia XG-040G-MF | `nokia_xg-040g-mf`、`nokia_xg-040g-mf-ubi` | `bosa`、`ri` |

## 默认配置

| 项目 | 值 |
| --- | --- |
| 管理地址 | `192.168.1.1` |
| CPU 架构 | `aarch64_cortex-a53` |
| 文件系统 | SquashFS + UBIFS |
| 包管理器 | APK (openssl) |
| 防火墙 | firewall4 + nftables (JSON) |
| DNS/DHCP | dnsmasq-full (DNSSEC、TFTP、Conntrack) |
| SSH | Dropbear |
| Web 服务 | uhttpd + LuCI (简体中文) |
| 网络加速 | BBR 拥塞控制 + CAKE 队列管理 + NFT Offload |
| VPN | WireGuard |
| 编译内核 | Linux 6.18 |

## 预装软件包

### LuCI 应用

| 软件包 | 说明 |
| --- | --- |
| `luci-app-autoreboot` | 定时重启 |
| `luci-app-firewall` | 防火墙管理 |
| `luci-app-hd-idle` | 硬盘休眠管理 |
| `luci-app-openclash` | Clash 代理管理 |
| `luci-app-package-manager` | 软件包管理 |
| `luci-app-pon` | PON 光猫管理 |
| `luci-app-samba4` | Samba 文件共享 |
| `luci-app-ttyd` | Web 终端 |
| `luci-app-upnp` | UPnP 管理 |

### PON 平台组件

| 软件包 | 说明 |
| --- | --- |
| `airoha-ponctl` | PON 控制工具 |
| `airoha-pond` | PON 守护进程 |
| `airoha-pon-debug` | PON 调试工具 |
| `airoha-en7581-npu-firmware` | EN7581 NPU 固件 |

### 内核模块

| 软件包 | 说明 |
| --- | --- |
| `kmod-wireguard` | WireGuard VPN |
| `kmod-tcp-bbr` | BBR 拥塞控制算法 |
| `kmod-sched-cake` | CAKE 队列管理 |
| `kmod-nft-offload` | NFT 硬件卸载 |
| `kmod-nft-tproxy` | NFT 透明代理 |
| `kmod-nft-bridge` | NFT 桥接 |
| `kmod-nf-flow` | 连接跟踪快路径 |
| `kmod-nf-conntrack-bridge` | 桥接连接跟踪 |
| `kmod-tun` | TUN/TAP 虚拟网络设备 |
| `kmod-mt7915e` | MediaTek MT7915 WiFi 驱动 |
| `kmod-usb3` / `kmod-usb-xhci-hcd` | USB 3.0 支持 |
| `kmod-fs-ext4` / `kmod-fs-exfat` / `kmod-fs-vfat` | 文件系统驱动 |
| `kmod-phy-airoha-en8811h` | Airoha EN8811H 2.5G PHY 驱动 |
| `kmod-phy-maxlinear` / `kmod-phy-realtek` | MaxLinear / Realtek PHY 驱动 |
| `kmod-airoha-en7572` / `kmod-airoha-xpon` / `kmod-airoha-paged-bosa` | Airoha PON 驱动 |

## 仓库结构

```
├── .github/workflows/
│   └── build-ponwrt.yml        # GitHub Actions 编译工作流
├── configs/
│   ├── an7581.config           # AN7581 平台完整配置 (本地编译用)
│   ├── nokia-xg-040g-md.config # Nokia XG-040G-MD 设备专用配置 (云编译用)
│   └── release.config          # 公共发布配置 (与设备配置合并)
├── before-update-custom.sh     # feeds 更新前执行的自定义脚本
├── after-update-custom.sh      # feeds 更新后执行的自定义脚本
└── feeds.conf.default          # 自定义 feeds 源配置
```

## 脚本说明

### `before-update-custom.sh`

在 feeds 更新**前**执行，用于修改 feeds 源。当前内容均为注释示例：

- 取消注释可启用 `helloworld` 等第三方 feed
- 可添加 PassWall、kenzok8 等软件源

### `after-update-custom.sh`

在 feeds 安装**后**、编译**前**执行，用于修改固件默认参数。当前内容均为注释示例：

- 取消注释 `sed` 行可修改默认 LAN IP（当前为 `192.168.1.1`）
- 可添加其他 `sed` 命令修改 DHCP、主机名等默认配置

### `feeds.conf.default`

覆盖源码自带的 feeds 源配置。除 ImmortalWrt 官方源外，额外包含：

- `pon_drivers` — Airoha PON 硬件驱动
- `pon_userspace` — Airoha PON 用户空间工具

## 云编译

### 编译流程

1. 释放 Runner 磁盘空间 (约 6GB)
2. 检出本仓库配置文件与脚本
3. 安装编译依赖工具链
4. 克隆 PonWrt 源码到 `/srcdir` (更大磁盘)
5. 缓存 `dl/` 下载目录 (按配置哈希，加速重复构建)
6. 覆盖 feeds 源，执行 `before-update-custom.sh`
7. 更新并安装 feeds
8. 加载 APK 仓库签名密钥 (可选，未配置则跳过)
9. `kconfig.pl +` 合并设备配置与发布配置 → `make defconfig`
10. 执行 `after-update-custom.sh` 修改默认参数
11. 预下载软件包源码 (`make download`)
12. 并行编译固件 (失败自动回退单线程)
13. 收集固件镜像，发布到 GitHub Release
14. 清理旧 workflow runs (保留 7 天 / 至少 3 条) 和旧 Release (保留最近 3 个)

### 触发方式

- **手动触发**: GitHub Actions 页面点击 "Run workflow"
- **定时编译**: 编辑 workflow 文件取消 `schedule` 注释 (UTC 时间)

### 配置合并规则

云编译使用 `kconfig.pl +` 合并两个配置文件：

```
kconfig.pl + configs/nokia-xg-040g-md.config configs/release.config > .config
```

- `nokia-xg-040g-md.config` — 设备级配置：目标平台、软件包选择、内核模块
- `release.config` — 公共配置：通用网络加速模块 (WireGuard、BBR、CAKE 等)
- **同名配置项以 `release.config` 为准**

### 自定义配置

- 修改 `configs/nokia-xg-040g-md.config` 调整软件包和内核模块
- 修改 `configs/release.config` 调整公共配置项
- 修改 `after-update-custom.sh` 自定义默认 IP、DHCP 等
- 修改 `.github/workflows/build-ponwrt.yml` 的 `env` 段切换设备或源码分支

## 本地编译

```sh
# 安装编译所需的工具链和库
sudo bash -c 'bash <(curl -s https://build-scripts.immortalwrt.org/init_build_environment.sh)'

# 拉取源码
git clone https://github.com/pbs05/ponwrt.git
cd ponwrt

# 更新并安装 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 选择配置 (以 AN7581 为例)
cp configs/an7581.config .config
# 若目标是 AN7583，改用: cp configs/an7583.config .config

# 开始编译
make defconfig
make -j$(nproc)
```

固件位于 `bin/targets/airoha/an7581/` 或 `bin/targets/airoha/an7583/`。

## 刷入

使用 [AN758x-Stock2UBI](https://github.com/pbs05/an758x-stock2ubi) 备份原厂闪存并安装 UBI 布局。启动镜像和 Web 恢复界面由 [AN758x U-Boot](https://github.com/pbs05/uboot-an758x) 提供。

刷入 PonWrt 后，通过 U-Boot Web 或 LuCI 的"网络 → PON → 配置 → PON board data"恢复原厂校准和身份数据。烽火 `factory` 需要先使用 [FiberHome Factory](https://github.com/pbs05/fiberhome-factory) 转换；转换后的烽火数据、`reservearea` 和 `dsd` 写入 PonWrt 的 `factory` 卷；Nokia 的 `bosa` 和 `ri` 写入同名卷。
