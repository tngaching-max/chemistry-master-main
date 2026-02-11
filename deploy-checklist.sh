#!/bin/bash
echo "=== 🚀 部署检查清单 ==="
echo ""

# 1. 本地构建测试
echo "1. 本地构建测试..."
rm -rf dist
npm run build 2>&1 | tail -5

if [ -f "dist/index.html" ]; then
  echo "✅ 构建成功"
else
  echo "❌ 构建失败"
  exit 1
fi

# 2. 本地预览测试
echo ""
echo "2. 本地预览测试..."
echo "运行: npx serve dist -p 3001"
echo "访问: http://localhost:3001"
echo "检查是否显示 '化學大師'"

# 3. Git 状态
echo ""
echo "3. Git 状态..."
git status --short

# 4. Netlify 配置
echo ""
echo "4. Netlify 配置检查..."
if [ -f "netlify.toml" ]; then
  echo "✅ netlify.toml 存在"
  grep -E "(command|publish|redirects)" netlify.toml
else
  echo "⚠️  没有 netlify.toml"
  cat > netlify.toml << 'TOML'
[build]
  command = "npm run build"
  publish = "dist"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
TOML
  echo "✅ 已创建 netlify.toml"
fi

# 5. 环境变量检查
echo ""
echo "5. 环境变量检查..."
if grep -q "VITE_GEMINI_API_KEY" .env* 2>/dev/null || grep -q "import.meta.env.VITE" src/* 2>/dev/null; then
  echo "⚠️  检测到环境变量使用"
  echo "   需要在 Netlify 控制台设置:"
  echo "   Site settings → Environment variables"
else
  echo "✅ 没有检测到环境变量依赖"
fi

echo ""
echo "=== 📋 下一步 ==="
echo "1. 推送到 GitHub:"
echo "   git add . && git commit -m '准备部署' && git push origin main"
echo ""
echo "2. 部署到 Netlify:"
echo "   A. 访问 https://app.netlify.com"
echo "   B. 点击 'New site from Git'"
echo "   C. 选择你的仓库"
echo "   D. 部署设置会自动使用 netlify.toml"
echo ""
echo "3. 部署后检查:"
echo "   - 访问你的 Netlify URL"
echo "   - 按 F12 检查控制台错误"
echo "   - 测试功能是否正常"
