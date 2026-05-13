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

// ⚠️ v0.1.1 修复：root.findAll() 默认不包括 root 自身。
// 把 root 和所有 descendants 合在一起，避免漏掉 root 节点的属性（特别是 cornerRadius/fills/layout）
const all = [root, ...root.findAll(() => true)]

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

// (b) 文字样式
const textStyles = []
for (const n of all) {
  if (n.type === 'TEXT' && typeof n.fontSize === 'number') {
    textStyles.push({
      chars: (n.characters || '').slice(0, 80),
      fontSize: n.fontSize,
      family: n.fontName?.family || null,
      style: n.fontName?.style || null,
    })
  }
}

// (c) 圆角 — v0.1.1 修：处理 4 种情况
//   ① cornerRadius 是 number（4 角统一） → 直接收
//   ② cornerRadius 是 relay.mixed（4 角不同） → 看个体 topLeftRadius 等
//   ③ cornerRadius 是 0 → 跳过（直角）
//   ④ 节点无 cornerRadius 字段 → 跳过
const radii = new Set()
for (const n of all) {
  if (!('cornerRadius' in n)) continue
  const cr = n.cornerRadius
  if (cr === relay.mixed) {
    // mixed: 读 4 个角，每个 > 0 都收
    for (const corner of ['topLeftRadius', 'topRightRadius', 'bottomLeftRadius', 'bottomRightRadius']) {
      const v = n[corner]
      if (typeof v === 'number' && v > 0) radii.add(v)
    }
  } else if (typeof cr === 'number' && cr > 0) {
    radii.add(cr)
  }
}

// (d) INSTANCE 引用（不含 root 自身 — root 是文档主题，不算子组件引用）
const instances = []
for (const n of all) {
  if (n.type === 'INSTANCE' && n.id !== root.id) {
    instances.push({ id: n.id, name: n.name })
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
    })
  }
}

// (f) 变体 — 两种来源：
//   ① root 是 COMPONENT_SET → children 即所有变体
//   ② root 是 INSTANCE/COMPONENT → componentProperties (v0.2 加)
let variants = []
let variantProps = null
if (root.type === 'COMPONENT_SET') {
  variants = (root.children || []).map(c => ({ id: c.id, name: c.name }))
}
// v0.2: 抽 componentProperties (VARIANT type) 用于 slug 后缀
if (root.type === 'INSTANCE' || root.type === 'COMPONENT') {
  const cp = root.componentProperties || {}
  variantProps = {}
  for (const [key, prop] of Object.entries(cp)) {
    if (prop?.type === 'VARIANT' && typeof prop.value === 'string') {
      // key 形如 "样式" 或 "样式#676:0"，去掉 ID 后缀
      const cleanKey = key.split('#')[0]
      variantProps[cleanKey] = prop.value
    }
  }
}

return {
  rootInfo: {
    id: root.id, name: root.name, type: root.type,
    page_name: pg?.name, page_id: pg?.id,
    w: Math.round(root.width), h: Math.round(root.height),
    description: root.description || null,
  },
  fileKey: relay.fileKey,
  uniqueFills: [...fills],
  textStyles: textStyles.slice(0, 30),    // 防溢出
  uniqueRadii: [...radii].sort((a, b) => a - b),
  instances: instances.slice(0, 30),
  layouts: layouts.slice(0, 20),
  variants,
  variantProps,   // v0.2: 用于 slug 后缀推断
}
```

> **v0.1.1 修复（2026-05-13）**：
> - `all` 数组从 `root.findAll()` 改为 `[root, ...root.findAll()]`，确保 root 节点本身被遍历
> - 圆角处理新增 `relay.mixed` 分支，可抽出 4 角不同情况下的个体角值
> - INSTANCE 引用过滤掉 root 自身（防止 root 是 INSTANCE 时被误算成"子组件引用"）
> - 影响：所有圆角在 root 节点上的组件（按钮 / 卡片 / 弹窗 / 容器等）现在能正确抽到 radius token

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
