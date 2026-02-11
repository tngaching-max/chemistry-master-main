#!/bin/bash
echo "=== 🔧 修复项目结构 ==="

# 1. 备份
echo "1. 备份当前文件..."
cp index.html index.html.backup

# 2. 修复 index.html
echo "2. 修复 index.html..."
if ! grep -q "<script type=\"module\"" index.html; then
  echo "添加 script 标签..."
  sed -i '/<body[^>]*>/a\    <script type="module" src="/index.tsx"></script>' index.html
fi

# 3. 检查入口文件
echo "3. 检查入口文件..."
if [ ! -f "index.tsx" ]; then
  echo "❌ index.tsx 不存在"
else
  echo "✅ index.tsx 存在"
  # 检查 index.tsx 内容
  if ! grep -q "ReactDOM.createRoot" index.tsx; then
    echo "⚠️  index.tsx 可能不是有效的 React 入口"
  fi
fi

# 4. 检查 App.tsx
if [ ! -f "App.tsx" ]; then
  echo "❌ App.tsx 不存在"
else
  echo "✅ App.tsx 存在"
fi

# 5. 测试构建
echo "4. 测试构建..."
rm -rf dist
npm run build 2>&1

# 6. 检查结果
echo "5. 检查构建结果..."
if [ -d "dist" ]; then
  echo "✅ dist 目录已创建"
  js_count=$(find dist -name "*.js" 2>/dev/null | wc -l)
  echo "   JS 文件数量: $js_count"
  
  if [ $js_count -eq 0 ]; then
    echo "⚠️  没有生成 JS 文件"
    echo "   检查 index.html 内容:"
    grep -n "script" index.html
  else
    echo "✅ 构建成功！"
    find dist -name "*.js" | head -3
  fi
else
  echo "❌ dist 目录未创建"
fi

echo -e "\n=== ✅ 修复完成 ==="
