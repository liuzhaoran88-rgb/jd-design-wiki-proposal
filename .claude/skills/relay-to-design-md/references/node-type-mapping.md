# Relay 节点属性 → design.md section 对照

> SKILL.md Step 4 调用本文件。**所有视觉数据抽取走唯一脚本**（第 2 节），不要碎片化分多次脚本调用 — 降低 MCP 失败概率 + 减少抽取一致性问题。

---

## 1. 对照表（Relay 属性 → design.md section）

| Relay 来源 | design.md 位置 | 提取代码片段 |
|---|---|---|
| `node.name` | H1 标题 + name_zh / name_en | (Step 2 已抽) |
| `node.type` | frontmatter `relay_source.node_type` | (Step 2 已抽) |
| `node.width`, `node.height` | frontmatter `relay_source.bounds` | `Math.round(node.width)` |
| `node.description` (PublishableMixin) | "## 一句话定义" 段（默认填，如有） | `node.description \|\| null` |
| 子 TEXT 的 chars | "## 文案" 段（v0.1 暂不抽，留 v0.2） | `node.findAll(n => n.type==='TEXT')` |
| 子节点 fills (SOLID) | "## 视觉 / 色彩" 段 | 见统一脚本 |
| 子节点 fills (IMAGE) | `_assets-cdn.md` 切图清单（v0.5.2） | 见统一脚本 (g) + [cutout-detection.md](./cutout-detection.md) |
| 子节点 textStyles | "## 视觉 / 文字" 段 | 见统一脚本 |
| 子节点 cornerRadius | "## 视觉 / 圆角" 段 | 见统一脚本 |
| 子节点 autoLayout 字段 | "## 视觉 / 间距" 段 | 见统一脚本 |
| 子节点 INSTANCE | "## 视觉 / 材质" + frontmatter `uses_components` | 见统一脚本 |
| COMPONENT_SET 的 variants | "## 变体" 段 | 见统一脚本 |
| 父级 PAGE 名 | 推断 level（不进 md） | (Step 2 已抽) |
| `relay.fileKey` | 推断 bg / frontmatter relay_source.file_id | (Step 2 已抽) |

---

## 2. 统一抽取脚本（Step 4 用 这个）

`use_design_script` 调用，code 字段如下（**直接复制**）：

```javascript
const ROOT_ID = '<NODE_ID>'  // 调用前替换成真实 node id
const root = await relay.getNodeByIdAsync(ROOT_ID)
if (!root) return { error: 'node not found' }

// 加载所在 page (确保 children 可读)
let pg = root
while (pg && pg.type !== 'PAGE') pg = pg.parent
if (pg && pg.loadAsync) await pg.loadAsync()

// 工具：色值转 hex
function rgbHex({r, g, b}) {
  const t = v => Math.round(v * 255).toString(16).padStart(2, '0').toUpperCase()
  return '#' + t(r) + t(g) + t(b)
}

// v0.4: page-doc 模式判定
// 触发条件（任一）：root.height > 5000  或  ≥ 3 个 FRAME/GROUP 子项
function isPageDoc(r) {
  if (r.height > 5000) return true
  const frameKids = (r.children || []).filter(c => c.type === 'FRAME' || c.type === 'GROUP')
  return frameKids.length >= 3
}
const pageDocMode = isPageDoc(root)

// v0.4.1: 缓存 root.children 的 id Set，chapterOf 走 parent 链时 O(1) 命中即停
const rootChildIds = new Set((root.children || []).map(c => c.id))

// ⚠️ v0.1.1 修复：root.findAll() 默认不包括 root 自身。
// 把 root 和所有 descendants 合在一起，避免漏掉 root 节点的属性（特别是 cornerRadius/fills/layout）
const all = [root, ...root.findAll(() => true)]

// v0.4: 章节归属 — 找每个节点的第 1 层 ancestor (root.children 之一)
//   如果不是 page-doc 模式，所有节点章节统一是 null（章节细分不渲染）
function chapterOf(n) {
  if (!pageDocMode) return null
  // v0.4 fix: root 自身没有章节，直接 short-circuit。
  // 否则 while 循环会上爬到 root.parent (PAGE/DOCUMENT) 然后返回错章节。
  if (n.id === root.id) return null
  // v0.4.1: rootChildIds Set O(1) 命中，避免每条 walk 时反复对比 root.id
  let cur = n
  while (cur.parent && !rootChildIds.has(cur.id)) cur = cur.parent
  if (!rootChildIds.has(cur.id)) return null  // 安全兜底：n 不在 root 子树
  return { id: cur.id, name: cur.name }
}

// v0.4: text pattern 分类 — 见 references/text-pattern-rules.md
function classifyText(chars, fontSize) {
  const s = (chars || '').trim()
  if (!s) return null
  // chapter_title
  if (fontSize >= 32 && /^\s*\d{1,2}[\.、 ]?\s*[一-龥]/.test(s)) return 'chapter_title'
  // figure_label
  if (/^图\s*\d+[\.：:]?\s*.{0,40}$/.test(s)) return 'figure_label'
  // dont_rule
  if (/^(禁止|不可|不要|不能|不允许)/.test(s) || s.includes('❌')) return 'dont_rule'
  // dimension_spec
  if (/^\s*\d+(\.\d+)?\s*(DP|dp|px|PX|%)(\s|$|×|x|\*|\/)/i.test(s) ||
      /^\s*\d+\s*[×x\*]\s*\d+\s*(DP|dp|px|PX)?/i.test(s)) return 'dimension_spec'
  // description（长度 ≥ 6 且不是纯英数字/纯符号）
  if (s.length >= 6 && /[一-龥]/.test(s)) return 'description'
  return null
}

// (a) 所有 SOLID fills + opacity
const fills = new Set()
for (const n of all) {
  if ('fills' in n && Array.isArray(n.fills)) {
    for (const f of n.fills) {
      if (f?.type === 'SOLID' && f.visible !== false) {
        const op = (f.opacity != null && f.opacity < 1) ? `@${Math.round(f.opacity * 100)}%` : ''
        fills.add(rgbHex(f.color) + op)
      }
    }
  }
}

// (b) 文字样式 + v0.4 pattern 分类 + 章节归属
const textStyles = []
for (const n of all) {
  if (n.type === 'TEXT' && typeof n.fontSize === 'number') {
    const chars = (n.characters || '').slice(0, 200)   // v0.4: 80 → 200
    const bucket = classifyText(chars, n.fontSize)
    textStyles.push({
      chars,
      fontSize: n.fontSize,
      family: n.fontName?.family || null,
      style: n.fontName?.style || null,
      bucket,                          // v0.4
      chapter: chapterOf(n),           // v0.4
    })
  }
}

// (c) 圆角 — v0.1.1 修：处理 4 种情况
const radii = new Set()
for (const n of all) {
  if (!('cornerRadius' in n)) continue
  const cr = n.cornerRadius
  if (cr === relay.mixed) {
    for (const corner of ['topLeftRadius', 'topRightRadius', 'bottomLeftRadius', 'bottomRightRadius']) {
      const v = n[corner]
      if (typeof v === 'number' && v > 0) radii.add(v)
    }
  } else if (typeof cr === 'number' && cr > 0) {
    radii.add(cr)
  }
}

// (d) INSTANCE 引用 + v0.4 absoluteBoundingBox + 章节归属
const instances = []
for (const n of all) {
  if (n.type === 'INSTANCE' && n.id !== root.id) {
    const bb = n.absoluteBoundingBox || null
    instances.push({
      id: n.id,
      name: n.name,
      // v0.4: 加 size（相对自身，绝对坐标减 root.x/y 不靠谱因为有 nested transform）
      size: bb ? { w: Math.round(bb.width), h: Math.round(bb.height) } : null,
      chapter: chapterOf(n),
    })
  }
}

// (e) 自动布局
const layouts = []
for (const n of all) {
  if ('layoutMode' in n && n.layoutMode && n.layoutMode !== 'NONE') {
    layouts.push({
      id: n.id, name: n.name,
      mode: n.layoutMode,
      padding: { l: n.paddingLeft, r: n.paddingRight, t: n.paddingTop, b: n.paddingBottom },
      spacing: n.itemSpacing,
      chapter: chapterOf(n),         // v0.4
    })
  }
}

// (f) 变体 — 两种来源
let variants = []
let variantProps = null
if (root.type === 'COMPONENT_SET') {
  variants = (root.children || []).map(c => ({ id: c.id, name: c.name }))
}
if (root.type === 'INSTANCE' || root.type === 'COMPONENT') {
  const cp = root.componentProperties || {}
  variantProps = {}
  for (const [key, prop] of Object.entries(cp)) {
    if (prop?.type === 'VARIANT' && typeof prop.value === 'string') {
      const cleanKey = key.split('#')[0]
      variantProps[cleanKey] = prop.value
    }
  }
}

// (g) v0.5.2: 切图侦测 —— 带 IMAGE 类型 fill 的节点 = 位图资产（切图），必须 CDN 托管。
// token / 矢量都无法表达位图，抽取层只负责"揪出来"，登记 / 提醒在 SKILL Step 5.2 / 8.5。
// 判据与 _assets-cdn.md 行格式见 references/cutout-detection.md。
const imageNodes = []
for (const n of all) {
  if (!('fills' in n) || !Array.isArray(n.fills)) continue
  const imgFill = n.fills.find(f => f?.type === 'IMAGE' && f.visible !== false)
  if (!imgFill) continue
  const bb = n.absoluteBoundingBox || null
  imageNodes.push({
    id: n.id,
    name: n.name,
    type: n.type,
    size: bb ? { w: Math.round(bb.width), h: Math.round(bb.height) }
             : (n.width && n.height ? { w: Math.round(n.width), h: Math.round(n.height) } : null),
    imageHash: imgFill.imageHash || null,   // 同 hash = 同一张切图被多处复用
    scaleMode: imgFill.scaleMode || null,
    chapter: chapterOf(n),
  })
}

// v0.4: chapters 元数据（page-doc 模式）
let chapters = null
if (pageDocMode) {
  chapters = (root.children || []).map(c => ({
    id: c.id,
    name: c.name,
    type: c.type,
    bounds: c.width && c.height ? { w: Math.round(c.width), h: Math.round(c.height) } : null,
  }))
}

return {
  rootInfo: {
    id: root.id, name: root.name, type: root.type,
    page_name: pg?.name, page_id: pg?.id,
    w: Math.round(root.width), h: Math.round(root.height),
    description: root.description || null,
    pageDocMode,                     // v0.4
    nodeCount: all.length,           // v0.5.3: 预检门规模维度用
  },
  fileKey: relay.fileKey,
  uniqueFills: [...fills],
  textStyles: textStyles.slice(0, 200),    // v0.4: 30 → 200
  uniqueRadii: [...radii].sort((a, b) => a - b),
  instances: instances.slice(0, 150),      // v0.4: 30 → 150
  layouts: layouts.slice(0, 50),           // v0.4: 20 → 50
  variants,
  variantProps,
  chapters,                                // v0.4: page-doc 模式才有
  imageNodes: imageNodes.slice(0, 100),    // v0.5.2: 切图侦测
}
```

> **v0.1.1 修复（2026-05-13）**：
> - `all` 数组从 `root.findAll()` 改为 `[root, ...root.findAll()]`，确保 root 节点本身被遍历
> - 圆角处理新增 `relay.mixed` 分支，可抽出 4 角不同情况下的个体角值
> - INSTANCE 引用过滤掉 root 自身（防止 root 是 INSTANCE 时被误算成"子组件引用"）
> - 影响：所有圆角在 root 节点上的组件（按钮 / 卡片 / 弹窗 / 容器等）现在能正确抽到 radius token

> **v0.4 升级（2026-05-13）** —— 支持 page-doc 大节点：
> - 新增 `pageDocMode` 判定：root.height > 5000 **或** root.children 有 ≥ 3 个 FRAME/GROUP 子项 ⇒ page-doc
> - text 抽取按 [text-pattern-rules.md](./text-pattern-rules.md) 分 5 类 bucket（chapter_title / figure_label / dont_rule / dimension_spec / description），写到 textStyles[].bucket
> - 所有 text / instance / layout 加 `chapter` 字段（root.children 第 1 层归属），便于按章节归类
> - instance 加 `size`（来自 absoluteBoundingBox），用于"灵动岛 131×44 DP"这类 DP 抽取
> - 提升 limit：textStyles 30→200，instances 30→150，layouts 20→50，text chars 80→200
> - 返回新增 `chapters[]` 元数据（仅 page-doc 模式）：每个章节 id / name / bounds

> **v0.5.2 升级（2026-05-20）** —— 切图侦测：
> - 新增 (g) 段：扫所有节点的 `fills`，凡带 `type === 'IMAGE'` 且 `visible !== false` 的判为切图，收进 `imageNodes[]`
> - 每条含 `id / name / type / size / imageHash / scaleMode / chapter`；`imageHash` 相同说明同一张切图被多处复用，登记时可去重
> - 返回新增 `imageNodes`（上限 100）。**原脚本只收 SOLID fill、IMAGE fill 被静默丢弃**，导致切图资产无法被自动识别 —— 本次修复
> - 下游处理见 [cutout-detection.md](./cutout-detection.md) + SKILL.md Step 5.2 / 8.5

> **v0.5.3 升级（2026-05-20）** —— 稿件预检门：
> - `rootInfo` 新增 `nodeCount`（= `all.length`，root + 全部 descendants 数）
> - 供 SKILL.md Step 4.5 预检门「节点规模」维度判断单次抽取是否会 token 超限，见 [preflight-gate.md](./preflight-gate.md)

> 返回数据结构稳定，本文档同时也是这个脚本的**契约**。

---

## 3. 处理 instances 字段

每个 instance 可能是：
- V16 图标（name 在 `tokens/icon.md` 库里 → frontmatter `uses_components` 加 `horizontal/components-base/icon-{name}`）
- V16 材质（name 含 "Liquid Glass" / "Frosted Glass" → frontmatter `uses_tokens.materials` 加对应 token）
- 业务子组件（其他 name → frontmatter `uses_components` 加，但**path 留 TODO**）

判断算法：

```javascript
// 伪码
if (instance.name matches /^(Liquid Glass|Frosted Glass)/) {
  → uses_tokens.materials += material-slug-from(instance.name)
} else if (instance.name in V16_ICON_LIBRARY) {
  → uses_components += "horizontal/components-base/icon-" + kebab(instance.name)
  → frontmatter 注释: # icon '{name}' V16 已在 icon.md 列出但尚未单独 design.md
} else {
  → uses_components += "TODO/" + kebab(instance.name)
  → frontmatter 注释: # 注：'{name}' 尚未录入 design.md，待后续
}
```

V16 图标库见 [../../../jd-design-system-md-v16/foundations/tokens/icon.md](../../../jd-design-system-md-v16/foundations/tokens/icon.md)。
