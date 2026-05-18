# Fallback token snapshot

> 当 `~/code/jd-design-wiki-proposal/jd-design-system-md/foundations/tokens/tokens.json` 不可读时,用本文件作为最小可走查的回退白名单。**优先**读 tokens.json。

> 同步时间:2026-05-08(更新:增加 Naming-conflict 前置规则 fallback 说明),基于 wiki main 分支。

---

## 0. 前置:Naming-conflict 检查(必跑)

**真相源已迁移至** [`../../../shared/references/naming-conflict-rules.md`](../../../shared/references/naming-conflict-rules.md) —— fingerprint 算法、触发判定、V15 已知冲突表(`colorborder` / `colortexthelp` / `colorbackgroundsunken`)、消费方契约统一在那。fallback 模式同样适用。

> 本文件作为 V15 fallback snapshot,只保留下方白名单(hex / 字号 / 圆角 / 间距)。Naming-conflict 规则的任何变更请改 shared 真相源。

---

## 颜色白名单(hex → token 名)

```
# 品牌
#ff0f23  color.brand.primary  (= color.semantic.danger,= color.functional.price)
#ff475d  color.brand.primary-gradient-stop
#ffadbe  color.brand.primary-disabled
#ffffff  color.brand.primary-text-on  (= color.neutral.bg.surface)

# 语义
#fff0f4  color.semantic.danger-subtle
#00d900  color.semantic.success
#ebfbeb  color.semantic.success-subtle
#2aa32a  color.semantic.success-strong
#ffbf00  color.semantic.warning
#fff9e0  color.semantic.warning-subtle
#b26b00  color.semantic.warning-strong
#0073ff  color.semantic.info  (= color.neutral.text.link)
#e5f5ff  color.semantic.info-subtle

# 中性 - 文字
#171a26  color.neutral.text.primary
#3d414d  color.neutral.text.secondary
#828794  color.neutral.text.tertiary
#c2c4cc  color.neutral.text.disabled

# 中性 - 背景
#f2f3f7  color.neutral.bg.body
#f5f6fa  color.neutral.bg.sunken

# 中性 - 边框 / 蒙层
#00000014  color.neutral.border.default
#00000005  color.neutral.mask.subtle
#00000066  color.neutral.mask.medium
#000000b2  color.neutral.mask.strong

# 功能 - 服务金
#b5691a   color.functional.service-gold       (VIP / 金融 主色)
#fff4e8   color.functional.service-gold-subtle (达人徽章 / 服务标签 浅底)
#b5691a05 color.functional.service-gold-subtle-2
#b5691a33 color.functional.service-gold-subtle-3
#ffe7cc   color.functional.service-gold-5
#ffd8ad   color.functional.service-gold-6
#664100   color.functional.service-gold-strong (浅底上的金色文字)
```

## 平台色板 11 阶 × 10 色族

key: `color.palette.{red,orange,yellow,light-green,green,light-blue,blue,purple,magenta,rose-red}.{1..11}`
- _1 最浅 / _6 默认主色 / _11 最深
- 完整 110 个 hex 见 tokens.json

各色 _6 默认值:
- red.6 #ff3333 / orange.6 #ff791a / yellow.6 #ffd500 / light-green.6 #92fa00
- green.6 #2ee52e / light-blue.6 #00d8f5 / blue.6 #0090ff / purple.6 #774aff
- magenta.6 #d419fa / rose-red.6 #fa25a1

---

## 字体白名单

| 维度 | 允许值 |
|---|---|
| family | `京东朗正体 V2.0` / `PingFang SC` / `京东正黑 V2.2` |
| size 基础 | **10, 12, 14, 15, 18** |
| size 价格特殊 | **15, 18, 24**(羊角符 / 角分最低 12) |
| weight | **400** / **600** / **700**(数字限定) |
| letterSpacing | 0 |
| lineHeight | 字号 × 1(单行) 或 字号 × 1.5 奇数 −1(段落) |

❌ 任何不在以上的 size 或 weight = 违规
⚠️ token 名带"临时新增" / "自定义" = 历史违规残留

---

## 圆角白名单

| Token | 值 |
|---|---|
| radius.0 | 0 |
| radius.xs | 2 |
| radius.s | 4 |
| radius.base | 6  ← 默认按钮 / 卡片 |
| radius.detail | 8  ← 内容详情型(商详 / 结算) |
| radius.xl | 12 |
| radius.structural | 24 |
| radius.full | 9999 |

---

## 间距白名单

```
0, 2, 4, 6, 7, 8, 12, 16, 20, 24, 28, 32, 40, 48, 56, 64, ... (4 的倍数延展)
```

特殊值:
- **2** 仅导购型慎用(异形)
- **6** 平台型慎用(替代 8) / 导购型常规
- **7** Feeds 横纵专用(整除像素)
- **16** 非卡片承载元素左右安全距离

塔式语义层级(按页面类型选):

| 层级 | 平台型 | 导购型 |
|---|---|---|
| 无关联(卡片内上下安全) | 16 | 12 |
| 弱关联(卡片内左右安全) | 12 | 8 |
| 常规关联(区块内子元素) | 8 | 6 |
| 紧密(图标-文字) | 4 | 4 |
| 慎用替代 | 6 | 2 |

---

## 动效白名单

| 维度 | 允许值 |
|---|---|
| 时长 | 100, **150 (s), 200 (m), 300 (l)** ms |
| 缓动 | standard `cubic-bezier(0.4, 0, 0.4, 1)` / decelerate `(0,0,0,1)` / accelerate `(1,0,1,1)` / spring `(0.5,1.4,0,1)` |
| 转场 | 容器继承 / 递进上浮 / 推屏跳转 |
| 出场时长 | ≤ 入场 1 档(l→m, m→s, s→s) |

---

## 图标白名单

| 维度 | 允许值 |
|---|---|
| 尺寸 | 16 / 20 / 24 DP |
| 字身框 | 26 × 26,留白 3DP |
| 笔触 | 16→1px / 20→1.5px / 24→1.5px |
| 等量比例 | 圆形 1:1 / 方形 8:9 / 圆角矩形 9:10 / 三角 10:11 |
| 倒圆角上限 | 2DP |

---

## 结构白名单

| 维度 | 允许值 |
|---|---|
| 逻辑尺寸 | 375 × 812 DP |
| 状态栏 | 44DP |
| 屏幕左右安全距离 | 8DP(**仅沉浸式**) |
| 起始指示器 | 34DP(可放浏览,**禁放操作**) |
| 内容详情型(商详 / 结算 / 订详) | **平铺式**(直角拉通) |
| 导购入口型(首页 / 搜索 / 购物车) | **卡片式**(小圆角 6dp 收拢) |

---

## 14.x 残留 token 黑名单

设计稿出现以下命名 = 一定要替换:

```
C_Newgray*       → color.neutral.{text,bg,border}.*
日间/线条色      → color.neutral.border.default
日间/背景色      → color.neutral.bg.surface
品牌色/日间/C_*  → color.brand.primary
辅助色/日间/*    → 对应 palette / semantic token
临时新增 后缀    → 必须移除,迁移到 5 阶字号 / 标准 token
```
