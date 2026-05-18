---
file: behaviors
bundle_part_of: design.md       # 反向指回 index；relay_source 单点存储在 design.md
slug: tabbar
last_synced: "2026-05-18"

# v0.5 page-doc bundle: 应用场景 / 交互 / Donts / 多端适配（文字）
# 来源：Relay 节点 312:46893 章节 04-05 + 跨章节 dont_rule 聚合
# v0.5.1 起 AI Schema 抽到独立 ai-schema.yaml；relay_source 单点存储在 design.md
---

# 底部导航栏 · 行为 / 禁止 / 适配

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

> v0.5.1 起抽到独立机器可读文件 → [`ai-schema.yaml`](./ai-schema.yaml)
>
> 含 `forms / slots / states / badges / island / agent / material / typography / events` 9 个段。状态机 / 事件签名仍需设计师 + 工程师 review（`on_island_click` / `on_island_dismiss` 仍为 TODO）。

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
