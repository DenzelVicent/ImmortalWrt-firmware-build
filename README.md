# PonWrt 固件云编译 (Airoha AN7581)

> 源码：[PonWrt](https://github.com/pbs05/ponwrt) | 基于 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt)

本仓库用于云编译 PonWrt 固件，目标设备为 Nokia XG-040G-MD (Airoha AN7581 平台)。

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

## 云编译

### 仓库结构

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

### 编译流程

1. 克隆 PonWrt 源码 (`pbs05/ponwrt` master 分支)
2. 覆盖 feeds 配置并执行自定义脚本
3. 更新并安装 feeds
4. 使用 `kconfig.pl` 合并设备配置与发布配置
5. 编译固件并发布到 GitHub Release

### 触发方式

- **手动触发**: GitHub Actions 页面点击 "Run workflow"
- **定时编译**: 编辑 workflow 文件取消 `schedule` 注释

### 自定义配置

- 修改 `configs/nokia-xg-040g-md.config` 调整软件包和内核模块
- 修改 `configs/release.config` 调整公共配置项
- 修改 `after-update-custom.sh` 自定义默认 IP、DHCP 等

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
