---
zone: jd-design-system-md-v16
version: 16.0-draft
owner: 设计与用研部 · AI 核心产品设计部
last_updated: 2026-05-18
relay_source:
  file_id: "2029484645871009793"
  url: https://relay.jd.com/file/design?id=2029484645871009793
parallel_to: ../jd-design-system-md/   # V15.0 冻结版本
migration_doc: ../MIGRATION-V15-TO-V16.md
status: in-progress
---

# JD APP 16.0 Design System (录入中)

> **本目录是 V16.0 设计系统的录入工程**。与 [`../jd-design-system-md/`](../jd-design-system-md/)（V15.0 冻结版本）平行存在。
>
> 本期录入完成后，V16.0 将替代 V15.0；过渡期保留双轨，所有引用需显式标版本。

---

## 与 V15.0 的关系

| 维度 | V15.0 | V16.0 |
|---|---|---|
| Relay 文件 | `1896756863949619202` | `2029484645871009793` |
| 目录 | `jd-design-system-md/`（冻结） | `jd-design-system-md-v16/`（本目录） |
| Token 架构 | 2 层：Token → Hex 直给 | **3 层：Token → Atom → Hex（解耦）** |
| 命名风格 | `color.brand.primary`（dot, 分类层级） | `color_primary`（snake, 扁平语义） |
| 错误色 | `semantic.danger = brand.primary` 共色 | **独立 `color_error`（errorred 色族）** |
| Service | `functional.service-gold-*` 9 个零散 | **`color_service_{,bground,border,text}` 四件套** |
| 文档主源 | `foundations/tokens/tokens.json` | `foundations/tokens/tokens.json`（新格式） |

完整变更见 [`../MIGRATION-V15-TO-V16.md`](../MIGRATION-V15-TO-V16.md)（录入完成后撰写）。

---

## 每条 Token 的状态标记

V16.0 每条 token 在 frontmatter / `$extensions` 中标记**与 V15.0 的关系**：

| `v16_status` | 含义 | 何时用 |
|---|---|---|
| `unchanged` | 与 V15.0 一致，保留照搬 | 视觉与命名都没动 |
| `upgraded` | 从 V15.0 升级而来，值或语义有改 | 同概念但更精确（如圆角值微调、间距重命名） |
| `decoupled` | V15.0 共用一项，V16.0 拆出独立 token | Error/Danger 从 Primary 解耦、Atom 从 Token 解耦 |
| `new` | V16.0 全新增加 | V15.0 不存在的能力 |
| `deprecated` | V15.0 有 V16.0 删除 | 写明替代方案 |

每条 token 同时记 `v15_equivalent`（指向 V15.0 路径，便于回溯）和 `rationale`（一句话说明为什么这样改）。

---

## 录入进度

| Foundation | Relay page | 状态 | v16 文档 |
|---|---|---|---|
| 设计哲学 | `12:251` | 🔘 占位（Relay 页空） | `knowledge/philosophy/README.md` |
| 色彩 Colors | `6:9` + `58:9/591:1785` | ✅ Token 表 + atom 引用 完整；atom hex TODO | `foundations/tokens/color.md` + `tokens.json` |
| 文本 Text Styles | `12:261` + `58:9/363:655` | ✅ size + weight + family + role 26 组 完整 | `foundations/tokens/typography.md` |
| 圆角 Radius | `12:262` + `58:9/363:507` | ✅ 7 阶 + V15 对照 完整 | `foundations/tokens/radius.md` |
| 线 Lines | `12:264` + `58:9/363:636` | ✅ 2 个线宽 token（V16 新独立） | `foundations/tokens/lines.md` |
| 材质 Materials | `12:260` | ✅ Liquid Glass + Frosted Glass 4 variants 完整（V16 新） | `foundations/visual/materials.md` |
| 空间布局 Spacing | `6:3`（规范 1/2/3） | ✅ Z 轴 4 层 + safe-area + 双梯度 完整 | `foundations/tokens/spacing.md` + `foundations/visual/layout.md` |
| 空间布局 Layout 独立页 | `12:265` | 🔘 占位（Relay 页空） | layout.md note 中说明 |
| 图标 Icons | `12:263` | 🟡 图标清单完整（33 个），参数 token 沿用 V15 | `foundations/tokens/icon.md` |
| 语义化统一（总览） | `58:9` | ✅ 作为 Token 真相源全程引用 | `foundations/tokens/tokens.json` |

**已完成**：色彩 / 文本 / 圆角 / 线 / 材质 / 空间布局 / 图标 + 设计哲学占位 + 布局独立页占位 + **Atom Light/Dark Hex 批量回填** + **MIGRATION-V15-TO-V16.md** + **RELAY-V16-TYPOS.md (13 条)** + **Foundation 总览 HTML**(`foundations/spec-page.html`,实物展示 + Pro/Basic 双视图)

**等 V16 设计师 WIP**：errorred 独立色谱 hex / errorred_3 + infoblue_3 缺源 / 京东朗正体去向 / bold 700 去向 / 圆角 full 胶囊方案

---

## V16 5 大 Zone HTML 发布层(2026-05-18 新)

V16 录入开始铺 HTML 发布物。每个 Zone 都有一份 `spec-page.html`,共用顶部 5 大 Zone tab + 左 sidebar(参 Ant Design 模式):

| Zone | 入口 | 状态 |
|---|---|---|
| 📚 Design 知识 | `knowledge/spec-page.html` | placeholder(3 子目录占位) |
| 🎨 Design 基础 | `foundations/spec-page.html` | 8 token 类别 + 通用组件(tabbar/button)group |
| 🤖 AI 机制 | `ai-mechanism/spec-page.html` | Skill Registry 4 卡片 + README + 3 个 V16 skill md |
| 🏗 组织架构 | `product-architecture/spec-page.html` | placeholder(domains/pages/relations 占位) |
| 🚀 横向专项 | 未建页 | top-bar 标灰 |

横向 components-base 的实战落地:[horizontal/components-base/tabbar/](./horizontal/components-base/tabbar/) — V16 第一个完整的 page-doc bundle(6 文件 + 12 张原稿切图 + spec-page.html)。

> **shared/ 重分类**:跨部门通用组件(Tabbar / Button)挂在 Zone 02 🎨 Design 基础 > 通用组件,而不是 Zone 04 🏗 组织架构 > shared/(原 ant-design 模板有 shared,V16 移到 Foundation 侧更贴近"原子/基础"语义)。

---

## 录入流程（每个 Foundation）

1. 读对应 Relay 页的「更改日志」frame
2. 读「语义化统一」(`58:9`) 里对应的 Token frame，提取 token 名 + atom 映射 + 场景说明
3. 读主规范 frame，补设计意图与用法
4. 与 V15.0 同名/同概念 token 做 diff，确定每条 `v16_status`
5. 写入 `foundations/tokens/{foundation}.md` + 同步 `tokens.json`
6. 用法独立写入 `foundations/visual/{foundation}-usage.md`（如果存在用法差异）

---

## 暗黑模式

V16.0 的暗黑映射在 Relay 页 `58:9` 内：

- 彩色暗黑映射表 `577:2610`
- 灰阶暗黑映射表 `577:2810`
- 平台色板暗黑映射表 `577:2944`

录入策略：每条 token 的 `$value` 用 atom 引用，atom 在色板里给 `light` / `dark` 双值。这样组件层不需要写 dark variant。
