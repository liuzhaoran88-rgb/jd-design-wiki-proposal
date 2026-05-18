# `level` 词表(跨 skill 共享真相源)

## 枚举值

design.md frontmatter 中 `level` 字段**必须**取以下值之一:

| `level` | 状态 | 含义 | 典型路径 |
|---|---|---|---|
| `component-base` | ✅ 在用 | 通用基础组件(按钮 / 输入框 / 列表 / 弹层 / 顶部导航等) | `jd-design-system-md-v16/horizontal/components-base/{slug}/design.md` |
| `component-business` | ✅ 在用(兜底值) | 业务组件 / 无法判定时兜底 | `jd-design-system-md-v16/product-architecture/{bg}/components/{slug}/design.md` |
| `page` | ✅ 在用 | 页面级(典型尺寸 ≈ 375×≥600) | `jd-design-system-md-v16/product-architecture/{bg}/pages/{slug}/design.md` |
| `flow` | ✅ 在用 | 流程级(多屏并列,尺寸 ≥ 1000×1000) | `jd-design-system-md-v16/product-architecture/{bg}/flows/{slug}/design.md` |
| `foundation` | 🟡 预留(尚未启用) | 基础规范(色彩 / 字体 / 圆角 / 间距 / 图标 / 动效),非组件;V16 `foundations/` 目录当前还没产出 design.md,真正写入时启用 | `jd-design-system-md-v16/foundations/{kind}/design.md` |

兜底:无法判定 → `component-business` + frontmatter `auto_detected.level` 标 ⚠️。

## `level` vs `bg` 边界(常见混淆)

`level` 描述**抽象层级**,`bg` 描述**业务背景**,二者正交。

| 维度 | 取值 | 谁决定 |
|---|---|---|
| `level` | 上表 5 选 1 | Relay 节点类型 + 尺寸 + page 命名(详见 relay-to-design-md `references/auto-detect-rules.md`) |
| `bg` | `horizontal` / `jdretail` / `jdsupermarket` / ... | Relay file_id → bg 映射(详见 relay-to-design-md `references/auto-detect-rules.md`) |

**`horizontal` 是 `bg` 值,不是 `level` 值。** V16 master file(`2029484645871009793`)下的所有组件 `bg = horizontal`,它们的 `level` 仍然是 `component-base` / `foundation`。

## 各 skill 消费方式

| skill | 消费方式 |
|---|---|
| relay-to-design-md | Step 5 写 frontmatter `level`;Step 10.5 写 Relay sharedPluginData `level` |
| design-md-to-site | 按 `level` 分组渲染 section,**不要**把 `bg` 当 level 用 |
| design-md-to-spec-page | 按 `level` 过滤可生成 spec page 的对象(目前仅 `component-base` / `component-business` / `foundation`,`page` / `flow` 走另一套模板,TBD) |

## 变更规则

新增/删除 `level` 枚举值 → 必须同步:
1. 本文件枚举表
2. `relay-to-design-md/references/auto-detect-rules.md` 的推断规则表
3. 上述 3 个消费方 SKILL.md 中的分组/过滤逻辑
