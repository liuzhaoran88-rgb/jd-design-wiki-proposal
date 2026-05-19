# Frontmatter Spec

> SKILL.md Step 5.5 / Step 8 调用本文件。`design-outline.md` 与 `design.md` 使用不同 frontmatter 约束。

---

## `design-outline.md`（确认稿，不进 traceability）

```yaml
---
file: design-outline
level: component-base
bg: horizontal
slug: "navbar-search-day"
name_zh: "搜索条日间"
name_en: "NavBar / SearchBar Day"
last_synced: "2026-05-19"

auto_detected:
  level: component-base
  bg: horizontal
  slug: "navbar-search-day"

relay_source:
  file_id: "..."
  page_id: "..."
  node_id: "..."
  node_name: "..."
  node_type: FRAME
  bounds: { w: 375, h: 224 }
  url: "https://relay.jd.com/..."
---
```

约束：

1. `file` 固定为 `design-outline`
2. outline 只用于确认门，不参与 `INDEX.md`、`used_by`、Relay sharedPluginData
3. outline 可保留待确认项 / 风险项，**不要求**像正式 `design.md` 一样补齐所有 TODO

---

## `design.md`（正式稿，进入 traceability）

---

## 完整字段（必填 + 可选）

```yaml
---
file: design                     # ★必填，固定值 "design"
level: component-base            # ★必填，受控词表（见下）
bg: horizontal                   # ★必填，受控词表（见下）
slug: "navbar-search-day"        # ★必填，kebab-case，唯一
name_zh: "搜索条日间"             # ★必填
name_en: "NavBar / SearchBar Day" # 可选，from slug 反推

owner: "@xushui2018"             # ★必填（git config 推断 / TODO 兜底）
contributors: []                 # 可选
status: draft                    # ★必填，受控词表 (draft/review/published/deprecated)
version: "0.1"                   # ★必填
last_synced: "2026-05-13"        # ★必填 ISO date

auto_detected:                   # ★必填 — skill 自动填，review 时改 fields 也要改这里
  level: component-base          # （可附 ⚠️ fallback 标记）
  bg: horizontal
  slug: "navbar-search-day"

relay_source:                    # ★必填整个 block
  file_id: "..."                 # ★必填
  page_id: "..."                 # ★必填
  node_id: "..."                 # ★必填
  node_name: "..."               # ★必填
  node_type: FRAME               # 可选（FRAME/COMPONENT/COMPONENT_SET/INSTANCE）
  bounds: { w: 375, h: 224 }     # 可选
  url: "https://relay.jd.com/..." # ★必填

references:                      # 可选整个 block（无引用时省略也行）
  uses_components: []
  uses_tokens:
    colors: []
    typography: []
    radius: []
    spacing: []
    materials: []

used_by: []                      # ★必填（哪怕空也写，skill 后续 append）
---
```

## 受控词表

### level（4 个值，v0.1 实际只产 1 个）

```
component-base      # L1 通用组件（v0.1 默认）
component-business  # L2 业务组件（v0.3+）
page                # L3 页面（v0.4+）
flow                # L4 流程（v0.4+）
```

### bg（受控词表，必从中选）

```
horizontal   # 跨 BG 通用（L1 默认）
retail       # 零售（JD 主站、商详、购物车、结算）
health       # 京东健康
finance      # 京东金融 / 京东科技
logistics    # 京东物流
global       # 国际站
jx           # 京喜
industrial   # 工业品
```

> 维护：扩展 bg 需要 ① 改本文件 ② 改 [bg-mapping.json](./bg-mapping.json) `mappings` 接入业务 file_id。

### status（4 个值）

```
draft       # 设计师起草中（skill 默认产）
review      # 提 PR 待 review
published   # 已合并、生产中
deprecated  # 已弃用
```

---

## 校验规则（v0.2 加自动校验脚本）

1. **file 字段固定** = "design"
2. **level + bg 组合限制**：
   - `level: component-base` 且 `bg ≠ horizontal` → 警告（通常通用组件 = horizontal）
   - `level ≠ component-base` 且 `bg = horizontal` → 警告（业务级设计应有具体 BG）
3. **slug 格式**：
   - 必须 kebab-case：`^[a-z0-9]+(-[a-z0-9]+)*$`
   - 不能以数字开头
   - 长度 2-50 字符
4. **relay_source.url 必须可解析**：URL 中应能提取 file_id / page_id / node_id 三者
5. **last_synced 必须 ISO date** (YYYY-MM-DD)
6. **uses_tokens 项必须是 V16 tokens.json 里存在的 token 名** — v0.2 加校验脚本

校验失败的 design.md → CI block PR 或本地 `pre-commit` 报错（v0.2 加）。

---

## 渲染规则（design.md 内文档体）

frontmatter 与文档体的关系：

| frontmatter 字段 | 渲染到文档体哪里 |
|---|---|
| `name_zh` + `name_en` | H1 标题（`# {name_zh} · {name_en}`） |
| `relay_source.url` | 文档顶部 "Relay" 链接（H1 下方） |
| `relay_source.node_id` | 同上，作为可视化的节点 ID |
| `last_synced` | 文档顶部 "自动同步" 时间 + 变更记录表格首行 |
| `references.uses_tokens.colors` 等 | 视觉 section 各表格用到的 token 名（一致性） |
| `references.uses_components` | 注：这是 hyperlink 后期可点击；v0.1 写相对路径 |
| `auto_detected` | 不渲染到文档体，只在 frontmatter 区，作为 review 提示 |

**关键**：frontmatter 是 single source of truth。文档体里的 token 名引用必须与 frontmatter `uses_tokens` 一致。skill 写文件时**一次性**生成，避免漂移。
