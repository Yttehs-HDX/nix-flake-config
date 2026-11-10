# Niri + Dux 桌面

当前用户和主机的桌面组合使用 niri 与 Dux。组件模块、主题和本地包定义保存在各自目录，通过 profile 与 imports 选择本机启用的组合。

## 组件选择

| 位置 | 职责 |
| --- | --- |
| `home/shetty/laptop.nix` | 用户 profile，选择桌面和应用主题组合 |
| `home/shetty/default.nix` | 用户通用应用组合 |
| `hosts/nixos/Shetty-Laptop/desktop.nix` | 主机桌面入口 |
| `modules/home/desktop/niri/default.nix` | 当前 niri 用户组件的 imports |
| `modules/nixos/desktop/niri.nix` | 当前 niri 系统组件的 imports 和系统集成 |
| `modules/home/theme/catppuccin-mocha/default.nix` | 用户主题的 imports |
| `modules/nixos/theme/catppuccin-mocha/default.nix` | 主机主题的 imports |

Rofi、SwayNC、Waybar、Swaylock、SDDM、Omasnap、Swappy 等模块和主题均可继续组合使用。当前 profile 取消了这些组件的导入，选择 Dux 系列。

`latchshot`、`hexecute` 的 flake 输入和锁定节点提供原有模块的依赖。SwayOSD 系统后端和 swaylock PAM 分别存放在 `modules/nixos/desktop/common/swayosd.nix`、`swaylock.nix`，可在选择对应组件时导入。

通用光标主题配置位于 `cursor.nix`。SDDM 和 Dux Greeter 的服务环境分别位于对应主题叶子模块，由主题 imports 选择。

| Dux 组件 | 固定版本 | 职责 |
| --- | --- | --- |
| Shell | 2.1.0 | 状态栏、工作区、托盘、通知、控制中心、媒体、启动器、剪贴板历史、壁纸、锁屏、OSD、截图和取色 |
| Greeter | 2.1.2 | greetd 登录界面，启动 niri 会话 |
| Files | 2.1.2 | 文件浏览、驱动器操作、打开和保存对话框 |
| Search | 2.1.1 | 启动器使用的本机文件索引 |
| Emoji Launcher | 1.7.3，提交 `fc385900e6df292f0a7e5bdda4e3e37169897d7c` | Dux 社区插件，搜索和复制 Emoji |

上述程序采用相应版本的官方 Nix 模块，Dux 与 Quickshell 使用固定的 `nixpkgs-unstable` 包集合。

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

## 快捷键

表中的 `Super` 对应 niri 的 `Mod`。

| 按键 | 功能 |
| --- | --- |
| `Alt+Space` | 全局搜索，进入全部结果模式 |
| `Super+D` | 应用搜索 |
| `Super+W` | 剪贴板历史 |
| `Super+E` | Emoji 搜索，预填 `:e ` |
| `Super+N` / `Super+A` | 通知中心 / 控制中心 |
| `Super+Escape` | 电源菜单 |
| `Super+/` | Dux 的 niri 快捷键面板 |
| `Super+Shift+/` | niri 快捷键提示 |
| `Super+Alt+F` | Dux Files |
| `Super+Alt+L` | Dux 锁屏 |
| `Print` 或 `Super+Shift+S` | 区域截图，松开鼠标完成选择 |
| `Ctrl+Print` / `Alt+Print` | 当前输出全屏截图 / 焦点窗口截图 |
| `Super+Shift+O` | 框选 OCR 并复制文字 |
| `Super+Shift+T` | 框选 OCR，翻译为中文并复制译文 |
| `Super+Alt+Delete` | 取色并复制 |
| 音量、媒体和屏幕亮度键 | Dux 控制及 OSD |

全局搜索启用了文件和目录结果。输入 `cb ` 搜索剪贴板，输入 `:e ` 搜索 Emoji。剪贴板也参与至少两个字符的普通搜索。OCR 和截图翻译通过 `.desktop` 项进入应用搜索。

Search 首次运行建立本机索引，默认从用户主目录开始遍历，深度为 6，跳过隐藏路径和常见依赖、缓存目录。它会跟随符号链接，并索引名称、元数据和受支持的文本内容。

## 设置和后台

初始界面使用 Dux 上游 Material 3 Expressive 风格、Comfortable 密度和 Purple 配色。Dynamic 壁纸取色由用户在设置中选择。外观、面板和插件设置使用用户可写文件，可在图形设置界面保存。

首次创建配置文件时，接电和电池模式都在空闲 300 秒时触发锁屏，330 秒时触发关闭屏幕，并启用睡眠前锁屏。上游渐变默认各有 5 秒宽限。初始化默认值仅作用于首次创建的文件。

已有 `dms` 或旧版 `DankMaterialShell` 目录中的设置文件和符号链接均不会被初始化覆盖。旧目录的迁移交由 Dux 上游处理。

niri 配置末尾引入 Dux 可写的三个片段，分别供图形界面的显示器、窗口规则和快捷键设置使用。

```kdl
include optional=true "dms/outputs.kdl"
include optional=true "dms/windowrules.kdl"
include optional=true "dms/binds.kdl"
```

- PipeWire、NetworkManager、BlueZ、polkit、GNOME Keyring、udisks2 和 XDG Portal 提供系统能力。
- `wl-clip-persist` 持有当前剪贴板内容，支持关闭来源程序后继续粘贴。Dux 提供历史和交互界面。
- `udiskie` 以隐藏托盘模式自动挂载移动存储，文件操作界面使用 Dux Files。
- OCR 使用 Tesseract，翻译使用 translate-shell。Dux 提供截图输入，成功且结果非空后才更新剪贴板。
- 系统电源策略使用 TLP，控制中心按可用后端展示选项。

Files 的系统模块负责文件选择器 Portal，系统同时配置 GNOME 屏幕共享、GTK Access/Notification 和 GNOME Keyring Secret 后端。

## 交互与验收

当前组合提供区域截图和焦点窗口截图，单击任意平铺窗口自动吸附仍需后续上游支持。Omasnap 贴图、Swappy 标注以及原 which-key 窗口菜单的定义可供按需导入。

文件选择器浮动规则匹配英文标题前缀。应用传入的自定义标题或本地化标题可能仍按 niri 规则平铺，需要在目标机器检查。

登录后检查服务状态，并在目标机器验证搜索、剪贴板、截图、OCR、锁屏解锁与浏览器屏幕共享。

```bash
systemctl --user status dms.service dfiles.service dsearch.service wl-clip-persist.service
dms ipc call spotlight toggleWith all
dms ipc call control-center toggle
```

本次执行结果及未验收范围见 [迁移验证记录](dux-migration-validation.md)。Linux 环境可用 `bash tests/dux-initial-settings.sh` 重跑初始化回归检查。
