#!/bin/bash
echo "=== 🔧 修复构建错误 ==="

# 1. 安装 terser
echo "1. 安装 terser..."
npm install --save-dev terser @types/node

# 2. 更新 tsconfig.json
echo "2. 更新 TypeScript 配置..."
cat > tsconfig.json << 'JSON'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "skipLibCheck": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": false,
    "noUnusedParameters": false,
    "noFallthroughCasesInSwitch": true,
    "types": ["vite/client"]
  },
  "include": ["**/*.ts", "**/*.tsx", "vite.config.ts"],
  "exclude": ["node_modules", "dist"]
}
JSON

# 3. 简化 vite.config.ts
echo "3. 简化构建配置..."
cat > vite.config.ts << 'TS'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/',
  build: {
    outDir: 'dist',
    sourcemap: false,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom']
        }
      }
    }
  }
})
TS

# 4. 创建类型声明
echo "4. 创建类型声明..."
cat > vite-env.d.ts << 'DTS'
/// <reference types="vite/client" />
DTS

# 5. 测试构建
echo "5. 测试构建..."
rm -rf dist
npm run build 2>&1

# 6. 检查结果
echo "6. 检查结果..."
if [ -d "dist" ]; then
  echo "✅ 构建成功！"
  echo "文件列表:"
  find dist -type f | while read file; do
    size=$(du -h "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "?")
    echo "   - $(basename "$file") ($size)"
  done
else
  echo "❌ 构建失败"
  echo "请检查上面的错误信息"
fi

echo "=== ✅ 完成 ==="
