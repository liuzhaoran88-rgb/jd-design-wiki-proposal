# JD Design Wiki · AI-Ready Upgrade Proposal

京东设计 wiki 在 AI 时代的升级方案、知识树、贡献指南、架构大图。

> **不是建一套新的设计系统，是让已有的 wiki 真正被用起来**——在组织协作、AI 消费、工具链打通三个维度上升级。

---

## ⭐ 给老板的 30 秒汇报

→ **[`docs/jd-design-wiki-executive-summary.html`](./docs/jd-design-wiki-executive-summary.html)** — Executive Summary，老板看 30 秒能 get 全貌

5 段式：**WHY**（4 个结构性问题）→ **WHAT**（3 个核心改造）→ **SO WHAT**（3 阶段量化结果）→ **NEXT**（进度+需要支持）→ **CTA**（核心金句）

---

## 四份 HTML · 各取所需

| 文件 | 用途 | 谁看 |
|---|---|---|
| **[`docs/jd-design-wiki-executive-summary.html`](./docs/jd-design-wiki-executive-summary.html)** | **30 秒汇报版**（WHY/WHAT/SO WHAT/NEXT/CTA 五段式） | **老板 / 决策层** |
| **[`docs/jd-design-wiki-master-diagram.html`](./docs/jd-design-wiki-master-diagram.html)** | **架构大图 · 演讲用**（5 个 Zone 可点击切换 + 29 个 md 模板） | 评审 / 跨部门同事 |
| **[`docs/jd-design-wiki-knowledge-tree.html`](./docs/jd-design-wiki-knowledge-tree.html)** | **知识树 · 顶层导航**（5 大 Zone + 二级目录 + 角色 owner） | 全员 |
| **[`docs/jd-design-wiki-contributor-guide.html`](./docs/jd-design-wiki-contributor-guide.html)** | **贡献指南 · 执行手册**（5 步流程 + 维度边界 + multi-md 文件结构） | 业务线设计师 |

**配套战略文档**：[`jd-design-os-proposal.md`](./jd-design-os-proposal.md) — 4500 字完整方案 + 6 个附录（外部标杆调研 + 实施路径）

---

## 核心架构（30 秒看完）

```
京东 Design Wiki
│
├── 📚 Design 知识        知识/研究/案例(按部门切)
├── 🎨 Design 基础        Token / 原子组件(全公司共用)
├── 🤖 AI 机制            Skill / 协议 / Agent 守则
├── 🏗 产品架构 ★         部门 → 业务 → 组件目录(业务线设计师主战场)
└── 🚀 横向专项           跨部门治理 / 反哺机制
```

**业务线设计师的产出 = 一个组件目录 = multi-md 文件结构**：

```
{组件}/
├── README.md      概述 + Meta
├── business.md    PM 写
├── research.md    用研写 ★
├── experience.md  体验设计师写 ★
├── visual.md      视觉设计师写 ★
├── interaction.md 交互写
├── content.md     内容运营写
├── donts.md       协作收集
├── ai-schema.md   AI 消费字段
├── CHANGELOG.md   自动生成
├── variants/      变体案例
└── examples/      示例资源
```

---

## 推荐阅读顺序

### 给老板汇报（30 秒 → 2 分钟弹性）★
→ 打开 `docs/jd-design-wiki-executive-summary.html`
→ 30 秒版：只读 Hero + Final CTA 金句
→ 2 分钟版：+ WHY 4 痛点 + WHAT 3 改造 + 3 阶段时间线
→ 老板深问 → 跳转 `docs/jd-design-wiki-master-diagram.html` 看具体架构

### 给评审 / 跨部门同事（10 分钟）
→ 打开 `docs/jd-design-wiki-master-diagram.html`
→ 按 **F11 全屏**讲第一屏架构图
→ **点 5 个 Zone 卡切换**看每个 Zone 的 multi-md 结构和模板

### 业务线设计师上手（10 分钟）
→ 先看 `docs/jd-design-wiki-knowledge-tree.html` 找到"我归到哪个 Zone"
→ 再看 `docs/jd-design-wiki-contributor-guide.html` 知道"怎么写"
→ 点击文件名跳转到 `docs/jd-design-wiki-master-diagram.html` 的 Templates 章节看具体模板

### 深度方案研读（30 分钟）
→ `jd-design-os-proposal.md` 完整战略方案

---

## 四份 HTML 的内在关系

```
executive-summary.html (30 秒汇报)
        ↓ footer 链接到
master-diagram.html (含 5 Zone × 29 个 md 模板)
        ↑ 跨文件锚点跳转
contributor-guide.html (md 文件名 → master-diagram#tpl-xxx)
        ↕ footer 互链
knowledge-tree.html (顶层导航)
```

任何一个文件打开，都能在 footer 找到另几个的入口。

---

## V16 设计系统 spec-page

V16 录入开始铺 HTML 发布物。每个 Zone 都有一份 `spec-page.html`,顶部用 5 大 Zone tab 互跳,左 sidebar 列当前 Zone 的子目录:

| Zone | 入口 | 状态 |
|---|---|---|
| 📚 Design 知识 | `jd-design-system-md-v16/knowledge/spec-page.html` | placeholder(3 子目录占位) |
| 🎨 Design 基础 | `jd-design-system-md-v16/foundations/spec-page.html` | **8 token 类别 + 通用组件(tabbar/button)** |
| 🤖 AI 机制 | `jd-design-system-md-v16/ai-mechanism/spec-page.html` | **4 个 skill 索引卡片**(README + 3 个 V16 skill md) |
| 🏗 产品架构 | `jd-design-system-md-v16/product-architecture/spec-page.html` | placeholder(domains/pages/relations 占位) |
| 🚀 横向专项 | 未建页 | top-bar 标灰 |

落地组件实例:[tabbar/spec-page.html](./jd-design-system-md-v16/horizontal/components-base/tabbar/spec-page.html) — 单组件 7 章节规范页,Pro/Basic 双视图、原稿切图、应用场景、Donts、AI Schema。共用同套 top-bar + sidebar 壳。

### Relay 改稿后的同步链路

```
1. Relay 改稿
   ↓ local Claude session 跑:/relay-to-design-md <relay-url>
2. design.md / spec.md / variants.md / behaviors.md / ai-schema.yaml / CHANGELOG.md
   6 文件 bundle 自动同步(v0.5.1 bundle 结构)
   ↓ local Claude session 跑:/design-md-to-spec-page <slug>
3. 增量启发(v0.5):比对 _assets/*.png 最旧 mtime vs frontmatter.last_synced,
   Relay 没动就跳切图重导(3-5min → < 10s);带 --refresh-assets 强制重导
   ↓ git add -A && git commit -m "update <slug> spec" && git push
4. GitHub Pages 自动重 build (~30s),URL 立即更新
```

### 涉及的 4 个 skill

| Skill | 版本 | 输入 | 输出 |
|---|---|---|---|
| [`relay-to-design-md`](./.claude/skills/relay-to-design-md/) | v0.5.1 | Relay URL | design.md / 6 文件 page-doc bundle(编辑面) |
| [`design-md-to-portal`](./.claude/skills/design-md-to-portal/) | v0.2 | 所有 design.md | `docs/design.html` 总站门户(聚合发布面) |
| [`design-md-to-spec-page`](./.claude/skills/design-md-to-spec-page/) | v0.5 | 单 design.md / bundle | `<slug>/spec-page.html` 单组件页(单页发布面) |
| [`design-review`](./.claude/skills/design-review/) | v0.1.1 | Relay 节点 | 5 段式合规走查报告(V15 + V16 双轨) |

V16 ai-mechanism wiki 索引:[jd-design-system-md-v16/ai-mechanism/](./jd-design-system-md-v16/ai-mechanism/)(README + 3 个 V16 skill 职能说明)。design-review 仍 V15 范围,索引在 [V15 ai-mechanism](./jd-design-system-md/ai-mechanism/design-review.md)。

### CI 自动化?

GitHub Actions 触发 skill 重跑这条路**走不通** —— skill 依赖 `use_design_script` MCP 调 Relay,GHA runner 没 Relay 浏览器 plugin。**必须 local Claude session 跑**,push 后 Pages 自动重 build 是免操作的最后一步。

---

## 状态

**v0.5 · 内部已授权推进**
**牵引**:综合业务设计组 · Shaka

**当前进度**(2026-05-18):
- ✅ 4 个 native skill 上线(relay/portal/spec-page v0.5+ + design-review V15 维持)
- ✅ V16 Foundation 8 token 类别 + Tabbar 落地组件 bundle 完整(6 文件)
- ✅ 5 大 Zone 跨页导航 + 左 sidebar 子目录(参 Ant Design)
- 🟡 录入中:button/V16 spec-page、ai-mechanism 协议层补全(消费协议/Agent 守则)
- 🟡 待启动:product-architecture domains/pages/relations、横向专项整套
