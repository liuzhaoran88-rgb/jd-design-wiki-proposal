---
file: design
level: component-base
bg: horizontal
slug: button
name_zh: "样式=主要操作（红色填充）, 状态=默认"
name_en: "Button"

owner: "@xushui2018"
contributors: []
status: draft
version: "0.1"
last_synced: "2026-05-13"

# skill 自动推断的字段。如不对，请改 frontmatter + mv 文件夹后告知。
auto_detected:
  level: component-base
  bg: horizontal
  slug: "button"
  # ⚠️ skill v0.1 限制：本节点是按钮的某个变体（主要操作红色填充默认态）。
  # 但 slug 检测从 PAGE 名提取 → "button"。
  # 设计师 review 时考虑：①若这是 Button 总入口文档 → 保持；
  # ②若仅是变体 → mv 文件夹到 button-primary-default 并改 slug。

relay_source:
  file_id: "2029484645871009793"
  page_id: "33:5"
  node_id: "608:1031"
  node_name: "样式=主要操作（红色填充）, 状态=默认"
  node_type: INSTANCE
  bounds: { w: 176, h: 48 }
  url: "https://relay.jd.com/file/design?id=2029484645871009793&page_id=33%3A5&node_id=608%3A1031"

references:
  uses_components:
    - horizontal/components-base/icon-home    # ✅ V16 图标库的 home（× 2 个实例）
    # 注：icon-home 还未单独 design.md，待图标库批量录入后回填

  uses_tokens:
    colors:
      - color_primary             # #FF0F23 → atom.jdred_6
      - color_primary_text        # #FFFFFF → atom.white
      # ⚠️ #FFFFFF@90% → rgba-suggestion "white-at-90"
      # 未匹配 V16 atom；若该 hex 在多组件出现，建议设计组加 atom.white_90
    typography:
      - pingfang_semibold/font_size_18_600    # 18pt PingFang SC Semibold "操作按钮"
    radius:
      - radius_l                  # 8px → 按钮单行高度 48px 对应 V16 「单行高度 40+」分组
    spacing:
      - spacing.24                # padding L/R
      - spacing.8                 # itemSpacing
    materials: []                 # 主要按钮不使用材质

used_by: []
---

# 样式=主要操作（红色填充）, 状态=默认 · Button

> 自动同步 2026-05-13 · skill v0.1 · Relay [`608:1031`](https://relay.jd.com/file/design?id=2029484645871009793&page_id=33%3A5&node_id=608%3A1031)

## 一句话定义

<!-- TODO: 设计师补充。一句话讲清这个组件是什么、解决什么问题。 -->

## 应用场景

### ✅ 用

<!-- TODO: 设计师列举什么场景下用 -->

### ❌ 不用

<!-- TODO: 设计师列举什么场景下不能用 -->

## 视觉

### 预览

![Button](./preview.png)

> ✅ 由 skill v0.2 自动导出（352×96 @2x · 3.8KB）

### 色彩

| 用途 | Token | 实际 hex |
|---|---|---|
| 按钮底 | `color_primary` | `#FF0F23` |
| 文字 + 图标 | `color_primary_text` | `#FFFFFF` |
| 点击高亮态 overlay | ⚠️ rgba-suggestion: `white-at-90` | `#FFFFFF@90%`（V16 atom 缺，若高频建议加 `atom.white_90`）|

### 文字

| 用途 | Token | Family / Size / Weight |
|---|---|---|
| 按钮文案 | `pingfang_semibold/font_size_18_600` | PingFang SC / 18pt / 600 |

### 圆角

| 用途 | Token | 实际值 |
|---|---|---|
| 按钮容器 | `radius_l` | 8px |

> 对应 V16 圆角分配规则：按钮单行高度 48px → 「单行高度 40+ 的组件」分组 → `radius_l` (8px)。详见 [foundations/tokens/radius.md](../../../foundations/tokens/radius.md)。

### 间距 / 布局

| 容器 | 模式 | Padding | Spacing |
|---|---|---|---|
| 根容器 | HORIZONTAL | 24 / 24 / 0 / 0 | 8 |

对应 Token：
- 左右内边距 → `spacing.24`
- 图标-文字间距 → `spacing.8`

### 材质

无（主要按钮使用实色填充，不引用材质）。

## 交互

<!-- TODO: 设计师描述手势、转场、状态切换、边界情况 -->
<!-- 已知状态：默认 / 禁用 / 点击 (需补充) -->

## 变体 Variants

> 同属 ↘️ 按钮 Button (page 33:5) 下的相关变体（INSTANCE 命名暗示）：
> - 样式=主要操作（红色填充）, 状态=默认（本节点 608:1031）
> - 样式=主要操作（红色填充）, 状态=禁用（608:1082）
> - …（页面共 9 个 top frames，含 spec 文档 + 多个状态变体）
>
> 完整 variants 矩阵建议参考 page 33:5 顶层结构。

## Donts

<!-- TODO: 设计师列举常见误用，例如：-->
<!-- - 不要硬编码 #FF0F23 替代 color_primary -->
<!-- - 不要在非首要操作场景使用主要按钮 -->
<!-- - 不要把 18pt Semibold 改成其他字号字重 -->

## AI Schema

```yaml
# TODO: 设计师补充。AI 消费者通过这个区块了解组件语义。
component_type: button
variant: primary-default
priority: primary
states:
  default: TODO
  hover: TODO
  pressed: TODO
  disabled: TODO
slots:
  leading_icon: optional (icon-home / etc)
  label: required (string)
  trailing_icon: optional
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
| 2026-05-13 | 创建 | skill v0.1 | 自动生成 / 5 处 TODO 待补 / 3 处 ⚠️ flag |
| 2026-05-13 | 圆角字段修正 | skill v0.1.1 | radii 抽取 bug 修复（root.findAll 不含 root 自身）→ 抽到 `radius_l` (8px) |
| 2026-05-13 | preview.png 补齐 | skill v0.2 | exportAsync({format:PNG, scale:2}) → 352×96 @2x · 3.8KB |

---

## ⚠️ 本次自动同步发现的待办（给设计师 / V16 设计组）

1. **rgba-suggestion**：`#FFFFFF@90%` → V16 atom 缺；skill v0.2 启发式建议 `white-at-90`。如果该 hex 在多个组件复现，请向 V16 设计组提议增加 `atom.white_90 = rgba(255,255,255,0.9)` (light/dark)。
2. ~~**圆角未检测**~~ ✅ **已 skill v0.1.1 修复** — 现已正确抽到 `radius_l` (8px)。
3. **slug 命名歧义**：本节点是 Button 变体，但 slug 检测到 "button"（来自 PAGE 名）。若打算建多个 Button 变体的 design.md，第 2 个 onwards 会触发 .NEW 冲突保护。设计师酌情：① 此文档作为 Button 总入口 → 保持；② mv 到 `button-primary-default/` → 改 frontmatter slug。
4. ~~**未自动导出 preview.png**~~ ✅ **已 skill v0.2 修复** — exportAsync 链路通，352×96 @2x · 3.8KB。
5. **未录入子组件**：`horizontal/components-base/icon-home` 引用，但 icon-home 自己还没 design.md。待图标库批量录入后由 skill 反向更新 used_by。
