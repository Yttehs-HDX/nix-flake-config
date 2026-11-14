# Niri + Dux 桌面

当前桌面只使用 niri 与 Dux：旧的 Rofi、Waybar、SwayNC、Swaylock、SwayOSD、Swayidle、Awww、Swww、Cliphist、Rofimoji、Swappy、Omasnap、Screen-pin、Window-menu、Hexecute、OCR、udiskie、SDDM 及相关主题和本地包定义已全部删除。

## 组件选择

| 位置 | 职责 |
| --- | --- |
| `home/shetty/laptop.nix` | 用户 profile，选择桌面组合 |
| `home/shetty/default.nix` | 用户通用应用组合 |
| `hosts/nixos/Shetty-Laptop/desktop.nix` | 主机桌面入口 |
| `modules/home/desktop/niri/default.nix` | niri 会话的用户组件 imports |
| `modules/nixos/desktop/niri.nix` | niri 会话的系统组件 imports 和系统集成 |

用户组件只保留 `niri.nix`、`dux.nix`、`dux-files.nix`，以及字体、亮度、Keyring、XWayland、剪贴板和 XDG 等基础设施。Dux 管理 shell、GTK/Qt、kitty 与 niri 的颜色；光标、Neovim、btop、cava 保留 Catppuccin Mocha 主题。

| Dux 组件 | 固定版本 | 职责 |
| --- | --- | --- |
| Shell | 2.1.0 | 状态栏、工作区、托盘、通知、控制中心、媒体、启动器、剪贴板历史、壁纸、锁屏、OSD、截图和取色 |
| Greeter | 2.1.2 | greetd 登录界面，启动 niri 会话 |
| Files | 2.1.2 | 文件浏览、驱动器操作、打开和保存对话框 |
| Search | 2.1.1 | 启动器使用的本机文件索引 |
| Emoji Launcher | 1.7.3，提交 `fc385900e6df292f0a7e5bdda4e3e37169897d7c` | Dux 社区插件，搜索和复制 Emoji |

上述程序采用相应版本的官方 Nix 模块，Dux 与 Quickshell 使用固定的 `nixpkgs-unstable` 包集合。

## 配置所有权

`modules/home/desktop/niri/niri.nix` 只提供合成器默认值。Dux 在运行时写入 `~/.config/niri/dms/`，这些文件通过 `include optional=true` 覆盖本文件中的同名设置：

```kdl
include optional=true "dms/binds-next.kdl"
include optional=true "dms/colors.kdl"
include optional=true "dms/layout.kdl"
include optional=true "dms/alttab.kdl"
include optional=true "dms/binds.kdl"
include optional=true "dms/outputs.kdl"
include optional=true "dms/cursor.kdl"
include optional=true "dms/input.kdl"
include optional=true "dms/windowrules.kdl"
include optional=true "dms/wpblur.kdl"
```

| 文件 | 写入方 | 内容 |
| --- | --- | --- |
| `binds-next.kdl` | DMS，按 niri 版本重写 | 版本相关的默认绑定 |
| `binds.kdl` | Dux 键位编辑器 | 图形界面修改的绑定 |
| `layout.kdl` | `NiriService` | gaps、边框、圆角、blur、bar/frame 的 xray 规则 |
| `colors.kdl` | matugen | niri 颜色和透明背景 |
| `alttab.kdl` | `NiriService` | recent-windows 高亮 |
| `wpblur.kdl` | `NiriService` | `dms:blurwallpaper` 的 backdrop 规则 |
| `outputs.kdl`、`input.kdl`、`cursor.kdl`、`windowrules.kdl` | Dux 设置 | 显示器、输入、光标和窗口规则 |

`binds-next.kdl` 在本地绑定之前 include，`binds.kdl` 在之后 include，因此优先级是：Dux 默认值 < `niri.nix` 默认值 < 图形界面绑定。

## 首次切换

此次配置包含系统登录管理器、PAM 和文件选择器。先在仓库根目录检查构建。

```bash
nix flake check --no-build --no-update-lock-file
nix build '.#homeConfigurations."shetty@Shetty-Laptop".activationPackage' --no-link
nix build '.#nixosConfigurations."Shetty-Laptop".config.system.build.toplevel' --no-link
```

为下次开机安装新配置，保存工作后重启，再从 Dux Greeter 登录 niri。

```bash
sudo nixos-rebuild boot --flake .#Shetty-Laptop
```

后续用户级修改可以使用 standalone Home Manager 输出。系统登录管理器、PAM 和 Portal 的修改通过 NixOS 构建应用。

```bash
home-manager switch --flake '.#shetty@Shetty-Laptop'
```

需要恢复上一代系统时，在启动菜单选择上一代 NixOS generation。

## 视觉设计

Dux 使用 Material 3 Expressive，密度为 Spacious。设计参数保存在 `modules/home/desktop/niri/dux-initial-settings.json`，只在首次创建 `settings.json` 时作为初始值；之后由 Dux 设置界面和 `settings.json` 自身管理。

| 维度 | 取值 | 意图 |
| --- | --- | --- |
| 字体 | SF Pro，Dux 全局字体缩放 1.15 | 放大设置、弹层与状态栏文字；状态栏自身字体倍率保持 1.0，避免叠乘 |
| 形状 | `radiusMode = scale`，niri 窗口圆角 12px、间距 8px | 无描边窗口仍有明确的留白与边界 |
| 窗口描边 | niri `border` 与 `focus-ring` 均为 `off` | 无边框，靠圆角、阴影和壁纸对比区分窗口 |
| 启动宽度 | 全局窗口规则 `open-maximized true` | 新平铺窗口默认整列最大化，相当于 `Super+F`；不进入无边距全屏，保留浮动对话框规则 |
| 高度 | M3 elevation 强度 8、透明度 24，分隔线 0.08 | 克制的层次，避免重阴影 |
| 表面 | bar 透明度 0.92，控件 0.96，弹层 0.96，前景层 0.94 | 可读性优先的半透明玻璃 |
| 模糊 | `blurStrength = 21` | 轻量背景模糊，降低高刷新屏幕上的合成负担；不承诺实测节电幅度 |
| 动效 | Standard motion，spring bounce 1，popout 160 ms，modal 180 ms | 平滑但不拖沓 |
| 图标与光标 | Papirus-Dark，Catppuccin Mocha 光标 | 与 Catppuccin 应用主题一致 |
| 状态栏 | 左侧启动器/工作区/窗口标题；中央时钟与天气；右侧托盘/通知/电池/控制中心 | 单一视觉锚点，状态区只保留高频信息 |
| 状态栏几何 | Island 厚度 48，间距 6，内边距 6，控件内边距 10，图标倍率 1.15 | 提高文字、图标和点击区域的可辨识度 |
| Dock | Compact，52 px 图标，间距 10，圆形指示，智能自动隐藏 | 放大应用入口，仍保留简洁布局 |

CPU、内存、剪贴板等条目不再占用状态栏：剪贴板保留 `Super+V`，系统监视保留进程列表快捷键。全屏时隐藏状态栏。

本机为 16 英寸 2560×1600 屏幕，niri 缩放 1.5，逻辑空间约 1706×1066。根据实际使用中元素偏小的反馈，仅放大 Dux：全局字体倍率 1.15、48px Island、52px Dock；不修改 niri 缩放、kitty 字号或浏览器缩放。电池模式由 Dux 降至显示器支持的约 60Hz，接电时按其保存的模式恢复；系统电源策略继续由 TLP 管理。低电量通知启用，充电上限和挂起策略不作额外修改。

当前用户已选用 Dux 注册表中的 Catppuccin Mocha/Lavender；调整设置时保留该选择。首次启动 JSON 不包含用户主目录中的主题绝对路径，因而不会声称在未安装该注册表主题的新机器上自动还原它。

### 控制中心

采用四列布局，图标倍率 1.1，沿用全局 115% 字号与 Catppuccin 配色。账户占两列，设置与电源各一列；Wi-Fi/蓝牙各两列；亮度与音量各占整行；输出/输入设备、夜间模式/免打扰、保持唤醒/电池分别两列并排；保留编辑入口。锁屏使用 `Super+Alt+L`。电池实际显示取决于 Dux 检测到的可用设备。

移除磁盘用量、运行中应用和深浅色切换，避免将快捷操作面板变成系统仪表盘。未修改全局透明度或其他面板样式。

上游 2.1 将控制中心最小列数限制为六列。本地 `dux-control-center-four-columns.patch` 仅将 `CcMetrics.minimumColumns` 改为 4，在 Dux 包安装 QML 后应用；未修改上游默认八列或字体缩放。升级 Dux 后若补丁上下文变化，构建会失败，需检查兼容性。


## 快捷键

表中的 `Super` 对应 niri 的 `Mod`。默认值来自 Dux Shell 2.1.0 的 stock 绑定，图形界面保存的 `dms/binds.kdl` 会覆盖同名按键。

| 按键 | 功能 |
| --- | --- |
| `Super+Space` | 应用启动器 |
| `Alt+Space` | Spotlight Bar |
| `Super+D` | Dash |
| `Super+V` | 剪贴板历史 |
| `Super+M` | 媒体 |
| `Super+X` | 电源菜单 |
| `Super+A` | 控制中心 |
| `Super+Shift+C` | 取色并复制 |
| `Super+Alt+N` | 夜间模式 |
| `Super+Alt+I` | 空闲抑制 |
| `Super+,` | Dux 设置 |
| `Super+Y` | 壁纸浏览 |
| `Super+N` / `Super+Shift+N` / `Super+Ctrl+N` | 笔记 / 展开笔记 / 通知中心 |
| `Super+Alt+L` | Dux 锁屏 |
| `Ctrl+Alt+Delete` 或 `Ctrl+Alt+M` | 进程列表 |
| `Super+Shift+?` | Dux 快捷键面板 |
| `Super+Alt+F` | Dux Files |
| `Super+E` | Emoji 搜索，预填 `:e ` |
| `Super+W` / `Super+Shift+W` | 标签列显示 / 窗口规则编辑器 |
| `Super+Shift+T` | 切换浮动窗口 |
| `Super+O` / `Super+Tab` | 概览 |
| `Print` / `Ctrl+Print` / `Alt+Print` | 区域 / 全屏 / 焦点窗口截图 |
| `Super+P` | 循环显示器配置 |
| `Super+Escape` | 切换快捷键抑制 |
| `Super+Shift+P` | 关闭显示器 |
| 音量、媒体和屏幕亮度键 | Dux 控制及 OSD |

全局搜索启用了文件和目录结果。输入 `cb ` 搜索剪贴板，输入 `:e ` 搜索 Emoji。剪贴板也参与至少两个字符的普通搜索。

Search 首次运行建立本机索引，默认从用户主目录开始遍历，深度为 6，跳过隐藏路径和常见依赖、缓存目录。它会跟随符号链接，并索引名称、元数据和受支持的文本内容。

## 设置和后台

初始界面使用 Dux 上游 Material 3 Expressive 风格、Comfortable 密度和 Purple 配色。Dynamic 壁纸取色由用户在设置中选择。外观、面板和插件设置使用用户可写文件，可在图形设置界面保存。

首次创建配置文件时，接电和电池模式都在空闲 300 秒时触发锁屏，330 秒时触发关闭屏幕，并启用睡眠前锁屏。上游渐变默认各有 5 秒宽限。初始化默认值仅作用于首次创建的文件。

已有 `dms` 或旧版 `DankMaterialShell` 目录中的设置文件和符号链接均不会被初始化覆盖。旧目录的迁移交由 Dux 上游处理。

GTK/Qt 自定义主题模块和 Kvantum 配置已移除。Dux 的 matugen 生成 GTK3/4 颜色及 Qt5ct/Qt6ct 配色，相关文件保持可写，不由 Home Manager 接管。GTK3 使用 Dux 管理的 adw-gtk3 副本，Qt 使用 qtct 平台插件；Qt6 通过 `QT_QPA_PLATFORMTHEME_QT6=qt6ct` 选择后端。Kitty 模板与 Niri 模板显式启用：Kitty 加载 `dank-theme.conf` 和 `dank-tabs.conf`，Dux 生成后发送 SIGUSR1 重载；niri 加载 `dms/colors.kdl` 并热重载。Kitty 字体、字号、透明度与 niri 无边框、默认全宽规则保持不变。Neovim 模板仍关闭。已启动 GTK/Qt 应用可能需要重启；完整会话环境需重新登录后生效。

- PipeWire、NetworkManager、BlueZ、polkit、GNOME Keyring、udisks2 和 XDG Portal 提供系统能力。
- `wl-clip-persist` 持有当前剪贴板内容，支持关闭来源程序后继续粘贴。Dux 提供历史和交互界面。
- 移动存储由 Dux Files 通过 udisks2 手动挂载、卸载和弹出，不再运行自动挂载守护进程。
- 系统电源策略使用 TLP，控制中心按可用后端展示选项。

Files 的系统模块负责文件选择器 Portal，系统同时配置 GNOME 屏幕共享、GTK Access/Notification 和 GNOME Keyring Secret 后端。

## 交互与验收

当前组合提供区域截图和焦点窗口截图，单击任意平铺窗口自动吸附仍需后续上游支持。

文件选择器浮动规则匹配英文标题前缀。应用传入的自定义标题或本地化标题可能仍按 niri 规则平铺，需要在目标机器检查。

登录后检查服务状态，并在目标机器验证搜索、剪贴板、截图、锁屏解锁与浏览器屏幕共享。

```bash
systemctl --user status dms.service dfiles.service dsearch.service wl-clip-persist.service
dms ipc call spotlight toggle
dms ipc call control-center toggle
```

Linux 环境可用 `bash tests/dux-initial-settings.sh` 重跑初始化回归检查。
