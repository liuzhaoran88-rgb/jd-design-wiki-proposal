# text node 文本 pattern 识别规则

> SKILL.md Step 4 调用本文件。统一抽取脚本拿到 `textStyles[]` 后，按下面规则把每条文本归类到 5 个 bucket，写到 design.md 对应 section。v0.4 加。

---

## 1. 5 个 bucket

每个 text node 试 5 个 pattern，命中第 1 个即归类（不可重复）：

| Bucket | Pattern | 去向 |
|---|---|---|
| `chapter_title` | `fontSize ≥ 32` **且** 文本匹配 `/^\s*\d{1,2}[\.、 ]?\s*[一-龥]/` | `## 章节大纲` 段（page-doc 模式）|
| `figure_label` | 文本完全匹配 `/^图\s*\d+[\.：:]?\s*.{0,40}$/` | 当前章节的 `figures[]` |
| `dont_rule` | 文本以 `禁止` / `不可` / `不要` / `不能` / `不允许` 开头，**或** 文本含 `❌` | `## Donts` 段（自动收，不再 TODO） |
| `dimension_spec` | 文本匹配 `/^\s*\d+(\.\d+)?\s*(DP\|dp\|px\|PX\|%)(\s\|$\|×\|x\|\*\|\/)/i`（含组合如 `131×44 DP`、`14/lh 20`） | 当前章节的 `dimensions[]` |
| `description` | 长度 ≥ 6 且含中文字符 | 当前章节的 `notes[]` |

> v0.4.1 (2026-05-14)：表格 pattern 与 `node-type-mapping.md` 抽取脚本里的 `classifyText()` 实现保持 1:1 一致。chapter_title 仅支持中文标号（v0.5 再加英文 fallback）。dimension_spec 接受 `/` 分隔符（如 `font_size_14/lh20`）。

> 短文本（< 6 字符）但非 figure_label / dont_rule / dimension_spec → 丢弃（视为 UI 装饰文字，如 "Tab" / "01" / "+"）。

---

## 2. 章节归属

每个 text node 抽取时附带 `ancestorPath: [rootChildId, ...]`（root 的第 1 层直接子 frame id）。这一层即"章节"边界（page-doc 模式下 root.children 就是章节列表）。

- 抽取脚本里：`let cur = n; while (cur.parent && cur.parent.id !== root.id) cur = cur.parent;`  → 此时 `cur.id` 即 chapter root id
- 把 text node 写到 `chapters[i].notes[]` / `chapters[i].donts[]` / `chapters[i].figures[]` / `chapters[i].dimensions[]`

---

## 3. 章节归属：抽取层 vs 渲染层

**抽取脚本只在每条 text/instance/layout 上加 `chapter` 字段（`{id, name}` 或 `null`），不做章节聚合。**

模板渲染层（SKILL.md Step 8）按 `chapter.id` 做 group-by，把同章节的 text 按 bucket 分桶为 `figures / donts / dimensions / notes`。

**不在抽取层聚合的理由**：
- 抽取脚本已经 200 行，加聚合逻辑会让单个 `use_design_script` 调用更脆弱
- 渲染层用 string substitution 而非 control flow（见 SKILL.md "占位符语义"），group-by 在模型一次性构造段落时本就要做
- `chapters[]` 元数据（id / name / bounds）已由抽取脚本返回，渲染时按这个列表迭代即可

**渲染期望的章节聚合形态**（仅供模板渲染参考，**不是**抽取脚本返回结构）：

```ts
// 渲染层在内存里构造的形态
{
  id: string,
  name: string,
  bounds: { w, h },
  title: string | null,             // chapter_title bucket 首条
  figures: { label, ctx }[],        // figure_label bucket
  donts: string[],                  // dont_rule bucket
  dimensions: { value, ctx }[],     // dimension_spec bucket
  notes: string[],                  // description bucket（建议 ≤ 3 避免淹没）
}
```

`ctx` 是该文本节点同 frame 内最近的兄弟 text（首选 `description` 桶、其次 `chapter_title`），渲染层从抽取结果里查找。

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
