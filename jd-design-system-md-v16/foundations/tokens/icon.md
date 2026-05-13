---
token_category: icon
version: 16.0-draft
last_updated: 2026-05-12
relay_source:
  file_id: "2029484645871009793"
  page_id: "12:263"
  spec_frames:
    - "259:12"   # 图标 Icons - 线性 - 4dp（26+ 线性图标）
    - "260:543"  # 图标 Icons - 填充（7 填充图标，frame 名/标题不一致）
  url: https://relay.jd.com/file/design?id=2029484645871009793&page_id=12%3A263
v15_predecessor: ../../../jd-design-system-md/foundations/tokens/tokens.json#icon
relay_changelog:
  - "2026-04-12 ｜ 周峯 ｜ 创建"
extraction_status: 图标清单 100% / 参数 token (size/stroke/frame) 未在 V16 显式定义 — 沿用 V15
v16_status_overall: WIP（页签未带 ✅）
---

# 图标 Token · V16.0 🟡 WIP

> V16.0 图标页 (`12:263`) 当前只列了**图标清单**（线性 + 填充两套），**未在文件中显式定义 size/stroke/frame 等参数 token**。
>
> 本文档：1) 图标清单全量录入；2) 参数 token 沿用 V15.0；3) 标 WIP 等设计师补齐参数层。

---

## 1. 参数 Token（沿用 V15.0）

> V15 图标参数 token 见 `../../../jd-design-system-md/foundations/tokens/tokens.json#icon`。V16 文件未提供新值，**默认沿用**。

| Token | V15 值 | V16 值 | 用法 | v16 status |
|---|---|---|---|---|
| `icon.size.s` | 16px | (待 V16 确认) | 列表项 / 表单 / 嵌入文字行内 | inherited from V15 |
| `icon.size.m` | 20px | (待 V16 确认) | 工具栏 / 卡片操作 | inherited from V15 |
| `icon.size.l` | 24px | (待 V16 确认) | Tab Bar / 标题栏 | inherited from V15 |
| `icon.stroke.s` | 1px | (待 V16 确认) | 16DP 笔触 | inherited from V15 |
| `icon.stroke.m` | 1.5px | (待 V16 确认) | 20DP 笔触 | inherited from V15 |
| `icon.stroke.l` | 1.5px | (待 V16 确认) | 24DP 笔触 | inherited from V15 |
| `icon.frame` | 26px | (待 V16 确认) | 字身框 | inherited from V15 |
| `icon.padding` | 3px | (待 V16 确认) | 字身框内留白 | inherited from V15 |
| `icon.balance-ratio.circle` | 1:1 | (待 V16 确认) | — | inherited from V15 |
| `icon.balance-ratio.square` | 8:9 | (待 V16 确认) | — | inherited from V15 |
| `icon.balance-ratio.rounded-square` | 9:10 | (待 V16 确认) | — | inherited from V15 |
| `icon.balance-ratio.triangle` | 10:11 | (待 V16 确认) | — | inherited from V15 |
| `icon.max-corner-radius` | 2px | (待 V16 确认) | 锐角倒圆角不超过 2DP | inherited from V15 |

> ⚠️ V16 文件名 "图标 Icons - 线性 - **4dp**" —— "4dp" 可能指**字身框内留白** 4DP（V15 是 3DP），暗示 V16 字身框留白从 3DP 提到 4DP；待向设计师确认。

---

## 2. 线性图标库 · 26 个（V16）

> Frame: `259:12` 「图标 Icons - 线性 - 4dp」(1840×1037)

| 行 | 图标名 |
|---|---|
| 1 | arrow-left · arrow-right · arrow-down · arrow-up · close · home · video · ask |
| 2 | cart · user · card · star · share · **List** · location · gift |
| 3 | search · clean · heart · store · setting · success · clock · more |
| 4 | setting · cart add |

> ⚠️ **typo**：`List`（大写 L），其他全小写。建议规范为 `list`。
> ⚠️ **疑似重复**：第 3 行 `setting` 和第 4 行 `setting` 重复，需向设计师确认是否同一图标或不同变体。
> ⚠️ **命名空格**：`cart add`（含空格）—— 建议规范为 `cart-add` 或 `cart_add` 以兼容文件/CSS 命名。

---

## 3. 填充图标库 · 7 个（V16）

> Frame: `260:543` —— **frame 命名 "图标 Icons - 线性" 但内部标题 "图标 Icons - 填充"**（Relay 文件不一致）

| 图标名 |
|---|
| home · video · ask · cart · user · star · heart |

**Rationale**：填充图标仅覆盖核心 Tab Bar / 收藏 / 心愿单 等需要选中态的图标。线性 = 常态；填充 = 选中态/强化。

> ⚠️ frame 名和内部标题不一致，需向设计师确认。

---

## 与 V15 的对照

V15 图标 token 只定义了**参数层**（size / stroke / frame 等），**未给图标清单**。V16 反过来：

| 维度 | V15 | V16 |
|---|---|---|
| 参数 token | ✅ 完整（size / stroke / frame / padding / balance-ratio / max-corner-radius） | ❌ 未显式（推断沿用 V15） |
| 图标清单 | ❌ TODO（"icon-library-json: 图标 unicode 清单 — 待 ICONFONT 库交付"） | ✅ 提供 33 个图标（26 线性 + 7 填充） |

**Rationale**：V15 把图标清单延后到 ICONFONT 库交付；V16 在设计文件里直接给图标库，弥补 V15 缺口。但 V16 缺**参数 token**，需要补齐才能完整。

---

## 待办

- [ ] V16 参数 token（size / stroke / frame）是否调整（特别是 "4dp" 字身框留白疑似改变）
- [ ] 图标清单完整性确认（V16 仅 33 个，V15 的 ICONFONT 库可能 ~200 个；剩余图标如何引入）
- [ ] Typo 修正：`List` → `list`；`cart add` → `cart-add`
- [ ] 重复检查：第 3 行 vs 第 4 行的 `setting`
- [ ] Filled 图标库补全（V16 仅 7 个 Tab Bar 用，其他可能场景如收藏选中态等）
- [ ] V16 是否引入「双色 / 多色」图标体系（V15 全单色）
- [ ] 图标 → ICONFONT 工具链对齐（V15 标 TODO）
