---
token_category: typography
last_updated: 2026-05-06
relay_source:
  file_id: "1896756863949619202"
  page_id: "44:1827"
  node_id: "4282:1884"
  url: https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=4282%3A1884
sync_status: relay-aligned
---

# 字体 Token · typography

> 京东 APP 字体体系 = **3 字族(品牌字 / 中文正文 / 数字字族)+ 5 阶基础字号 + 3 阶价格字号 + 2 阶字重**。本文档与 [JD APP 15.0 设计语言 / 基础视觉设定 / 文字](https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=4282%3A1884) 同步。

> **2026-05-06 同步说明**:本次将 v0.9 草案的 13 阶字号阶梯收敛到 Relay 15.0 实际投产的 5 阶 + 3 阶价格特殊。多余 display 阶 / heading 4 阶等草案字号已**移除**(在 15.0 主流程中禁用)。

---

## 1. 字族 · font-family

> 15.0 明确 3 套字体并行,各自有清晰的领地。

| Token | iOS / Android | 用途 |
|---|---|---|
| `typography.family.brand` | 京东朗正体 V2.0 | **品牌字体** —— 业务标题、部分标志型文字应用 |
| `typography.family.sans` | PingFang SC / 思源黑体 | **中文基础内容** —— 移动端界面文字主力 |
| `typography.family.number` | 京东正黑 V2.2 | **数字 / 金额字族** —— 价格 / 数量 / 金额(品牌识别) |
| `typography.family.mono` | `> TODO: 15.0 未规范` | 代码 / ID 展示 |

**关键说明(15.0 文字章节原文)**:
- a. 京东朗正体 2.0 作为京东品牌生态的重要组成部分,在业务标题及部分标志型文字应用上可采用京东朗正体搭配业务图形作为品牌形象传达。
- b. 在移动端界面设计中,字体的使用会受到系统的限制,因此在设计稿中使用 PingFang SC 苹方字体作为基础内容字体。苹方字体中也有携带英文文字的,所以中英文文版禁止重新设置英文字体,以中英文文版为准的字体。
- c. 在数字及金额的字体选择上尽可能选择中京东正黑 2.2,来使品牌的整体形象更可以最大化表达。

**数字字族特别说明**:启用 OpenType `tnum`(tabular-nums)特性,价格 "¥99.00" 中每个数字宽度一致,跳动时不抖。

---

## 2. 字号阶梯 · font-size

### 基础字号(主流程禁用 < 10pt)

> 5 阶刚好够用,**新设计需求不允许引入阶梯外字号**。

| Token | size (pt) | line-height | 应用场景 |
|---|---|---|---|
| `typography.size.18` | 18 | 18(单行)/ 8dp 间距 | 页面标题、弹窗标题 |
| `typography.size.15` | 15 | 15 / 8dp | **页面最重要的内容**、楼层模块卡片标题(如商详详细名称、楼层标题、结算金额信息) |
| `typography.size.14` | 14 | 14 / 6dp | 标准内容、名称类卡号信息(如海报、购物车、结算、订单等模块的商品名称) |
| `typography.size.12` | 12 | 12 / 6dp | 次要内容、辅助类信息 |
| `typography.size.10` | 10 | 9 / 4dp | 标签、空间局促时的修饰说明 |

**对应 Relay 变量**:
- `苹方Regular/font_size_{10,12,14,15,18}_400`
- `苹方Medium/font_size_{10,14,15}_600`
- `苹方Semibold/T3-14-600`、`苹方Semibold/T4-16-600`(注:T4 实际尺寸为 16,与基础阶非主流程,慎用)

### 特殊字号 · 仅价格 / 角标 / 羊角符

> 突破基础字阶为 3 类价格场景,羊角符号和角分在主价基础上降两档梯度,**最低不小于 12pt**。

| Token | size (pt) | line-height | 应用场景 |
|---|---|---|---|
| `typography.size.special.price-l` | 24 | 24 | 页面级:商详、收银台等商品主价格 |
| `typography.size.special.price-m` | 18 | 18 | 模块级:购物车、结算等模块主价格 |
| `typography.size.special.price-s` | 15 | 15 | 重型级:搜索、订单列表等商品主价格 |

**对应 Relay 变量**:`京东正黑2.2Regular/font_size_{12,14,15,18,24}_400` + `京东正黑2.2Bold/font_size_24_400`

---

## 3. 字重 · font-weight

> 常规汉字内容应用 **Regular** 字重,特殊强化内容允许使用 **Semibold** 字重来强化对比。**因研发原因,其他字重不可使用。**

| Token | iOS / Android | 用途 |
|---|---|---|
| `typography.weight.regular` | 400 | 默认正文(全场景) |
| `typography.weight.medium` | 500 | `> TODO: Relay 15.0 列出但 lineHeight 一致(实际等同 Regular),仅在数字 Medium token 中出现` |
| `typography.weight.semibold` | 600 | **强化内容** —— 适用于零售终端强化内容文字、楼层标题、店铺标题、List 内项引导、促销信息提示;Tab 选中态、主按钮文字、突出展示信息或为常规内容化等、小范围说明 |
| `typography.weight.bold` | 700 | **数字限定** —— 用于价格、到手价等重要场景使用 Bold;用于灰字符、京东原价等对比场景使用 Regular |

**禁用**:
- 不允许 100 / 200(过细,弱视用户识别困难)
- 不允许 800 / 900(过粗,15.0 视觉传统不符)

**字重应用**:
| 场景 | 字重 |
|---|---|
| 主价 / 到手价 | Bold |
| 灰字 / 京东原价(对比) | Regular |
| 一般数字表达 | Regular |

---

## 4. 行高 · line-height

> 15.0 明确 3 类行距应用,根据是否多行 / 元素混排切换。

### a. 行距应用(单行场景)
**单行文本推荐使用,字框上下无余量**。行距标准为字号的 0.5 倍,若遇奇数则 −1。

```
T15:size=15 → lineHeight=15(0.5 间距)
T16:size=16 → lineHeight=16(0.5 间距,= -1=15)
```

### b. 行高应用(段落场景)
**段落文本推荐使用,字框上下有余量**。排版时候注意减去余量,再计算栅格布局。行距标准为字号的 **1.5 倍**,若遇奇数则 −1。

```
T18:size=18 → lineHeight=27(1.5 倍)
T15:size=15 → lineHeight=22(1.5 倍 -1=22)
```

### c. 元素混排(多元素场景)
字框上下有余量,行高标准为字号的 **1.5 倍**,若遇奇数则 −1。

**Token 表达**:每个 `typography.size.*` Token 已自带配套行高;混排场景需额外使用 `typography.line-height.tight`(单行)或 `typography.line-height.loose`(段落 / 混排)。

| Token | 倍率 | 用途 |
|---|---|---|
| `typography.line-height.tight` | 字号 × 1 | 单行(按钮 / Tag / 一行标题) |
| `typography.line-height.loose` | 字号 × 1.5 | 段落 / 元素混排 |

---

## 5. 字间距 · letter-spacing

> Relay 15.0 当前所有 token `letterSpacing: 0`。

| Token | 值 | 用途 |
|---|---|---|
| `typography.tracking.normal` | 0 | 默认(15.0 全部值) |
| `typography.tracking.tight` | `> TODO: 15.0 暂未规范,沿用 v0.9 草案 -0.01em` | 大号标题(收紧) |
| `typography.tracking.loose` | `> TODO: 15.0 暂未规范` | 全大写英文 / 标签 |

---

## 6. 语义字体角色

> 用于组件 visual.md 引用,屏蔽底层字号阶梯细节。

| Token | 引用 | 用途 |
|---|---|---|
| `typography.heading.page` | `size.18` + `weight.semibold` + `family.sans` | 页面 / 弹窗主标题 |
| `typography.heading.module` | `size.15` + `weight.semibold` + `family.sans` | 楼层 / 模块卡片标题 |
| `typography.body.standard` | `size.14` + `weight.regular` + `family.sans` | 标准正文(商品名称等) |
| `typography.body.secondary` | `size.12` + `weight.regular` + `family.sans` | 次要内容 / 辅助 |
| `typography.label` | `size.10` + `weight.regular` + `family.sans` | 标签 / 修饰文字 |
| `typography.price.large` | `special.price-l` (24pt) + `weight.bold` + `family.number` | 商详 / 收银台主价格 |
| `typography.price.medium` | `special.price-m` (18pt) + `weight.bold` + `family.number` | 购物车 / 结算主价格 |
| `typography.price.small` | `special.price-s` (15pt) + `weight.bold` + `family.number` | 搜索 / 订单列表价格 |
| `typography.price.strikethrough` | `size.12` + `family.number` + 删除线 | 划线价 |
| `typography.button.L` | `> TODO: 15.0 按组件粒度交付,暂未在文字基础规范中收敛` | L 尺寸按钮 |
| `typography.input` | `> TODO` | 输入框文字 |
| `typography.placeholder` | `> TODO` + `color.neutral.text.tertiary` | 占位符 |

---

## 7. 字号缩放 · font-scaling

> Relay 15.0 当前未单独规范字号缩放表(归属于 a11y 章节)。

`> TODO: 待 [[../../horizontal/multi-platform/font-scaling.md]] 与 a11y 章节同步,确认 15.0 字号缩放阶梯(85% / 100% / 130% / 150%)是否仍然适用。`

---

## 8. 多语言支持

> Relay 15.0 文字章节聚焦中文体系,多语言部分**待补充**。

`> TODO: 京东全球版的英文 / 西语 / 繁体中文字族选择需独立交付,可暂沿用 v0.9 方案。`

---

## 9. 反例

| ❌ 反面 | 解释 |
|---|---|
| 字号阶梯外的值(如 16pt 17pt 20pt) | 破坏 15.0 5 阶刚需统一性 |
| 价格不用京东正黑 V2.2 | 失去品牌识别 |
| 主流程使用 < 10pt | 无障碍不达标(15.0 明文禁止) |
| 单行文本使用 1.5 倍行高 | 行间空间过大,视觉松散 |
| 段落文本使用 0.5 倍间距 | 行间粘连,阅读困难 |
| 价格用 Regular 字重 | 主价必须 Bold,弱化视觉权重 |

---

## 10. 历史版本

- **v1.0(2026-05-06)**:与 Relay 15.0 实际投产对齐;字号收敛到 5 阶 + 价格特殊 3 阶;字族明确 3 套(朗正体 / 苹方 / 京东正黑 V2.2)。
- v0.9(2026-04):草案版,13 阶字号(display/heading/body/caption)冗余,未与 15.0 对齐。
