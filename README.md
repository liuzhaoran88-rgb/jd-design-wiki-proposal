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

## 组件 spec page 维护流程

落地产物示例:[tabbar/spec-page.html](./jd-design-system-md-v16/horizontal/components-base/tabbar/spec-page.html) — 单组件 7 章节规范页,含 Pro / Basic 视图切换、原稿切图、应用场景、Donts、AI Schema。在线版(repo 公开时)走 GitHub Pages。

### Relay 改稿后的同步链路

当 Relay 设计稿更新,要让对外的 spec-page.html 同步:

```
1. Relay 改稿
   ↓ local Claude session 跑:/relay-to-design-md <relay-url>
2. design.md / spec.md / variants.md / behaviors.md bundle 自动同步
   ↓ local Claude session 跑:/design-md-to-spec-page <slug>
3. _assets/*.png 切图重导(3~5 min)+ spec-page.html 重渲染
   ↓ git add -A && git commit -m "update <slug> spec" && git push
4. GitHub Pages 自动重 build (~30s),URL 立即更新
```

### 涉及的 3 个 skill

| Skill | 输入 | 输出 |
|---|---|---|
| [`relay-to-design-md`](./.claude/skills/relay-to-design-md/) | Relay URL | design.md / page-doc bundle(编辑面) |
| [`design-md-to-site`](./.claude/skills/design-md-to-site/) | 所有 design.md | `docs/design.html` 总站(聚合发布面) |
| [`design-md-to-spec-page`](./.claude/skills/design-md-to-spec-page/) | 单 design.md / bundle | `<slug>/spec-page.html` 单组件页(单页发布面) |

### 已知效率痛点(待优化)

当前每次跑 `/design-md-to-spec-page` 都会全量重导 9 张切图(走 use_design_script + chunkedB64 + sharedPluginData 中转 + jq 解 dump file),即使你只是改了一段 design.md 文字。skill v0.4 计划加增量逻辑:

- 默认对比 `_assets/*.png` mtime vs design.md mtime,后者新才重导
- `--refresh-assets` 强制全量
- `--dry-run` 只看会变什么不动文件

详见 [issue 列表](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues)。

### CI 自动化?

GitHub Actions 触发 skill 重跑这条路**走不通** —— skill 依赖 `use_design_script` MCP 调 Relay,GHA runner 没 Relay 浏览器 plugin。**必须 local Claude session 跑**,push 后 Pages 自动重 build 是免操作的最后一步。

---

## 状态

**v0.4 · 内部已授权推进**
**牵引**:综合业务设计组 · Shaka

**P1 阶段** (1 个月内):
- Week 1-2: 录入 15.0 设计语言到 foundations/ + 建角色模板
- Week 2-3: 2-3 场域试点（按部门-业务-组件三级结构）
- Week 3-4: Figma + Zero 打通 POC + AI Skill 自动化 POC
- 月底: MVP 完成，决定是否规模化
