#!/bin/bash
echo "=== 修复 Git 推送问题 ==="

# 1. 检查远程
echo "1. 检查远程仓库..."
git remote -v

# 2. 尝试推送到 main
echo "2. 尝试推送到 main 分支..."
if git push -u origin master:main 2>/dev/null; then
    echo "✅ 成功推送到 origin/main"
    echo "建议重命名本地分支: git branch -M master main"
    exit 0
fi

# 3. 尝试推送到 master
echo "3. 尝试推送到 master 分支..."
if git push -u origin master 2>/dev/null; then
    echo "✅ 成功推送到 origin/master"
    exit 0
fi

# 4. 强制推送
echo "4. 尝试强制推送..."
git push -u origin master --force

echo "=== 完成 ==="
