---
file: design
level: component-base
bg: horizontal
slug: navbar-search-day
name_zh: "搜索条日间"
name_en: "NavBar / SearchBar Day"

owner: "@xushuai133"
contributors: []
status: draft
version: "0.1"
last_synced: "2026-05-13"

# skill 自动推断的字段。如不对，请改 frontmatter + mv 文件夹后告知。
auto_detected:
  level: component-base            # 因 Relay PAGE 名含「↘️ 顶部导航栏 NavBar 🟡」(类似导航类)
  bg: horizontal                   # 因 file_id 2029484645871009793 = V16 master 文件
  slug: "navbar-search-day"        # 从 PAGE 名抽 "NavBar" + 节点名 "搜索条日间"

relay_source:
  file_id: "2029484645871009793"
  page_id: "47:1"
  node_id: "542:6495"
  node_name: "搜索条日间"
  node_type: FRAME
  bounds: { w: 375, h: 224 }
  url: "https://relay.jd.com/file/design?id=2029484645871009793&page_id=47%3A1&node_id=542%3A6495"

references:
  uses_components:                 # 此组件用了哪些 L1 子组件 — skill 抽 INSTANCE 自动填
    - horizontal/components-base/icon-arrow-left
    - horizontal/components-base/icon-close
    - horizontal/components-base/icon-card

  uses_tokens:
    colors:
      - color_background_overlay   # #FFFFFF → V16 white atom
      # ⚠️ TODO: 以下 hex 未在 V16 tokens.json 找到匹配，请设计师确认
      # - #11141A (用于文字色 - 似 color_title 但 hex 偏一点)
      # - #B4B8BF (用于 placeholder - 似 color_text_disabled 但 hex 偏一点)
      # - #F0F2F7 (用于背景 - 似 color_background 但 hex 偏一点)
    typography:
      - pingfang_regular/font_size_13_400   # iPhone17 Pro 搜索文案
    radius:
      - radius_base                # 6px 用于 容器 20121213213
      - radius_xl                  # 12px 用于 Liquid Glass Small
    spacing:
      - spacing.4                  # 内组件 spacing (icon-text-gap)
      - spacing.8                  # padding 8/4 (容器 20121213213)
    materials:
      - liquid-glass-small         # ✅ INSTANCE 引用了 Liquid Glass - Small

used_by: []                        # 反向引用：被哪些 L2/L3/L4 用 — skill 维护
---

# 搜索条日间 · NavBar / SearchBar Day

> 自动同步 2026-05-13 · skill v0.1 · Relay [`542:6495`](https://relay.jd.com/file/design?id=2029484645871009793&page_id=47%3A1&node_id=542%3A6495)

## 一句话定义

<!-- TODO: 设计师补充。一句话讲清这个组件是什么、解决什么问题。 -->
<!-- 示例: 商品搜索结果页顶部的搜索条，日间模式下复用 Liquid Glass Small 材质 + iPhone17 Pro 搜索关键词回显 + 返回 / 关闭 / card 切换三按钮。-->

## 应用场景

### ✅ 用

<!-- TODO: 设计师列举什么场景下用 -->

### ❌ 不用

<!-- TODO: 设计师列举什么场景下不能用 -->

## 视觉

### 预览

![搜索条日间](./preview.png)

> ⚠️ skill v0.1 暂未自动导出 preview.png — 请设计师手动截图或 v0.2 自动化

### 色彩

| 用途 | Token | 实际 hex |
|---|---|---|
| 容器底（搜索框） | `color_background_overlay` | `#FFFFFF` |
| 搜索文案 | ⚠️ token-miss | `#11141A` (设计师确认是否应为 `color_title` `#171A26`) |
| Placeholder | ⚠️ token-miss | `#B4B8BF` (设计师确认是否应为 `color_text_disabled` `#C2C4CC`) |
| 状态栏背景 | ⚠️ token-miss | `#F0F2F7` (设计师确认是否应为 `color_background` `#F2F3F7`) |

> 自动推断时发现 3 处 hex 与 V16 token 偏差 1-2 个色阶。可能是：① 该组件设计早于 V16 token 锁定 ② V16 token 后续微调要回写组件 ③ 设计师特意用变体值。**请 review**。

### 文字

| 用途 | Token | Family / Size / Weight |
|---|---|---|
| 搜索回显文案 | `pingfang_regular/font_size_13_400` | PingFang SC / 13pt / 400 |

### 圆角

| 用途 | Token |
|---|---|
| 搜索框容器 | `radius_base` (6px) |
| Liquid Glass 容器 | `radius_xl` (12px) |

> ⚠️ 子节点还出现 1.33px / 2.67px 圆角 — 应该是图标内部矢量曲率，不需建 token。

### 间距 / 布局

| 容器 | 模式 | Padding | Spacing |
|---|---|---|---|
| 根容器 | VERTICAL | 0 / 0 / 0 / 0 | 0 |
| 基础-左侧操作 | HORIZONTAL | 10 / 10 / 10 / 10 | 20 |
| 搜索框内部容器 | HORIZONTAL | 8 / 8 / 4 / 4 | 4 |

> ⚠️ "基础-左侧操作" 用了 padding=10 / spacing=20 — V16 标准间距是 4 / 6 / 8 / 12 / 16 倍数，**10 / 20 不在 V16 spacing token 内**。可能是设计师按视觉对齐调出来的"半步值"，请确认是否回写为标准 spacing.8 / spacing.16 / spacing.4 / spacing.20。

### 材质

- **Liquid Glass - Small**（iOS 17+） → V16 `material.liquid-glass.small`
- 详见 [../../../foundations/visual/materials.md](../../../foundations/visual/materials.md#liquid-glass---small)

## 交互

<!-- TODO: 设计师描述 -->
<!-- - 左按钮 arrow-left：点击返回上一页 -->
<!-- - 右按钮 card：点击切换视图（看卡 / 列） -->
<!-- - 中间搜索文案：点击 → 进搜索关键词编辑态；关闭 → 触发清除态 -->
<!-- - 状态切换动效：参考 V16 motion.duration.s + easing.standard（继承 V15）-->
<!-- - 滚动联动：随页面滚动时材质透明度梯度变化 -->

## 变体 Variants

> 同属 ↘️ 顶部导航栏 NavBar 🟡 (page 47:1) 下的相关变体：
> - 搜索条日间 (本节点)
> - 搜索条通透 (542:6455)
> - 搜索条日间 (635:576) — 重复命名？(参见 [RELAY-V16-TYPOS.md](../../../RELAY-V16-TYPOS.md))
> - 各暗黑模式变体（INSTANCE `542:6498` 模式=暗黑模式）

## Donts

<!-- TODO: 设计师列举常见误用，例如：-->
<!-- - 不要用 hex 硬编码替代 color_background_overlay -->
<!-- - 不要把搜索文案改成 zhenghei 字族 -->
<!-- - 不要把 Liquid Glass Small 拿到 iOS 16 以下平台用 — 应走 Frosted Glass Small -->

## AI Schema

```yaml
# TODO: 设计师补充。AI 消费者通过这个区块了解组件语义。
component_type: navbar.search-day
states:
  default: 搜索文案回显
  empty: TODO
  loading: TODO
slots:
  left: icon (arrow-left)
  center: text (search-keyword)
  right: icon (card / close)
events:
  TODO
```

## 关联

- 此组件归属：`level: component-base`, `bg: horizontal`
- V16 Foundation 引用：见 frontmatter `references.uses_tokens`
- 父级页面：（待 L3 录入后由 skill 反向填 `used_by`）

## 变更记录

| 时间 | 操作 | 来源 | 备注 |
|---|---|---|---|
| 2026-05-13 | 创建 | skill v0.1 | 80% 自动 / 5 处 TODO 待设计师补；3 处 token-miss flag |

---

## ⚠️ 本次自动同步发现的待办（给设计师 / V16 设计组）

1. **3 处 token-miss**：`#11141A` / `#B4B8BF` / `#F0F2F7` 与 V16 token 偏 1-2 色阶 — 是该回归 token，还是组件特殊处理？
2. **半步间距**：10px / 20px 不是 V16 spacing 倍数 4 — 回归到 spacing.8 / spacing.16 还是新增 atom？
3. **3 个 INSTANCE 子组件引用未建 design.md**：`icon-arrow-left` / `icon-close` / `icon-card` —— 这些图标当前由 [icon.md](../../../foundations/tokens/icon.md) 列了清单但还没单独 design.md，需要后续走 skill 录入。
4. **未自动导出 preview.png** — v0.2 加。
