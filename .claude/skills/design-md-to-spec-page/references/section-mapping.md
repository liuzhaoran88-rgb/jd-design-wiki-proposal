# 7 章节 ↔ design.md / bundle 字段映射

> SKILL.md Step 3 调用。把 design.md / page-doc bundle 的内容映射到 jd-toast-spec(1).html 7 章节模板。
>
> **章节名 / anchor slug 真相源在 [`../../../shared/references/section-anchors.md`](../../../shared/references/section-anchors.md)**(跨 skill 共享)。本文件只描述详情页字段→章节内容的具体映射,不再单独维护章节名 / id。

---

## 7 章节映射表

### 1. 定义

| HTML 子位置 | 来源 |
|---|---|
| `<h1>` 标题 | `frontmatter.name_zh` + `name_en` → "{name_zh} · {name_en} 组件规范" |
| 副标 meta | `frontmatter.relay_source.url` + 关联 Foundation token 列表（来自 `uses_tokens.colors/typography/...` 的类别） |
| 第 1 段定义 | `## 一句话定义` 段（bundle: `design.md`；single: 同名段） |
| 第 2 段边界 | 从 `## 应用场景 ❌` 段提炼 1 句"它的核心边界是「X」而非「Y」" |
| 对比表 | 默认 1 行：本组件 vs "近邻组件"。**近邻组件**由 frontmatter `references.uses_components` + 同 `level` 内 sibling 组件推断。无法推断 → 标 ⚠️ TBD：未识别可对比组件 |
| 立场 blockquote | 从 `## Donts` 提炼 1-2 条最强禁止规则（如"不引入 X 形态"/"不允许自定义类型"） |

### 2. 行为准则

| HTML 子位置 | 来源 |
|---|---|
| 编号 list（≤ 8 条） | `## 交互` 段提炼为 ≤ 8 条单句（每条 `<li>` 含 `<strong>` 关键词 + 后置说明）|

提炼规则：
- 含数字尺寸 / 时长 / 字符限制的 → 必入选
- "不允许 / 仅 / 强制 / 唯一性 / 非阻断" 类强约束 → 必入选
- 长描述拆短：取主语 + 谓语 + 1 个修饰，砍掉枝蔓
- 不足 8 条 → 留实际数量；超 8 条 → 取最重要 8 条 + 末尾 `<li>` 加"⚠️ {N} 条规则截断，详见 design.md"

### 3. 类型

| HTML 子位置 | 来源 |
|---|---|
| 引导句"X 共定义 N 种 X 型 + M 种 Y 型" | `## 变体 Variants` 顶部综述 |
| 类型表 | `variants.md` / 单 md `## 变体 Variants` 的**类型 / 形态维度**表（包含 标识 / 必要元素 / 关键尺寸 / 典型用途 4-5 列）|
| 实时演示 stage | 见 SKILL.md Step 5 — 静态 mockup 或 JS engine |
| 不允许扩展 blockquote | 来自 `## Donts` 含"不允许自定义" / "不引入"的禁止条 |

### 4. 结构

| HTML 子位置 | 来源 |
|---|---|
| 引导句"X 由 [原子 1 + 原子 2 + 原子 3] 构成" | 推断：从 `spec.md` colors / typography / radius 表行 + 实体描述综合 |
| 4.1 容器 子表 | `spec.md` 圆角表 + 间距表（背景 / 圆角 / padding / 最大-最小宽 / 阴影） |
| 4.2 状态图标 子表 | `spec.md` icon 引用 + 颜色 token + 尺寸（如组件无图标，整段去掉） |
| 4.3 文字 子表 | `spec.md` 文字表（层级 / 字号 / 字重 / 颜色 / token） |
| 4.4 实体预览 stage | 静态 mockup，按 `## 变体 Variants` 各形态生成（最多 4 个并排） |

### 5. 布局

| HTML 子位置 | 来源 |
|---|---|
| 5.1 位置子表 | `spec.md` 间距 / 布局段含"位置 / 距屏幕"的行；如组件是定位组件（toast/sheet/banner），单独列 center/top/bottom 选项 |
| 5.2 内部布局 ASCII | 由模型按 `spec.md` 总高度结构 + 坑位 / 内容子表生成 ASCII 框图（参考 jd-toast-spec 5.2 节风格） |
| 5.3 浅深底应用 stage | 如 `materials` 段含 light / dark token → 渲染浅深底两个 stage；否则跳过此节 |
| 5.4 动效 | 如 design.md 有 motion/transition 字段 → 渲染；否则标 ⚠️ TBD |

### 6. 正反案例

| HTML 子位置 | 来源 |
|---|---|
| 正例 N 个（target ≥ 3） | `## 应用场景 ✅` 段每个用例 → 1 个 case good。case 内容含 stage（静态 mockup）+ ul（参数列表 type/position/duration） |
| 反例 N 个（target ≥ 3） | `## Donts` 段每条 → 1 个 case bad。stage 渲染违反规则的 mockup（如 toast 反例 D 把 toast 当 snackbar），后置 `<p><strong>问题：</strong>...</p>` 解释为何违反 |

如果 `## Donts` 自动收的条目数 ≥ 3 → 全收；< 3 → 标 ⚠️ TBD。

### 7. 典型场景

| HTML 子位置 | 来源 |
|---|---|
| 大表（场景 / 类型 / 参数列 N / 文案 / 触发） | `## 应用场景 ✅` 段每条扩展为 1 行。参数列由组件性质决定（如 toast 是 type/position/duration；tabbar 是 form/slot-count/island-type） |

如组件是抽象基础组件（无典型业务场景） → 标 ⚠️ TBD：典型场景待业务录入。

### 附加段

| HTML 子位置 | 来源 |
|---|---|
| `## API 速查` | 来自 `## AI Schema` yaml 的核心 API 调用形态。如 design.md 没有 → 标 TBD |
| `## 引用` ul | frontmatter `relay_source.url` + 各 `uses_tokens.*` 类别对应的 token 文件路径 |
| 底部 meta | "JD APP V16.0 Design System · {name_zh} 规范 · 生成于 {today_iso} · 样式 = Relay 节点 {node_id}" |

---

## 章节模板（每节固定 HTML 结构）

每章节 H2 的格式：

```html
<h2 id="sec-{N}"><span class="num">{N}</span>{section_name}</h2>
```

如果某章节内无内容（来源缺失） → 在 `<h2>` 后插：

```html
<blockquote class="warn">
  <p>⚠️ <strong>TBD</strong>：本组件 design.md 暂未提供「{section_name}」内容。建议补 design.md 后重跑 /design-md-to-spec-page。</p>
</blockquote>
```

不要省略整个 `<h2>`；7 章节是契约。
