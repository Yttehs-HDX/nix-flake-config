import re
import subprocess
import sys

kind, command = sys.argv[1:]
try:
    if kind == "wifi":
        result = subprocess.run([command, "-t", "-f", "TYPE,STATE,CONNECTION", "device", "status"], capture_output=True, text=True, timeout=3, check=True)
        names = [re.sub(r"\\(.)", r"\1", line.split(":", 2)[2]) for line in result.stdout.splitlines() if line.startswith("wifi:connected:")]
        icon, fallback = "󰖩", "网络配置"
    else:
        result = subprocess.run([command, "devices", "Connected"], capture_output=True, text=True, timeout=3, check=True)
        names = [parts[2] for line in result.stdout.splitlines() if len(parts := line.split(" ", 2)) == 3 and parts[0] == "Device"]
        icon, fallback = "󰂯", "蓝牙设备"
    label = fallback if not names else names[0] if len(names) == 1 else f"{len(names)} 个设备"
    print(f"{icon}  {label}")
except (OSError, subprocess.SubprocessError):
    print("󰖩  网络配置" if kind == "wifi" else "󰂯  蓝牙设备")
