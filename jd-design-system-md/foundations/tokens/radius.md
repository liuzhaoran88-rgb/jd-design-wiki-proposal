---
token_category: radius
last_updated: 2026-05-06
relay_source:
  file_id: "1896756863949619202"
  page_id: "44:1827"
  node_id: "4061:4771"
  url: https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=4061%3A4771
sync_status: relay-aligned
---

# 圆角 Token · radius

> 京东 15.0 圆角体系简洁:**5 阶基础 + 4 类应用场景**。所有组件圆角都引用 Token,不允许硬编码。本文档与 [JD APP 15.0 设计语言 / 基础视觉设定 / 圆角](https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=4061%3A4771) 同步。

> **2026-05-06 同步说明**:本次将 v0.9 草案的 `radius.0/4/8/12/16/24/full` 7 阶调整为 Relay 15.0 实际的 `2/4/6/12/24` 5 阶。**关键变更**:`radius.button` / `radius.card` 由 `8` 改为 `6`(对应 `radius.base`);移除 `radius.16`(15.0 不使用)。

---

## 1. 基础阶梯

> Radius 阶值越大「分割」属性越强,越独立。2/4/6 用于元素描边与微块;12/24 用于结构性分割。

| Token | 值 | 别名 | 常见用途 |
|---|---|---|---|
| `radius.0` | 0 | - | 直角(列表分隔 / 全屏) |
| `radius.xs` | 2 | `radius_xs` (Relay) | 极小元素描边 / 微小标签 |
| `radius.s` | 4 | `radius_s` (Relay) | 小标签 / Tag / 骨架屏 |
| `radius.base` | 6 | `radius_base` (Relay) | **默认按钮 / 卡片 / 输入框 / 列表卡** |
| `radius.detail` | 8 | `卡片容器型/radius_8` / `组件型/Radius-8` (Relay) | **内容详情型** —— 商详 / 结算单页;某些组件型多行场景 |
| `radius.xl` | 12 | `radius-xl` (Relay) | 大卡片 / 半弹层 / 提示弹层 |
| `radius.structural` | 24 | `Radius-24` (Relay) | 结构分割型 —— 大块独立模块、长矩形顶部 |
| `radius.full` | 9999 | - | 胶囊型(头像 / 圆形按钮 / 大促胶囊按钮) |

---

## 2. 应用场景(4 类)

> 15.0 把圆角应用归为 4 类:入口卡片型 / 内容详情型 / 组件型 / 装饰型。

### a. 入口卡片型 · 6dp(`radius.base`)
**线框示例**:切片分割组件,商品卡片应用为商品流类卡片分隔。

适用:
- 切片分割:卡片型搜索、首页搜索、楼层标题、店铺楼层、临时操作组件、提示弹层 / FOAST 等
- 卡片分割(双列卡):双列卡型搜索结果、首页、店铺
- 卡片分割(单列卡):临时性组件应用、商详、PDP 等系统弹窗、楼层

### b. 内容详情型 · 8dp(`radius.detail`)
**确认 token**:Relay 中实际存在 `卡片容器型/radius_8 = 8` 与 `组件型/Radius-8 = 8` 两个变量,本仓库统一为 `radius.detail`。

适用:用于内容描述详情页面、单页操作场景、点击进入下一级页面。

线框示例:商详 / 结算 / 订单详情

### c. 组件型 · 6dp / 4dp / 24dp 等
**多种圆角应用于不同组件场景**。

线框示例:
- **单行 6dp**:单行 6dp 应用于行高较小、24dp 行高、对应 6dp 圆角
- **多行 4dp / 24dp**:多行场景应用 24dp、单行可能应用 4dp 或更小

### d. 装饰型(视觉表达性,非结构性)
图标说明:具有视觉表达,可在文化运用中、统一直接组件型组件 6dp 大小。

线框示例:
- **特殊范本类型**:具有视觉的氛围氛围,统一适用面值 6dp 显示
- **特殊插画**:可不文表式具值,统一一定值面值现一定的圆角应用场景

`> TODO: 装饰型 token 化粒度待补充(每个装饰场景单独 token 还是统一 radius.decorative?)`

---

## 3. 语义角色

| Token | 引用 | 用途 |
|---|---|---|
| `radius.button` | `radius.base` (6) | 默认按钮(可被主题覆盖为 `full`) |
| `radius.card` | `radius.base` (6) | 默认卡片 / 商品卡 / 列表卡 |
| `radius.card-detail` | `radius.detail` (8) | 内容详情型卡片 / 商详 / 结算 |
| `radius.card-large` | `radius.xl` (12) | 大卡片 / 突出卡片 / 半弹层 |
| `radius.modal` | `radius.xl` (12) | 模态对话框 / 弹层 |
| `radius.tag` | `radius.s` (4) | 标签 / Chip |
| `radius.avatar` | `radius.full` | 头像 |
| `radius.input` | `radius.base` (6) | 输入框 |
| `radius.skeleton` | `radius.s` (4) | 骨架屏 |
| `radius.structural` | `radius.structural` (24) | 结构分割型(独立大块) |
| `radius.toast` | `radius.base` (6) | Toast / 临时提示 |

---

## 4. 主题切换

大促主题可整体覆盖语义角色:

| 场景 | radius.button | radius.card |
|---|---|---|
| Default(15.0) | 6pt | 6pt |
| 618 | `> TODO: 15.0 大促主题包待交付` | `> TODO` |
| 1111 | `> TODO` | `> TODO` |
| 春节 | `> TODO` | `> TODO` |

主题切换由 Token 层完成,组件代码不感知。

---

## 5. 反例

| ❌ 反面 | 解释 |
|---|---|
| `border-radius: 8px` | 硬编码,不在 15.0 5 阶内(15.0 用 6 不用 8) |
| `border-radius: 10px` | 硬编码,不在阶梯内 |
| 同一卡片不同位置不同圆角 | 不允许(除非是有意识的视觉手段) |
| 小尺寸用大圆角(如 24pt 用在 32pt 高的按钮) | 视觉破碎 |
| 在主流程使用 `radius.0`(直角)| 15.0 风格普遍偏柔和,直角仅用于全屏 / 列表分隔 |

---

## 6. 注意事项

- **iOS 自带继承超圆角(superellipse)**,Token 值在 iOS 实际渲染会略偏圆润
- **大促胶囊按钮**圆角 = 高度的一半,等价于 `radius.full`
- **图片裁剪**圆角通过 mask 实现,引用 `radius.card` 或独立 Token

---

## 7. 历史版本

- **v1.0(2026-05-06)**:与 Relay 15.0 对齐;`base` 由 8 改为 6;移除 `radius.16`;新增 `radius.xs(2)` 与 `radius.structural(24)`。
- v0.9(2026-04):草案版,7 阶值不与 15.0 对齐。
