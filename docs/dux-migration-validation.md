# Dux 迁移验证记录

本次验证日期为 2026-11-10。验证对象是本 PR，不将附件中的历史构建记录计为本次通过。

## 来源和修正

- 从 `origin/continuously-update` 的 `8816611aed951f7354a1ada141ed1a4782fab1af` 创建独立工作树和 `feat/dux-desktop-migration` 分支。
- 附件 `SHA256SUMS` 四项全部通过，完整补丁通过 `git am --3way` 无冲突应用。
- 基线 209 个文件全部保留，删除数为 0。16 个原有非 root 锁节点及原有 root input 映射逐对象一致，包括 `latchshot`、`hexecute`。
- 修复首次初始化遮蔽旧 `DankMaterialShell` 设置的问题。当前目录或旧目录存在对应文件或符号链接时不创建默认文件，由上游处理旧目录迁移。
- 将系统主题导入移到主机桌面 profile，使可复用 niri 模块不选择主题，当前启用的组合不变。

## 本次执行环境

宿主为 macOS arm64，没有本机 Nix。使用独立 Docker Linux arm64 容器内的 Nix 2.35.5 求值和构建。目标输出仍为原配置的 `x86_64-linux`。容器支持 QEMU x86_64 执行，构建允许该额外平台。早期最多两个构建任务，后续改为单任务、单核并降低下载并发。未激活配置、修改真实用户设置或重启。

## 配置和回归检查

- `git diff --check` 通过。
- 对实际模块求值结果核对，Dux 的 `dms`、`dfiles`、`dsearch` 用户服务被选择，保留 `wl-clip-persist`、无托盘 `udiskie`。旧 Rofi、Waybar、SwayNC、Swaylock、SwayOSD 未启用，SDDM 未启用，greetd 已启用。
- `dms` 和 `dfiles` 随 `graphical-session.target` 启动，`dsearch` 随用户 `default.target` 启动。系统侧没有第二份 dfiles 用户服务。
- FileChooser 路由为 `dfiles`，Access/Notification 为 GTK，Secret 为 GNOME Keyring，默认后端为 GNOME/GTK。`dankshell` PAM 含密码认证，greetd 启用 Keyring PAM。
- Dux 设置不由 Home Manager 的只读文件管理，插件设置也不强制管理。固定上游的默认值为 Material 3 Expressive、Comfortable、Purple，未强制 Dynamic。
- `bash tests/dux-initial-settings.sh` 在隔离临时目录通过。测试求值实际初始化脚本，覆盖旧目录设置、首次生成普通可写 0600 文件、GUI 后续修改以及新旧目录的悬空符号链接。
- 修复前同一回归检查失败，输出为 `FAIL: initialization masks existing legacy settings with new dms files`；修复后全部通过。
- `bash tests/dux-ocr.sh` 对实际 Nix 模块生成的 OCR 脚本在 Linux 中执行并通过 12 个模拟场景，覆盖成功、取消、空图、OCR 失败/空结果和翻译失败/空结果。模拟测试不证明真实截图或 OCR 识别效果。

## 上游 IPC 测试

固定 Shell 源码提交为 `7627111c3ebd402662283f5f4a93223cda9e0a9d`。直接在 macOS 执行 Go 测试因上游 Linux 专用函数缺失而编译失败，不是 AF_UNIX 权限失败。

使用 Go 1.27.3 交叉编译未修改的整个 `cmd/dms` 测试包，并分别在 Linux arm64 与 QEMU x86_64 中执行。两种架构均为 3/3 通过，没有复现附件环境中的 AF_UNIX 限制。

```bash
cd core
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go test -c -o dms-ipc.test ./cmd/dms
# 在相应架构的 Linux 环境执行；x86_64 对应 GOARCH=amd64。
./dms-ipc.test -test.run '^TestServerRequest' -test.count=1 -test.v
```

通过的测试为 `TestServerRequestTimesOutWithoutGreeting`、`TestServerRequestWaitsForSlowReply`、`TestServerRequestReportsClosedConnection`。这不替代完整 Dux Shell Nix 包构建及其全部测试。

## 目标机器验收

系统激活、重启和 PR 合并由用户执行。首次切换步骤和快捷键见 [桌面说明](dux-desktop.md)。需要在真实 Wayland 会话验收：

- Greeter 登录、锁屏解锁、空闲锁屏和挂起前锁屏。
- 面板、托盘、通知、媒体缩略图、动画、音量亮度键和搜索索引。
- 设置 GUI 保存并跨登录保留，用户手动选择 Dynamic 壁纸取色。
- 剪贴板在来源程序退出后粘贴、外部磁盘自动挂载。
- 区域截图松开鼠标完成、焦点窗口截图、实时 OCR 和截图翻译。
- Files 文件选择器及本地化/自定义标题窗口的布局、浏览器屏幕共享。

单击任意平铺窗口自动吸附仍需上游支持。文件选择器当前浮动规则只匹配英文标题前缀，其他标题可能保持平铺。

## 本次 Nix 与 KDL 检查

以下命令在容器内仓库快照根目录执行，Nix 启用了 `nix-command flakes`。

| 检查 | 本次结果 |
| --- | --- |
| `nix flake check --no-build --no-update-lock-file` | 通过，exit 0 |
| `nix eval --raw '.#homeConfigurations."shetty@Shetty-Laptop".activationPackage.drvPath'` | 通过，exit 0 |
| `nix eval --raw '.#nixosConfigurations."Shetty-Laptop".config.system.build.toplevel.drvPath'` | 通过，exit 0 |
| `nix build '.#homeConfigurations."shetty@Shetty-Laptop".activationPackage' --no-link` | 未完成。首次 exit 137；串行重试在依赖下载阶段主动中止，exit 1 |
| `nix build '.#nixosConfigurations."Shetty-Laptop".config.system.build.toplevel' --no-link` | 未完成。两次尝试均在依赖下载阶段主动中止，exit 1 |
| `niri validate --config <生成的 KDL 路径>` | 使用目标配置同一 Nix 包的 niri 26.04，exit 0 |

本次 drvPath 为：

```text
/nix/store/w6j5jlaglmaisdzhiwq2z2m8rw5rgc4y-home-manager-generation.drv
/nix/store/530y9qsx5kp3hswidrd5hsl4l391amqb-nixos-system-Shetty-Laptop-26.05.20261026.718f670.drv
```

KDL 来自 Home Manager 最终 `config.xdg.configFile."niri/config.kdl".text` 的实际求值，SHA-256 为 `96e6330cc332b5f0d60828001083bd2621556f2c55817b7f48ce55b2fa0dd126`。验证仅提示三个尚未生成的 optional include 不存在，最终输出 `config is valid`。

早期并发求值及构建在约 3.8 GiB Docker VM 中遇到 OOM，Home Manager 构建及两次求值 exit 137，cgroup 记录四次 OOM kill。为避免继续争用内存，中断了当时的系统构建。降低下载并发后，最终配置的 flake check 和两个 drvPath 求值已串行通过。Home Manager 串行重试计划下载约 7.6 GiB 依赖，系统重试计划下载约 11.2 GiB。为控制本次本机验证的资源和下载占用，两项重试均在依赖下载阶段主动中止，日志为 `error: interrupted by the user`。这不说明配置编译失败，也不说明低并发构建必然无法完成；本次两个完整构建均未验证通过。未增加 VM 内存或重启环境。
