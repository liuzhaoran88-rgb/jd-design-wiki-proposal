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
version: "0.1"
last_synced: "2026-05-13"

# skill 自动推断的字段。如不对，请改 frontmatter + mv 文件夹后告知。
auto_detected:
  level: component-base  # ⚠️ 实际节点 312:46893 是 page-level 规范文档（1666×18519，含 5 大章节），不是单一组件实例。skill v0.1 仅支持 L1 component-base 模板，本次按 L1 套；正文按 Relay 5 章节实际结构展开。建议后续设计师 review 是否拆为 multi-md bundle（spec.md / variants.md / behaviors.md）
  bg: horizontal
  slug: "tabbar"
  page_doc: true  # 自定义 flag：标记此 design.md 来源是规范文档页，非单一组件 INSTANCE

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
    - horizontal/components-business/joy-agent    # ⚠️ Joy Agent 形态在 04 章节出现 2 个 INSTANCE 引用，子组件尚未录入 design.md，待后续

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
      # atom 层：
      - jdred_6                     # #ff0f23
      - gray_6                      # #f0f2f7 — 灵动岛常规底色（注：与 color_background_component 数值有 ~1 色阶差，待与设计师核对，可能是 atom 层与 token 层同义但漂移）
      - gray_8                      # #11141a33 — 透明叠加
      - gray_9                      # #11141a14
      - gray_10                     # #11141a05
      - white                       # #ffffff
      - black                       # #000000

    typography:
      - pingfang_regular/font_size_10_400      # PingFang SC Regular 10/lh14 — 底导标签默认
      - pingfang_semibold/font_size_10_600     # PingFang SC Semibold 10/lh14 — 底导标签选中
      - pingfang_semibold/font_size_14_600     # PingFang SC Semibold 14/lh22 — 灵动岛文字
      - zhenghei_bold/font_size_14_600         # 京东正黑 Bold 14/lh22 — 大促灵动岛强调文字

    radius:
      - Radius_6                    # 6
      - Radius_8                    # 8
      - Radius_12                   # 12 — 灵动岛容器圆角
      - Radius_16                   # 16

    spacing:
      # ⚠️ spacing token 未在 variables 中绑定。Relay 设计稿提到的 DP 单位：
      # - 底导总高 69DP, 导航高 52DP, iOS 安全区 17DP
      # - 灵动岛常规 131×44DP
      # 待 V16 spacing token 表录入后回填映射
      - TODO: spacing tokens 待回填

    materials:
      - liquid-glass                # iOS 26+ 液态玻璃材质（05 多端适配章节）
      - frosted-glass               # Android / iOS 老系统毛玻璃 fallback
      # ⚠️ materials 未通过 INSTANCE 引用，是文本描述。待 V16 materials token 表确立后回填

used_by: []
---

# 底部导航栏 · Tabbar

> 自动同步 2026-05-13 · skill v0.1 (手作 / page-doc 模式) · Relay [`312:46893`](https://relay.jd.com/file/design?id=2029484645871009793&page_id=31%3A1&node_id=312%3A46893)

## 一句话定义

<!-- TODO: 设计师补充。来自 Relay 章节 01 设计原则：「位于屏幕底部，作为页面导航的最高层级，管控全局，点击切换整页内容；分为常规、Agent 组合两种形态，左侧为 Agent 固定形态不可变，右侧 Tabbar 建议……」请基于此扩写一句话。 -->

## 应用场景

### ✅ 用

<!-- TODO: 设计师列举什么场景下用。Relay 章节 04「应用场景」涉及 Joy Agent 形态搭配，可参考。 -->

### ❌ 不用

<!-- TODO: 设计师列举什么场景下不能用 -->

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

> ⚠️ **token-miss flag**：未匹配 V16 标准值——
> - `color_text_help` 当前 `#828794`，与 V16 gray.3 标准值待对齐
> - `gray_6` 与 `color_background_component` 数值 1 色阶差异（`#f0f2f7` vs `#f5f6fa`），建议设计组核对取舍

### 文字

| 用途 | Token | 字号/字重/行高 |
|---|---|---|
| 底导标签默认态 | `pingfang_regular/font_size_10_400` | PingFang SC Regular 10/lh14 |
| 底导标签选中态 | `pingfang_semibold/font_size_10_600` | PingFang SC Semibold 10/lh14 |
| 灵动岛文字 | `pingfang_semibold/font_size_14_600` | PingFang SC Semibold 14/lh22 |
| 大促灵动岛强调文字 | `zhenghei_bold/font_size_14_600` | 京东正黑 V2.3 Bold 14/lh22 |

### 圆角

| Token | px |
|---|---|
| `Radius_6` | 6 |
| `Radius_8` | 8 |
| `Radius_12` | 12 |
| `Radius_16` | 16 |

> 灵动岛容器使用 `Radius_12`；其它角色对应 px 待与设计师按章节确认。

### 间距 / 布局

> ⚠️ **token-miss flag**：spacing token 未在 Relay variables 中绑定。Relay 设计稿明确的 DP 单位：

| 项 | DP | 备注 |
|---|---|---|
| 底导总高度 | 69 | 含 iOS 安全区 |
| 导航实际高度 | 52 | 不含安全区 |
| iOS 系统安全区 | 17 | 不可放置任何操作 |
| 常规灵动岛坑位 | 131×44 | 见章节 03 图 1 |
| 运营灵动岛坑位 | TODO | 见章节 03 图 3 |
| 大促灵动岛坑位 | TODO | 见章节 03 图 5/6 |
| 坑位数 | 2 / 3 / 4 / 5 | 见章节 02 图 2-5 |

待 V16 spacing token 表确立后回填映射。

### 材质

- **iOS 26+**：液态玻璃材质（liquid-glass）—— 章节 05 图 1
- **Android / iOS 老系统**：毛玻璃 fallback（frosted-glass）—— 章节 05 图 2

> ⚠️ materials 未通过 INSTANCE 绑定，仅为文本描述。等 V16 materials token 表建立后回填。

## 交互

<!-- TODO: 设计师描述：
- 点击切换整页内容的行为
- 选中态 / 默认态切换
- Agent 形态切换逻辑
- 灵动岛点击行为
- 红点 / 数字角标交互
-->

## 变体 Variants

本 Relay 节点包含**完整规范**，涉及以下变体维度（来自抓取的章节 02-03）：

### 形态维度

- **常规底导**：左右居中，2-5 坑位 + 灵动岛
- **Agent 组合底导**：左侧 Agent 固定形态不可变，右侧 Tabbar 2-5 坑位 + 灵动岛

### 坑位数维度

- **2 坑位**（图 5）
- **3 坑位**（图 4）
- **4 坑位**（图 3）
- **5 坑位**（图 2）

### 灵动岛运营维度

- **常规型灵动岛**：131×44 DP，常规商品推荐
- **运营型灵动岛**：尺寸 TODO，运营场景
- **大促型灵动岛**：尺寸 TODO，大促场景

> ⚠️ 变体数量丰富，建议后续按 multi-md bundle 拆分为：
> - `variants/regular-2.md` ~ `variants/regular-5.md`
> - `variants/agent-combo-2.md` ~ `variants/agent-combo-5.md`
> - `variants/island-regular.md` / `variants/island-operation.md` / `variants/island-promo.md`

## Donts

<!-- TODO: 设计师列举常见误用。
建议参考 Relay 章节 02「iOS 安全区 17DP 不可放置任何操作」、
章节 03「常规型灵动岛红色区域禁止出现任何元素」等明确的 ❌ 规则。 -->

## AI Schema

```yaml
# TODO: 设计师补充。AI 消费者通过这个区块了解组件语义。
component_type: tabbar
states:
  default: TODO
  selected: TODO
  badged: TODO            # 红点
  number-badge: TODO      # 数字角标
slots:
  TODO                    # 坑位结构
events:
  TODO
```

## 关联

- 此组件归属：`level: component-base` (⚠️ 实际是 page-doc), `bg: horizontal`
- V16 Foundation 引用：见 frontmatter `references.uses_tokens`
- 父级页面：所有挂载 Tabbar 的应用页面（待 L3 录入后由 skill 反向填 `used_by`）
- 关联子组件：Joy Agent（horizontal/components-business/joy-agent，待录入）

## Relay 原稿章节大纲

为方便 review，列出 Relay 原稿（节点 `312:46893`）的实际章节结构：

| # | Relay 章节标题 | 节点 ID | 高度 (px) | 内容要点 |
|---|---|---|---|---|
| 0 | 设计系统文档头部 | `312:46894` | 240 | banner，跟仓库 design.html 顶部同源 (6:229 风格) |
| 01 | 设计原则 | `312:46895` | 304 | 位置 / 层级 / 常规 + Agent 组合两形态 |
| 02 | 组件设计属性 | `312:46900` | 6124 | 常规底导布局（图 1-7）+ Agent 底导布局：69/52/17 DP 三段高度 / 2-5 坑位 / 灵动岛 |
| 03 | 灵动岛运营资源位 | `312:47479` | 5589 | 常规 / 运营 / 大促三型灵动岛 · 字号 · 颜色应用 · 同频色 |
| 04 | 应用场景 | `312:47792` | 3864 | Joy Agent 形态搭配（2 个 INSTANCE 引用） |
| 05 | 多端适配 | `312:52979` | 1678 | iOS 26+ 液态玻璃 / Android·iOS 老系统毛玻璃 |

## 变更记录

| 时间 | 操作 | 来源 | 备注 |
|---|---|---|---|
| 2026-05-13 | 创建 | skill v0.1 手作 / page-doc 模式 | 自动抽取节点结构 + variables，正文按 Relay 5 章节大纲展开 / 5 处 TODO 待补 / 6 处 ⚠️ flag |

---

## 本次自动同步发现的待办

1. **preview.png 未导出** —— 节点高 18519px 超 base64 编码栈限。设计师手动从 Relay export，建议分章节 5 张
2. **page-doc 性质** —— 当前文档来自规范文档页（非单一 INSTANCE），后续可考虑拆为 multi-md bundle（spec.md / variants.md / behaviors.md）。建议跟 V16 设计组确认是否升级 skill 模板
3. **gray_6 与 color_background_component 数值漂移** —— `#f0f2f7` vs `#f5f6fa` 一色阶差，疑命名空间冲突，待设计组核对
4. **color_text_help 当前 `#828794`** —— 与 V16 gray.3 标准值待对齐（参见 jd-design-system-md/foundations/tokens 历史命名漂移记录）
5. **spacing token 未绑定** —— 设计稿用 DP 直接标注（69/52/17/131/44），等 V16 spacing token 表确立后回填
6. **materials 仅文字描述** —— liquid-glass / frosted-glass 未挂 INSTANCE，等 V16 materials token 表建立后回填
7. **uses_components: joy-agent 尚未录入** —— frontmatter 已留位，待 component-business 批量录入后回填 used_by 反向引用
