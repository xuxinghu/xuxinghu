# 可运行脚本工具箱

从 GitHub 热门开源脚本项目提炼的 6 个实用脚本，全部可双击 `Start.bat` 菜单运行，也可用命令行带参数运行。

## 脚本一览

| 脚本 | 功能 | 灵感来源 |
|---|---|---|
| `1-Search.ps1` | 按文件名/内容快速搜索 | fd + ripgrep |
| `2-BatchRename.ps1` | 批量重命名（默认预览，加 `-Apply` 才执行） | 文件管理类脚本 |
| `3-SystemInfo.ps1` | CPU / 内存 / 磁盘 / 占用最高的进程一览 | btop 等监控工具 |
| `4-DuplicateFinder.ps1` | 按大小+哈希找重复文件，输出 CSV 报告（只报告不删除） | 去重清理类脚本 |
| `5-JunkScan.ps1` | 扫描临时文件夹、回收站、大文件（只报告不删除） | Bloatynosy |
| `6-Backup.ps1` | 把文件夹打包成带时间戳的 ZIP 备份 | 备份同步类脚本 |

## 运行方式

### 方式一：菜单（最简单）
双击 `Start.bat`，输入编号即可。

### 方式二：命令行（可自定义参数）
```powershell
# 1. 搜索：在图片文件夹找 jpg
powershell -ExecutionPolicy Bypass -File 1-Search.ps1 -Name "*.jpg" -Path C:\Users\Administrator\Pictures

# 2. 批量重命名：先预览
powershell -ExecutionPolicy Bypass -File 2-BatchRename.ps1 -Path .\photos -Find "IMG_" -Replace "2026_"
# 确认无误后真正执行（加 -Apply）
powershell -ExecutionPolicy Bypass -File 2-BatchRename.ps1 -Path .\photos -Find "IMG_" -Replace "2026_" -Apply

# 4. 找重复文件（Downloads 目录，只统计 >=100KB）
powershell -ExecutionPolicy Bypass -File 4-DuplicateFinder.ps1 -Path C:\Users\Administrator\Downloads

# 6. 备份文档到桌面 backups 文件夹
powershell -ExecutionPolicy Bypass -File 6-Backup.ps1 -Source C:\Users\Administrator\Documents
```

## 安全说明

- **首次运行**：Windows 默认禁止运行 .ps1 脚本。双击 `Start.bat` 无需任何设置（已内置 `-ExecutionPolicy Bypass`）；命令行方式请按上面的示例加 `-ExecutionPolicy Bypass`
- **批量重命名**默认是"预演模式"，只有加 `-Apply` 才会真正改名
- **重复文件查找**和**垃圾扫描**都只生成报告，**不会删除任何文件**
- 备份脚本只创建新 ZIP，不覆盖已有文件

## 原始项目

完整源码仓库已下载到桌面的 `GitHub脚本` 文件夹，共 19 个项目，可对照阅读。
