---
file: spec
bundle_part_of: design.md       # 反向指回 index；relay_source 单点存储在 design.md
slug: tabbar
last_synced: "2026-05-18"

# v0.5 page-doc bundle: 视觉规范
# 来源：Relay 节点 312:46893 章节 01-02（设计原则 + 组件设计属性）
# v0.5.1 起 relay_source 单点存储在 design.md，本文件不重复

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
    - radius_base                 # 6  (atom: Radius_6) — 单行高度 28-36 组件
    - radius_l                    # 8  (atom: Radius_8) — 单行高度 40+ / 卡片
    - radius_xl                   # 12 (atom: Radius_12) — 顶导/吐司/灵动岛容器
    - radius_xxl                  # 16 (atom: Radius_16) — 弹层/底导悬浮容器

  spacing:
    # ⚠️ spacing token 未在 Relay variables 中绑定。
    # 章节 02-03 抽出的 25+ DP 标注详见下面"间距 / 布局"章节多张表格，
    # 待 V16 spacing token 表录入后回填映射。
    - "TODO: spacing tokens 待回填"

  materials:
    - liquid-glass                # iOS 26+ 液态玻璃材质（章节 05 图 1）
    - frosted-glass               # Android / iOS 老系统毛玻璃 fallback（章节 05 图 2）
    # ⚠️ materials 未通过 INSTANCE 引用，是文本描述。待 V16 materials token 表确立后回填
---

# 底部导航栏 · 视觉规范

> design.md → [index](./design.md) · 同 bundle: [variants](./variants.md) · [behaviors](./behaviors.md)
>
> ⚠️ **Relay 章节 02 跨文件提示**：本文件包含章节 02「基础布局」原文；章节 02 的「交互状态 / 招手形态 / Joy Agent 布局」三段在 [variants.md 章节 02 状态/招手/Agent 原文](./variants.md#章节-02-状态招手agent-原文)。读完本文章节 02 别忘记跳过去。

## 预览

![底部导航栏](./preview.png)

> ⚠️ **preview.png 未自动导出** —— Relay 节点高 18519px，PNG 二进制经 base64 编码超出脚本栈限制。请设计师从 Relay 桌面端选中节点 `312:46893` → 右键 Export → PNG（SCALE=1 整页 / 或分章节 5 张），保存到本目录的 `preview.png`。或采用分章节策略：`preview-01-principles.png` / `preview-02-properties.png` / ...

## 色彩

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

### Atom 层（章节 02/03 引用）

| 角色 | Atom | 来源 |
|---|---|---|
| 默认态图标 + 文本 | `gray_1` | 章节 02 交互状态 |
| 选中态图标 + 文本 | `jdred` | 章节 02 交互状态(图标走选中态专用彩色切图,`jdred` 已烘焙进切图,见 [_assets-cdn.md](./_assets-cdn.md)) |
| 选中态背景 | `gray_6` | 章节 02 交互状态（灵动岛展开期间消失） |
| 常规灵动岛背景 | `gray_6` | 章节 03 颜色应用 a |
| 常规灵动岛商品图底背景 | `white` | 章节 03 颜色应用 a，需 PNG 透明底素材 |

> ⚠️ **token-miss flag**：
> - `color_text_help` 当前 `#828794`，与 V16 gray.3 标准值待对齐
> - `gray_6` 与 `color_background_component` 数值 1 色阶差异（`#f0f2f7` vs `#f5f6fa`），建议设计组核对取舍
> - 运营/大促灵动岛颜色按章节 03 文字描述「推荐同频色 / 浅色背景 + 深色字」，无具体 token 绑定，需在 V16 token 系统增加 dynamic-color / case-by-case 标记

## 文字

| 用途 | Token | 字号/字重/行高 |
|---|---|---|
| 底导标签默认态 | `pingfang_regular/font_size_10_400` | 苹方 Regular 10/lh14（≤ 4 汉字） |
| 底导标签选中态 | `pingfang_semibold/font_size_10_600` | 苹方 Semibold 10/lh14 |
| 灵动岛主字号 | `pingfang_semibold/font_size_14_600` | 苹方 Semibold 14/lh20 |
| 灵动岛副字号 | `pingfang_semibold/font_size_14_600` | 苹方 Semibold 14/lh20 |
| 灵动岛小字号 | `pingfang_medium/font_size_10_500` | 苹方 Medium 10/lh14 |
| 大促灵动岛强调文字 | `zhenghei_bold/font_size_14_600` | 京东正黑 V2.3 Bold 14/lh20 |

## 圆角

| Token | Atom | px | 角色 |
|---|---|---|---|
| `radius_base` | `Radius_6` | 6 | 单行高度 28-36 组件 |
| `radius_l` | `Radius_8` | 8 | 单行高度 40+ / 卡片 |
| `radius_xl` | `Radius_12` | 12 | 顶导 / 吐司 / **灵动岛容器** |
| `radius_xxl` | `Radius_16` | 16 | 弹层 / **Tabbar 底导悬浮容器** |

> - **Tabbar 容器自身**：`radius_xxl` (16px)，参见 V16 [foundations/tokens/radius.md](../../../foundations/tokens/radius.md)「弹层/弹窗/底导」用法
> - **灵动岛容器**：`radius_xl` (12px)
> - 其它角色对应 px 待与设计师按章节确认

## 容器描边

> Relay 容器 fill 为 `background-blend-mode: normal, color-dodge` 双层结构，第二层 `color-dodge` 是液态玻璃边缘的 hairline 高光描边，导出 CSS 时丢层。

| 项 | 当前取值 | 状态 |
|---|---|---|
| Tabbar 容器描边 | 1 px 内描边高光，`box-shadow: inset 0 0 0 1px rgba(255,255,255,0.6)` | ⚠️ **估值** — 待设计师从 Relay 回填 `color-dodge` 层确切色值 / 宽度 / 不透明度 |

## 间距 / 布局

> v0.4 已从 Relay 章节 02/03 真实文本抽出以下 DP 标注。⚠️ spacing token 未在 Relay variables 绑定，token 名称列待 V16 spacing token 表建立后回填。

### 总高度结构

| 项 | DP | 备注 |
|---|---|---|
| 底导总高度 | 69 | 含 iOS 安全区 |
| 导航实际高度 | 52 | 不含安全区 |
| iOS 系统安全区 | 17 | **不可放置任何操作** |

### 宽度结构

| 项 | DP | 备注 |
|---|---|---|
| 常规底导宽度 | 351 | 章节 02 基础布局 a |
| Agent 组合底导宽度 | 319 | Agent + 底导基础布局 a |
| 距离 Agent 间距 | 8 | Agent 组合形态 |

### 坑位 / 内容

| 项 | DP | 备注 |
|---|---|---|
| 坑位基础尺寸 | 44×44 | 章节 02 默认态 |
| 坑位图标 | 20×20 | |
| 坑位文本框 | 44×14 | 字符与图标间距 4 |
| 内容距导航内间距 | 4 | |
| 内容高度 | 44 | |
| 各坑位左右间距 | -4 | 5 坑位时重叠负间距，以自动布局计算为准 |
| 营销态图片 | 38×38 | 章节 02 营销态 |

### 灵动岛

| 项 | DP | 备注 |
|---|---|---|
| 常规型灵动岛 | 131×44 | 日常 / 运营 |
| 大促型灵动岛 | 144×52 | |
| 灵动岛距底部安全区 | 4 | |
| 常规/运营灵动岛商品图 | 32 | |
| 大促灵动岛运营图 | 34 | |

### Joy Agent

| 项 | DP | 备注 |
|---|---|---|
| Agent 模块 | 52×52 | |
| 距底部距离 | 17 | |
| 默认抽缩 | 16 | 向外抽缩 |
| 灵动岛展开期抽缩 | 28 | 向外抽缩 |
| 招手气泡距 Agent 模块 | 8 | 底部间距 |
| 招手气泡距页边距 | 16 | 右侧 |
| 招手气泡最大字符 | 18 汉字 | |

### 招手位置 — 距图标 / 营销图偏移

> 数字本身是 spacing 规则（与"灵动岛距底部 4 DP"同性质），归属 spec.md 间距章节。各招手类型的语义/降级规则在 [variants.md 招手形态](./variants.md#招手形态维度)。

| 招手形态 | 距图标左 (DP) | 距图标底 (DP) | 距营销图左 (DP) | 距营销图底 (DP) | 字符限制 |
|---|---|---|---|---|---|
| 红点型 | 19 | 14 | 28 | 32 | — |
| 数字型 | 15 | 14 | 24 | 32 | — |
| 文字型 | 15 | 14 | 24 | 32 | **最多 4 字符** |
| 灵动岛展开型 | — | — | — | — | 灵动岛存在时降级红点型 |

## 材质

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

---

## 章节 01 设计原则原文

> 节点 `312:46895`，1426×304

> 位于屏幕底部，作为页面导航的最高层级，管控全局，点击切换整页内容；
>
> a. 分为常规、Agent 组合两种形态，左侧为 Agent 固定形态不可变，右侧 Tabbar 建议 2~5 个；
>
> b. Agent 为东东入口，点击进入对话中心场景弹层，模块上方存在招手引导，最多展示 18 个汉字；
>
> c. 营销资源位基础形态可结合红点飘新、数字飘新、招手等形式，其中消息模块存在灵动岛运营态，划分为日常、活动、大促灵动岛运营形式；
>
> d. 底导材质根据不同 OS 端、版本差异化使用，其中 iOS 26 以上建议适配液态背板，iOS 26 以下或 Android 适配毛玻璃或纯色背板。

## 章节 02 组件设计属性原文

> 节点 `312:46900`，1666×6124（基础布局部分；状态/招手/Agent 详见 [variants.md](./variants.md)）

### 章节 02 基础布局相关图示（图 1-7）

| # | 标号 | 上下文 |
|---|---|---|
| 1 | 图 1：基础布局 | 常规底导 + Agent 底导基础布局 |
| 2 | 图 2：5 坑位 | 5 坑位均分布局 |
| 3 | 图 3：4 坑位 | 4 坑位均分布局 |
| 4 | 图 4：3 坑位 | 3 坑位均分布局 |
| 5 | 图 5：2 坑位 | 2 坑位均分布局 |
| 6 | 图 6：日常/运营灵动岛坑位 | 131×44 灵动岛 |
| 7 | 图 7：大促灵动岛坑位 | 144×52 灵动岛 |

> 章节 02 状态/招手/Agent 相关图 8-16 在 [variants.md 章节 02 图示](./variants.md#章节-02-图示--局部状态招手agent)。

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
