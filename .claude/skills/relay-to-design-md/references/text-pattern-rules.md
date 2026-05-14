# text node 文本 pattern 识别规则

> SKILL.md Step 4 调用本文件。统一抽取脚本拿到 `textStyles[]` 后，按下面规则把每条文本归类到 5 个 bucket，写到 design.md 对应 section。v0.4 加。

---

## 1. 5 个 bucket

每个 text node 试 5 个 pattern，命中第 1 个即归类（不可重复）：

| Bucket | Pattern | 去向 |
|---|---|---|
| `chapter_title` | `fontSize ≥ 32` **且** 文本包含 `/^\s*\d{1,2}[\.、 ]?\s*[一-龥]/` 或英文 chapter heading | `## 章节大纲` 段（page-doc 模式） |
| `figure_label` | 文本完全匹配 `/^图\s*\d+[\.：:]?\s*.{0,40}$/` | 当前章节的 `figures[]` |
| `dont_rule` | 文本以 `禁止` / `不可` / `不要` / `不能` 开头，**或** 文本含 `❌` / `不允许` | `## Donts` 段（自动收，不再 TODO） |
| `dimension_spec` | 文本匹配 `/^\s*\d+(\.\d+)?\s*(DP|dp|px|PX|%)(\s|$|×|x|\*)/i`（含组合如 `131×44 DP`） | 当前章节的 `dimensions[]` |
| `description` | 长度 ≥ 6 且不是纯英数字/纯符号 | 当前章节的 `notes[]` |

> 短文本（< 6 字符）但非 figure_label / dont_rule / dimension_spec → 丢弃（视为 UI 装饰文字，如 "Tab" / "01" / "+"）。

---

## 2. 章节归属

每个 text node 抽取时附带 `ancestorPath: [rootChildId, ...]`（root 的第 1 层直接子 frame id）。这一层即"章节"边界（page-doc 模式下 root.children 就是章节列表）。

- 抽取脚本里：`let cur = n; while (cur.parent && cur.parent.id !== root.id) cur = cur.parent;`  → 此时 `cur.id` 即 chapter root id
- 把 text node 写到 `chapters[i].notes[]` / `chapters[i].donts[]` / `chapters[i].figures[]` / `chapters[i].dimensions[]`

---

## 3. 章节大纲优先抽

每个 chapter 必抽以下 5 字段：

```ts
{
  id: string,         // chapter root id
  name: string,       // chapter root name
  bounds: { w, h },
  title: string | null,   // 章节标题（chapter_title bucket 第 1 条）
  figures: { label, ctx }[],   // 图 N 列表
  donts: string[],
  dimensions: { value, ctx }[],
  notes: string[],
}
```

`ctx` 是这个 text node 同 frame 内最近的兄弟 text（首选 `description` bucket、其次 `chapter_title`），用于给 figure / dimension 配语境。脚本里抽：`n.parent?.children?.filter(c => c !== n && c.type==='TEXT')` 取第一个有效。

---

## 4. 落到 design.md

| Bucket | design.md 位置 |
|---|---|
| chapter_title | `## 章节大纲` 表格的「章节标题」列 |
| figures | 章节细节段 `### 图 N` 子标题（含 ctx 描述） |
| dimensions | `### 间距 / 布局` 表 + 各章节细节段 |
| donts | `## Donts` 段（自动收，每条引用来源章节） |
| notes | 章节细节段 `> {notes}` 引用块（≤ 3 条/章节，避免淹没） |

---

## 5. fallback

如果 5 个 bucket 全没命中（极少数：纯数字 / 纯单字符）→ 丢弃，不写到 design.md。

如果某个章节的所有 text 都没匹配上 figure / dimension / dont → 该章节细节段只渲染 chapter_title + notes 前 3 条。
