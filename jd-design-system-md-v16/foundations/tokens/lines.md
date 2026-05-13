---
token_category: lines
version: 16.0-draft
last_updated: 2026-05-12
relay_source:
  file_id: "2029484645871009793"
  page_id: "12:264"
  token_frame: "363:636"
  spec_frame: "297:293"
  url: https://relay.jd.com/file/design?id=2029484645871009793&page_id=12%3A264
v15_predecessor: null   # V15 无独立 line token
relay_changelog:
  - "2026-03-12 ｜ 周峯 ｜ 创建"
extraction_status: tokens 100%
v16_status_overall: new
---

# 线 Token · V16.0 🚩 全新独立 foundation

> V16.0 **新增「线」作为独立 foundation**。V15.0 没有线宽 token —— 只有 `color.neutral.border.default = #00000014`（颜色），线宽靠 CSS 默认 1px。
>
> V16 把线宽显式 token 化，针对高密屏（2x/3x）做了精细化处理。

---

## V15 → V16：整组 **new**

| V15 状态 | V16 新增 |
|---|---|
| ❌ 无线宽 token，靠 CSS 默认 1px | ✅ 2 个线宽 token：0.33px / 0.5px |
| 只有线色 `border.default = #00000014` | 颜色仍走 `color_border` → `gray_9`（见 [color.md](./color.md)） |

---

## 线变量（2 个 token）

| Token | Atom | 宽度 | 场景说明 | v16 status |
|---|---|---|---|---|
| `line_tag` | `line_1` | **0.33px** | 标签边框 | **new** |
| `line_component` | `line_2` | **0.5px** | 间隔线 / 组件边框 | **new** |

### 为什么是 0.33px 和 0.5px？

V16 线宽是按**物理像素**反推的 CSS px：

| Atom | CSS 宽度 | 物理 px @1x | 物理 px @2x | 物理 px @3x |
|---|---|---|---|---|
| `line_1` | 0.33px | 0.33（不可见） | 0.66（接近 1） | **1**（精确 1 物理 px） |
| `line_2` | 0.5px | 0.5（不可见） | **1**（精确 1 物理 px） | 1.5 |

**Rationale**：
- 移动端高密屏（iPhone/Android 2x-3x）上，CSS `1px` 实际渲染成 2-3 个物理像素，**视觉上偏粗**
- V16 用 `0.33px` / `0.5px` 实现高密屏上的 **"1 物理 px hairline"** 效果，视觉更精致
- 1x 屏（桌面默认）渲染会因小于 1px 而**消失或被舍入**，需要业务层做兼容

---

## 与 V15 的对照

V15 处理细线只能：
1. 用 `border.default` 颜色 + CSS `1px`（粗，2x/3x 屏明显）
2. 用 `transform: scaleY(0.5)` 等 hack（兼容性问题）
3. 用 `box-shadow` 模拟（性能问题）

V16 把这层抽象明确化，**与圆角/字号一样作为 foundation token**。

---

## 线色 vs 线宽 vs 线型

| 维度 | Token | 真相源 |
|---|---|---|
| 线色 | `color_border` → `gray_9` | [color.md](./color.md) |
| 线宽 | `line_tag` / `line_component` | 本文件 |
| 线型（实线/虚线） | — | V16 未定义；默认 `solid` |

---

## 使用约束（推断，待确认）

- ✅ 标签边框 → `line_tag` (0.33px)
- ✅ 卡片间隔线 / 列表分割线 / 输入框边框 → `line_component` (0.5px)
- ❌ 不要硬编码 `border-width: 1px` —— V16 视觉规范默认线宽 ≠ 1
- ⚠️ 桌面端（1x 屏）渲染需做 polyfill：用 SVG / `transform: scale()` / `box-shadow inset` 或退回 1px

---

## 待办

- [ ] 1x 屏渲染兜底方案（V16 是否规定了 polyfill 模式？）
- [ ] 是否有更粗的线宽 token？比如分割大区域用的 4px / 8px 装饰线？
- [ ] 虚线 / 点线规范是否在 V16 治理范围
- [ ] 暗黑模式下线色是否切换（同 `color_border` 走 atom dark variant）
- [ ] 视觉资源：与主规范 frame 297:293 的图示一致
