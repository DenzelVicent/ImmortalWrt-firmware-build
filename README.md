# ImmortalWrt MT7981 路由器固件编译

> 源码：[Hanwckf's ImmortalWrt](https://github.com/hanwckf/immortalwrt-mt798x) | [U-Boot](https://github.com/hanwckf/bl-mt798x)

本项目利用 GitHub Actions 编译 ImmortalWrt 固件及相应的 U-Boot。
支持一次性编译以下 MT7981 平台路由器的固件：

- **小米 AX3000T**（标准版 / stock 版 / AN8855 交换芯片版）
- **CMCC RAX3000M**（SPI-NAND 版 / eMMC 版）

## 编译工作流

| 工作流 | 说明 | 触发方式 |
|---|---|---|
| `build-immortalwrt.yml` | 编译所有支持设备的 ImmortalWrt 固件 | 手动触发 (`workflow_dispatch`) |
| `build-u-boot.yml` | 并行编译所有板型变体的 U-Boot 引导加载器 | 手动触发 (`workflow_dispatch`) |

## 默认配置

- **默认 LAN IP**: `10.0.0.1`
- **DHCP 范围**: `10.0.0.2` – `10.0.0.56`

## 预装插件

| 插件 | 说明 |
|---|---|
| `luci-app-openclash` | OpenClash 代理客户端（LuCI 界面，内核需首次启动后下载） |
| `luci-app-samba4` | Samba4 文件共享服务 |
| `luci-app-hd-idle` | USB 硬盘自动休眠 |
| `luci-app-ttyd` | 网页终端（浏览器访问路由器 Shell） |
| `luci-app-autoreboot` | 定时自动重启 |
| `luci-app-turboacc-mtk` | MTK Turbo ACC 网络加速 |
| `luci-app-eqos-mtk` | MTK QoS 带宽控制 |
| `luci-app-mtwifi-cfg` | MTK WiFi 配置 |
| `luci-app-upnp` | UPnP 自动端口映射 |
| `luci-theme-argon` | Argon 主题 |

## 支持的设备

### 固件 (ImmortalWrt)

| 设备 | 配置标识符 | 变体 |
|---|---|---|
| 小米 AX3000T | `xiaomi_mi-router-ax3000t` | 标准版、stock 版、AN8855 版、AN8855-stock 版 |
| CMCC RAX3000M | `cmcc_rax3000m` | SPI-NAND 版、eMMC 版 |

### U-Boot

| 板型 | `BOARD` 值 | SoC |
|---|---|---|
| 小米 AX3000T | `ax3000t` | MT7981 |
| 小米 AX3000T (AN8855) | `ax3000t_an8855` | MT7981 |
| CMCC RAX3000M (SPI-NAND) | `cmcc_rax3000m` | MT7981 |
| CMCC RAX3000M (eMMC) | `cmcc_rax3000m-emmc` | MT7981 |

## 自定义编译

如需自定义固件配置，请克隆本仓库并根据需求进行修改。

主要定制入口：

| 文件 | 用途 |
|---|---|
| `.config` | OpenWrt menuconfig 配置 — 定义目标设备、内核选项、WiFi 驱动特性及包含的软件包 |
| `before-update-custom.sh` | feeds 更新前执行的钩子脚本 — 在此添加自定义软件源 |
| `after-update-custom.sh` | feeds 更新后执行的钩子脚本 — 修改默认 IP、DHCP 范围等 |
| `feeds.conf.default` | （可选）覆盖默认 feeds 软件源 |
| `files/` | （可选）预置文件目录，将文件覆盖到固件根文件系统 |

## 编译指南参考

详细编译说明请参考：[hanwckf ImmortalWrt MT798x 编译说明](https://cmi.hanwckf.top/p/immortalwrt-mt798x/)

## 许可证

本项目依据 Apache 2.0 许可证进行授权。有关详细信息，请参阅 [LICENSE](LICENSE) 文件。
