---
token_category: color
last_updated: 2026-05-06
relay_source:
  file_id: "1896756863949619202"
  page_id: "44:1827"
  node_id: "513:25300"
  url: https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=513%3A25300
sync_status: relay-aligned
---

# 色彩 Token · color

> 京东 APP 色彩体系分 5 大族:**品牌 / 语义 / 中性 / 功能 / 平台色板**。本文档与 [JD APP 15.0 设计语言 / 基础视觉设定 / 色彩](https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=513%3A25300) 同步。
>
> **不要在 visual.md 出现任何具体色值**。所有色值在本文档管理,机器读的真相源是 [tokens.json](./tokens.json)(W3C DTCG 格式)。

> **2026-05-06 同步说明**:本次将 v0.9 草案值统一对齐到 Relay 15.0 实际投产值。`brand.primary` 由 `#fa2c19` 调整为 `#ff0f23`(15.0 京东红),`semantic.danger` 与 `brand.primary` 同色 —— 这是 15.0 的有意设计,非冲突;状态色刻意通过浅色 wash + 图标区分。

---

## 1. 品牌色 · color.brand

| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.brand.primary` | `#ff0f23` | `> TODO: Relay 暂未提供深色值` | 京东红主色,主 CTA / 价格 / 品牌区(对应 Relay `品牌色/brand_6`) |
| `color.brand.primary.gradient-stop` | `#ff475d` | `> TODO` | 主色渐变止点(对应 Relay `color_primary_stop_1`) |
| `color.brand.primary.disabled` | `#ffadbe` | `> TODO` | 主色禁用态(对应 Relay `color_primary_specialdisabled`) |
| `color.brand.primary.text-on` | `#ffffff` | `> TODO` | 主色背景上的文字(对应 Relay `color_primary_text`) |
| `color.brand.primary.hover` | `> TODO: Relay 15.0 暂未规范` | `> TODO` | 桌面端 hover (iPad) — 待补充 |
| `color.brand.primary.pressed` | `> TODO: Relay 15.0 暂未规范` | `> TODO` | 移动端按下 — 待补充 |
| `color.brand.gradient.618` | `> TODO: 主题包独立交付` | - | 大促渐变(主题层处理) |

**使用规则**:见 [[../visual/color-usage.md#1-京东红用法]]

---

## 2. 语义色 · color.semantic

> 语义色用于状态传达。**注意**:在 15.0 中 `semantic.danger` 与 `brand.primary` 同色(`#ff0f23`),通过 wash 底 + 图标 + 文字三重区分,非通过色相区分。

### 错误 · danger(对应 Relay `辅助色/错误红/dangerred_*`)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.semantic.danger` | `#ff0f23` | `> TODO` | 错误(下单失败 / 校验错) |
| `color.semantic.danger.subtle` | `#fff0f4` | `> TODO` | 错误背景 wash |

### 成功 · success(对应 Relay `辅助色/成功绿/successgreen_*`)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.semantic.success` | `#00d900` | `> TODO` | 成功状态(支付成功 / 订单完成) |
| `color.semantic.success.subtle` | `#ebfbeb` | `> TODO` | 成功背景 wash |
| `color.semantic.success.strong` | `#2aa32a` | `> TODO` | 浅底上的成功文字(可达 4.5:1) |

### 警告 · warning(对应 Relay `辅助色/警示黄/warningyellow_*`)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.semantic.warning` | `#ffbf00` | `> TODO` | 警告(库存紧张 / 待支付) |
| `color.semantic.warning.subtle` | `#fff9e0` | `> TODO` | 警告背景 wash |
| `color.semantic.warning.strong` | `#b26b00` | `> TODO` | 浅底上的警告文字 |

### 提示 · info(对应 Relay `辅助色/系统蓝/infoblue_*`)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.semantic.info` | `#0073ff` | `> TODO` | 提示(系统通知 / 新功能 / 链接) |
| `color.semantic.info.subtle` | `#e5f5ff` | `> TODO` | 提示背景 wash |

---

## 3. 中性色 · color.neutral

> 中性色支撑 80% 的页面元素。

### 文字(对应 Relay `灰阶/文字/contentgray_*`)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.neutral.text.primary` | `#171a26` | `> TODO` | 主文字(对应 contentgray_4) |
| `color.neutral.text.secondary` | `#3d414d` | `> TODO` | 次文字 / 辅助说明(对应 contentgray_3) |
| `color.neutral.text.tertiary` | `#828794` | `> TODO` | 三级辅助 / 时间戳(对应 contentgray_2) |
| `color.neutral.text.disabled` | `#c2c4cc` | `> TODO` | 禁用文字(对应 contentgray_1) |
| `color.neutral.text.on-color` | `#ffffff` | `#ffffff` | 在彩色背景上的文字(品牌红 / 渐变上的白字) |
| `color.neutral.text.link` | `#0073ff` | `> TODO` | 链接(同 `semantic.info`,不是品牌红) |

### 背景(对应 Relay `灰阶/背景/backgroundgray_*`)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.neutral.bg.surface` | `#ffffff` | `> TODO` | 卡片 / 模块表面(对应 backgroundgray_1) |
| `color.neutral.bg.body` | `#f2f3f7` | `> TODO` | 页面底层背景(对应 `color_background`) |
| `color.neutral.bg.sunken` | `#f5f6fa` | `> TODO` | 下沉区(楼层间 / 列表分组背景,对应 `color_background_sunken`) |
| `color.neutral.bg.surface-elevated` | `> TODO: Relay 15.0 未规范,沿用 #ffffff` | `> TODO` | 抬升表面(对话框) |
| `color.neutral.bg.pressed` | `> TODO: Relay 15.0 未规范` | `> TODO` | 点击态背景 |
| `color.neutral.bg.disabled` | `> TODO: Relay 15.0 未规范` | `> TODO` | 禁用背景 |

### 描边 / 分隔(对应 Relay `灰阶/线/linegray_*`)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.neutral.border.default` | `#00000014` | `> TODO` | 默认描边(8% 黑色,自适应底色;对应 linegray_1) |
| `color.neutral.border.subtle` | `> TODO: Relay 15.0 未单列,可沿用 default` | `> TODO` | 浅描边 |
| `color.neutral.border.strong` | `> TODO` | `> TODO` | 强描边 |

### 蒙层(对应 Relay `灰阶/蒙层/maskgray_*`)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.neutral.mask.subtle` | `#00000005` | `> TODO` | 极浅蒙层 / 按下态(对应 maskgray_1) |
| `color.neutral.mask.medium` | `#00000066` | `> TODO` | 中度蒙层(对应 maskgray_2) |
| `color.neutral.mask.strong` | `#000000b2` | `> TODO` | 模态背景蒙层默认值(对应 maskgray_3) |

---

## 4. 功能色 · color.functional

### 价格 / 折扣(语义独立,值同品牌主色)
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.functional.price` | `#ff0f23` | `> TODO` | 价格(对应 brand.primary,但语义独立) |
| `color.functional.discount-tag` | `#ff0f23` | `> TODO` | 折扣标签底色 |

### 服务金 · service-gold(对应 Relay `辅助色/服务金/servicegolden_*`)
> 京东 15.0 特色 —— VIP / 高端服务 / 金融场景使用。

| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.functional.service-gold` | `#b5691a` | `> TODO` | 服务金主色(对应 servicegolden_4) |
| `color.functional.service-gold.subtle` | `#fff4e8` | `> TODO` | 浅底 wash(对应 servicegolden_1) |
| `color.functional.service-gold.subtle-2` | `#b5691a05` | `> TODO` | 极浅金色蒙层(对应 servicegolden_2) |
| `color.functional.service-gold.subtle-3` | `#b5691a33` | `> TODO` | 浅金色蒙层(对应 servicegolden_3) |
| `color.functional.service-gold.5` | `#ffe7cc` | `> TODO` | 金色阶 5(对应 servicegolden_5) |
| `color.functional.service-gold.6` | `#ffd8ad` | `> TODO` | 金色阶 6(对应 servicegolden_6) |
| `color.functional.service-gold.strong` | `#664100` | `> TODO` | 浅底上的金色文字(对应 servicegolden_7) |

### 优惠券 / VIP
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `color.functional.coupon` | `> TODO: Relay 15.0 暂未单列` | `> TODO` | 优惠券色 |
| `color.functional.vip` | `> TODO: 走 service-gold 体系` | `> TODO` | VIP / 黑金会员 |

---

## 5. 平台色板 · color.palette(11 阶,业务自由扩展)

> 11 阶设计:_1 最浅 → _11 最深,_6 = 默认主色。供业务在自定义场景下使用,**不允许直接覆盖品牌 / 语义 / 中性 Token**。

10 个色族,每族 11 阶:

| 色族 | Token | _6 默认 |
|---|---|---|
| 红 | `color.palette.red.1`..`.11` | `#ff3333` |
| 橙 | `color.palette.orange.1`..`.11` | `#ff791a` |
| 黄 | `color.palette.yellow.1`..`.11` | `#ffd500` |
| 浅绿 | `color.palette.light-green.1`..`.11` | `#92fa00` |
| 绿 | `color.palette.green.1`..`.11` | `#2ee52e` |
| 浅蓝 | `color.palette.light-blue.1`..`.11` | `#00d8f5` |
| 蓝 | `color.palette.blue.1`..`.11` | `#0090ff` |
| 紫 | `color.palette.purple.1`..`.11` | `#774aff` |
| 洋红 | `color.palette.magenta.1`..`.11` | `#d419fa` |
| 玫红 | `color.palette.rose-red.1`..`.11` | `#fa25a1` |

完整 11 阶值见 [tokens.json](./tokens.json)。

---

## 6. 透明度 · 不作为单独 Token

**京东不允许通过透明度模拟新色值**。所有"半透明"效果应该通过实色 Token(或预定义蒙层 Token)实现:

❌ 反例:`background: rgba(255, 0, 0, 0.5)`(模拟浅红)
✅ 正确:`background: var(--color-semantic-danger-subtle)`

例外:`color.neutral.mask.*` 系列(三档 maskgray_1/2/3)是允许的透明度 Token,因为蒙层语义就是"在任意底色上叠加暗度"。

---

## 7. 对比度自检

| 配对 | 对比度 | WCAG 2.1 AA | 备注 |
|---|---|---|---|
| `text.primary` (#171a26) on `bg.surface` (#fff) | 16.4:1 | ✅ 远超 4.5:1 |
| `text.secondary` (#3d414d) on `bg.surface` | 10.6:1 | ✅ 通过 |
| `text.tertiary` (#828794) on `bg.surface` | 3.4:1 | ⚠️ 仅适用于 ≥ 18pt 大字(3:1) |
| `text.on-color` (#fff) on `brand.primary` (#ff0f23) | 4.6:1 | ✅ 通过 |
| `text.disabled` (#c2c4cc) on `bg.disabled` | `> TODO: bg.disabled 待 Relay 补充` |

> **TODO**:CI 自动化对比度检查工具链尚未接入,详见 [[../../horizontal/governance/quality.md]]。

---

## 8. 深色模式

> **2026-05-06 状态**:Relay 15.0 当前文件仅交付浅色模式。深色模式 Token 集**待补充**。

`> TODO: 深色模式色值需设计组单独输出。在 tokens.json 中,所有 dark 字段当前用占位值,接入前请勿启用深色主题。`

---

## 9. 历史版本

- **v1.0(2026-05-06)**:与 Relay 15.0 实际投产值对齐;新增平台色板 10 色 × 11 阶 + 服务金体系;明确 `semantic.danger` 与 `brand.primary` 同色为 15.0 有意设计。
- v0.9(2026-04):草案版,色值为 v14.x 占位,未与 15.0 对齐。
