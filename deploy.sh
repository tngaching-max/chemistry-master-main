#!/bin/bash
echo "=== 化學大師部署準備 ==="

# 清理舊的構建
rm -rf dist
rm -rf .netlify

# 安裝依賴
npm install --legacy-peer-deps

# 構建專案
npm run build

# 檢查構建結果
if [ -d "dist" ] && [ -f "dist/index.html" ]; then
    echo "✅ 構建成功！"
    echo "📁 構建文件:"
    ls -la dist/
else
    echo "❌ 構建失敗！"
    exit 1
fi

echo "=== 完成 ==="
