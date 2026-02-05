// check.mjs
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log('=== 项目状态检查 ===\n');

// 1. 检查当前目录
console.log('1. 当前目录:', process.cwd());

// 2. 检查 package.json
const packagePath = path.join(process.cwd(), 'package.json');
if (fs.existsSync(packagePath)) {
  console.log('2. ✓ package.json 存在');
  const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
  console.log('   项目名称:', pkg.name);
  console.log('   项目类型:', pkg.type || 'CommonJS');
  console.log('   Vite 版本:', pkg.devDependencies?.vite || '未找到');
  console.log('   Scripts:', Object.keys(pkg.scripts || {}).join(', '));
} else {
  console.log('2. ✗ package.json 不存在');
}

// 3. 检查 node_modules/vite
const vitePath = path.join(process.cwd(), 'node_modules', 'vite');
if (fs.existsSync(vitePath)) {
  console.log('3. ✓ node_modules/vite 存在');
  const vitePkg = JSON.parse(fs.readFileSync(path.join(vitePath, 'package.json'), 'utf8'));
  console.log('   Vite 实际版本:', vitePkg.version);
} else {
  console.log('3. ✗ node_modules/vite 不存在');
}

// 4. 检查关键文件
console.log('\n4. 检查关键文件:');
['vite.config.ts', 'index.html', 'src/main.tsx', 'src/App.tsx'].forEach(file => {
  const filePath = path.join(process.cwd(), file);
  console.log(`   ${fs.existsSync(filePath) ? '✓' : '✗'} ${file}`);
});

console.log('\n=== 检查完成 ===');