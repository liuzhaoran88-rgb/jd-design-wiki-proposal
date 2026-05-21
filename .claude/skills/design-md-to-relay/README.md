# /design-md-to-relay · v0.1 骨架

按 wiki design.md 规范在 Relay 当前打开文件里实例化一份**100% 还原的参考稿**。通用 component 生成器(任意 component-base),自动 auto-pull foundation 真相源、读 Relay 原版组件 ground truth、SVG 优先拉资产、用 Auto Layout 接管对齐、所有色/字/圆角强制绑定 V16 foundation token。补 V16 编辑面缺失的「md → Relay」反向能力。

## 设计目标(硬约束)

| # | 目标 | 含义 |
|---|---|---|
| 1 | **通用 component 生成器** | 跑任意 `component-base` 组件,不绑定 tabbar 或具体业务 |
| 2 | **100% 还原度** | 几何 0 DP diff / 0 placeholder / 100% token binding,任一不达 strict 模式 fail |
| 3 | **符合 V16 Foundation** | 所有 fill / stroke / cornerRadius / fontSize / spacing 必须 foundation 反查绑定,**禁止裸 hex / 裸 px** |
| 4 | **Foundation 实时同步** | skill 起手 auto-pull upstream main,产出报告附 foundation commit SHA(可追溯) |

## 状态:v0.1 骨架

**当前版本仅是流程梳理 + reference 占位,尚未实现可执行脚本**。

实际能跑的 v0.2 + 需要先解决以下上游依赖:

| Gap | 上游 issue | 影响哪一步 |
|---|---|---|
| Relay 原版组件 ground truth 未 anchor | [#60 Gap 2](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 3 probe ground truth |
| design.md 02.4 表选中态尺寸不闭合 | [#60 Gap 1](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 2 read bundle + Step 4 diff |
| Auto Layout 模式 wiki 未明文 | [#60 Gap 3](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 5 plan structure |
| `_assets-cdn.md` 只登记 PNG | [#60 Gap 4](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 6 fetch assets |

issue #60 的 P0(Gap 1 + Gap 4)合并后即可启动 v0.2。

## Roadmap

| 版本 | 内容 | 依赖 |
|---|---|---|
| **v0.1**(本骨架) | SKILL.md 10 步流程 + 设计目标硬约束 + R3 实录 + foundation/fidelity 两个 P0 reference | 无 |
| v0.2 | Step 0(foundation auto-pull)+ Step 1-2(parser + bundle reader)+ Step 2.5(token 表构建)+ Step 3(ground-truth probe)| issue #60 Gap 2 合并 |
| v0.3 | Step 5-7(Auto Layout + use_design_script + 强制 token 绑定)| issue #60 Gap 3 合并 |
| v0.4 | Step 4 + 8 反查机制 + strict mode 几何 0 DP 审计 | issue #60 Gap 1 合并 |
| v0.5 | **tabbar 跑通 + button 验证组件无关性** | 上述全部 |
| **v0.6** | **Step 9 子组件递归(tabbar → Joy Agent → 各 icon atom)** | v0.5 |
| v1.0 | page-doc bundle level(L2/L3/L4) | v0.6 验证后 |

## Skill 矩阵中的位置

```
                          Relay
                          ↑    ↓
  relay-to-design-md   ───┘    └───  design-md-to-relay (本 skill)
                                 ↓
                            design.md
                                 ↓
                                 ├── design-md-to-portal
                                 ├── design-md-to-spec-page
                                 └── design-review
```

V16 三面四 skill 闭环现已齐整(原 4 个 skill + 本 skill = 5 个)。

## Foundation 实时同步策略 · auto-pull

skill 每次起手都跑:

```bash
git -C ~/code/jd-design-wiki-proposal pull --ff-only origin main
```

- **成功**:拿到 upstream 最新 foundation,记录当前 commit SHA
- **失败**(网络故障 / 非 fast-forward):降级用本地 cache,输出明确警告
- **追溯**:每次产出报告附 `foundationVersion.commit`,user 可验证用的哪版

可绕开的 flags:

- `--no-pull`:离线 / dev 场景,完全跳过 pull
- `--foundation-from <path>`:用指定路径(调试 PR 分支 / fork)

详见 [`references/foundation-token-table.md`](references/foundation-token-table.md)。

## 100% 还原度量化判定

| 维度 | strict 模式(默认)| 非 strict |
|---|---|---|
| 几何 dimension diff | **0 DP**,任何 > 0 即 fail | > 0.5 DP warn / > 2 DP violate |
| Token binding 覆盖率 | **100%**(0 个裸 hex / px) | 80%+ 即可 |
| Placeholder 数量 | **0 个** | 不限 |
| 变体完整性 | **100%**(枚举状态全画) | 至少 1 个 |

详见 [`references/fidelity-thresholds.md`](references/fidelity-thresholds.md)。

## 设计依据

本 skill 的 10 步工作流 + 8 条核心规则,来自:

1. **R3 Tabbar 走查实录**(规则 1-4 + 4 个 wiki gap),详见 [`references/lessons-from-r3-tabbar.md`](references/lessons-from-r3-tabbar.md)
2. **3 个硬约束目标**(规则 5-8 + Step 0/2.5/6/8/9):通用 / 100% / Foundation / 实时同步

skill 与 issue 互为产物:

- **skill** = issue gap 修完后的「正确做法固化」
- **issue** = skill 设计中暴露的「wiki 不闭合点」反馈

upstream issue: https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60

## 怎么贡献(等 v0.2 启动后)

1. 等 issue #60 上游 PR 合并(至少 P0)
2. fork 本仓库,基于 `feat/skill-design-md-to-relay` 分支起 v0.2 工作分支
3. 按 `references/workflow-10-steps.md` 实现各 step
4. 跑 tabbar 跑通 → 跑 button 验证 → 跑 Joy Agent 验证子组件依赖
5. PR 回 fork → 评审 → 合并到上游
