# design-md-to-relay

按 JD 设计 wiki 的 markdown,在 Relay/Zero 当前打开文件里生成参考设计稿。

本 skill 支持多种组件,**不仅是 Tabbar**。采用通用 pipeline:

```text
确认 scope
→ 同步 foundation (auto-pull upstream)
→ 解析目标 design.md
→ 读 wiki bundle
→ 读 foundation token + 视觉规则
→ 构建归一化 spec JSON
→ 仅在有用时探 ground truth
→ 规划 Relay 节点树
→ 取资产并归一化
→ 分小批次写入
→ metadata + 截图验证
```

## 关键设计决策

### 运行时读 wiki(不复制 wiki 进 skill)

组件 spec **留在 wiki 主仓库**。不要把每个组件的 `design.md` 复制进 skill。

skill 的 `references/` 目录**只**放工作流文档、归一化 spec schema、adapter 注解、实现指引。运行时 skill 实时解析目标组件,直接从源 wiki 读:

```text
jd-design-system-md-v16/**/<slug>/design.md
jd-design-system-md-v16/**/<slug>/spec.md
jd-design-system-md-v16/**/<slug>/variants.md
jd-design-system-md-v16/**/<slug>/behaviors.md
jd-design-system-md-v16/**/<slug>/ai-schema.yaml
```

这避免 skill 跟 wiki 之间产生版本漂移。

### Foundation Auto-Pull

skill 在 Step 1 跑 `git pull --ff-only origin main` 同步上游 foundation。commit SHA 记入输出报告 `foundationVersion.commit`,**每次跑动都能追溯到具体的 foundation 快照**。

失败处理:

| 状态 | 处理 |
|---|---|
| 成功 / up-to-date | 用 upstream HEAD |
| 本地有未推 commit(diverged) | 用本地 + warn(报告 SHA + 原因) |
| 网络故障 | 用本地缓存 + warn(报告 SHA + 距离上次 pull 多久) |
| 仓库不存在 | fail,提示 clone |
| `--no-pull` flag | 完全跳过 pull |
| `--foundation-from <path>` flag | 绕过仓库,用指定路径 |

详见 [`references/foundation-token-table.md`](references/foundation-token-table.md)。

### Scope 优先(画之前先问)

skill 在动手画**之前**确认请求的 output 形态。「**一个底导设计稿**」可能只是「一个底导放在手机页面里」,不是完整状态矩阵或 spec 板。

scope 不清楚 → 问**一个**简练问题,等回答。

### Wiki First,Ground Truth Second

原版 Relay 节点对「**补缺失字段**」+「**diff 报告**」有用,但**不能**静默覆盖 wiki / foundation 显式字段。skill 不 clone 原稿,除非用户明确要求。

来源优先级:

```text
用户 scope
> ai-schema.yaml / spec.md 结构化字段
> design.md 显式字段
> foundation token + 视觉规则
> 组件 adapter 默认值
> ground truth(仅用于补缺失字段)
```

### 归一化 spec 先于动笔

Markdown 是给人看的,值散落在散文 / 表 / frontmatter / foundation / 视觉规则各处。Relay 脚本需要的是结构化指令。skill 先把 wiki 归一化成一份 JSON 执行契约,再从契约写 Relay。

价值:

- 分离「理解」和「执行」
- 支持验证断言
- 支持 retry / resume
- 每个字段可追溯来源

### 通用核心 + 组件 Adapter

核心工作流通用。组件特异性细节走 adapter:

- `references/adapters/tabbar.md`
- `references/adapters/button.md`
- `references/adapters/toast.md`
- `references/adapters/navbar.md`

没 adapter 时走通用归一化流程;anatomy 不清楚就问 scope。

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
2. **User 提供的 v0.2 草稿**:贡献了 Prime Directive / Source Precedence / 归一化 spec / Adapter pattern / 放宽容忍度 / 不 clone guardrail 等架构决策。本 skill 学习自该草稿(参见 commit `refactor(skill): 全套合并 user v0.2 草稿`)。

Skill 与 upstream issue #60 互为产物:

- **skill** = wiki gap 修复后的「正确做法」固化
- **issue** = skill 设计中暴露的「wiki 不闭合点」反馈

上游 issue: https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60

## 怎么贡献(v0.2 启动后)

1. 等上游 issue #60 P0 PR 合并
2. fork 本仓库,从 `feat/skill-design-md-to-relay` 起 v0.2 工作分支
3. 按 SKILL.md 工作流实现各 Step
4. 验证顺序:tabbar → button → toast → navbar
5. PR 到 fork → review → 合到上游
