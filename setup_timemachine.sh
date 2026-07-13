#!/bin/bash
# 一键设置 Time Machine 备份到本地 sparse bundle
set -e

echo "1/3 删除旧的 Time Machine 目标..."
OLD_DEST=$(tmutil destinationinfo 2>/dev/null | grep "ID" | awk '{print $NF}')
if [ -n "$OLD_DEST" ]; then
    sudo tmutil removedestination "$OLD_DEST" 2>/dev/null || true
    echo "   旧目标已删除"
fi

echo "2/3 设置新目标: /Volumes/TimeMachine..."
sudo tmutil setdestination /Volumes/TimeMachine

echo "3/3 验证..."
tmutil destinationinfo

echo ""
echo "✅ 完成！去 系统设置 → Time Machine 看看能不能识别"
echo "   然后点'立即备份'开始第一次备份"
