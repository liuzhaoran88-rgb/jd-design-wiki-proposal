# preview.png 自动导出（v0.2+）

> SKILL.md Step 6 调用本文件。把 Relay 节点导出成 PNG 写到 design.md 同目录。

---

## 算法

### Step 1: Relay 端导出 + base64 编码

通过 `use_design_script` 调用：

```javascript
const root = await relay.getNodeByIdAsync('<NODE_ID>')
if (!root) return { error: 'node not found' }

const bytes = await root.exportAsync({
  format: 'PNG',
  constraint: { type: 'SCALE', value: 2 },   // 2× 高清，retina 友好
})

return {
  byteLength: bytes.length,
  base64: relay.base64Encode(bytes),
}
```

返回结构：
- `byteLength`: 原始 PNG 字节数（用于体积告警）
- `base64`: base64 编码字符串（用于写文件）

### Step 2: 体积检查 + 决策

| 体积 | 处理 |
|---|---|
| `byteLength < 50KB` | 直接 inline 写入（Bash 单行命令足够） |
| `50KB ≤ byteLength < 500KB` | 用 `echo` 多行 / heredoc 写到临时文件 → base64 -d |
| `byteLength ≥ 500KB` | 异常 — 节点尺寸过大或缩放过高。降到 SCALE=1 重试。仍超 → 跳过 + flag |

### Step 3: Bash 写文件

```bash
mkdir -p '<output_dir>'
echo '<base64_string>' | base64 -d > '<output_dir>/preview.png'
```

**macOS / Linux 都需要 `base64 -d` 处理 padding `=`** — 标准 GNU base64 / BSD base64 都支持。

校验：

```bash
file '<output_dir>/preview.png'    # 期望: PNG image data, ...
ls -l '<output_dir>/preview.png'    # 期望: 体积 ≈ byteLength
```

### Step 4: 失败兜底

如果导出失败（exportAsync 报错 / 节点不可见 / MCP 抖动）：

1. **不要 abort skill 主流程** —— design.md 继续生成
2. design.md 视觉/预览 section 留 placeholder：
   ```markdown
   ### 预览
   ![{name_zh}](./preview.png)
   > ⚠️ skill v0.2 导出失败 (原因: {错误描述})，请设计师手动从 Relay 截图后命名为 preview.png 放本目录
   ```
3. 终端输出加 `⚠️ preview.png 自动导出失败，需手动补`

---

## SKILL.md Step 6 替换为以下伪码

```
1. 调 use_design_script export PNG (SCALE 2)
2. 拿 byteLength 判断体积分支
3. Bash echo <base64> | base64 -d > <output_dir>/preview.png
4. file <path> 验证 PNG 头
5. 终端输出 "📎 已附 preview.png ({byteLength}B)"
6. 失败 → 留 placeholder + 终端 warn
```

---

## 体积优化建议（设计师 review 时）

- 单组件 preview 通常 < 50KB
- 整页 (375×800+) 通常 50-200KB
- 流程级 / 多屏拼接 > 500KB → 改用 SCALE=1 或 export PDF

`exportAsync` 还支持其他参数（详见 Relay Plugin API ExportSettings*）：

| 选项 | 用途 |
|---|---|
| `format: 'PNG'` | 默认；位图，色彩准 |
| `format: 'JPG'` | 体积更小但有损；摄影类素材用 |
| `format: 'SVG'` | 矢量图标 |
| `format: 'PDF'` | 多页 / 流程级 |
| `constraint.type: 'SCALE'` | 按倍率（1/2/3） |
| `constraint.type: 'WIDTH'` | 按目标宽度（如 750） |
| `constraint.type: 'HEIGHT'` | 按目标高度 |

v0.2 仅用 PNG @ SCALE=2。其他格式 v0.4+ 加选项。
