# ImmortalWrt 固件云编译

## 项目概述

本项目通过 GitHub Actions 云编译多平台路由器/光猫固件，基于 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 及其衍生源码。仓库按设备平台划分为独立分支，各分支自行维护编译配置、自定义脚本和工作流，互不干扰。

## 分支说明

| 分支 | 平台 | 源码 | 支持设备 |
|---|---|---|---|
| **MT7981-hanwckf** | MediaTek MT7981 | [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) | 小米 AX3000T、CMCC RAX3000M |
| **AN7581** | Airoha AN7581 | [pbs05/ponwrt](https://github.com/pbs05/ponwrt) | Nokia XG-040G-MD 等 PON 光猫 |

### MT7981-hanwckf

基于 hanwckf 的 ImmortalWrt MT798x 源码，编译路由器固件及 U-Boot 引导加载器。

支持设备：
- **小米 AX3000T**（标准版 / stock 版 / AN8855 交换芯片版）
- **CMCC RAX3000M**（SPI-NAND 版 / eMMC 版）

编译工作流：
| 工作流 | 说明 |
|---|---|
| `build-mt7981-immortalwrt.yml` | 编译 ImmortalWrt 固件 |
| `build-mt7981-u-boot.yml` | 编译 U-Boot 引导加载器 |

### AN7581

基于 PonWrt 源码，编译 Airoha AN7581/AN7583 平台 PON 光猫固件。

支持设备：
- Nokia XG-040G-MD / XG-040G-TF
- FiberHome HG5382A / HG5585F
- Gemtek XG2010G
- UnionMan UNG00A
- ZNXT ZN504XG-D / ZN515XG-D
- Nokia XG-040G-MF (AN7583)

编译工作流：
| 工作流 | 说明 |
|---|---|
| `build-an7581-ponwrt.yml` | 编译 PonWrt PON 光猫固件 |

## 如何选择分支

- 如果你的设备是 **MT7981 平台路由器**（小米 AX3000T、CMCC RAX3000M），切换到 `MT7981-hanwckf` 分支
- 如果你的设备是 **AN7581/AN7583 平台 PON 光猫**（Nokia XG-040G-MD 等），切换到 `AN7581` 分支
- 各分支的 README 包含该平台的详细配置说明和编译指南

## 许可证

本项目依据 Apache 2.0 许可证进行授权。有关详细信息，请参阅 [LICENSE](LICENSE) 文件。
