---
token_category: color
version: 16.0-draft
last_updated: 2026-05-12
relay_source:
  file_id: "2029484645871009793"
  page_id: "58:9"
  node_id: "591:1785"
  url: https://relay.jd.com/file/design?id=2029484645871009793&page_id=58%3A9&node_id=591%3A1785
v15_predecessor: ../../../jd-design-system-md/foundations/tokens/color.md
extraction_status:
  tokens: 34 / 34 (Light 模式 token 名 + atom 映射 100% 覆盖)
  atom_hex_values: TODO (需从色板真相源批量提取)
  dark_variants: TODO (需从 58:9 的暗黑映射表提取)
---

# 色彩 Token · V16.0

> V16.0 色彩体系是 **3 层架构**：组件 → Token（语义） → Atom（原子色板）→ Hex/Dark variant。
>
> 本文档定义 **L2 Token 层**（34 个语义 token，10 大组）。L1 Atom 层在 `tokens.json#atom` 维护；hex 与 dark 值待从平台色板批量提取。

---

## 🚩 V15.0 → V16.0 重大变化

| 变化 | V15.0 | V16.0 |
|---|---|---|
| **架构** | Token → Hex 直给（混层） | Token → Atom → Hex（3 层解耦） |
| **命名** | `color.brand.primary`（dot 层级） | `color_primary`（snake 平铺） |
| **Error/Danger** | `semantic.danger = brand.primary = #ff0f23`（共色，wash 区分） | **`color_error` 独立色族 errorred**（彻底拆开） |
| **Service** | `functional.service-gold-{1..7,subtle,strong}` 9 个零散 | **`color_service{,_bground,_border,_text}` 四件套** |
| **镂空背景体系** | 无 | **新增**：`color_primary_light` / `_light_pressed` |
| **点击态** | V15 标记 TODO "Relay 暂未规范" | **覆盖**：`*_pressed` 系列 |
| **容错蒙层** | 无 | **新增**：`color_mask_fault_toleran` |

> ⚠️ Relay 文件 typo：「信息 Info」section 下 3 个 token 用 `color_Info`（大写 I），与其他 `color_*`（小写）不一致。本文档**保持与 Relay 一致**录入，建议设计师修正后回写。

---

## 1. 主色 Primary · 7 个 token

> 品牌色，用于控件主色调和不同状态，不限于背景、图标、文字、边框等。

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_primary` | `jdred_6` | 品牌主色调默认态，主要功能控件的背景、边框、镂空状态下的文字等 | **upgraded** | `color.brand.primary` |
| `color_primary_text` | `white` | 品牌主色调或其他深色背景下的文字 | **upgraded** | `color.brand.primary-text-on` |
| `color_primary_pressed` | `red_7` | 品牌主色调点击态，背景、边框、镂空状态下的文字 | **new** | — (V15 TODO) |
| `color_primary_disabled` | `gray_4` | 品牌主色调禁用态 | **upgraded** | `color.brand.primary-disabled` |
| `color_primary_disabled_special` | `gray_3` | 品牌主色调**特殊**禁用态（通过操作后可转默认态） | **new** | — |
| `color_primary_light` | `red_1` | 品牌主色调**镂空背景**默认态 | **new** | — (V15 无镂空背景体系) |
| `color_primary_light_pressed` | `red_2` | 品牌主色调镂空背景点击态 | **new** | — |

**Rationale**：V15.0 标记 `brand.primary.hover` / `brand.primary.pressed` 为 TODO "Relay 暂未规范"；V16.0 补齐**禁用 / 点击 / 镂空**完整状态机，且区分**普通禁用 vs 特殊禁用**（特殊禁用可通过用户操作恢复）。

---

## 2. 服务 Service · 4 个 token

> 服务金，用于全链路服务场景的背景、图标、边框、文字等。

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_service` | `servicegold_2` | 浅背景 | **upgraded** | `color.functional.service-gold-subtle` |
| `color_service_bground` | `servicegold_1` | 深背景/图形 | **upgraded** | `color.functional.service-gold-subtle-2` |
| `color_service_border` | `servicegold_3` | 边框 | **upgraded** | `color.functional.service-gold-subtle-3` |
| `color_service_text` | `servicegold_4` | 文字 | **upgraded** | `color.functional.service-gold` / `-strong` |

**Rationale**：V15.0 有 9 个 `service-gold-{1..7,subtle,strong}` token，命名是色阶序号（语义不明）；V16.0 重组为 4 个语义角色（默认 / 背景 / 边框 / 文字），与 service 业务场景一一对应。

⚠️ 拼写：`color_service_bground` 在 Relay 文件中即如此（应为 `background`），保持原样录入。

---

## 3. 文本 Text · 4 个 token

> 文字灰阶，用于常态的信息表达，包括文字、图形等。

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_title` | `gray_1` | 一级重要内容 | **upgraded** | `color.neutral.text.primary` |
| `color_text` | `gray_2` | 二级辅助/可操作内容 | **upgraded** | `color.neutral.text.secondary` |
| `color_text_help` | `gray_3` | 三级次要内容 | **upgraded** | `color.neutral.text.tertiary` |
| `color_text_disabled` | `gray_4` | 四级置灰内容 / 组件线 | **upgraded** | `color.neutral.text.disabled` |

**Rationale**：V15.0 用 primary/secondary/tertiary/disabled 序数；V16.0 用 title/text/text_help/text_disabled 角色名（语义更直接）。

---

## 4. 背景 Background · 3 个 token

> 背景灰阶，用于界面背景、组件容器的填充。

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_background` | `gray_5` | 页面背景 | **upgraded** | `color.neutral.bg.body` |
| `color_background_overlay` | `white` | 内容容器背景 | **upgraded** | `color.neutral.bg.surface` |
| `color_background_component` | `gray_6` | 组件 / 容器背景 | **upgraded** | `color.neutral.bg.sunken` |

**Rationale**：V15.0 用 body/surface/sunken 概念（继承自 Material Design）；V16.0 用 background/overlay/component（更直观，与组件层级直接对应）。

---

## 5. 蒙层 Mask + 间隔线 · 4 个 token

> 蒙层灰阶，用于区隔临时层和稳态界面（背景层、内容层、导航层）的填充；间隔线用于内容分隔。

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_border` | `gray_9` | 间隔线 | **upgraded** | `color.neutral.border.default` |
| `color_mask` | `gray_7` | 全局蒙层 | **upgraded** | `color.neutral.mask.medium` |
| `color_mask_part` | `gray_8` | 局部蒙层 | **upgraded** | `color.neutral.mask.subtle` |
| `color_mask_fault_toleran` | `gray_10` | **容错蒙层** | **new** | — |

**Rationale**：V15.0 mask 用 subtle/medium/strong 强度三级；V16.0 用使用场景三级（全局 / 局部 / 容错），并**新增容错蒙层**用于错误/异常 fallback 态遮罩。

⚠️ 拼写：`color_mask_fault_toleran` 缺末尾 `t`（应为 `tolerant`），Relay 原样录入。

---

## 6. 成功 Success · 3 个 token

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_success` | `successgreen_2` | 深背景 / 图形 | **upgraded** | `color.semantic.success` |
| `color_success_light` | `successgreen_1` | 浅背景 | **upgraded** | `color.semantic.success-subtle` |
| `color_success_pressed` | `successgreen_3` | 文字 | **upgraded** | `color.semantic.success-strong` |

**Rationale**：命名规范化 subtle/strong → light/pressed，与其他语义色一致。

> ⚠️ `_pressed` 后缀语义≠点击态，是「文字在浅背景上的深色变体」。Relay 命名沿用，但语义有歧义。建议后续治理统一为 `_strong` 或 `_on-light`。

---

## 7. 错误 Error · 3 个 token 🚩 **decoupled**

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_error` | `errorred_2` | 深背景 / 图形 | **decoupled** | `color.semantic.danger`（与 `brand.primary` 同色 `#ff0f23`） |
| `color_error_light` | `errorred_1` | 浅背景 | **decoupled** | `color.semantic.danger-subtle` |
| `color_error_pressed` | `errorred_3` | 文字 | **new** | — |

**Rationale**：V15.0 中 `semantic.danger` **直接复用 `brand.primary` 的 `#ff0f23`**（"15.0 中与 brand.primary 同色,通过 wash + 图标区分"）。V16.0 拆出独立 `errorred` 色族，**色相与京东红刻意区分**，从源头消除歧义。

> 这是 V15 → V16 **最重要的解耦**。

---

## 8. 警示 Warning · 3 个 token

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_warning` | `warningyellow_2` | 深背景 / 图形 | **upgraded** | `color.semantic.warning` |
| `color_warning_light` | `warningyellow_1` | 浅背景 | **upgraded** | `color.semantic.warning-subtle` |
| `color_warning_pressed` | `warningyellow_3` | 文字 | **upgraded** | `color.semantic.warning-strong` |

---

## 9. 信息 Info · 3 个 token

| Token | Atom | 场景说明 | v16 status | v15 对应 |
|---|---|---|---|---|
| `color_Info` | `infoblue_2` | 深背景 / 图形 | **upgraded** | `color.semantic.info` |
| `color_Info_light` | `infoblue_1` | 浅背景 | **upgraded** | `color.semantic.info-subtle` |
| `color_Info_pressed` | `infoblue_3` | 文字 | **new** | — |

⚠️ Relay 文件 typo：本组 token 名首字母 `I` 大写，与全文 snake_case 风格不一致。本文档保持原样录入；建议设计师修正回 `color_info`。

---

## L1 Atom 层（原子色板）

V16.0 引用的 atom 共 **17 个**（按色族分组）：

| 色族 | Atoms 引用 | 说明 |
|---|---|---|
| **jdred** | `jdred_6` | 京东红，主色族（11 阶完整色板待录入） |
| **red**（中性红族） | `red_1` / `red_2` / `red_7` | 镂空 / 点击态用 |
| **gray** | `gray_1` ~ `gray_10` | 文字 / 背景 / 蒙层主力 |
| **white** | `white` | 文字 on dark + 容器底 |
| **servicegold** | `servicegold_1` ~ `_4` | 服务金 |
| **successgreen** | `successgreen_1` ~ `_3` | 成功 |
| **errorred** | `errorred_1` ~ `_3` | 错误（V16 新独立色族） |
| **warningyellow** | `warningyellow_1` ~ `_3` | 警示 |
| **infoblue** | `infoblue_1` ~ `_3` | 信息 |

完整色板（含 Light / Dark hex）由 [tokens.json](./tokens.json) 维护。

---

## 与 V15.0 的兼容性 · Palette 保留

V15.0 的 `palette.{red,orange,...}` 10×11 色板（110 个 atom）**在 V16 保留**，作为 atom 层的业务自定义补充：

- ✅ 业务方在需要自定义色时仍可引用 `atom.palette.red.6` 等
- ❌ 语义化统一（color_*）不引用 palette，禁覆盖 brand / semantic / neutral 语义 token
- ⚠️ Dark variant 暂未提供，待 V16 设计师补充

完整 110 atom hex 见 [tokens.json#palette](./tokens.json)。

---

## 待办

- [ ] L1 Atom 层完整 Light hex（从色板真相源批量提取）
- [ ] L1 Atom 层 Dark hex（从 58:9 暗黑映射表提取）
- [ ] palette 10×11 是否保留 / 弃用决策
- [ ] Relay 文件 typo 反馈：`color_Info` 大小写 + `_bground` 拼写 + `_fault_toleran` 缺 `t`
- [ ] `_pressed` 语义统一性治理（多数场景 = 文字，但点击态 `_pressed` 名字易混淆）
- [ ] 写 [`../visual/color-usage.md`](../visual/color-usage.md) 用法约束（参考 V15.0 同名文档）
