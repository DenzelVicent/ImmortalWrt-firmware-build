# ImmortalWrt 固件云编译

> MT7981 源码：[Hanwckf's ImmortalWrt](https://github.com/hanwckf/immortalwrt-mt798x) | [U-Boot](https://github.com/hanwckf/bl-mt798x)  
> AN7581 源码：[ImmortalWrt](https://github.com/DenzelVicent/ponwrt)

本项目利用 GitHub Actions 编译 ImmortalWrt 固件，支持 MT7981 和 AN758x 两大平台。

## 分支结构

| 分支 | 说明 | 配置文件 |
|---|---|---|
| `master` | 总览分支，存放所有工作流模板（不存放设备配置） | — |
| `AN7581` | AN758x 平台三个编译目标（XGS-PON 与 GPON）合并在同一分支 | `an7581.config`、`an7581-gpon.config`、`an7583-gpon.config` |
| `MT7981-hanwckf` | MT7981 平台固件 + U-Boot | `mt7981.config` |

> 2026-10-15 起原 `AN7581-GPON` / `AN7583-GPON` 两个分支并入 `AN7581`：三份设备配置和三份工作流
> 全部保留、不合并（各工作流只读自己那份配置，cache key 的 `hashFiles` 参数是字面量，并一会让
> 改一台设备连带失效另两台的缓存），只有 README 合成一份。要编哪台设备，在 Actions 页面选对应工作流。

## 编译工作流

| 工作流 | 所在分支 | 说明 | 触发方式 |
|---|---|---|---|
| `build-mt7981-immortalwrt.yml` | MT7981-hanwckf / master | 编译 MT7981 平台路由器 ImmortalWrt 固件 | 手动触发 (`workflow_dispatch`) |
| `build-mt7981-u-boot.yml` | MT7981-hanwckf / master | 并行编译 MT7981 平台所有板型变体的 U-Boot 引导加载器 | 手动触发 (`workflow_dispatch`) |
| `build-an7581-immortalwrt.yml` | AN7581 / master | 编译 AN7581 平台光猫固件 (XGS-PON)，源码分支 `REPO_BRANCH=master` | 手动触发 (`workflow_dispatch`) |
| `build-an7581-gpon-immortalwrt.yml` | AN7581 / master | 编译 AN7581 平台光猫固件 (GPON)，源码分支 `REPO_BRANCH=AN7581-GPON` | 手动触发 (`workflow_dispatch`) |
| `build-an7583-gpon-immortalwrt.yml` | AN7581 / master | 编译 AN7583 平台光猫固件 (GPON)，源码分支 `REPO_BRANCH=AN7583-GPON` | 手动触发 (`workflow_dispatch`) |

> `REPO_BRANCH` 写死在各工作流的 `env` 段（指向 PonWrt 源码仓库的分支），不由本仓库分支名推导；
> 这三份副本留在 master 是因为非默认分支的工作流必须先在默认分支存在才能手动运行。

## MT7981 平台默认配置

- **默认 LAN IP**: `10.0.0.1`
- **DHCP 范围**: `10.0.0.100` – `10.0.0.249`（dnsmasq 出厂模板的 `start=100` / `limit=150`；`set-firmware-defaults.sh` 里把池扩满整个 /24 的两行 `sed` 处于注释状态，无需显式配置）

## AN758x 平台默认配置

- **默认 LAN IP**: `192.168.1.1`（三个编译目标一致；`AN7581` 分支 `set-firmware-defaults.sh` 里改 IP 的 `sed` 行处于注释状态）
- **包管理器**: APK (openssl)，文件系统 SquashFS + UBIFS
- **编译内核**: Linux 6.18

## MT7981 平台预装插件

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

## AN758x 平台预装插件

三个编译目标（AN7581 XGS-PON / AN7581 GPON / AN7583 GPON）的插件清单一致，仅 NPU 固件包按 SoC 区分。

| 插件 | 说明 |
|---|---|
| `luci-app-adguardhome` | AdGuard Home DNS 过滤（同时预装 `adguardhome` 核心） |
| `luci-app-airoha-npu` | Airoha NPU 硬件加速管理（AN7581 配 `airoha-en7581-npu-firmware`，AN7583 配 `airoha-an7583-npu-firmware`） |
| `luci-app-autoreboot` | 定时自动重启 |
| `luci-app-firewall` | 防火墙管理 |
| `luci-app-hd-idle` | USB 硬盘自动休眠 |
| `luci-app-lucky` | Lucky 多合一工具（端口转发、DDNS、反向代理） |
| `luci-app-openclash` | OpenClash 代理客户端（LuCI 界面，内核需首次启动后下载） |
| `luci-app-package-manager` | 软件包管理 |
| `luci-app-pon` | PON 光猫管理（同时预装 `airoha-ponctl` / `airoha-pond` / `airoha-pon-debug`） |
| `luci-app-samba4` | Samba4 文件共享服务 |
| `luci-app-ttyd` | 网页终端（浏览器访问路由器 Shell） |
| `luci-app-upnp` | UPnP 自动端口映射 |
| `luci-theme-argon` | Argon 主题（`luci-theme-bootstrap` 一并保留） |

> 除 `luci-app-lucky` 与 `luci-app-airoha-npu` 外，上表都来自源码分支自带的 feeds。
> 这两个不在任何 feed 内，改由各分支的 `clone-packages.sh` 在工作流 "Clone custom packages"
> 步骤（`./scripts/feeds install -a` 之后、`make defconfig` **之前**）`git clone` 到 `package/`——
> 顺序反了 kconfig 不会报错，只会静默不打包这两个界面（见提交 `77684b6`）。清单以各设备配置文件里的
> `CONFIG_PACKAGE_luci-app-*=y` 为准，本地编译时同样要先克隆再 `make defconfig`。
>
> 每个 `luci-app-*` 都配套 `luci-i18n-<app>-zh-cn`，简体中文界面随镜像内置。

## 支持的设备

### MT7981 平台 - 固件 (ImmortalWrt)

| 设备 | 配置标识符 | 变体 |
|---|---|---|
| 小米 AX3000T | `xiaomi_mi-router-ax3000t` | 标准版、stock 版、AN8855 版、AN8855-stock 版 |
| CMCC RAX3000M | `cmcc_rax3000m` | SPI-NAND 版、eMMC 版 |

### MT7981 平台 - U-Boot

| 板型 | `BOARD` 值 | SoC |
|---|---|---|
| 小米 AX3000T | `ax3000t` | MT7981 |
| 小米 AX3000T (AN8855) | `ax3000t_an8855` | MT7981 |
| CMCC RAX3000M (SPI-NAND) | `cmcc_rax3000m` | MT7981 |
| CMCC RAX3000M (eMMC) | `cmcc_rax3000m-emmc` | MT7981 |

### AN7581 平台 - 固件 (ImmortalWrt)

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

## 自定义编译

如需自定义固件配置，请克隆本仓库并根据需求进行修改。

主要定制入口：

| 文件 | 用途 |
|---|---|
| `an7581.config` / `an7581-gpon.config` / `an7583-gpon.config`（均在 `AN7581` 分支根目录）、`mt7981.config`（在 `MT7981-hanwckf` 分支根目录） | 按设备型号命名的 OpenWrt menuconfig 配置，master 不存放配置文件 — 定义目标设备、内核选项、软件包；工作流复制成 `openwrt/.config` 并按触发表的缓存开关追加 `CONFIG_CCACHE=y`（四份固件编译工作流都带 `use_dl_cache` / `use_ccache` 两个开关）；缓存 key 的前缀取自工作流 env 的 `CONFIG_NAME`，`an7581-` / `an7581-gpon-` / `an7583-gpon-` / `mt7981-` 四组前缀互不为前缀，同一分支上的多份工作流才不会恢复到彼此的缓存；改设备名要同步 `CONFIG_FILE`、`CONFIG_NAME` 和 key 里 `hashFiles` 的字面文件名（该参数不接受变量）；开关关掉时对应的 `Clear ... cache if disabled` 步骤会从 Actions 缓存存储里删除旧条目 |
| `add-feed-sources.sh` | feeds 更新**前**执行的钩子脚本 — 增删第三方软件源（改 `feeds.conf.default`）。feed 名只能用字母、数字、下划线，带连字符会让 `feeds update` 报语法错误 |
| `clone-packages.sh` | feeds 安装**后**、`make defconfig` **前**执行的钩子脚本 — clone 非 feed 格式的第三方包到 `package/<包名>/`。位置是硬约束：提前 clone 时 `+luci-base` 这类 feed 依赖解析不了，`make defconfig` 会静默跳过整包（编译不报错，见提交 `77684b6`）。AN7581 分支预置 `luci-app-lucky` + `luci-app-airoha-npu`，MT7981-hanwckf 分支只有 `luci-app-lucky` |
| `set-firmware-defaults.sh` | `make defconfig` **后**、编译**前**执行的钩子脚本 — 用 `sed` 改源码树里会被装进 rootfs 的文件，即固件的出厂默认值（恢复出厂和 `sysupgrade -n` 后仍是这里的值）。AN758x 三个编译目标共用一份，改动对三份产出同时生效；MT7981 分支把默认 LAN IP 改成 `10.0.0.1`，AN7581 分支该行保持注释 |
| `feeds.conf.default` | （可选）覆盖默认 feeds 软件源 |
| `files/` | （可选）预置文件目录，将文件覆盖到固件根文件系统 |

## 编译指南参考

详细编译说明请参考：[hanwckf ImmortalWrt MT798x 编译说明](https://cmi.hanwckf.top/p/immortalwrt-mt798x/)

## 许可证

本项目依据 Apache 2.0 许可证进行授权。有关详细信息，请参阅 [LICENSE](LICENSE) 文件。
