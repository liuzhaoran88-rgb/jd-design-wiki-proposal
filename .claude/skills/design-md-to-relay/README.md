# /design-md-to-relay · v0.1 骨架

按 wiki design.md 规范在 Relay 当前打开文件里实例化一份参考设计稿。补 V16 编辑面缺失的「md → Relay」反向能力。

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
| **v0.1**(本骨架) | SKILL.md 流程梳理 + R3 实录 reference + 4 个 references 占位 | 无 |
| v0.2 | 实现 Step 1-2(parser + bundle reader)+ Step 3(ground-truth probe)| issue #60 Gap 2 合并 |
| v0.3 | 实现 Step 5-7(Auto Layout + use_design_script 执行)| issue #60 Gap 3 合并 |
| v0.4 | 加 Step 4 + 8 反查机制 | issue #60 Gap 1 合并 |
| v0.5 | 跑通 tabbar 全流程 + 加 button 验证 | 上述全部完成 |
| v1.0 | 接 page-doc bundle level | v0.5 验证后 |

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

## 设计依据

本 skill 的 8 步工作流 + 4 条核心规则,完全来自一次真实的 R3 Tabbar 走查实录,详见 [`references/lessons-from-r3-tabbar.md`](references/lessons-from-r3-tabbar.md)。这次走查也是 issue [#60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) 4 个 gap 的来源。

skill 与 issue 互为产物:skill 是 issue gap 修完后的「**正确做法**」固化;issue 是 skill 设计中暴露出来的「**wiki 不闭合点**」反馈。

## 怎么贡献(等 v0.2 启动后)

1. 等 issue #60 上游 PR 合并
2. fork 本仓库,基于 `feat/skill-design-md-to-relay` 分支起 v0.2 工作分支
3. 按 `references/workflow-8-steps.md` 实现各 step
4. 跑 tabbar 跑通了再扩 button 等其他组件
5. PR 回 fork → 评审 → 合并到上游
