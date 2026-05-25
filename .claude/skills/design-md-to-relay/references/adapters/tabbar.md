# Tabbar Adapter · Tabbar 适配器

本 adapter 沉淀 Tabbar 特异性教训,**不让主 skill 变成 Tabbar 专属**。

**不是** `tabbar/design.md` 的副本。运行时永远从源 wiki 仓库实时读真实 Tabbar 规范。本 adapter 只解释「**如何把 Tabbar wiki 字段映射成 Relay 节点计划**」。

## Scope 澄清问题

用户说「画一个底导」且没指定 scope 时,问:

```text
你要的是一个底导放在手机页面里的示意，还是底导组件的多状态规范展示？
```

**不要**创建多个 Tabbar 变体,除非用户要求。

## 单实例常见默认值

仅在 wiki 确认 + 用户 scope 匹配 JD APP 手机页面时使用:

| 字段 | 值 | 来源 |
|---|---|---|
| 手机页面 | 375 × 812 | foundation/visual/layout.md |
| 底部 layer | 69 | tabbar/design.md 02.1 |
| 导航实际高 | 52 | tabbar/design.md 02.1 |
| 浮动安全区 | 17 | tabbar/design.md 02.1 |
| Joy Agent atom | 52 × 52 | tabbar/design.md 02.6 |
| Joy Agent 出血抽缩 | 16 | tabbar/design.md 02.6 |
| Joy Agent 到 capsule 间距 | 8 | tabbar/design.md 02.6 |
| capsule(含 Joy Agent) | 319 × 52 | tabbar/design.md 02.1 |
| Tab atom | 44 × 44 | tabbar/design.md 02.4 |
| icon box | 20 × 20,y=3 | tabbar/design.md 02.4 |
| label box | 44 × 14,y=27 | tabbar/design.md 02.4 |
| 选中 pill 左右 inset | 4(slot 内) | Zero ground truth(wiki gap,见 issue #60 Gap 1) |
| 选中 pill 圆角 | radius_xl (12) | tabbar/design.md 设计令牌总表 |

## 文本规则

Tabbar 的 label **必须用固定文本框**:

```text
textAutoResize = NONE
width = 44
height = 14
y = 27
fontSize = 10
lineHeight = 14
align = center
```

否则中文 label 会按内容收缩,视觉偏离 icon 中线。(R3 教训 #2)

## 分层规则

分开如下层:

- **slot 分布层**(capsule 内 `layoutGrow=1` 子节点)
- **选中背景视觉层**(pill:gray_6 fill + radius_xl)
- **44 × 44 tab atom 内容层**(icon + label 的容器)
- **icon box**(20 × 20 SVG 容器)
- **label box**(44 × 14 固定 bound 文本)

**不要**把选中背景直接挂在 icon / label 节点上。(R3 教训 #3)

## Ground Truth 用法

原版 Relay Tabbar 节点(如 `266:475` Joy Agent 形态,`266:674` 常规形态)**只用来**:

- 补缺失尺寸
- 检测 wiki 字段过时 / 不完整
- 生成 wiki gap 报告

**不要** clone,除非用户显式要求。

## 资产规则

- icon SVG **优先**。`_assets-cdn.md` 只登记 PNG 时,**使用 PNG + flag wiki gap**(见 issue #60 Gap 4)
- Joy Agent atom(`_assets-cdn.md` 里的 `312:58236`):当前是 64 × 64 PNG;SVG 源待补
- 各坑位 icon(home / 分类 / 消息 / 我的):**当前 wiki 仅登记 home 一张**;其他坑位必须标到 `assetUsage.placeholder` + 显式 wiki gap

## 变体覆盖(用户要求全套时)

完整 Tabbar 变体矩阵(参 `tabbar/variants.md`):

| 维度 | 取值 |
|---|---|
| 形态 | 常规 / Joy Agent 组合 |
| 坑位数 | 2 / 3 / 4 / 5 |
| 坑位状态 | 默认 / 选中 / 营销 |
| 招手状态 | 无 / 红点 / 数字 / 文字 |
| 灵动岛 | 无 / 常规 / 运营 / 大促 |

「**全状态矩阵**」输出需要用户**显式确认**;默认 scope 是 1 个坑位数 × 1 种状态。

## R3 走查发现的 wiki gap(2026-05-20)

这几个 gap 都在生成 R3 参考稿时浮出,全部归入上游 [issue #60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60):

| Gap | 章节 | 症状 |
|---|---|---|
| 1 | 02.4 交互状态表 | 选中 bg L/R inset (4 DP) + 圆角(`radius_xl`)没声明 |
| 2 | 组件层表 | 列了 Relay 节点 ID(`266:475` / `266:674`)但没明示「以它们为 ground truth」 |
| 3 | 02.x 对齐描述 | 写了几何结果数值,但 Auto Layout 模式没明文 |
| 4 | `_assets-cdn.md` | 只登记 PNG,SVG channel 缺失 |

skill v0.2 跑动时这些 gap 会出现在 `wikiGapsFound` 输出里,直到上游 PR 合并掉。

## R3 实现 pitfall(教训 4 条)

1. **选中 bg 尺寸**:不要把 bg 挂在 44×44 atom 上;独立 pill 层做,尺寸 `(slot − 8) × 44`
2. **label 水平对齐**:不要依赖默认 `textAutoResize` 下的 `textAlignHorizontal`;用固定文本框或 Auto Layout 居中
3. **状态背景分层**:视觉层(pill)和内容层(atom)分 frame,避免状态切换跟内容布局打架
4. **icon 资产格式**:SVG 优先于 PNG;各坑位 SVG 今天缺失,**flag wiki gap 而不是悄悄用 PNG 凑数**
