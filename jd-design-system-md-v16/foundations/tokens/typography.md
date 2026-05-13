---
token_category: typography
version: 16.0-draft
last_updated: 2026-05-12
relay_source:
  file_id: "2029484645871009793"
  page_id: "12:261"
  token_frame: "363:655"
  spec_frame: "297:165"
  url: https://relay.jd.com/file/design?id=2029484645871009793&page_id=12%3A261
v15_predecessor: ../../../jd-design-system-md/foundations/tokens/typography.md
relay_changelog:
  - "2026-04-03 ｜ 周峯 ｜ 创建"
  - "2026-04-17 ｜ 周峯 ｜ 行高向下取整偶数"
extraction_status: tokens 100% (size + weight + family + role 组合)
---

# 字体 Token · V16.0

> V16.0 字体 token 三层：**Family**（字族）× **Size**（字阶）× **Weight**（字重）。组件层引用 **Role 组合 token**（如 `font_size_14_400` = pingfang 14pt regular）。

---

## 🚩 V15 → V16 重大变化

| 维度 | V15.0 | V16.0 |
|---|---|---|
| **字阶** | 5 通用（10/12/14/15/18）+ 3 价格专用（24/18/15） | **7 通用（10/11/13/14/16/18/24）**，价格融入通用字阶 |
| **删除字号** | — | ❌ 12pt、15pt（被 11/13 / 16 替代） |
| **新增字号** | — | ✅ **11pt、13pt、16pt**（更细粒度） |
| **T-shirt size 语义** | 无 | **新增** `font_size_{xxs,xs,s,base,l,xl,xxl}` 7 级 |
| **字族命名** | `brand` / `sans` / `number` | **`pingfang` / `zhenghei`**（直用字体名） |
| **品牌字体** | 京东朗正体 V2.0 | ❌ 文字变量页未出现，疑似 V16 移除 |
| **字重** | regular(400) / semibold(600) / **bold(700)** | regular(400) / semibold(600)；**bold 700 移除** |
| **role 命名** | `typography.role.heading-page` 等 9 个 | **`{family}_{size}_{weight}` 组合 token**（26 组） |
| **行高规则** | "字号 × 1.5，奇数 -1"（loose） | **"向下取整偶数"**（2026-04-17 改） |

---

## 1. Atom 层（L1）

### 1.1 Font Family · 2 个

| Atom | 字体 | 用途 | v16 status | v15 对应 |
|---|---|---|---|---|
| `pingfang` | PingFang SC | 文字 / 标题 / 标签 主力 | **upgraded** | `typography.family.sans` |
| `zhenghei` | 京东正黑 V2.2 | **数字 / 价格 / 金额** 专用 | **upgraded** | `typography.family.number` |
| ~~`xiangzheng`~~ | ~~京东朗正体 V2.0~~ | ~~品牌字体~~ | **deprecated** | `typography.family.brand` |

> ⚠️ 京东朗正体（V15 brand 字体）在 V16 文字变量页**未出现**。需向设计师确认：是 V16 删除？还是放在了别处（如主题包）？暂标 deprecated。

### 1.2 Font Size · 7 个

> Relay 文字变量页（`363:655`）定义。

| T-shirt Size Token | Atom (Numeric) | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `font_size_xxs` | `font_size_10` | 标签文字；标签内金额 | **upgraded** | `size.10` |
| `font_size_xs` | `font_size_11` | 次要注解；搭配同字号汉字或币种符号、角分 | **new** | — |
| `font_size_s` | `font_size_13` | 辅助说明；狭小空间商品价格 | **new** | — |
| `font_size_base` | `font_size_14` | 正文；普通商卡价格 | **upgraded** | `size.14` |
| `font_size_l` | `font_size_16` | 楼层标题；重复型主价格（搜推、交易、订单） | **new** | — |
| `font_size_xl` | `font_size_18` | 页面标题；模块级总价格（购物车、结算底部条） | **upgraded** | `size.18` + `size.special.price-m` |
| `font_size_xxl` | `font_size_24` | **页面级重要价格**（商详、收银台） | **upgraded + decoupled** | `size.special.price-l`（V15 专用价格字号 → V16 升为通用字阶） |

**Rationale**：V16 重做字阶——
- **删除 12pt、15pt**：12 被 11/13 替代（更精确），15 被 16 替代（更整齐）
- **新增 11pt、13pt、16pt**：覆盖原本断档（10→14、14→18）的中间档
- **价格字号融入通用字阶**：V15 把 24/18/15 放在 `size.special.price-{l,m,s}` 子树，V16 把 24 直接升到 `font_size_xxl` 通用层，去掉 special 子树 → **解耦**

### 1.3 Font Weight · 2 个

| Atom | CSS Weight | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `regular` | 400 | 常规内容 | **upgraded** | `weight.regular` |
| `semibold` | 600 | 强化内容 | **upgraded** | `weight.semibold` |
| ~~`bold`~~ | ~~700~~ | ~~价格 / 到手价数字限定~~ | **deprecated** | `weight.bold`（V15 数字专用） |

> ⚠️ V15 `weight.bold = 700` 在 V16 文字变量页**未出现**。但主规范页（`297:165`）有「zhenghei_bold」组（实际使用 weight 600），与 zhenghei_semibold 应该等同。建议设计师确认：是命名口误（zhenghei_bold → zhenghei_semibold）还是 zhenghei 字族有不同的 weight 映射？

### 1.4 Line Height（规则，非 token）

V16 规则：**`line-height = floor(font-size × 1.5, even)`**
- 即 行高 = 字号 × 1.5，向下取整到偶数
- 例：14 × 1.5 = 21 → 向下取偶 = 20
- 例：16 × 1.5 = 24 → 偶 = 24
- 例：18 × 1.5 = 27 → 向下取偶 = 26

**Rationale**：V15.0 也是「字号 × 1.5,奇数 -1」（同效）。V16 把规则细化为「向下取整偶数」，处理边界更明确。

> 2026-04-17 更改日志原话："行高向下取整偶数"。

### 1.5 Letter Spacing（V16 暂无 token）

V15 有 `tracking.normal = 0`，V16 文字变量页未出现，沿用默认 0。

---

## 2. Role 层（L2）· 26 个组合 token

> Relay 主规范页（`297:165`）按字族分 4 组。每组 token 命名 `{family}_{size}_{weight}`，例如 `font_size_14_400` = 14pt regular。

### 2.1 pingfang_regular（PingFang SC + 400）· 6 个

> 文字主力 — 标签、注解、辅助、正文、楼层标题、页面标题。

| Token | 字号 | 字重 | 场景 |
|---|---|---|---|
| `font_size_10_400` | 10 | 400 | 标签文字 |
| `font_size_11_400` | 11 | 400 | 次要注解 |
| `font_size_13_400` | 13 | 400 | 辅助说明 |
| `font_size_14_400` | 14 | 400 | 正文 |
| `font_size_16_400` | 16 | 400 | 楼层标题 |
| `font_size_18_400` | 18 | 400 | 页面标题 |

### 2.2 pingfang_semibold（PingFang SC + 600）· 6 个

> 强化内容、模块/楼层标题、Tab 选中。

| Token | 字号 | 字重 | 场景 |
|---|---|---|---|
| `font_size_10_600` | 10 | 600 | 标签文字（强化） |
| `font_size_11_600` | 11 | 600 | 次要注解（强化） |
| `font_size_13_600` | 13 | 600 | 辅助说明（强化） |
| `font_size_14_600` | 14 | 600 | 正文（强化） |
| `font_size_16_600` | 16 | 600 | 楼层标题 |
| `font_size_18_600` | 18 | 600 | 页面标题 |

### 2.3 zhenghei_regular（京东正黑 + 400）· 7 个

> 数字 / 价格 / 金额常规态。

| Token | 字号 | 字重 | 场景 |
|---|---|---|---|
| `font_size_10_400`（zhenghei） | 10 | 400 | 标签内金额 |
| `font_size_11_400`（zhenghei） | 11 | 400 | 搭配同字号汉字或币种符号、角分 |
| `font_size_13_400`（zhenghei） | 13 | 400 | 狭小空间商品价格 |
| `font_size_14_400`（zhenghei） | 14 | 400 | 普通商卡价格 |
| `font_size_16_400`（zhenghei） | 16 | 400 | 重复型主价格（搜推、交易、订单） |
| `font_size_18_400`（zhenghei） | 18 | 400 | 模块级总价格（购物车、结算底部条） |
| `font_size_24_400`（zhenghei） | 24 | 400 | **页面级重要价格**（商详、收银台） |

### 2.4 zhenghei_bold（京东正黑 + 600）· 7 个

> 数字 / 价格 / 金额强化态。注：Relay 标 "bold" 但实际 weight=600（同 semibold）。

| Token | 字号 | 字重 | 场景 |
|---|---|---|---|
| `font_size_10_600`（zhenghei） | 10 | 600 | 标签内金额 |
| `font_size_11_600`（zhenghei） | 11 | 600 | 搭配同字号汉字或币种符号、角分 |
| `font_size_13_600`（zhenghei） | 13 | 600 | 狭小空间商品价格 |
| `font_size_14_600`（zhenghei） | 14 | 600 | 普通商卡价格 |
| `font_size_16_600`（zhenghei） | 16 | 600 | 重复型主价格 |
| `font_size_18_600`（zhenghei） | 18 | 600 | 模块级总价格 |
| `font_size_24_600`（zhenghei） | 24 | 600 | 页面级重要价格 |

> ⚠️ **命名冲突**：pingfang 和 zhenghei 的 token 名同为 `font_size_14_400`，区分依靠 family 上下文。Relay 文件中是分组命名 (pingfang_regular / zhenghei_regular)，但 token 名本身不带 family 前缀。**建议治理**：token 名加 family 前缀避免歧义，例如 `pingfang_size_14_400` / `zhenghei_size_14_400`。本文档录入时保持 Relay 原貌，建议反馈给 V16 设计组。

---

## 与 V15.0 role token 的对照

| V15 role | V15 值 | V16 等价组合 | v16 status |
|---|---|---|---|
| `heading-page` | 18 + semibold + sans | `pingfang_semibold / font_size_18_600` | **upgraded** |
| `heading-module` | 15 + semibold + sans | ❌ V16 无 15pt，最接近 `font_size_16_600` | **upgraded**（字号微调） |
| `body-standard` | 14 + regular + sans | `pingfang_regular / font_size_14_400` | **unchanged** |
| `body-secondary` | 12 + regular + sans | ❌ V16 无 12pt，最接近 `font_size_13_400` 或 `font_size_11_400` | **upgraded**（拆开） |
| `label` | 10 + regular + sans | `pingfang_regular / font_size_10_400` | **unchanged** |
| `price-large` | 24 + bold + number | `zhenghei_bold / font_size_24_600` | **upgraded**（bold→semibold） |
| `price-medium` | 18 + bold + number | `zhenghei_bold / font_size_18_600` | **upgraded** |
| `price-small` | 15 + bold + number | ❌ V16 无 15pt，最接近 `font_size_16_600` | **upgraded** |
| `price-strikethrough` | 12 + regular + number | ❌ V16 无 12pt，最接近 `font_size_13_400` | **upgraded** |

---

## 待办

- [ ] 京东朗正体（V15 brand 字体）在 V16 是否保留确认
- [ ] `weight.bold` (700) 在 V16 是否真的废弃，zhenghei_bold 实际是 600 还是 700？
- [ ] `letter-spacing` 是否 V16 保留沿用 V15 默认 0
- [ ] 容器 76:36（1186×2719）和 文字-0305 76:562（1800×10312）是否为历史样表，是否需要参考
- [ ] Role token 命名歧义治理（同名 `font_size_14_400` 跨 family 冲突）
- [ ] 写 `../visual/typography.md` 用法规范（参考 V15 同名文档）
