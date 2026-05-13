---
token_category: radius
version: 16.0-draft
last_updated: 2026-05-12
relay_source:
  file_id: "2029484645871009793"
  page_id: "12:262"
  token_frame: "363:507"
  spec_frame: "297:248"
  url: https://relay.jd.com/file/design?id=2029484645871009793&page_id=12%3A262
v15_predecessor: ../../../jd-design-system-md/foundations/tokens/radius.md
relay_changelog:
  - "2026-03-12 ｜ 周峯 ｜ 创建"
extraction_status: tokens 100%
---

# 圆角 Token · V16.0

> V16.0 圆角 token 7 阶（T-shirt size），按**单行高度 / 组件类型**精确分配。

---

## 🚩 V15 → V16 变化

| V15 token | V15 值 | V16 token | V16 值 | 状态 |
|---|---|---|---|---|
| `radius.0` | 0 | `radius_xxs` | 0 | **upgraded**（语义升级：V15 "直角" → V16 "平台型通栏卡片"） |
| `radius.xs` | 2px | `radius_xs` | 2 | **unchanged** |
| `radius.s` | 4px | `radius_s` | 4 | **unchanged** |
| `radius.base` | 6px | `radius_base` | 6 | **upgraded**（语义精确化：V15 "默认按钮/卡片" → V16 "单行高度 28-36 组件"） |
| `radius.detail` | 8px | `radius_l` | 8 | **upgraded**（重命名 detail→l） |
| — | — | `radius_xxl` | 16 | **new** |
| `radius.xl` | 12px | `radius_xl` | 12 | **unchanged**（值同，用法重定位） |
| `radius.structural` | 24px | — | — | **deprecated** |
| `radius.full` | 9999px | — | — | **deprecated**（胶囊型整体移除？需确认） |

---

## 1. 圆角变量（7 个 token）

| Token | Atom | 数值 | 场景说明 | v16 status |
|---|---|---|---|---|
| `radius_xxs` | `Radius_0` | 0 | 平台型页面通栏卡片结构 | **upgraded** |
| `radius_xs` | `Radius_2` | 2px | 标签 | **unchanged** |
| `radius_s` | `Radius_4` | 4px | 单行高度 20 至 24 的组件 | **unchanged** |
| `radius_base` | `Radius_6` | 6px | 单行高度 28 至 36 的组件 | **upgraded** |
| `radius_l` | `Radius_8` | 8px | 导购型页面卡片结构 / 单行高度 40 及以上的组件 | **upgraded** |
| `radius_xl` | `Radius_12` | 12px | 顶导 / 吐司提示等悬浮层小面积组件 | **upgraded** |
| `radius_xxl` | `Radius_16` | 16px | 弹层 / 弹窗 / 底导等悬浮层中大面积组件 | **new** |

---

## V16 的圆角分配逻辑（关键认知）

V16 圆角不是按「组件类型」（button/card/modal），而是按 **单行高度** + **组件层级**（平台型/导购型/悬浮层）：

```
单行高度  → 圆角 atom
20-24    → Radius_4  (radius_s)
28-36    → Radius_6  (radius_base)
40+      → Radius_8  (radius_l)

组件层级  → 圆角 atom
平台型通栏    → Radius_0  (radius_xxs)
导购型卡片    → Radius_8  (radius_l)
悬浮层小面积  → Radius_12 (radius_xl)  ← 顶导/吐司
悬浮层中大面积 → Radius_16 (radius_xxl) ← 弹层/弹窗/底导
```

**Rationale**：V15 用 role token (`button`/`card`/`modal` 等) 给每个组件指定圆角；V16 改为**按高度/层级算**，无需给每个组件单独指 role token，**减少 role token 蔓延**，但代价是需要计算判断。

---

## 与 V15 role token 的对照

V15 的 `radius.role.*` 在 V16 没有等价独立 token，需要按规则推导：

| V15 role | V15 值 | V16 推导 |
|---|---|---|
| `radius.role.button` | base = 6px | 按高度推：默认按钮 32-40 高 → `radius_base` 或 `radius_l` |
| `radius.role.card` | base = 6px | 按层级推：导购型 → `radius_l`；平台型 → `radius_xxs` |
| `radius.role.card-detail` | detail = 8px | → `radius_l` ✅ |
| `radius.role.card-large` | xl = 12px | → `radius_xl` |
| `radius.role.modal` | xl = 12px | 弹窗中大面积 → `radius_xxl`（V16 16px，比 V15 12px 大） |
| `radius.role.tag` | s = 4px | → `radius_s` 或 `radius_xs`（看标签实际高度） |
| `radius.role.avatar` | full = 9999px | ❌ V16 无 full（胶囊/圆形头像方案需确认） |
| `radius.role.input` | base = 6px | → `radius_base` ✅ |
| `radius.role.skeleton` | s = 4px | → `radius_s` ✅ |
| `radius.role.toast` | base = 6px | 悬浮层小面积 → `radius_xl`（V16 12px，比 V15 6px 大） |

> ⚠️ **Avatar / 头像怎么办**：V16 没有 `full = 9999px`。Avatar 圆形（胶囊）需要业务方自己写 `border-radius: 50%`？还是 V16 引入了独立的形状 token？**待向设计师确认**。

> ⚠️ **Toast 圆角变化**：V15 toast=6px，V16 toast=12px（按悬浮层小面积归类）—— 视觉变化可能较明显，迁移时需评估。

> ⚠️ **Modal 圆角变化**：V15 modal=12px，V16 modal=16px —— 同上。

---

## 待办

- [ ] `radius.full = 9999px`（胶囊型）在 V16 是否真的废弃？头像 / Switch / Tab 等胶囊形组件方案？
- [ ] `radius.structural = 24px`（结构分割型）废弃方案确认
- [ ] V16 没有 role token，是否真的所有组件都走「单行高度判断」？需要确认 button/input 等高频组件的实际取值规则
- [ ] V16 圆角值升级影响评估：toast 6→12、modal 12→16，业务侧迁移成本
- [ ] 与主规范 frame 297:248（2400×697）的图示对照 — 待截图验证
