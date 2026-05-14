# Stage 切图导出流程(v0.2)

> SKILL.md Step 5b 调用。从 Relay 节点导出 PNG 切图到 `<bundle-dir>/_assets/`,用于 stage block 替代 CSS mockup。

---

## 何时用切图 vs CSS mockup

| 情况 | 走哪条 |
|---|---|
| 组件来自 Relay,节点 ID 已知,要展示**正向标准形态** | ✅ 切图(原稿,可信) |
| 反例(违反规范的形态),Relay 上没有 | ✅ CSS mockup(简化版即可) |
| feedback 类组件需要交互演示(如 toast 按钮触发) | ✅ JS engine + CSS mockup |
| 非视觉规范段(章节 2 行为准则 / 章节 7 典型场景) | 不用 stage |

正例切图能彻底解决 CSS mockup "做不像、做错"的问题,**v0.2 起优先走切图路径**。

---

## 节点选择启发(从 page-doc bundle 推断切图候选)

对 page-doc bundle:

1. 先用 `mcp__zero-design__use_design_script` 列出 root 节点的直接子 children(章节 frame),取每个章节 frame 的直接子 frame 作为候选
2. 候选过滤:`type === 'FRAME' && height >= 200 && height <= 3000`(太小没意义,太大可能爆栈或太久)
3. 按章节归类:
   - 章节 01 设计原则 → 通常 1 张整章节图(因为篇幅小)
   - 章节 02 组件设计属性 → 多个子段(常规布局 / Agent 布局 / 状态招手 / Joy Agent)各 1 张
   - 章节 03 灵动岛 → 三型各 1 张(常规 / 运营 / 大促)
   - 章节 04 应用场景 → 通常无独立 description,可跳过或导整章节图
   - 章节 05 多端适配 → 1 张多端对比图

对单 design.md(非 page-doc):
- root 节点单张图作为预览
- 各 variants 子节点(若 root 是 COMPONENT_SET)各 1 张

切图命名约定:`_assets/sec-{章节号}-{slug}.png`,例:
- `sec-1-principles.png`
- `sec-2-regular-layout.png`、`sec-2-agent-layout.png`、`sec-2-states-badges.png`、`sec-2-joy-agent.png`
- `sec-3-island-regular.png`、`sec-3-island-operation.png`、`sec-3-island-promo.png`
- `sec-5-multi-platform.png`

---

## 导出流程(3 步)

### Step A: chunked base64 export 到 sharedPluginData

`relay.base64Encode` 是栈递归实现,> ~150KB raw 字节会爆 `Maximum call stack size exceeded`。**必须用 chunked 包装**。

```javascript
function chunkedB64(bytes) {
  const CHUNK = 60000  // 60KB blocks, 60000 % 3 == 0 (base64 块边界)
  if (bytes.length <= CHUNK) return relay.base64Encode(bytes)
  const parts = []
  for (let i = 0; i < bytes.length; i += CHUNK) {
    parts.push(relay.base64Encode(bytes.slice(i, i + CHUNK)))
  }
  return parts.join('')
}

const NS = 'jd-spec-page-assets'
const root = await relay.getNodeByIdAsync('<ROOT_NODE_ID>')
const NODES = [
  { key: 'sec-1-principles', id: '...' },
  { key: 'sec-2-regular-layout', id: '...' },
  // ... 9-12 个候选
]

const summary = []
for (const n of NODES) {
  const node = await relay.getNodeByIdAsync(n.id)
  if (!node) { summary.push({ key: n.key, status: 'not-found' }); continue }
  const bytes = await node.exportAsync({ format: 'PNG', constraint: { type: 'SCALE', value: 1 } })
  const b64 = chunkedB64(bytes)
  root.setSharedPluginData(NS, n.key, b64)
  summary.push({ key: n.key, w: Math.round(node.width), h: Math.round(node.height), bytesLen: bytes.length, b64Len: b64.length, status: 'set' })
}
return { ns: NS, host: root.id, summary, keys: root.getSharedPluginDataKeys(NS) }
```

**重要发现**:
- chunked 60KB 块完美绕过栈溢出
- `setSharedPluginData` 单 value 实测可存 800k+ chars,无显著上限
- 一次脚本可批 export 7-12 张图,所有 b64 都进 sharedPluginData

### Step B: 批量 readback 触发 dump

`getSharedPluginData` 取出所有图的 b64 总字符 ≥ 200KB 必然超 LLM token 限制。**这正是我们要的** —— MCP 触发 result-too-large 后自动 dump 到磁盘文件:

```javascript
const NS = 'jd-spec-page-assets'
const root = await relay.getNodeByIdAsync('<ROOT_NODE_ID>')
const keys = root.getSharedPluginDataKeys(NS)
const out = {}
for (const k of keys) out[k] = root.getSharedPluginData(NS, k)
return out
```

返回会被 MCP 错误,但 dump 文件路径会显示在 error message 里,例:
```
Error: result (2,271,336 characters) exceeds maximum allowed tokens.
Output has been saved to /path/to/tool-results/mcp-zero-design-use_design_script-{ts}.txt
```

记下这个 dump 文件路径。

### Step C: jq 解 dump + base64 -d 写 PNG

```bash
SRC=/path/to/tool-results/mcp-zero-design-use_design_script-{ts}.txt
DST_DIR=<bundle-dir>/_assets

mkdir -p "$DST_DIR"

# .[0].text 是 JSON 字符串 → fromjson 后 .key/.value (key=name, value=b64)
jq -r '.[0].text | fromjson | to_entries[] | "\(.key)\n\(.value)"' "$SRC" | while IFS= read -r KEY; do
  read -r B64
  if [ -n "$B64" ]; then
    echo "$B64" | base64 -d > "$DST_DIR/${KEY}.png"
    SZ=$(wc -c < "$DST_DIR/${KEY}.png")
    INFO=$(file -b "$DST_DIR/${KEY}.png" | cut -d, -f1-2)
    echo "✓ ${KEY}.png ${SZ}B / ${INFO}"
  fi
done
```

每张 PNG 落地到 `<bundle-dir>/_assets/{key}.png`,文件名跟 sharedPluginData key 一致。

### Step D: 清理 sharedPluginData(可选)

避免 Relay 文件膨胀,导出完成后清理:

```javascript
const NS = 'jd-spec-page-assets'
const root = await relay.getNodeByIdAsync('<ROOT_NODE_ID>')
for (const k of root.getSharedPluginDataKeys(NS)) {
  root.setSharedPluginData(NS, k, '')  // 设置空字符串清除
}
```

---

## 失败模式与兜底

| 失败 | 原因 | 兜底 |
|---|---|---|
| `base64Encode: Maximum call stack size exceeded` | raw bytes > ~150KB | 用 chunkedB64 helper(必须) |
| 单张 raw bytes > 1MB | 节点高度 > 5000px 或 SCALE 太大 | 降到 SCALE 0.5 / 切分子节点 |
| sharedPluginData set 失败 | namespace 冲突 / key 长度过长 | namespace 用 `jd-spec-page-assets`,key ≤ 64 chars |
| `<img>` 路径找不到 | _assets/ 没建 / 文件名拼错 | 写文件后 `ls -la _assets/` 必检 |
| 切图过大撑爆 HTML | 单张 PNG > 1MB | 模板 `.stage img { max-width: 100% }` 自动缩(已默认) |

---

## stage block HTML 形态(v0.2)

模板 [templates/spec-page.html](../templates/spec-page.html) 的 `<style>` 已加 `.stage--image` class:

```html
<div class="stage stage--image">
  <img src="./_assets/sec-3-island-promo.png" alt="大促灵动岛">
</div>
<div class="stage-label">📖 大促灵动岛(144×52, 渐变描边 0~60% + 异型背板)— 节点 312:47747, 1426×2154</div>
