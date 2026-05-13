---
token_category: spacing
version: 16.0-draft
last_updated: 2026-05-12
relay_source:
  file_id: "2029484645871009793"
  page_id: "6:3"
  spec_frames: ["480:9718", "464:10576", "508:4087"]   # 空间布局 1/2/3
  url: https://relay.jd.com/file/design?id=2029484645871009793&page_id=6%3A3
v15_predecessor: ../../../jd-design-system-md/foundations/tokens/spacing.md
extraction_status: 数值已识别，token 命名未在语义化统一中出现 — 沿用 V15 体系并标注变化
v16_status_overall: upgraded (大部分沿用 V15)
---

# 间距 Token · V16.0

> V16.0 间距体系 **沿用 V15 的双梯度（导购型 / 平台型） + 基量 4**，但**未在「语义化统一」里出现新的 spacing token frame**。空间布局 1/2/3 规范页（`6:3`）里以「DP 数值 + 用法描述」形式呈现，token 命名沿用 V15 即可。
>
> **重大新增**：Z 轴层级模型（4 层）+ 悬浮底导起始器 17DP。

---

## 🚩 V15 → V16 变化

| 变化 | V15 | V16 |
|---|---|---|
| **基量** | 4 | 4 ✅ |
| **双梯度** | 平台型 / 导购型 | 平台型 / 导购型 ✅ |
| **基础数值** | 0/2/4/6/7/8/12/16/20/24/28/32/40 | 沿用（未在 token frame 出现，但规范页用法一致） |
| **safe-area.status-bar** | 44DP | 44DP ✅ unchanged |
| **safe-area.home-indicator** | 34DP（常规起始器） | 34DP ✅ unchanged |
| **safe-area.screen-edge** | 8DP（沉浸式专用） | 8DP ✅ unchanged |
| **悬浮底导起始器** | — | **17DP** 🆕 new |
| **Z 轴层级** | 隐式（未规范） | **4 层显式**（背景/内容/全局控制/临时任务）—— 见 [layout.md](../visual/layout.md) |
| **token frame** | 显式 (tokens.json) | ❌ V16 语义化统一未列 spacing token — 沿用 V15 |

---

## 1. 基础数值（atom 层，沿用 V15）

| Token | 值 | 用法 | v16 status |
|---|---|---|---|
| `spacing.0` | 0 | 紧贴 | **unchanged** |
| `spacing.2` | 2px | 导购型 慎用 — 异形空间紧密关联 | **unchanged** |
| `spacing.4` | 4px | 紧密关联（图标-文字） | **unchanged** |
| `spacing.6` | 6px | 平台型 慎用替代 / 导购型 常规关联 | **unchanged** |
| `spacing.7` | 7px | Feeds 横纵特殊值（保证像素整除） | **unchanged** |
| `spacing.8` | 8px | 平台型 常规关联 / 导购型 弱关联 / 卡片间距 / 顶导外边距 | **unchanged** |
| `spacing.12` | 12px | 平台型 弱关联 / 导购型 无关联 | **unchanged** |
| `spacing.16` | 16px | 平台型 无关联 / 非卡片元素左右安全距离 / 平铺式核心内容边距 | **unchanged** |
| `spacing.20` | 20px | 平台型延展 | **unchanged** |
| `spacing.24` | 24px | 平台型延展 / 大模块间距 | **unchanged** |
| `spacing.28` | 28px | 平台型延展 | **unchanged** |
| `spacing.32` | 32px | 大留白 | **unchanged** |
| `spacing.40` | 40px | 节庆装饰间距 | **unchanged** |

---

## 2. 双梯度语义（沿用 V15）

> 塔式原理 5 级语义层级 × 平台 / 导购双梯度。

### 2.1 平台型（首页、搜推、我京、频道 → 用于个人中心 / 设置 / 后台）

| Token | 值 | 用法 |
|---|---|---|
| `spacing.semantic.platform.unrelated` | `{spacing.16}` | 无关联（卡片内上下安全） |
| `spacing.semantic.platform.loose` | `{spacing.12}` | 弱关联（卡片内左右安全） |
| `spacing.semantic.platform.normal` | `{spacing.8}` | 常规关联（区块内子元素） |
| `spacing.semantic.platform.alt` | `{spacing.6}` | 慎用替代（异形） |
| `spacing.semantic.platform.tight` | `{spacing.4}` | 紧密（图-文） |

### 2.2 导购型（商品列表、活动页、首页、搜推、我京、频道）

> **⚠️ V16 描述更精确**："信息密集，紧凑梯度，在有限空间内展示更多内容"

| Token | 值 | 用法 |
|---|---|---|
| `spacing.semantic.shopping.unrelated` | `{spacing.12}` | 无关联（卡片内上下安全） |
| `spacing.semantic.shopping.loose` | `{spacing.8}` | 弱关联（卡片内左右安全） |
| `spacing.semantic.shopping.normal` | `{spacing.6}` | 常规关联（区块内子元素） |
| `spacing.semantic.shopping.tight` | `{spacing.4}` | 紧密（图-文） |
| `spacing.semantic.shopping.alt` | `{spacing.2}` | 慎用（异形） |

---

## 3. Role token（沿用 V15）

| Token | 值 | 用法 | v16 status |
|---|---|---|---|
| `spacing.role.page-edge` | `{spacing.16}` | 页面左右边距（非卡片承载元素） | **unchanged** |
| `spacing.role.section-gap-platform` | `{spacing.12}` | 平台型通栏间距 | **unchanged** |
| `spacing.role.section-gap-shopping` | `{spacing.8}` | 导购型通栏间距 | **unchanged** |
| `spacing.role.feeds-gap` | `{spacing.7}` | Feeds 横纵 | **unchanged** |
| `spacing.role.icon-text-gap` | `{spacing.4}` | 图文 | **unchanged** |
| `spacing.role.modal-padding` | `{spacing.16}` | 模态内边距 | **unchanged** |

---

## 4. Safe Area（V16 新增 17DP）

| Token | V15 值 | V16 值 | 说明 | v16 status |
|---|---|---|---|---|
| `spacing.safe-area.status-bar` | 44DP | **44DP** | iOS 顶部系统状态栏 | **unchanged** |
| `spacing.safe-area.home-indicator` | 34DP | **34DP** | 常规起始器（标准 Tab Bar bottom safe area） | **unchanged** |
| `spacing.safe-area.home-indicator-floating` | — | **17DP** | **悬浮底导起始器**（V16 新增） | **new** |
| `spacing.safe-area.screen-edge` | 8DP | 8DP | 屏幕左右安全距离（沉浸式氛围专用） | **unchanged** |

**Rationale 新增 17DP**：V16 引入悬浮底导（Floating Tab Bar）组件——见 [materials.md](../visual/materials.md) Liquid Glass Medium 容器 120×120。常规起始器 34DP 会与悬浮底导高度冲突，V16 提供 17DP 减半 safe-area 让悬浮底导浮在原 home indicator 区域。

---

## 5. 关键场景间距（V16 规范页明示）

| 场景 | 间距 | 说明 |
|---|---|---|
| 卡片距屏幕左右 | **8DP** | 导购型 |
| 卡片之间间距 | **8DP** | 导购型 |
| 双列 Feeds 横向间距 | **7DP** | 像素整除 |
| 顶导组件距屏幕左右 | **8DP** | 通用 |
| 容器纵向间距（卡片混排/横滑） | **8DP** | 导购型 |
| 容器横向间距 | **7DP** | 导购型 |
| 非卡片散落元素左右安全 | **≥16DP** | 曲面屏适配 |
| 平铺式核心内容左右 | **16DP** | 平台型（商详/购物车/结算/订列/订详） |
| 平铺式顶底导组件 | **8DP** | 平台型 |
| 平铺式纵向区块间距 | **8DP** | 平台型 |

---

## 待办

- [ ] V16 是否会在后续单独建 spacing token frame？还是 V16 spacing 故意沿用 V15 不变？
- [ ] 17DP 悬浮底导起始器对应 atom 命名（`spacing.17`？沿用 V15 体系应该补一个 17 atom）
- [ ] Z 轴层级的「全局控制层」与「临时任务层」详细定义（规范页文本被截断 — 需补全或回查）
- [ ] 元素布局 3 中的「文本行高」和「元素增加余量」（被截断）— 需补全
- [ ] 与新的 16/17DP 高度组件相关的 padding 规范是否变化
