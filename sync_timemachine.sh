#!/bin/bash
# Time Machine sparse bundle → 阿里云盘 同步脚本
# 用法: ./sync_timemachine.sh

SPARSE_BUNDLE="$HOME/TimeMachine.sparsebundle"
REMOTE="alist:aliyun/TimeMachine-Backup"

echo "[$(date)] 开始同步 Time Machine 到阿里云盘..."

# 卸载 sparse bundle（确保数据写入完成）
hdiutil detach /Volumes/TimeMachine 2>/dev/null

# 同步 sparse bundle 到阿里云盘（只传变化的 band 文件）
rclone sync "$SPARSE_BUNDLE" "$REMOTE" \
  --progress \
  --transfers 4 \
  --checkers 8 \
  --min-size 1B \
  --log-file "$HOME/.timemachine-sync.log" \
  --log-level INFO

echo "[$(date)] 同步完成"

# 重新挂载（方便下次 Time Machine 写入）
hdiutil attach "$SPARSE_BUNDLE" 2>/dev/null
