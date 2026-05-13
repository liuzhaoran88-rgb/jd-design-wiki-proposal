---
file: MIGRATION-V15-TO-V16
purpose: JD APP 设计系统 V15.0 → V16.0 迁移指南
audience: 业务线设计师 + 前端工程师 + AI consumers
relay_file_v15: "1896756863949619202"
relay_file_v16: "2029484645871009793"
v15_source: jd-design-system-md/
v16_source: jd-design-system-md-v16/
last_updated: 2026-05-12
status: in-progress（V16 录入完成；视觉走查 / 迁移工具链待跟进）
---

# JD APP 设计系统 V15.0 → V16.0 迁移指南

> **本文档作用**：业务线设计师 / 前端 / AI 消费者**升级到 V16.0 之前**必读。
> - 每个 Foundation 的解耦 / 升级 / 删除 / 新增项一览
> - Token 级 codemod 替换表
> - Visual 级 before/after 对照（搜列/商详/购物车/结算）
> - 已知阻塞项（V16 设计师 WIP）

---

## TL;DR · 1 分钟速读

V16.0 是 **架构级升级**，不是渐进迭代：

1. 🚩 **Token 3 层架构** — V15 是 Token→Hex 混层；V16 解耦为 Token→Atom→Hex
2. 🚩 **Error 从 Primary 命名层解耦** — V15 `danger=primary` 共色；V16 `color_error` 独立 token（但当前 hex 仍共用，hex 解耦 WIP）
3. 🚩 **新独立 Foundation**：「线 Lines」+「材质 Materials」
4. 🚩 **Z 轴 4 层显式模型** + 悬浮底导 **17DP safe-area**
5. 🚩 **字号体系重做** — 删 12/15pt，加 11/13/16/24pt，价格字号融入通用字阶
6. ⚠️ **京东朗正体（V15 brand 字体）疑似废弃**，weight 700 (bold) 疑似废弃
7. ⚠️ **圆角 full/structural 删除** — 胶囊型组件（头像 / Switch / Tab）方案待确认

---

## Foundation 状态矩阵

| Foundation | V15 状态 | V16 状态 | 改动量 | 业务影响 |
|---|---|---|---|---|
| 色彩 Colors | ✅ 完整 | ✅ 重构（3 层架构） | 🔴 大 | 全量 token 重命名 |
| 字体 Typography | ✅ 完整 | ✅ 重做字阶 + role 组合 | 🔴 大 | 12/15pt 全替；price-* 重命名 |
| 圆角 Radius | ✅ 完整 | ✅ 7 阶 T-shirt | 🟡 中 | role token 全删；按高度算 |
| 线 Lines | ❌ 仅 border 颜色 | 🆕 全新独立 | 🟢 小（新增） | 0.33/0.5px hairline，业务需适配 |
| 材质 Materials | ❌ TODO | 🆕 全新独立 | 🟢 小（新增） | 顶/底导用新材质，业务需切换 |
| 空间 Spacing | ✅ 完整 | ✅ 大部分沿用 | 🟢 小 | safe-area 新增 17DP |
| 布局 Layout | ✅ 完整 | ✅ Z 轴 4 层显式 | 🟡 中 | 卡片式/平铺式分类，组件需明示层级 |
| 图标 Icons | ⚠️ 仅参数 | 🟡 WIP（清单部分） | 🟡 中 | 33 个图标进库，参数沿用 |
| 设计哲学 | ✅ 4 支柱 | 🔘 占位 TBD | — | 待 V16 设计师补 |
| 动效 Motion | ✅ 完整 | ❌ V16 暂无 | — | 沿用 V15 |

---

## Token 级迁移表

> 业务方应该把 V15 token 引用全量替换为 V16 token。

### 🎨 色彩 Color · 重命名 + 解耦

#### Brand 色

| V15 | V16 | 类型 | 备注 |
|---|---|---|---|
| `color.brand.primary` | `color_primary` | upgraded | atom: jdred_6 / hex #FF0F23 |
| `color.brand.primary-text-on` | `color_primary_text` | upgraded | atom: white |
| `color.brand.primary-disabled` | `color_primary_disabled` | upgraded | atom: gray_4 |
| — | `color_primary_pressed` | **new** | V15 标 TODO |
| — | `color_primary_disabled_special` | **new** | 可恢复禁用态 |
| — | `color_primary_light` | **new** | 镂空背景 默认 |
| — | `color_primary_light_pressed` | **new** | 镂空背景 点击 |
| `color.brand.primary-gradient-stop` | — | **deprecated**? | V16 未在 token frame 出现，需确认 |

#### Semantic 色（注：Error 命名解耦但 hex 共用）

| V15 | V16 | 类型 | 备注 |
|---|---|---|---|
| `color.semantic.danger` | **`color_error`** | **decoupled** | ⚠️ 命名解耦 / hex 当前仍 #FF0F23（共 brand），独立色谱 WIP |
| `color.semantic.danger-subtle` | `color_error_light` | decoupled | atom: errorred_1 |
| — | `color_error_pressed` | **new** | atom 引用 errorred_3，但 V15 未提供该 stop |
| `color.semantic.success` | `color_success` | upgraded | atom: successgreen_2 |
| `color.semantic.success-subtle` | `color_success_light` | upgraded | |
| `color.semantic.success-strong` | `color_success_pressed` | upgraded | ⚠️ _pressed 在此 = 文字色 |
| `color.semantic.warning` | `color_warning` | upgraded | |
| `color.semantic.warning-subtle` | `color_warning_light` | upgraded | |
| `color.semantic.warning-strong` | `color_warning_pressed` | upgraded | |
| `color.semantic.info` | `color_Info` ⚠️ typo | upgraded | Relay 大写 I 是 typo |
| `color.semantic.info-subtle` | `color_Info_light` | upgraded | |
| — | `color_Info_pressed` | **new** | 缺 hex |

#### Neutral 文字

| V15 | V16 | 类型 |
|---|---|---|
| `color.neutral.text.primary` | `color_title` | upgraded |
| `color.neutral.text.secondary` | `color_text` | upgraded |
| `color.neutral.text.tertiary` | `color_text_help` | upgraded |
| `color.neutral.text.disabled` | `color_text_disabled` | upgraded |
| `color.neutral.text.on-color` | （V16 内联 white） | — |
| `color.neutral.text.link` | （V16 未列） | TODO |

#### Neutral 背景

| V15 | V16 | 类型 |
|---|---|---|
| `color.neutral.bg.surface` | `color_background_overlay` | upgraded |
| `color.neutral.bg.body` | `color_background` | upgraded |
| `color.neutral.bg.sunken` | `color_background_component` | upgraded |

#### Neutral 边框 + 蒙层

| V15 | V16 | 类型 |
|---|---|---|
| `color.neutral.border.default` | `color_border` | upgraded |
| `color.neutral.mask.medium` | `color_mask` | upgraded |
| `color.neutral.mask.subtle` | `color_mask_part` | upgraded |
| `color.neutral.mask.strong` | `color_mask_fault_toleran` ⚠️ typo | upgraded (语义扩展为容错蒙层) |

#### Functional 服务金

| V15 | V16 | 类型 |
|---|---|---|
| `color.functional.service-gold` | `color_service_text` | upgraded（V15 9 个零散 → V16 4 件套） |
| `color.functional.service-gold-subtle` | `color_service` | upgraded |
| `color.functional.service-gold-subtle-2` | `color_service_bground` ⚠️ typo | upgraded |
| `color.functional.service-gold-subtle-3` | `color_service_border` | upgraded |
| `color.functional.service-gold-{5,6,7}` | — | **deprecated** |
| `color.functional.price` / `discount-tag` | （V16 未列）→ 业务方直接用 `color_primary` | — |

#### Palette 10×11

V15 `color.palette.{red,orange,...,rose-red}.{1..11}` **保留**，迁移到 `atom.palette.*`（V16 atom 层 business-use-only），namespace 不变（除 `light-green`/`light-blue` 在 V16 平台色板里叫 `lightgreen`/`lightblue`，`green`→`deepgreen`，`blue`→`deepblue`，`orange`→`orang` ⚠️ typo）。

---

### ✏️ 字体 Typography · 字阶重做

#### Family

| V15 | V16 | 类型 |
|---|---|---|
| `typography.family.brand` (京东朗正体) | — | **deprecated**?（V16 文字变量页未出现） |
| `typography.family.sans` | `pingfang` | upgraded |
| `typography.family.number` | `zhenghei` | upgraded |

#### Size

| V15 | V16 | 类型 |
|---|---|---|
| `typography.size.10` | `font_size_xxs` / `font_size_10` | upgraded |
| `typography.size.12` | — | **deprecated**（用 `font_size_xs` 11pt 或 `font_size_s` 13pt 替代） |
| — | `font_size_xs` (11pt) | **new** |
| — | `font_size_s` (13pt) | **new** |
| `typography.size.14` | `font_size_base` / `font_size_14` | upgraded |
| `typography.size.15` | — | **deprecated**（用 `font_size_l` 16pt 替代） |
| — | `font_size_l` (16pt) | **new** |
| `typography.size.18` | `font_size_xl` / `font_size_18` | upgraded |
| `typography.size.special.price-l` (24) | `font_size_xxl` (24) | upgraded + decoupled |
| `typography.size.special.price-m` (18) | `font_size_xl` (18) | upgraded |
| `typography.size.special.price-s` (15) | `font_size_l` (16) | upgraded（值改了） |

#### Weight

| V15 | V16 | 类型 |
|---|---|---|
| `typography.weight.regular` (400) | `regular` / `font_regular` | upgraded |
| `typography.weight.semibold` (600) | `semibold` / `font_semibold` | upgraded |
| `typography.weight.bold` (700) | — | **deprecated**?（V16 zhenghei_bold 实际是 600，需确认） |

#### Role

| V15 | V16 | 备注 |
|---|---|---|
| `typography.role.heading-page` | `pingfang_semibold / font_size_18_600` | upgraded |
| `typography.role.heading-module` | `pingfang_semibold / font_size_16_600` | upgraded（15→16）|
| `typography.role.body-standard` | `pingfang_regular / font_size_14_400` | unchanged |
| `typography.role.body-secondary` | `pingfang_regular / font_size_13_400` (or 11) | upgraded |
| `typography.role.label` | `pingfang_regular / font_size_10_400` | unchanged |
| `typography.role.price-large` | `zhenghei_bold / font_size_24_600` | upgraded |
| `typography.role.price-medium` | `zhenghei_bold / font_size_18_600` | upgraded |
| `typography.role.price-small` | `zhenghei_bold / font_size_16_600` (V16 无 15) | upgraded |
| `typography.role.price-strikethrough` | `zhenghei_regular / font_size_13_400` (V16 无 12) | upgraded |

---

### 🟫 圆角 Radius · 删 role token 改按高度算

#### Atom

| V15 | V16 | 类型 |
|---|---|---|
| `radius.0` (0) | `radius_xxs` (0) | upgraded |
| `radius.xs` (2px) | `radius_xs` (2) | unchanged |
| `radius.s` (4px) | `radius_s` (4) | unchanged |
| `radius.base` (6px) | `radius_base` (6) | unchanged |
| `radius.detail` (8px) | `radius_l` (8) | upgraded（重命名） |
| `radius.xl` (12px) | `radius_xl` (12) | unchanged |
| — | `radius_xxl` (16px) | **new** |
| `radius.structural` (24px) | — | **deprecated** |
| `radius.full` (9999px) | — | **deprecated** ⚠️ Avatar/胶囊方案待确认 |

#### Role（V16 全删，按规则推导）

| V15 | V16 推导 |
|---|---|
| `radius.role.button` | 按高度 28-36 → `radius_base`；高度 40+ → `radius_l` |
| `radius.role.card` | 平台型 → `radius_xxs`；导购型 → `radius_l` |
| `radius.role.card-detail` | `radius_l` |
| `radius.role.card-large` | `radius_xl` |
| `radius.role.modal` | `radius_xxl` ⚠️（V15 12px → V16 16px，视觉变更） |
| `radius.role.tag` | `radius_xs` (2px) 或 `radius_s` (4px) |
| `radius.role.avatar` | ❌ 无替代（V16 无 full/9999px） |
| `radius.role.input` | `radius_base` |
| `radius.role.skeleton` | `radius_s` |
| `radius.role.toast` | `radius_xl` ⚠️（V15 6px → V16 12px，视觉变更） |

---

### 📏 线 Lines · 全新独立 foundation

| V15 | V16 | 类型 |
|---|---|---|
| 无 | `line_tag` = 0.33px | **new** |
| 无 | `line_component` = 0.5px | **new** |

**业务影响**：硬编码的 `border-width: 1px` 在 V16 视觉上偏粗。建议：
- 标签边框 → `line_tag` (0.33px)
- 组件分割线 / 边框 → `line_component` (0.5px)
- 桌面端（1x 屏）需 polyfill：SVG / `transform: scale()` / `box-shadow inset`

---

### 🌫 材质 Materials · 全新独立 foundation

| V15 | V16 | 类型 |
|---|---|---|
| 无（shadow TODO） | Liquid Glass Small/Medium (×Light/Dark) | **new**（iOS 17+） |
| 无 | Frosted Glass Small/Medium (×Light/Dark) | **new**（其他平台兜底） |

**业务影响**：顶导 / 底导组件 V16 默认使用新材质，业务方需切换组件 API（具体 component-level 升级路径见后续组件库更新）。

---

### 📐 空间 Spacing · 大部分沿用 + 新增 17DP

| V15 | V16 | 类型 |
|---|---|---|
| spacing.{2..40} 全部 atom | 沿用 | unchanged |
| `spacing.safe-area.status-bar` (44) | unchanged | unchanged |
| `spacing.safe-area.home-indicator` (34) | unchanged | unchanged |
| `spacing.safe-area.screen-edge` (8) | unchanged | unchanged |
| — | `spacing.safe-area.home-indicator-floating` (17) | **new** |
| 所有 semantic / role token | 沿用 | unchanged |

---

### 🟦 布局 Layout · Z 轴 4 层显式

V15 隐式 → V16 显式 4 层（背景 / 内容 / 全局控制 / 临时任务），见 [jd-design-system-md-v16/foundations/visual/layout.md](./jd-design-system-md-v16/foundations/visual/layout.md)。

业务影响：组件需明示自己所属的 Z 层；浮于内容上的临时任务需走材质（Liquid/Frosted Glass）。

---

### 🖼 图标 Icons · WIP

V15 参数 token 沿用。V16 提供 33 个图标库（26 线性 + 7 填充），覆盖 Tab Bar / 常用动作 / 反馈语义。完整 ICONFONT 工具链 V15 标 TODO，V16 仍未交付。

---

## Visual 级 before/after · 4 个核心场景

> Relay 文件 `2029484645871009793` page `6:3` 「基础视觉设定」上有 4 套对照截图。

| 场景 | V15 (before) | V16 (after) | Relay frame |
|---|---|---|---|
| **搜列**（搜索结果） | 搜列before `508:601` | 搜列after `480:2826` | 中间版 `464:6845` |
| **商详**（商品详情） | 商详before `508:955` | 商详after `480:3514` | 中间版 `464:7506` |
| **购物车** | 购物车before `508:225` | 购物车after `480:3154` | 中间版 `464:7173` |
| **结算** | 结算before `508:3037` | 结算after `480:4009` | 中间版 `464:8001` |

**预期视觉差异**（基于本次录入分析）：
1. **顶导 / 底导用了新材质**（Liquid Glass / Frosted Glass）—— 透明 + blur 替代 V15 实色背景
2. **细线变细**（0.5px hairline 替代 V15 实 1px）
3. **modal / toast 圆角变大**（toast 6→12px、modal 12→16px）
4. **价格字号** —— 16pt 替代 V15 15pt（差异微小但全局生效）
5. **页面级背景层** —— V16 引入大促换肤背板、商详主图背板等氛围层

建议导出每对 before/after 截图存到 `research/v16-migration-visuals/` 供 review。

---

## ⚠️ 已知阻塞项（V16 设计师 WIP）

> 这些必须 V16 设计师补齐后，业务方才能完成迁移。

| 阻塞项 | 影响 | 严重度 |
|---|---|---|
| **errorred 独立色谱 hex** | 命名解耦但 hex 共用 jdred；视觉上无法区分错误态和品牌色 | 🔴 高 |
| **errorred_3 / infoblue_3 缺源** | V16 token 引用但 V15 dangerred / infoblue 没 _3 阶 | 🔴 高 |
| **京东朗正体（brand 字体）去向** | V15 brand 字体用于业务标题；V16 不见 | 🟡 中 |
| **bold (weight 700) 去向** | V16 zhenghei_bold 实际 600；V15 价格用 700 | 🟡 中 |
| **圆角 full / 胶囊方案** | Avatar / Switch / Tab / 头像位 等胶囊型组件 | 🟡 中 |
| **设计哲学内容** | V16 知识层框架缺失 | 🟢 低（不影响代码） |
| **图标参数 token 4DP 字身框** | V15=3DP, V16 frame 名暗示 4DP，需确认 | 🟢 低 |
| **动效 Motion** | V16 暂未提供，沿用 V15 | 🟢 低 |
| **iPad / 折叠屏布局** | V15 也 TODO | 🟢 低 |

完整 Relay 文件 typo / 命名歧义清单见 [jd-design-system-md-v16/RELAY-V16-TYPOS.md](./jd-design-system-md-v16/RELAY-V16-TYPOS.md)（11 条）。

---

## Codemod 提示（前端工具链）

升级到 V16.0 时，建议工具链支持：

### 1. Token 字符串替换（机械化）

参考 [Token 级迁移表](#token-级迁移表) 实现批量 codemod：

```bash
# 示例（grep / sed）：
grep -rn 'color\.brand\.primary' src/ | wc -l    # 影响面盘点
sed -i '' 's/color\.brand\.primary/color_primary/g' src/**/*.{ts,tsx,css}
```

⚠️ 注意 **CSS 自定义属性**：V15 `--color-brand-primary` → V16 `--color_primary`（连字符 vs 下划线）。

### 2. 视觉回归（不能机械）

- 圆角 (modal/toast/avatar) 视觉变更 → 全量截图对比
- 线宽 (1px→0.5px) → 高密屏走查
- 材质 (顶/底导背景) → iOS17+/<17 双端走查

### 3. AI 消费层校验

V16 tokens.json 引入了 `$extensions.v16_status` 字段。AI 消费者（如 Claude）应能识别：
- `v16_status: decoupled` → 警示「视觉可能与 V15 不一致」
- `v16_status: new` → 标记「V15 无对应，业务方需新引入」
- `v16_status: deprecated` → 阻断使用

---

## 迁移建议节奏

| 阶段 | 时间 | 工作 |
|---|---|---|
| **P0** | V16 设计师 WIP 完成（errorred / brand 字体 / bold 等阻塞项） | 录入回填，Typo 修正 |
| **P1** | V16 阻塞项清零后 1 周 | 前端工具链 codemod，组件库适配 |
| **P2** | P1 后 2 周 | 业务方按场景灰度（先低频 / 内部页 → 高频 / 主链路） |
| **P3** | P2 后 1 月 | 视觉走查 / AB 测试 / 数据回收 |
| **P4** | P3 后 1 月 | 删 V15 token 引用，归档 `jd-design-system-md/` |

---

## 相关文档

- 完整 V16 文档：[`jd-design-system-md-v16/`](./jd-design-system-md-v16/)
- V16 Token JSON：[`jd-design-system-md-v16/foundations/tokens/tokens.json`](./jd-design-system-md-v16/foundations/tokens/tokens.json)
- Relay 文件 typo 反馈：[`jd-design-system-md-v16/RELAY-V16-TYPOS.md`](./jd-design-system-md-v16/RELAY-V16-TYPOS.md)
- V15 冻结版本：[`jd-design-system-md/`](./jd-design-system-md/)
- V15 Token JSON：[`jd-design-system-md/foundations/tokens/tokens.json`](./jd-design-system-md/foundations/tokens/tokens.json)
- 总体 wiki 战略：[`jd-design-os-proposal.md`](./jd-design-os-proposal.md)

---

## 反馈

发现 V15→V16 迁移问题，请：
1. 在本仓库提 issue（标签 `migration:v15-v16`）
2. 设计层问题反馈到 V16 设计师组（钉钉群「JD APP 16.0 GUIDELINE」）
3. 工具链问题反馈到设计系统维护组
