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

## 状态

**v0.4 · 内部已授权推进**
**牵引**：综合业务设计组 · Shaka

**P1 阶段** (1 个月内):
- Week 1-2: 录入 15.0 设计语言到 foundations/ + 建角色模板
- Week 2-3: 2-3 场域试点（按部门-业务-组件三级结构）
- Week 3-4: Figma + Zero 打通 POC + AI Skill 自动化 POC
- 月底: MVP 完成，决定是否规模化
