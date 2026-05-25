# design-md-to-relay

按 JD 设计 wiki 的 markdown,在 Relay/Zero 当前打开文件里生成参考设计稿。本 skill 支持多种组件,**不仅是 Tabbar**。

本文件只负责**项目状态、路线图、设计背景**。工作流、设计准则、来源优先级、guardrail 等「skill 怎么工作」的内容,全部以 [`SKILL.md`](SKILL.md) 为唯一真相源,这里不重复。

## 当前状态:v0.1 骨架

工作流 + 契约已就位。可执行脚本未写。

v0.2 实现依赖 upstream [issue #60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) 的 P0 合并:

| Gap | 上游 issue 章节 | 影响哪一步 |
|---|---|---|
| design.md 02.4 表选中态尺寸不闭合 | [#60 Gap 1](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 3 read bundle |
| Relay 原版组件未 anchored 为 ground truth | [#60 Gap 2](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 6 probe ground truth |
| Auto Layout 模式 wiki 未明文 | [#60 Gap 3](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 7 plan node tree |
| `_assets-cdn.md` 只登记 PNG | [#60 Gap 4](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 8 fetch assets |

## 路线图

| 版本 | 内容 | 依赖 |
|---|---|---|
| **v0.1**(本骨架) | SKILL.md + 4 references + tabbar adapter | 无 |
| v0.2 | Step 0-5 实现(确认 scope / 同步 / 解析 / 读 bundle / 读 foundation / 归一化 spec) | issue #60 Gap 1 + 2 |
| v0.3 | Step 6-8(ground truth probe / 节点树 / 取资产) | issue #60 Gap 3 |
| v0.4 | Step 9-10(执行 + 验证容忍度) | issue #60 Gap 4 |
| v0.5 | **Tabbar 在 375×812 单实例 · 端到端跑通验证** | 以上全部 |
| v0.6 | Button 变体生成 · 第二个组件验证通用核心 | v0.5 |
| v0.7 | Toast 浮层组件 · 第三组验证 | v0.6 |
| v1.0 | page-doc bundle level(L2/L3/L4) | v0.7 |

每个组件验证都用来加固归一化 spec schema + 验证断言。

## Skill 矩阵位置

```text
                          Relay
                          ↑    ↓
  relay-to-design-md   ───┘    └───  design-md-to-relay (本 skill)
                                 ↓
                            design.md (bundle)
                                 ↓
                                 ├── design-md-to-portal
                                 ├── design-md-to-spec-page
                                 └── design-review
```

V16 编辑面 / 发布面 / 审计面 三面四 skill 闭环齐整(原 4 个 + 本 skill = 5 个)。

## 设计渊源

本 v0.1 骨架综合两个来源:

1. **R3 Tabbar 走查实录**(2026-05-20):暴露 4 个 wiki gap + 4 个实现 pitfall。蒸馏进 [`references/adapters/tabbar.md`](references/adapters/tabbar.md)。
2. **User 提供的 v0.2 草稿**:贡献了 Prime Directive / Source Precedence / 归一化 spec / Adapter pattern / 放宽容忍度 / 不 clone guardrail 等架构决策。

Skill 与 upstream issue #60 互为产物:

- **skill** = wiki gap 修复后的「正确做法」固化
- **issue** = skill 设计中暴露的「wiki 不闭合点」反馈

上游 issue: https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60

## 怎么贡献(v0.2 启动后)

1. 等上游 issue #60 P0 PR 合并
2. fork 本仓库,从 `feat/skill-design-md-to-relay` 起 v0.2 工作分支
3. 按 [`SKILL.md`](SKILL.md) 工作流实现各 Step
4. 验证顺序:tabbar → button → toast → navbar
5. PR 到 fork → review → 合到上游
