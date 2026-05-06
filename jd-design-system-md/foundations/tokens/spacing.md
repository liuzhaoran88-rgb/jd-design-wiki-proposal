---
token_category: spacing
last_updated: 2026-05-06
relay_source:
  file_id: "1896756863949619202"
  page_id: "44:1827"
  node_ids:
    layout-1: "31728:1615"
    layout-2: "31728:1"
  url: https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=31728%3A1
sync_status: relay-aligned
---

# 间距 Token · spacing

> 京东 15.0 间距 = **两套布局梯度(平台型 / 导购型)+ 塔式语义层级 + 4 倍率延展**。本文档与 [JD APP 15.0 设计语言 / 基础视觉设定 / 布局-1](https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=31728%3A1615) 与 [布局-2](https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=31728%3A1) 同步。
>
> **铁律**:所有 padding / margin / gap 必须引用 Token,不允许写裸数字。

> **2026-05-06 同步说明**:本次将 v0.9 的单一 4pt 基线扩展为 Relay 15.0 的**双梯度体系**(平台型 4 基量 + 导购型 2 基量),引入塔式原理对应的 5 级语义关联(无关联 / 弱关联 / 常规 / 紧密 / 慎用)。

---

## 1. 双梯度体系

> 依据不同内容密度,精细化元素布局提供两个梯度,分别对应**导购型**和**平台型**使用,标准元素以 4 的倍率逐步递增,两种基量标准在空间布局中适用于「间距」及「尺寸」。

### a. 平台型(基量 4)
**适用**:平台型、系统流程型页面,对屏效**没有极致压缩的诉求**(商详 / 结算 / 订详 / 我京 / 设置)。

常规阶梯: **4、8、12、16**
延展规则:以 4 为基量递增 — 20、24、28、32、36、40 …

### b. 导购型(基量 2)
**适用**:**内容密度较大**的导购型页面(搜索 / 双列流 / 频道页)。
基于平台型布局,进行**排布梯度降级**。

常规阶梯: **2、4、6、8、12**
延展规则:同平台型(以 4 为基量)
**首页作为极端情况定制处理,不具备参考性。**

---

## 2. 塔式原理(语义层级)

> Relay 原文:**塔式原理将信息聚合成区块,先「外」后「内」,由外向内由大到小层层递减,形成疏密布局思路,以便合理呈现页面内「包含」、「对比」、「排比」等层级归属关系。**

### 平台型 5 级语义

| 语义层级 | 间距 | Token | 用途 |
|---|---|---|---|
| 无关联内容 | 16 | `spacing.semantic.platform.unrelated` | 相对独立的信息之间;**卡片内上下安全距离** |
| 弱关联内容 | 12 | `spacing.semantic.platform.loose` | 并列关联区块信息,如商卡的主图 / 店铺信息 / 商品信息;**卡片内左右安全距离** |
| 常规关联内容 | 8 | `spacing.semantic.platform.normal` | 区块内信息,如商品信息中的名称 / 规格 / 价格 |
| 替代常规关联(慎用)| 6 | `spacing.semantic.platform.alt` | 例:空间不足或异形造成的视差替代 8DP 使用 |
| 紧密关联内容 | 4 | `spacing.semantic.platform.tight` | 图标和文字、文字和箭头等 |

### 导购型 5 级语义

| 语义层级 | 间距 | Token | 用途 |
|---|---|---|---|
| 无关联内容 | 12 | `spacing.semantic.shopping.unrelated` | 同级别无关联内容,如我京订单信息 / 物流信息;**卡片内上下安全距离** |
| 弱关联内容 | 8 | `spacing.semantic.shopping.loose` | 不同区块信息,如搜索卡片内的商品名称 / 亮点 / 价格 / 辅助信息;**卡片内左右安全距离** |
| 常规关联内容 | 6 | `spacing.semantic.shopping.normal` | 同区块内子元素 |
| 紧密关联内容 | 4 | `spacing.semantic.shopping.tight` | 图标和文字、文字和箭头等 |
| 狭小空间内紧密关联(慎用)| 2 | `spacing.semantic.shopping.alt` | 例:异形造成的视差替代 4DP 使用 |

---

## 3. 基础阶梯

| Token | 值 | 阶梯归属 | 常见用途 |
|---|---|---|---|
| `spacing.0` | 0 | 通用 | 紧贴 |
| `spacing.2` | 2 | 导购型 | 极小间隙(图标-数字 微调,慎用) |
| `spacing.4` | 4 | 平台 / 导购 | 紧密关联(图标-文字、文字-箭头) |
| `spacing.6` | 6 | 平台(替代,慎用)/ 导购(常规)| 异形 / 空间不足时的 8DP 替代;导购型常规关联 |
| `spacing.8` | 8 | 平台 / 导购 | 平台型常规关联;导购型弱关联 |
| `spacing.12` | 12 | 平台 / 导购 | 平台型弱关联;导购型无关联 |
| `spacing.16` | 16 | 平台 | 平台型无关联;**非卡片元素左右安全距离** |
| `spacing.20` | 20 | 延展 | 平台型延展 |
| `spacing.24` | 24 | 延展 | 平台型延展 / 大模块间距 |
| `spacing.28` | 28 | 延展 | 平台型延展 |
| `spacing.32` | 32 | 延展 | 平台型延展 / 大留白 |
| `spacing.40` | 40 | 延展 | 节庆装饰间距 |

**对应 Relay 变量**:`元素布局/Spacing-4` = 4、`元素布局/Spacing-6` = 6,以及上述其他阶值。

---

## 4. 通栏 / 卡片间距

> Relay 15.0 布局-1 节点明确以下规则。

| 场景 | 间距 |
|---|---|
| 平台型通栏间距 | **12DP**(`spacing.12`) |
| 导购型通栏间距 | **8DP**(`spacing.8`) |
| 通栏与可滑动非通栏混排 — 非通栏内部 | **8DP**(`spacing.8`) |
| 通栏与可滑动非通栏混排 — 非通栏外部 | **12 或 8DP**(按通栏场景) |
| Feeds 横纵间距 | **7DP** ⚠️ 像素整除友好的特殊值 |
| 其他非通栏卡片内部间距 | 优先整除像素,接近 **7DP** 即可 |
| 非卡片承载元素距屏幕左右安全距离 | **16DP**(`spacing.16`) |

> **关于 7DP**:这是 Relay 15.0 为了在 375 屏宽下双列卡能整除像素而引入的特殊值,**不属于 4 基量阶梯**。建议工程实现允许 7px,但限定在 Feeds 场景。

---

## 5. 元素尺寸延展

> Relay 原文:**为确保元素与栅格之间拥有更完善、体系化的布局效果,元素尺寸延展以 4 的基量递增,常规使用 4、8、12、16、20、24、28、32、40 …**

间距与尺寸共用同一阶梯,**避免引入并行的尺寸 token**。

---

## 6. 语义间距(组件层引用)

| Token | 引用 | 用途 |
|---|---|---|
| `spacing.role.page-edge` | `spacing.16` (16) | 页面左右边距(非卡片承载元素) |
| `spacing.role.section-gap.platform` | `spacing.12` (12) | 平台型通栏间距 |
| `spacing.role.section-gap.shopping` | `spacing.8` (8) | 导购型通栏间距 |
| `spacing.role.card.padding-v.platform` | `spacing.16` (16) | 平台型卡片内上下安全 |
| `spacing.role.card.padding-h.platform` | `spacing.12` (12) | 平台型卡片内左右安全 |
| `spacing.role.card.padding-v.shopping` | `spacing.12` (12) | 导购型卡片内上下安全 |
| `spacing.role.card.padding-h.shopping` | `spacing.8` (8) | 导购型卡片内左右安全 |
| `spacing.role.icon-text-gap` | `spacing.4` (4) | 图标与文字 |
| `spacing.role.feeds-gap` | `7` (特殊) | Feeds 横纵 |
| `spacing.role.button.padding-h.L` | `spacing.16` (16) | L 按钮水平内边距 |
| `spacing.role.button.padding-h.M` | `spacing.12` (12) | M 按钮水平内边距 |
| `spacing.role.button.padding-h.S` | `spacing.8` (8) | S 按钮水平内边距 |
| `spacing.role.button.padding-h.XS` | `spacing.4` (4) | XS 按钮水平内边距 |
| `spacing.role.modal-padding` | `spacing.16` (16) | 弹窗内边距 |

---

## 7. 安全区 · safe-area

> Relay 15.0 结构节点定义,详见 [[../visual/layout.md]]。

| Token | 值 | 用途 |
|---|---|---|
| `spacing.safe-area.status-bar` | 44DP | iOS 顶部状态栏 |
| `spacing.safe-area.home-indicator` | 34DP | 底部起始指示器(可放浏览内容,**禁放操作**) |
| `spacing.safe-area.screen-edge` | 8DP | 屏幕左右安全距离(沉浸式氛围专用) |
| `spacing.safe-area.bottom` | 设备相关(自动获取) | iOS / Android safe-area-inset-bottom |
| `spacing.bottom-tab-height` | 49pt(iOS)/ 48pt(Android) | 底部 Tab Bar 高度 |

**铁律**:任何固定底部的元素(底部 CTA / 工具栏)必须考虑 safe-area。

---

## 8. 决策树:选哪个 spacing?

```
当前页面是?
├── 平台型(商详 / 结算 / 订详 / 我京 / 设置)→ 用 4/8/12/16 + 平台型语义
└── 导购型(搜索 / 双列流 / 频道)→ 用 2/4/6/8/12 + 导购型语义
    └── 例外:首页作为极端情况定制处理

间距用途是?
├── 卡片内上下安全 → 平台 16 / 导购 12
├── 卡片内左右安全 → 平台 12 / 导购 8
├── 区块内子元素   → 平台 8  / 导购 6
├── 紧密(图-文)   → 4(两套都是)
├── 通栏间距       → 平台 12 / 导购 8
└── Feeds 卡片     → 7(特殊,整除像素)
```

---

## 9. 反例

| ❌ 反面 | 解释 |
|---|---|
| 写裸数字 `padding: 14px` | 破坏 4 基量体系 |
| 平台型页面用 2DP 间距 | 平台型禁用 2,只在导购型慎用 |
| 卡片内上下安全用 12(平台型)| 应该是 16,违反塔式原理 |
| 通栏间距随意混用 12 / 8 | 平台型 12,导购型 8,不可混 |
| 双梯度强行统一(只用 4 的倍数)| 失去导购型紧凑表达力 |
| Feeds 用 8DP | 应该用 7DP(整除像素) |
| 自定义新阶梯(如 spacing.10) | 必须走治理流程 |

---

## 10. 历史

- **v1.0(2026-05-06)**:与 Relay 15.0 双梯度体系对齐;新增塔式原理 5 级语义层级;新增平台型 / 导购型独立 token 命名空间;Feeds 7DP 列为特殊值。
- v0.9(2026-04):草案版,单一 4pt 基线 + 简化语义,与 15.0 双梯度不一致。
