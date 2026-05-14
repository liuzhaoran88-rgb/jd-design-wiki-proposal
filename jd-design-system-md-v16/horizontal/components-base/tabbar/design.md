---
file: design
level: component-base
bg: horizontal
slug: tabbar
name_zh: "底部导航栏"
name_en: "Tabbar"

owner: "@xushui2018"
contributors: []
status: draft
version: "0.2"
last_synced: "2026-05-13"

# skill 自动推断的字段。如不对，请改 frontmatter + mv 文件夹后告知。
# ⚠️ 实际节点 312:46893 是 page-doc 规范文档（1666×18519，含 5 大章节）。
#    skill v0.4 已支持 page-doc 模式（章节切分 + text bucket 分类），
#    仍套 L1 component-base 模板，但加 `## 设计规范细节（按章节）` 段。
auto_detected:
  level: component-base
  bg: horizontal
  slug: "tabbar"
  page_doc: true  # v0.4 自动判定（root.height > 5000）

relay_source:
  file_id: "2029484645871009793"
  page_id: "31:1"
  node_id: "312:46893"
  node_name: "导航类-底部导航栏设计规范"
  node_type: FRAME
  bounds: { w: 1666, h: 18519 }
  url: "https://relay.jd.com/file/design?id=2029484645871009793&page_id=31%3A1&node_id=312%3A46893"

references:
  uses_components:
    - horizontal/components-business/joy-agent    # ⚠️ Joy Agent 形态在 04 章节出现 2 个 INSTANCE 引用（"组件-Joy Agent 形态" 375×69、"原子-Joy Agent" 52×52），子组件尚未录入 design.md

  uses_tokens:
    colors:
      - color_title                 # #171a26 — 一级文字 / 标题
      - color_text                  # #3d414d — 二级文字
      - color_text_help             # #828794 — 三级辅助文字 ⚠️ V16 标准 gray.3 hex 待与设计师核对
      - color_background            # #f2f3f7 — 页面背景
      - color_background_component  # #f5f6fa — 组件/容器背景（灵动岛常规底色）
      - color_border                # #00000014 — 边框
      - color_primary               # #ff0f23 — 主色（红点 / 选中态）
      - color_primary_text          # #ffffff — 主色背景下文字
      - color_primary_pressed       # #e53029 — 主色按下态
      - color_primary_specialdisabled # #ffadbe — 主色特殊禁用
      - color_service_text          # #b5691a — 服务金文字
      # atom 层（按章节 02/03 原稿引用）：
      - jdred                       # 章节 02 选中态色（图标 + 文本）
      - jdred_6                     # #ff0f23
      - gray_1                      # 章节 02 默认态色（图标 + 文本）
      - gray_6                      # #f0f2f7 — 灵动岛常规底色 + 选中背景
      - gray_8                      # #11141a33 — 透明叠加
      - gray_9                      # #11141a14
      - gray_10                     # #11141a05
      - white                       # #ffffff — 常规灵动岛商品图底部背景
      - black                       # #000000

    typography:
      # 底导标签（章节 02 默认/选中态文字）：
      - pingfang_regular/font_size_10_400      # 苹方 Regular 10/lh14 — 底导默认态（≤ 4 汉字）
      - pingfang_semibold/font_size_10_600     # 苹方 Semibold 10/lh14 — 底导选中态
      # 灵动岛（章节 03 字号规则）：
      - pingfang_semibold/font_size_14_600     # 苹方 Semibold 14/lh20 — 灵动岛主字号 + 副字号
      - pingfang_medium/font_size_10_500       # 苹方 Medium 10/lh14 — 灵动岛小字号
      - zhenghei_bold/font_size_14_600         # 京东正黑 Bold 14/lh20 — 大促灵动岛强调

    radius:
      # token 名（V16 T-shirt size）+ atom 名（V16 数字尺寸，括号内）
      - radius_base                 # 6  (atom: Radius_6) — 单行高度 28-36 组件
      - radius_l                    # 8  (atom: Radius_8) — 单行高度 40+ / 卡片
      - radius_xl                   # 12 (atom: Radius_12) — 顶导/吐司/灵动岛容器
      - radius_xxl                  # 16 (atom: Radius_16) — 弹层/底导悬浮容器

    spacing:
      # ⚠️ spacing token 未在 Relay variables 中绑定。v0.4 已从 Relay 章节 02/03 真实文本抽出以下 DP 标注，
      # 待 V16 spacing token 表录入后回填映射：
      # - 总高: 69 / 导航: 52 / iOS 安全区: 17
      # - 底导宽: 常规 351 / Agent 组合 319（距 Agent 8 DP）
      # - 坑位: 44×44 / 图标: 20×20 / 文本框: 44×14 / 字符-图标间距: 4
      # - 营销态图: 38×38
      # - 灵动岛: 常规/运营 131×44 / 大促 144×52 / 距底部安全区 4
      # - 灵动岛商品图: 常规 32 / 大促 34
      # - Joy Agent: 52×52 / 距底部 17 / 抽缩 16（默认）/ 28（灵动岛展开）/ 招手气泡距 Agent 8 / 距页边距 16
      # - 招手位置: 红点 19/14 / 数字+文字 15/14 / 营销图 28-32
      - "TODO: spacing tokens 待回填"

    materials:
      - liquid-glass                # iOS 26+ 液态玻璃材质（章节 05 图 1）
      - frosted-glass               # Android / iOS 老系统毛玻璃 fallback（章节 05 图 2）
      # ⚠️ materials 未通过 INSTANCE 引用，是文本描述。待 V16 materials token 表确立后回填

used_by: []
---

# 底部导航栏 · Tabbar

> 自动同步 2026-05-13 · skill v0.4 (page-doc 模式) · Relay [`312:46893`](https://relay.jd.com/file/design?id=2029484645871009793&page_id=31%3A1&node_id=312%3A46893)

## 一句话定义

> ⚠️ **草稿，待设计师 review**

底部导航栏（Tabbar）是 JD APP 屏幕底部的全局导航组件，作为页面导航的最高层级管控全局，点击切换整页内容。分**常规**和**Joy Agent 组合**两种形态，支持 2~5 个常规坑位 + 灵动岛运营资源位，并按 OS 端/版本差异化适配材质（iOS 26+ 液态玻璃 / 老系统毛玻璃）。

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

## 视觉

### 预览

![底部导航栏](./preview.png)

> ⚠️ **preview.png 未自动导出** —— Relay 节点高 18519px，PNG 二进制经 base64 编码超出脚本栈限制。请设计师从 Relay 桌面端选中节点 `312:46893` → 右键 Export → PNG（SCALE=1 整页 / 或分章节 5 张），保存到本目录的 `preview.png`。或采用分章节策略：`preview-01-principles.png` / `preview-02-properties.png` / ...

### 色彩

| 用途 | Token | 实际 hex |
|---|---|---|
| 标题文字（章节标题 / 主信息） | `color_title` | `#171a26` |
| 正文 / 二级文字 | `color_text` | `#3d414d` |
| 辅助 / 三级文字 | `color_text_help` | `#828794` ⚠️ |
| 页面背景 | `color_background` | `#f2f3f7` |
| 组件容器背景 / 灵动岛常规底 | `color_background_component` | `#f5f6fa` |
| 灵动岛常规底（atom 层） | `gray_6` | `#f0f2f7` ⚠️ 与 `color_background_component` 数值不一致，疑命名漂移 |
| 边框 | `color_border` | `#00000014` |
| 主色 / 红点 / 选中态 | `color_primary` | `#ff0f23` |
| 主色文字 / 反白 | `color_primary_text` | `#ffffff` |
| 主色按下态 | `color_primary_pressed` | `#e53029` |
| 主色特殊禁用 | `color_primary_specialdisabled` | `#ffadbe` |
| 服务金文字（PLUS 等） | `color_service_text` | `#b5691a` |

#### Atom 层（章节 02/03 引用）

| 角色 | Atom | 来源 |
|---|---|---|
| 默认态图标 + 文本 | `gray_1` | 章节 02 交互状态 |
| 选中态图标 + 文本 | `jdred` | 章节 02 交互状态 |
| 选中态背景 | `gray_6` | 章节 02 交互状态（灵动岛展开期间消失） |
| 常规灵动岛背景 | `gray_6` | 章节 03 颜色应用 a |
| 常规灵动岛商品图底背景 | `white` | 章节 03 颜色应用 a，需 PNG 透明底素材 |

> ⚠️ **token-miss flag**：
> - `color_text_help` 当前 `#828794`，与 V16 gray.3 标准值待对齐
> - `gray_6` 与 `color_background_component` 数值 1 色阶差异（`#f0f2f7` vs `#f5f6fa`），建议设计组核对取舍
> - 运营/大促灵动岛颜色按章节 03 文字描述「推荐同频色 / 浅色背景 + 深色字」，无具体 token 绑定，需在 V16 token 系统增加 dynamic-color / case-by-case 标记

### 文字

| 用途 | Token | 字号/字重/行高 |
|---|---|---|
| 底导标签默认态 | `pingfang_regular/font_size_10_400` | 苹方 Regular 10/lh14（≤ 4 汉字） |
| 底导标签选中态 | `pingfang_semibold/font_size_10_600` | 苹方 Semibold 10/lh14 |
| 灵动岛主字号 | `pingfang_semibold/font_size_14_600` | 苹方 Semibold 14/lh20 |
| 灵动岛副字号 | `pingfang_semibold/font_size_14_600` | 苹方 Semibold 14/lh20 |
| 灵动岛小字号 | `pingfang_medium/font_size_10_500` | 苹方 Medium 10/lh14 |
| 大促灵动岛强调文字 | `zhenghei_bold/font_size_14_600` | 京东正黑 V2.3 Bold 14/lh20 |

### 圆角

| Token | Atom | px | 角色 |
|---|---|---|---|
| `radius_base` | `Radius_6` | 6 | 单行高度 28-36 组件 |
| `radius_l` | `Radius_8` | 8 | 单行高度 40+ / 卡片 |
| `radius_xl` | `Radius_12` | 12 | 顶导 / 吐司 / **灵动岛容器** |
| `radius_xxl` | `Radius_16` | 16 | 弹层 / 底导悬浮容器 |

> 灵动岛容器使用 `radius_xl` (12px)；其它角色对应 px 待与设计师按章节确认。

### 间距 / 布局

> v0.4 已从 Relay 章节 02/03 真实文本抽出以下 DP 标注。⚠️ spacing token 未在 Relay variables 绑定，token 名称列待 V16 spacing token 表建立后回填。

#### 总高度结构

| 项 | DP | 备注 |
|---|---|---|
| 底导总高度 | 69 | 含 iOS 安全区 |
| 导航实际高度 | 52 | 不含安全区 |
| iOS 系统安全区 | 17 | **不可放置任何操作** |

#### 宽度结构

| 项 | DP | 备注 |
|---|---|---|
| 常规底导宽度 | 351 | 章节 02 基础布局 a |
| Agent 组合底导宽度 | 319 | Agent + 底导基础布局 a |
| 距离 Agent 间距 | 8 | Agent 组合形态 |

#### 坑位 / 内容

| 项 | DP | 备注 |
|---|---|---|
| 坑位基础尺寸 | 44×44 | 章节 02 默认态 |
| 坑位图标 | 20×20 | |
| 坑位文本框 | 44×14 | 字符与图标间距 4 |
| 内容距导航内间距 | 4 | |
| 内容高度 | 44 | |
| 各坑位左右间距 | -4 | 5 坑位时重叠负间距，以自动布局计算为准 |
| 营销态图片 | 38×38 | 章节 02 营销态 |

#### 灵动岛

| 项 | DP | 备注 |
|---|---|---|
| 常规型灵动岛 | 131×44 | 日常 / 运营 |
| 大促型灵动岛 | 144×52 | |
| 灵动岛距底部安全区 | 4 | |
| 常规/运营灵动岛商品图 | 32 | |
| 大促灵动岛运营图 | 34 | |

#### Joy Agent

| 项 | DP | 备注 |
|---|---|---|
| Agent 模块 | 52×52 | |
| 距底部距离 | 17 | |
| 默认抽缩 | 16 | 向外抽缩 |
| 灵动岛展开期抽缩 | 28 | 向外抽缩 |
| 招手气泡距 Agent 模块 | 8 | 底部间距 |
| 招手气泡距页边距 | 16 | 右侧 |
| 招手气泡最大字符 | 18 汉字 | |

#### 招手位置（距图标 / 营销图）

| 招手形态 | 距图标左 | 距图标底 | 距营销图左 | 距营销图底 |
|---|---|---|---|---|
| 红点型 | 19 | 14 | 28 | 32 |
| 数字型 | 15 | 14 | 24 | 32 |
| 文字型（≤ 4 字符） | 15 | 14 | 24 | 32 |
| 灵动岛展开型 | 灵动岛展开时降级为红点型，灵动岛消失后恢复 | | | |

### 材质

按章节 03 + 05 真实文本：

| 灵动岛形态 | 材质规则 | 来源 |
|---|---|---|
| 常规灵动岛 | 纯色背景 `gray_6` (#f0f2f7)，无描边 | 章节 03 材质 a |
| 运营灵动岛 | 线性渐变描边 100%，背板渐变描边 100%，85% 叠加灰阶背景 | 章节 03 材质 b |
| 大促灵动岛 | 线性渐变描边 0~60%，背板渐变描边 0~66.36%，85% 叠加灰阶背景 | 章节 03 材质 c |

| 端 / OS 版本 | 底导材质 | 来源 |
|---|---|---|
| iOS 26+ | 液态玻璃（liquid-glass） | 章节 05 图 1 |
| Android / iOS 26 以下 | 毛玻璃（frosted-glass）fallback | 章节 05 图 2 |

> ⚠️ materials 未通过 INSTANCE 绑定，仅文字描述。等 V16 materials token 表建立后回填。

## 交互

> ⚠️ **草稿，待设计师 / 工程师 review**

- **基础切换**：点击坑位切换整页内容（章节 01 设计原则）
- **状态切换**：默认态 ↔ 选中态（按下后图标 + 文本变 jdred、背景变 gray_6）；营销态可与红点/数字/文字招手叠加，但 38×38 图片仅可替换不可改其它样式
- **灵动岛展开**：灵动岛展开期间，对应坑位选中态背景消失；同时 Joy Agent（若存在）向外抽缩从 16 → 28 DP
- **招手降级**：底部存在灵动岛时，文字/数字招手默认收起为红点型，灵动岛消失后恢复
- **Joy Agent 招手气泡**：缓出向上弹出，最多展示 18 个汉字（超出截断或翻页待确认）
- **Joy Agent 点击**：进入对话中心场景弹层

## 变体 Variants

### 形态维度

- **常规底导**：标准底部导航，2~5 个坑位 + 可选灵动岛
- **Joy Agent 组合底导**：左侧 Joy Agent 52×52 固定形态不可变，右侧 Tabbar 2~5 坑位 + 可选灵动岛

### 坑位数维度（章节 02 图 2-5）

- **5 坑位**（图 2）：均分布局，各坑位左右间距 -4 DP（重叠负间距）
- **4 坑位**（图 3）：均分布局
- **3 坑位**（图 4）：均分布局
- **2 坑位**（图 5）：均分布局

### 灵动岛运营维度（章节 03）

- **常规型**（131×44 DP，图 1-2）：商品图 32 DP + 基础文本，背景 `gray_6` 纯色，适用日常商品推荐
- **运营型**（131×44 DP，图 3-4）：运营图 32 DP + 利益文本 gif，渐变描边 100% + 85% 叠加灰阶，适用会场推广
- **大促型**（144×52 DP，图 5-6）：运营图 34 DP + 利益文本 gif，渐变描边 0-60% + 异型背板，适用重点大促

### 交互状态维度（章节 02 交互状态标注）

- **默认态**：图标 + 文本 `gray_1`
- **选中态**：图标 + 文本 `jdred`，背景 `gray_6`（灵动岛展开期间背景消失）
- **营销态**：替换 38×38 DP 图片，其它样式不可改

### 招手形态维度（章节 02 招手形态标注）

- **红点型**（图 1）：距图标左 19 / 底 14 DP；距营销图左 28 / 底 32 DP
- **数字型**（图 2）：距图标左 15 / 底 14 DP；距营销图左 24 / 底 32 DP
- **文字型**（图 3）：同数字型，**最多 4 个字符**
- **灵动岛展开型**（图 4）：灵动岛存在时降级为红点

## 设计规范细节（按章节）

> v0.4 page-doc 模式输出。来源为 Relay 节点 312:46893 的 5 个直接子章节 frame。每节摘录 chapter_title + 真实 description（精确还原原文） + figure 标号 + 章节内 dont 规则（已聚合到下面 ## Donts 段）。

### 章节 01 设计原则（`312:46895`，1426×304）

> 位于屏幕底部，作为页面导航的最高层级，管控全局，点击切换整页内容；
>
> a. 分为常规、Agent 组合两种形态，左侧为 Agent 固定形态不可变，右侧 Tabbar 建议 2~5 个；
>
> b. Agent 为东东入口，点击进入对话中心场景弹层，模块上方存在招手引导，最多展示 18 个汉字；
>
> c. 营销资源位基础形态可结合红点飘新、数字飘新、招手等形式，其中消息模块存在灵动岛运营态，划分为日常、活动、大促灵动岛运营形式；
>
> d. 底导材质根据不同 OS 端、版本差异化使用，其中 iOS 26 以上建议适配液态背板，iOS 26 以下或 Android 适配毛玻璃或纯色背板。

### 章节 02 组件设计属性（`312:46900`，1666×6124）

#### 图示清单

| # | 标号 | 上下文 |
|---|---|---|
| 1 | 图 1：基础布局 | 常规底导 + Agent 底导基础布局 |
| 2 | 图 2：5 坑位 | 5 坑位均分布局 |
| 3 | 图 3：4 坑位 | 4 坑位均分布局 |
| 4 | 图 4：3 坑位 | 3 坑位均分布局 |
| 5 | 图 5：2 坑位 | 2 坑位均分布局 |
| 6 | 图 6：日常/运营灵动岛坑位 | 131×44 灵动岛 |
| 7 | 图 7：大促灵动岛坑位 | 144×52 灵动岛 |
| 8 | 图 1：默认态（52×52） | Joy Agent 默认态 |
| 9 | 图 2：选中态 | 坑位选中态 |
| 10 | 图 3：营销态（实际图片 38×38） | 营销态坑位 |
| 11 | 图 1：红点型 | 红点招手 |
| 12 | 图 2：数字型 | 数字招手 |
| 13 | 图 3：文字型 | 文字招手（最大 4 字符） |
| 14 | 图 4：灵动岛默认收起 | 招手降级 |
| 15 | 图 2：气泡提示（最大字符数 18 个） | Joy Agent 招手气泡 |
| 16 | 图 3：灵动岛状态 | Joy Agent 灵动岛态 |

#### 核心规范文字（原文还原）

**常规底导布局属性：默认 2~5 坑位布局、灵动岛布局**

> a. 基础布局：底导总高 69 DP，导航实际高度 52 DP，iOS 系统安全区 17 DP，**不可放置任何操作**，如图 1；底导宽度 351 DP，内容距导航内间距 4 DP，内容高度 44 DP，如图 2；
>
> b. 5 坑位布局：以基准尺寸均分布局，以自动布局计算为准，内容居中展示，各内容左右间距为 -4 DP，如图 2；
>
> c. 4 坑位布局：以基准尺寸均分布局，以自动布局计算为准，内容居中展示，如图 3；
>
> d. 3 坑位布局：以基准尺寸均分布局，以自动布局计算为准，内容居中展示，如图 4；
>
> e. 2 坑位布局：以基准尺寸均分布局，以自动布局计算为准，内容居中展示，如图 5；
>
> f. 灵动岛布局：资源位固定范围宽度为 131 DP，日常/运营类高度为 44 DP，如图 6，大促类宽度 144 DP，高度为 52 DP，距离底部安全区域 4 DP，灵动岛展开期间，模块选中态背景消失，其余模块尺寸均分布局，以自动布局计算为准，内容居中展示，如图 7。

**Agent + 底导布局属性：默认 2~5 坑位布局、灵动岛布局**

> a. 基础布局：底导总高 69 DP，其中导航实际高度 52 DP，iOS 系统安全区 17 DP，**不可放置任何操作**，如图 1；底导宽度 319 DP，距离 Agent 间距 8 DP，内容距导航内间距 4 DP，内容高度 44 DP，距离安全区间距 4 DP，如图 2；
>
> b~e. 坑位布局同常规形态（5/4/3/2 坑位均分）；
>
> f. 灵动岛布局：同常规形态。

**交互状态标注：默认态、选中态、营销态**

> a. 默认态：坑位尺寸 44×44 DP，图标尺寸 20×20；文本框 44×14 DP，字符与图标间距为 4 DP，使用苹方 Regular/font_size_10_400，**最多展示 4 个汉字**；图标与文本色值为灰阶/`gray_1`；如图 1；
>
> b. 选中态：布局、图标、文本与默认态一致，图标与文本色值为品牌色/`jdred`，选中背景色值为灰阶/`gray_6`；灵动岛展开期间，模块选中态背景消失；
>
> c. 营销态：未点击的默认营销态，图片尺寸为 38×38 DP，**仅可替换图片，不可做其他样式更改**。

**招手形态标注：红点型、数字型、文字型、灵动岛展开型**

> a. 红点型：距离图标左侧 19 DP、底部 14 DP；距离营销图片左侧 28 DP，底部 32 DP，如图 1；
>
> b. 数字型：距离图标左侧 15 DP、底部 14 DP；距离营销图片左侧 24 DP，底部 32 DP，如图 2；
>
> c. 文字型：距离图标左侧 15 DP、底部 14 DP；距离营销图片左侧 24 DP，底部 32 DP，底导逛一逛**支持最大四个字符**，如图 3；
>
> d. 灵动岛展开型：若底部存在灵动岛，默认收起为红点型，待灵动岛消失后恢复，如图 4。

**Joy Agent：基础布局、交互状态、有/无灵动岛**

> a. 基础布局：Agent 模块为 52×52 DP，根据终端设备向外抽缩 16 DP，距离底部距离为 17 DP，如图 1；
>
> b. 交互状态：模块上方存在招手引导，**最多展示 18 个汉字**，气泡缓出向上弹出，气泡底部距离 Agent 模块 8 DP，右侧距离页边距 16 DP，如图 2；
>
> c. 有/无灵动岛：灵动岛展开期间，Agent 向外抽缩 28 DP，见图 3。

### 章节 03 灵动岛运营资源位（`312:47479`，1426×5589）

#### 图示清单

| # | 标号 | 上下文 |
|---|---|---|
| 1 | 图 1：常规灵动岛布局 | 131×44 |
| 2 | 图 2：常规灵动岛字号取值 | 主/副 14pt + 小 10pt |
| 3 | 图 3：运营灵动岛布局 | 131×44 |
| 4 | 图 4：运营灵动岛字号取值 | gif 素材字号 |
| 5 | 图 5：大促灵动岛布局 | 144×52，异型背板 |
| 6 | 图 6：大促灵动岛布局 | 续 |
| 7 | 图 1：常规灵动岛色值 | gray_6 + white 商品图底 |
| 8 | 图 2：运营灵动岛推荐同频色 | 浅色背景 + 深色字 |
| 9 | 图 3：大促灵动岛推荐同频色 | 浅色背景 + 深色字 |
| 10 | 图 1：常规灵动岛材质 | 纯色无描边 |
| 11 | 图 2：运营灵动岛材质 | 渐变描边 100% + 85% 叠加 |
| 12 | 图 3：大促灵动岛材质 | 渐变描边 0-60% + 85% 叠加 |

#### 核心规范文字（原文还原）

**灵动岛布局属性：常规型、运营型、大促型**

> a. 常规型灵动岛：坑位尺寸 131×44 DP，适用于常规商品推荐信息，**红色区域禁止出现任何元素**，见图 1；商品图与基础文本构成，商品图尺寸 32 DP，支持文本可配置，见图 2；
>
> b. 运营型灵动岛：坑位尺寸 131×44 DP，适用于运营会场推广信息，**红色区域禁止出现任何元素**，见图 3；运营图与利益文本构成，运营图尺寸 32 DP，文本按照规范字号设计输出 gif 素材，见图 4；
>
> c. 大促型灵动岛：坑位尺寸 144×52 DP，适用于重点大促活动信息，**红色区域禁止出现任何元素**，支持异型背板，见图 5；运营图与利益文本构成，运营图尺寸 34 DP，文本按照规范字号设计输出 gif 素材，见图 6。

**字号规则**

> - 主字号：14pt / PingFang Semibold / 行高 20 DP
> - 副字号：14pt / PingFang Semibold / 行高 20 DP
> - 小字号：10pt / PingFang Medium / 行高 14 DP

**颜色应用：常规型、运营型、大促型**

> a. 常规灵动岛：背景色值为灰阶/`gray_6`，商品图底部背景为灰阶/`white`，**需上传 PNG 透明底素材**，见图 1；
>
> b. 运营灵动岛：色相不做限制，**推荐使用同频色**，但**必须使用浅色系背景 + 深色字**，整体色调柔和，搭配合理，**避免使用红配绿/纯黑/白等不适合色彩**，见图 2；
>
> c. 大促灵动岛：色相不做限制，推荐使用同频色，但必须使用浅色系背景 + 深色字，整体色调柔和，搭配合理，避免使用红配绿/纯黑/白等不适合色彩，见图 3。

**材质应用：常规型、运营型、大促型**

> a. 常规灵动岛：纯色背景 `gray_6`，无描边，见图 1；
>
> b. 运营灵动岛：线性渐变描边区域 100%，背板渐变描边区域 100%，由 85% 叠加灰阶背景组成，见图 2；
>
> c. 大促灵动岛：线性渐变描边区域 0~60%，背板渐变描边区域 0~66.36%，由 85% 叠加灰阶背景组成，见图 3。

### 章节 04 应用场景（`312:47792`，1426×3864）

⚠️ **本章节未抽到独立的 description 文本** —— Relay 内容主要是 INSTANCE 实例样本图（10 个 instance 引用，含 `组件-Joy Agent 形态 375×69`、`原子-Joy Agent 52×52`）和 230 个 frame 排布。无独立文字规范节点。

待办：
- 设计师补充应用场景叙述文字（不同 BU / 业务线 / 大促节奏下的 Tabbar 选型）
- 录入 Joy Agent 子组件 design.md（`horizontal/components-business/joy-agent`）

### 章节 05 多端适配（`312:52979`，1426×1678）

#### 图示清单

| # | 标号 | 上下文 |
|---|---|---|
| 1 | 图 1：iOS 26 以上版本液态玻璃适配 | liquid-glass |
| 2 | 图 2：Android / iOS 老系统毛玻璃 | frosted-glass |

#### 核心规范文字（原文还原）

> 底导版本适配：iOS 26 / Android 版本适配
>
> a. iOS 26 版本：26 以上版本，使用**液态玻璃材质**，见图 1；
>
> b. Android / iOS 老系统：不支持液态玻璃，使用**毛玻璃材质**，见图 2。

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

## 关联

- 此组件归属：`level: component-base`（⚠️ 实际是 page-doc，模板套用 + v0.4 章节细分段），`bg: horizontal`
- V16 Foundation 引用：见 frontmatter `references.uses_tokens`
- 父级页面：所有挂载 Tabbar 的应用页面（待 L3 录入后由 skill 反向填 `used_by`）
- 关联子组件：Joy Agent（`horizontal/components-business/joy-agent`，待录入，见 issue #18 follow-up）

## Relay 原稿章节大纲

| # | Relay 章节标题 | 节点 ID | 高度 (px) | 内容要点 |
|---|---|---|---|---|
| 0 | 设计系统文档头部 | `312:46894` | 240 | banner，跟仓库 design.html 顶部同源 (6:229 风格) |
| 01 | 设计原则 | `312:46895` | 304 | 位置 / 层级 / 常规 + Agent 组合两形态 / 招手 / 灵动岛 / 端适配 |
| 02 | 组件设计属性 | `312:46900` | 6124 | 常规 + Agent 底导布局 / 2-5 坑位 / 默认+选中+营销 三态 / 4 型招手 / Joy Agent 布局 |
| 03 | 灵动岛运营资源位 | `312:47479` | 5589 | 常规 / 运营 / 大促 三型灵动岛 · 布局 · 字号 · 颜色 · 材质 |
| 04 | 应用场景 | `312:47792` | 3864 | Joy Agent 形态搭配（2 个 INSTANCE 引用）/ 230 frame 场景排布 |
| 05 | 多端适配 | `312:52979` | 1678 | iOS 26+ 液态玻璃 / Android·iOS 老系统毛玻璃 |

## 变更记录

| 时间 | 操作 | 来源 | 备注 |
|---|---|---|---|
| 2026-05-13 | 创建 | skill v0.1 手作 / page-doc 模式 | 自动抽 token + Relay 5 章节大纲 / 5 处 TODO / 6 处 ⚠️ |
| 2026-05-13 | v0.4 升级 | skill v0.4（page-doc）+ get_design_context 真文本 | 修正 spacing 数据（69/52/17 验证为对）/ 补章节 02 全量布局/坑位/状态/招手/Agent 尺寸 / 补章节 03 三型灵动岛字号/颜色/材质 / 自动收 Donts 9 条 / AI Schema 写完整草稿 / 一句话定义+应用场景+交互 B 类草稿待设计师 review |

---

## 本次自动同步发现的待办

1. **preview.png 未导出** —— 节点高 18519px 超 base64 编码栈限。设计师手动从 Relay export，建议分章节 5 张
2. **v0.4 章节切分仍是单 md** —— page-doc 模式深化了内容，但仍未拆为 multi-md bundle（spec.md / variants.md / behaviors.md）。是否升级 v0.5 拆分见 issue #18
3. **gray_6 与 color_background_component 数值漂移** —— `#f0f2f7` vs `#f5f6fa` 一色阶差，疑命名空间冲突，待设计组核对
4. **color_text_help 当前 `#828794`** —— 与 V16 gray.3 标准值待对齐
5. **spacing token 未绑定** —— 章节 02/03 已抽出 25+ 个 DP 标注（69/52/17/351/319/44/20/14/4/38/131/44/144/52/32/34/19/15/28/24/32 等），等 V16 spacing token 表确立后回填映射
6. **materials 仅文字描述** —— liquid-glass / frosted-glass / gradient_stroke_100 / gradient_stroke_0_60 + 异型背板 等未挂 INSTANCE，等 V16 materials token 表建立后回填
7. **uses_components: joy-agent 尚未录入** —— frontmatter 已留位，章节 04 有 2 个 INSTANCE 引用，子组件 design.md 待录入
8. **运营/大促灵动岛"同频色"无 token 绑定** —— 章节 03 颜色应用规则是 case-by-case 动态色，无单一 token 可绑，建议 V16 token 系统增加 dynamic-color / contextual-color 类别
9. **章节 04 无独立 description 文本** —— 仅 INSTANCE 实例样本，设计师需补充应用场景叙述
10. **B 类草稿待 review** —— `## 一句话定义` / `## 应用场景` / `## 交互` 由 skill 基于章节 01 文本拟初稿（标 ⚠️ 草稿），设计师需修订
11. **AI Schema events 字段缺 island 行为** —— `on_island_click` / `on_island_dismiss` 行为未在 Relay 原稿明确，需设计师 + PM 确认
