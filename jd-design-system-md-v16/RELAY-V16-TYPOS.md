---
file: RELAY-V16-TYPOS
purpose: 录入 V16.0 设计系统时发现的 Relay 文件 typo / 命名歧义 / 跨页面不一致汇总
target_audience: V16.0 设计师 / 设计组
relay_file_id: "2029484645871009793"
created: 2026-05-12
status: 待设计师确认 / 修正
---

# JD APP V16.0 Relay 文件 typo & 命名歧义清单

> 录入 V16.0 设计系统时发现的待修问题。每条都带 **Relay 位置（page + node）**、**当前值**、**建议值** 和 **影响**，方便定位修复。
>
> 共 **11 条**：明确 typo 6 条 / 命名歧义 3 条 / 跨页面不一致 2 条。

---

## 🔴 P0 · 明确 typo（建议本期内修）

### 1. `color_Info` 系列首字母大写

| 维度 | 内容 |
|---|---|
| **位置** | `page 58:9` → 「色彩变量 Colors Token」`591:1785` → 信息 Info 分组 |
| **当前值** | `color_Info` / `color_Info_light` / `color_Info_pressed` |
| **建议值** | `color_info` / `color_info_light` / `color_info_pressed` |
| **影响** | 与全局 snake_case 风格不一致；引用时 case-sensitive 系统（如某些 build pipeline）会出错 |

### 2. `color_service_bground` 拼写错误

| 维度 | 内容 |
|---|---|
| **位置** | `page 58:9` → 「色彩变量 Colors Token」`591:1785` → 服务 Service 分组 |
| **当前值** | `color_service_bground` |
| **建议值** | `color_service_background` |
| **影响** | 拼写不完整，工程师容易拼错引用 |

### 3. `color_mask_fault_toleran` 缺末尾 `t`

| 维度 | 内容 |
|---|---|
| **位置** | `page 58:9` → 「色彩变量 Colors Token」`591:1785` → 蒙层 Mask 分组 |
| **当前值** | `color_mask_fault_toleran` |
| **建议值** | `color_mask_fault_tolerant` |
| **影响** | 单词不完整，难记 / 易拼错 |

### 4. 图标命名 `List` 首字母大写

| 维度 | 内容 |
|---|---|
| **位置** | `page 12:263` → 「图标 Icons - 线性 - 4dp」`259:12` → 第 2 行 |
| **当前值** | `List` |
| **建议值** | `list` |
| **影响** | 同 1，破坏命名规范一致性 |

### 5. 图标 `cart add` 含空格

| 维度 | 内容 |
|---|---|
| **位置** | `page 12:263` → 「图标 Icons - 线性 - 4dp」`259:12` → 第 4 行 |
| **当前值** | `cart add` |
| **建议值** | `cart-add` 或 `cart_add` |
| **影响** | 空格无法直接做 CSS class / 文件名 / 变量名 |

### 6.5 平台色板 `orang_*` 缺末尾 `e`（11 处）

| 维度 | 内容 |
|---|---|
| **位置** | `page 58:9` → 「平台色板暗黑映射表」`577:2944` → 橙色族 |
| **当前值** | `orang_1` / `orang_2` / ... / `orang_11`（11 阶全部缺末尾 e） |
| **建议值** | `orange_1` ... `orange_11` |
| **影响** | 单词不完整；与 V15 palette.orange 命名不一致 |

### 6. 图标 `setting` 重复

| 维度 | 内容 |
|---|---|
| **位置** | `page 12:263` → 「图标 Icons - 线性 - 4dp」`259:12` → 第 3 行末尾 + 第 4 行开头 |
| **当前值** | 两处都叫 `setting` |
| **建议值** | 二者是否同图标？若不同请改名（如 `setting-detail` / `setting-fill`）；若相同请删一处 |
| **影响** | 图标库不能有同名重复（覆盖问题） |

---

## 🟡 P1 · 命名歧义（建议讨论后统一）

### 7. `zhenghei_bold` 实际 weight = 600，不是 700

| 维度 | 内容 |
|---|---|
| **位置** | `page 12:261` → 「文本 Text Styles」`297:165` → 第 4 组 |
| **当前值** | 组名 `zhenghei_bold`，但每个 token 名为 `font_size_N_600`（600 是 semibold 不是 bold） |
| **建议值** | 二选一：① 组名改 `zhenghei_semibold`（与 weight 一致）；② 改用 700 weight（V15 bold 的 700） |
| **影响** | 与 CSS 标准（400 regular / 600 semibold / 700 bold）冲突；工程师按 `font-weight: bold` 翻译会拿到 700，与设计实际 600 不一致 |

### 8. `_pressed` 语义在不同色族下不一致

| 维度 | 内容 |
|---|---|
| **位置** | `page 58:9` → 「色彩变量 Colors Token」`591:1785` |
| **当前值** | `color_primary_pressed` = 点击态；`color_success_pressed` / `color_error_pressed` / `color_warning_pressed` / `color_Info_pressed` = 文字色（不是点击态） |
| **建议值** | 区分语义：点击态用 `_pressed`，文字色改用 `_text` 或 `_strong`（如 `color_success_text` / `color_success_strong`） |
| **影响** | 语义混淆，工程师容易把"文字色"误用作"点击态"反之亦然 |

### 9. Role token 跨 family 同名冲突

| 维度 | 内容 |
|---|---|
| **位置** | `page 12:261` → 「文本 Text Styles」`297:165` |
| **当前值** | pingfang 组和 zhenghei 组都叫 `font_size_14_400` / `font_size_14_600` 等 |
| **建议值** | 给 family 前缀：`pingfang_font_size_14_400` / `zhenghei_font_size_14_400` |
| **影响** | 单凭 token 名无法识别字族；全局命名空间冲突 |

---

### 9.5 V16 errorred 与 jdred 共享 light hex（解耦未完成）

| 维度 | 内容 |
|---|---|
| **位置** | `page 58:9` → 「彩色暗黑映射表」`577:2610` |
| **当前值** | `errorred_2` (V16) → `dangerred_2` (V15) → `#FF0F23`，与 `brand_6` / V16 `jdred_6` 完全同色 |
| **建议值** | 给 errorred 提供独立色谱（红色系但与京东红色相区分），例如 errorred_2 偏暗或偏橙红 |
| **影响** | V16 设计意图是「Error 从 Primary 解耦」，但当前 hex 仍共用，命名解耦了但视觉没解耦 |

### 9.6 V16 errorred_3 / infoblue_3 引用但缺源数据

| 维度 | 内容 |
|---|---|
| **位置** | `page 58:9` → 「色彩变量 Colors Token」`591:1785` 引用 `errorred_3`、`infoblue_3` |
| **当前值** | V15 「彩色暗黑映射表」`577:2610` 中只有 `dangerred_1/2`、`infoblue_1/2`，无 _3 阶 |
| **建议值** | 补 `dangerred_3` / `infoblue_3`（V16 重命名后即 `errorred_3` / `infoblue_3`）的 light + dark hex |
| **影响** | V16 token `color_error_pressed` / `color_Info_pressed` 当前无 hex 可用 |

## 🟠 P2 · 跨页面 / 跨标题不一致（疑似）

### 10. Filled 图标 frame 名与内部标题不一致

| 维度 | 内容 |
|---|---|
| **位置** | `page 12:263` → frame `260:543` |
| **当前值** | Frame 名 `图标 Icons - 线性`，内部标题文字 `图标 Icons - 填充` |
| **建议值** | Frame 名改为 `图标 Icons - 填充` |
| **影响** | 通过 frame 名引用时找不到对的内容 |

### 11. 字身框留白 3DP vs 4DP 不一致

| 维度 | 内容 |
|---|---|
| **位置** | V15 `tokens.json#icon.padding = 3px` vs V16 frame 名 `图标 Icons - 线性 - 4dp` (`259:12`) |
| **当前值** | V15 字身框留白 3DP；V16 frame 名含 "4dp" 暗示 4DP |
| **建议值** | 若 V16 改了请显式声明（在「线」「圆角」「图标」页加一行参数 token）；若没改请改 frame 名为 "3dp" |
| **影响** | 字身框留白决定图标视觉中心，是否变化直接影响所有图标渲染 |

---

## 📋 修复 checklist（给设计师）

- [ ] #1 color_Info 系列 3 个改小写
- [ ] #2 color_service_bground → color_service_background
- [ ] #3 color_mask_fault_toleran → color_mask_fault_tolerant
- [ ] #4 图标 List → list
- [ ] #5 图标 cart add → cart-add
- [ ] #6 图标 setting 重复处理
- [ ] #6.5 平台色板 orang_* → orange_*（11 处）
- [ ] #7 zhenghei_bold 与 weight 600 不一致 — 讨论决定方向
- [ ] #8 _pressed 语义统一 — 讨论决定方向
- [ ] #9 Role token family 前缀 — 讨论决定方向
- [ ] #9.5 **errorred 独立色谱 hex 提供**（关键：解耦只在命名层完成）
- [ ] #9.6 dangerred_3 / infoblue_3 hex 补全
- [ ] #10 Filled 图标 frame 名修正
- [ ] #11 字身框留白 3 / 4 DP 确认

---

## 修复后流程

设计师在 Relay 文件改好后告知我，我同步把 v16 文档的相应位置回填正确命名，并把本文件的对应条目划掉。

设计文件：`https://relay.jd.com/file/design?id=2029484645871009793`
