---
file: behaviors
bundle_part_of: design.md
slug: tabbar
last_synced: "2026-05-14"

# v0.5 page-doc bundle: 应用场景 / 交互 / Donts / AI Schema / 多端适配
# 来源：Relay 节点 312:46893 章节 04-05 + 跨章节 dont_rule 聚合
relay_source:
  node_id: "312:46893"
  url: "https://relay.jd.com/file/design?id=2029484645871009793&page_id=31%3A1&node_id=312%3A46893"
---

# 底部导航栏 · 行为 / 禁止 / Schema / 适配

> design.md → [index](./design.md) · 同 bundle: [spec](./spec.md) · [variants](./variants.md)

## 应用场景

> ⚠️ **草稿，待设计师 review**

### ✅ 用

- 作为 APP 主要功能区的最高层级导航（首页 / 分类 / 购物车 / 我的 等）
- 需要在 2~5 个核心一级功能间快速切换的全局导航场景
- 需要展示日常 / 活动 / 大促灵动岛运营资源位的场景
- 需要嵌入 Joy Agent 入口（点击进入对话中心场景弹层）的场景

### ❌ 不用

- 二级及以下页面（应由顶部 NavBar 或 SegmentControl 承担）
- 需要超过 5 个一级 Tab 的场景（章节 01 建议 ≤ 5，详见 Donts）
- 需要持续遮挡内容的场景（Tabbar 是常驻底部组件）

## 交互

> ⚠️ **草稿，待设计师 / 工程师 review**

- **基础切换**：点击坑位切换整页内容（章节 01 设计原则）
- **状态切换**：默认态 ↔ 选中态（按下后图标 + 文本变 jdred、背景变 gray_6）；营销态可与红点/数字/文字招手叠加，但 38×38 图片仅可替换不可改其它样式
- **灵动岛展开**：灵动岛展开期间，对应坑位选中态背景消失；同时 Joy Agent（若存在）向外抽缩从 16 → 28 DP
- **招手降级**：底部存在灵动岛时，文字/数字招手默认收起为红点型，灵动岛消失后恢复
- **Joy Agent 招手气泡**：缓出向上弹出，最多展示 18 个汉字（超出截断或翻页待确认）
- **Joy Agent 点击**：进入对话中心场景弹层

## Donts

> v0.4 自动收 —— 从章节 02/03/05 真实描述中嵌入的禁止规则抽出（pattern：含 `禁止/不可/不要/避免/最多/支持最大`）。每条标来源章节。

- ❌ iOS 系统安全区 17 DP 内**不可放置任何操作**（章节 02 基础布局 a）
- ❌ 营销态**仅可替换图片，不可做其他样式更改**（章节 02 交互状态 c）
- ❌ 文字型招手**支持最大 4 个字符**（章节 02 招手形态 c）
- ❌ Joy Agent 招手气泡**最多展示 18 个汉字**（章节 01 / 02 交互状态 b）
- ❌ 底导坑位**建议 2~5 个**（章节 01 / 02，上限隐含）
- ❌ 灵动岛**红色区域禁止出现任何元素**（章节 03 三型布局通用）
- ❌ 运营 / 大促灵动岛**避免使用红配绿 / 纯黑 / 纯白等不适合色彩**（章节 03 颜色应用 b/c）
- ❌ 运营 / 大促灵动岛**必须使用浅色系背景 + 深色字**（章节 03 颜色应用 b/c）
- ❌ 常规灵动岛商品图**需上传 PNG 透明底素材**（章节 03 颜色应用 a，反向 dont：不允许带背景）

## AI Schema

> 草稿，基于章节 01-05 实际规范抽出。状态机/事件签名仍需设计师 + 工程师 review。

```yaml
component_type: tabbar

forms:
  regular:        # 常规底导
    total_height: 69      # DP, 含 iOS 安全区
    nav_height: 52        # DP, 不含安全区
    safe_area: 17         # DP, iOS, 不可放置任何操作
    width: 351            # DP
  agent_combo:    # Joy Agent 组合
    total_height: 69
    nav_height: 52
    safe_area: 17
    width: 319            # DP, 距 Agent 8 DP

slots:
  count: [2, 3, 4, 5]     # 章节 02 图 2-5; 建议上限 5
  size: { w: 44, h: 44 }  # DP
  icon: { w: 20, h: 20 }  # DP
  text_box: { w: 44, h: 14 }   # DP, 字符与图标间距 4 DP, 最多 4 汉字
  marketing_image: { w: 38, h: 38 }  # DP, 仅可替换图片
  layout: 均分, 自动布局, 5 坑位左右间距 -4 DP

states:
  default:
    icon_color: gray_1
    text_color: gray_1
    typography: pingfang_regular/font_size_10_400
  selected:
    icon_color: jdred
    text_color: jdred
    background: gray_6     # 灵动岛展开期间背景消失
    typography: pingfang_semibold/font_size_10_600
  marketing:
    image_only: true       # 仅可替换 38x38 图片, 其它样式不可改

badges:
  red_dot:
    offset_icon: { left: 19, bottom: 14 }
    offset_marketing: { left: 28, bottom: 32 }
  number:
    offset_icon: { left: 15, bottom: 14 }
    offset_marketing: { left: 24, bottom: 32 }
  text:
    offset_icon: { left: 15, bottom: 14 }
    offset_marketing: { left: 24, bottom: 32 }
    max_chars: 4
  island_collapse:
    rule: 灵动岛存在时降级为 red_dot, 灵动岛消失后恢复

island:
  regular:                # 常规型
    size: { w: 131, h: 44 }
    image: 32
    background: gray_6
    image_bg: white       # PNG 透明底
    material: solid_no_stroke
    use_case: 日常商品推荐
  operation:              # 运营型
    size: { w: 131, h: 44 }
    image: 32
    material: gradient_stroke_100 + frosted_85
    color_rule: 同频色 / 浅色背景+深色字 / 避免红配绿/纯黑白
    content: 运营图 + 利益文本 (gif)
    use_case: 运营会场推广
  promotion:              # 大促型
    size: { w: 144, h: 52 }
    image: 34
    material: gradient_stroke_0_60 + irregular_backplate
    color_rule: 同频色 / 浅色背景+深色字 / 避免红配绿/纯黑白
    content: 运营图 + 利益文本 (gif)
    use_case: 重点大促活动
  forbidden_zone: 红色区域禁止出现任何元素 (三型通用)
  offset_safe_bottom: 4   # DP
  on_expand:
    selected_background: 消失
    agent_inflate: 28     # DP (从默认 16 扩到 28)

agent:                    # Joy Agent (仅 agent_combo 形态)
  size: 52                # DP, 52x52
  offset_bottom: 17       # DP
  inflate_default: 16     # DP, 向外抽缩
  inflate_with_island: 28 # DP
  bubble:
    offset_bottom: 8      # DP, 距 Agent 模块
    offset_right: 16      # DP, 距页边距
    max_chars: 18         # 汉字
    animation: 缓出向上弹出
  click_action: 进入对话中心场景弹层

material:                 # 底导背景, 章节 05
  ios_26_plus: liquid-glass
  android_or_legacy_ios: frosted-glass

typography:
  default_label: pingfang_regular/font_size_10_400
  selected_label: pingfang_semibold/font_size_10_600
  island_primary: pingfang_semibold/font_size_14_600    # 行高 20
  island_secondary: pingfang_semibold/font_size_14_600  # 行高 20
  island_small: pingfang_medium/font_size_10_500        # 行高 14
  island_promo_emphasis: zhenghei_bold/font_size_14_600

events:
  on_tab_click: 切换整页内容
  on_agent_click: 进入对话中心场景弹层
  on_island_click: TODO        # 待设计师 / PM 确认行为
  on_island_dismiss: TODO      # 灵动岛消失行为 (timeout / user-dismiss / route-change)
```

## 多端适配

> 章节 05 节点 `312:52979`，1426×1678

| 端 / OS 版本 | 底导材质 | 图示 |
|---|---|---|
| iOS 26+ | **液态玻璃** (liquid-glass) | 图 1 |
| Android / iOS 26 以下 | **毛玻璃** (frosted-glass) fallback | 图 2 |

### 章节 05 多端适配原文

> 底导版本适配：iOS 26 / Android 版本适配
>
> a. iOS 26 版本：26 以上版本，使用**液态玻璃材质**，见图 1；
>
> b. Android / iOS 老系统：不支持液态玻璃，使用**毛玻璃材质**，见图 2。

---

## 章节 04 应用场景原文

> 节点 `312:47792`，1426×3864

⚠️ **本章节未抽到独立的 description 文本** —— Relay 内容主要是 INSTANCE 实例样本图（10 个 instance 引用，含 `组件-Joy Agent 形态 375×69`、`原子-Joy Agent 52×52`）和 230 个 frame 排布。无独立文字规范节点。

待办：
- 设计师补充应用场景叙述文字（不同 BU / 业务线 / 大促节奏下的 Tabbar 选型）
- 录入 Joy Agent 子组件 design.md（`horizontal/components-business/joy-agent`）
