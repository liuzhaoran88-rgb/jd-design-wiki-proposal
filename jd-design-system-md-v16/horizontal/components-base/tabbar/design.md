---
file: design
bundle: page-doc           # v0.5: multi-md bundle 标识
level: component-base
bg: horizontal
slug: tabbar
name_zh: "底部导航栏"
name_en: "Tabbar"

owner: "@xushui2018"
contributors: []
status: draft
version: "0.3"
last_synced: "2026-05-14"

# skill 自动推断的字段。如不对，请改 frontmatter + mv 文件夹后告知。
# v0.5 起 page-doc 节点拆为 4 文件 bundle，本文件是 index。详细规范见同目录子文件。
auto_detected:
  level: component-base
  bg: horizontal
  slug: "tabbar"
  page_doc: true            # v0.4 自动判定（root.height > 5000）

relay_source:
  file_id: "2029484645871009793"
  page_id: "31:1"
  node_id: "312:46893"
  node_name: "导航类-底部导航栏设计规范"
  node_type: FRAME
  bounds: { w: 1666, h: 18519 }
  url: "https://relay.jd.com/file/design?id=2029484645871009793&page_id=31%3A1&node_id=312%3A46893"

bundle_files:
  - design.md     # 本文件，index + frontmatter + 章节链接
  - spec.md       # 视觉规范：colors / typography / radius / spacing / materials
  - variants.md   # 形态 / 状态 / 各维度变体
  - behaviors.md  # 应用场景 / 交互 / Donts / AI Schema / 多端适配

references:
  uses_components:
    - horizontal/components-business/joy-agent    # ⚠️ Joy Agent 形态在 04 章节出现 2 个 INSTANCE 引用，子组件尚未录入

used_by: []
---

# 底部导航栏 · Tabbar

> 自动同步 2026-05-14 · skill v0.5 (page-doc bundle) · Relay [`312:46893`](https://relay.jd.com/file/design?id=2029484645871009793&page_id=31%3A1&node_id=312%3A46893)

## 这是 page-doc bundle

本组件来自 Relay page-doc 节点（高 18519px，5 大章节），内容超出单 md 承载量，已按 v0.5 multi-md bundle 模板拆分为 **4 份**：

| 文件 | 内容 | 章节来源 |
|---|---|---|
| **[spec.md](./spec.md)** | 视觉规范：colors / typography / radius / spacing / materials | 章节 01-02 |
| **[variants.md](./variants.md)** | 形态 / 状态 / 坑位 / 灵动岛 / 招手 各维度变体 | 章节 02-03 |
| **[behaviors.md](./behaviors.md)** | 应用场景 / 交互 / Donts / AI Schema / 多端适配 | 章节 04-05 |
| **design.md**（本文件） | frontmatter / Relay 章节大纲 / 链接索引 | — |

## 一句话定义

> ⚠️ **草稿，待设计师 review**

底部导航栏（Tabbar）是 JD APP 屏幕底部的全局导航组件，作为页面导航的最高层级管控全局，点击切换整页内容。分**常规**和**Joy Agent 组合**两种形态，支持 2~5 个常规坑位 + 灵动岛运营资源位，并按 OS 端/版本差异化适配材质（iOS 26+ 液态玻璃 / 老系统毛玻璃）。

## Relay 原稿章节大纲

| # | Relay 章节标题 | 节点 ID | 高度 (px) | 内容要点 | bundle 落点 |
|---|---|---|---|---|---|
| 0 | 设计系统文档头部 | `312:46894` | 240 | banner，跟仓库 design.html 顶部同源 (6:229 风格) | — |
| 01 | 设计原则 | `312:46895` | 304 | 位置 / 层级 / 常规 + Agent 组合两形态 / 招手 / 灵动岛 / 端适配 | [spec.md](./spec.md#章节-01-设计原则原文) |
| 02 | 组件设计属性 | `312:46900` | 6124 | 常规 + Agent 底导布局 / 2-5 坑位 / 默认+选中+营销 三态 / 4 型招手 / Joy Agent 布局 | [spec.md](./spec.md#章节-02-组件设计属性原文) + [variants.md](./variants.md) |
| 03 | 灵动岛运营资源位 | `312:47479` | 5589 | 常规 / 运营 / 大促 三型灵动岛 · 布局 · 字号 · 颜色 · 材质 | [variants.md](./variants.md) |
| 04 | 应用场景 | `312:47792` | 3864 | Joy Agent 形态搭配（2 个 INSTANCE 引用）/ 230 frame 场景排布 | [behaviors.md](./behaviors.md) |
| 05 | 多端适配 | `312:52979` | 1678 | iOS 26+ 液态玻璃 / Android·iOS 老系统毛玻璃 | [behaviors.md](./behaviors.md#多端适配) |

## 关联

- 此组件归属：`level: component-base`（page-doc bundle），`bg: horizontal`
- V16 Foundation 引用：见 [spec.md](./spec.md) 的 `uses_tokens`
- 父级页面：（待 L3 录入后由 skill 反向填 `used_by`）
- 关联子组件：Joy Agent（`horizontal/components-business/joy-agent`，待录入）

## 变更记录

| 时间 | 操作 | 来源 | 备注 |
|---|---|---|---|
| 2026-05-13 | 创建 | skill v0.1 手作 / page-doc 模式 | 自动抽 token + Relay 5 章节大纲 / 5 处 TODO / 6 处 ⚠️ |
| 2026-05-13 | v0.4 升级 | skill v0.4（page-doc）+ get_design_context 真文本 | 修正 spacing / 补章节 02-03 全部内容 / 自动收 Donts 9 条 / AI Schema 完整草稿 |
| 2026-05-14 | v0.5 拆 bundle | skill v0.5 multi-md bundle | 540 行单 design.md → 4 文件 bundle（design / spec / variants / behaviors）— close issue #18 |

---

## 本次自动同步发现的待办

详细待办分散在各 bundle 子文件末尾。汇总：

1. **preview.png 未导出** —— 节点高 18519px 超 base64 编码栈限。设计师手动从 Relay export，建议分章节 5 张
2. **gray_6 与 color_background_component 数值漂移** —— `#f0f2f7` vs `#f5f6fa` 一色阶差，疑命名空间冲突，待设计组核对（spec.md）
3. **color_text_help 当前 `#828794`** —— 与 V16 gray.3 标准值待对齐（spec.md）
4. **spacing token 未绑定** —— 25+ DP 标注待 V16 spacing token 表确立后回填（spec.md）
5. **materials 仅文字描述** —— 待 V16 materials token 表建立后回填（spec.md / variants.md）
6. **uses_components: joy-agent 尚未录入** —— 子组件 design.md 待录入
7. **运营/大促灵动岛"同频色"无 token 绑定** —— 建议 V16 token 系统增加 dynamic-color 类别（variants.md）
8. **章节 04 应用场景无独立 description 文本** —— 仅 INSTANCE 实例样本，设计师需补叙述（behaviors.md）
9. **B 类草稿待 review** —— 一句话定义（本文件）/ 应用场景 + 交互（behaviors.md）由 skill 拟初稿，设计师需修订
10. **AI Schema events 缺 island 行为** —— `on_island_click` / `on_island_dismiss` 待设计师 + PM 确认（behaviors.md）
