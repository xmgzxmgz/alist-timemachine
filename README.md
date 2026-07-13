# Time Machine + 阿里云盘 备份方案

通过 AList + rclone 将 Time Machine 备份同步到阿里云盘。

## 原理

```
Time Machine → 本地 sparse bundle（虚拟硬盘）
                    ↓ rclone sync（增量同步 band 文件）
                AList WebDAV → 阿里云盘
```

## 使用方法

### 1. 启动 AList

```bash
docker compose up -d
docker exec alist ./alist admin random  # 获取密码
```

### 2. 配置阿里云盘

打开 http://localhost:5244，登录管理面板，添加阿里云盘存储。

### 3. 配置 rclone

```bash
rclone config  # 添加 WebDAV 后端，指向 AList
```

### 4. 创建虚拟硬盘

```bash
hdiutil create -size 300g -fs APFS -type SPARSEBUNDLE -volname "TimeMachine" -layout GPTSPUD ~/TimeMachine.sparsebundle
hdiutil attach ~/TimeMachine.sparsebundle
```

### 5. 设置 Time Machine

```bash
sudo tmutil setdestination /Volumes/TimeMachine
```

### 6. 启用定时同步

编辑 `sync_timemachine.sh` 中的路径，然后：

```bash
launchctl load com.xiamuguizhi.timemachine-sync.plist
```

## 注意事项

- 首次全量备份需要足够的本地空间
- sparse bundle 是按需增长的，不会一开始就占满
- rclone 只同步变化的 band 文件，日常增量同步很快
- 建议配合外接硬盘使用，本地备份 + 云端备份双重保险
