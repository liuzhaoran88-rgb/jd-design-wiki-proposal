# 刘昭然 2026-05-18 跨 skill review 响应

> **2026-05-18** | 4 个 skill 系统性 review 触发的 8 PR 反馈环 / 9 个 issue / 4 份 shared/references

## 背景

2026-05-18 刘昭然完整读完 4 个 skill 的 SKILL.md(`design-review` / `design-md-to-site` / `design-md-to-spec-page` / `relay-to-design-md`),写出系统性 review,分:

- **🔴 跨 skill 系统性问题**(5 条)— 最大风险,影响整个 skill 联动
- **🟡 各 skill 内部问题**(15 条)— 工程债,影响维护
- **🟢 与顶层 design.md 的缺口**(1 条建议)

本文档记录这次 review 的响应:**8 PR 跨 5 轮(2026-05-18)闭环 13/20 条 + 7 条留 issue 跟踪**。

## 闭环状态总览

| 类别 | Liu 提的条数 | 已 PR 闭环 | 留 issue |
|---|---|---|---|
| 🔴 跨 skill 系统性 | 5 | 5 | 0 |
| 🟡 各 skill 内部 | 15 | 13 | 2(#45 / #46)|
| 🟢 顶层 design.md TOC | 1(建议)| 1(决策:不联动)| 0 |
| 实战暴露的工具自身缺口 | (review 没提)| 10(PR4 6 + PR5 4)| 0 |
| 实战暴露的设计系统层缺口 | (review 没提)| 0(超出工具范围)| 4(#35 / #36 / #37 / #38)|

**总计**: 8 PR / 9 issue(#35-38 内容 + V16 / #39-41 单 skill 母 issue / #45-46 follow-up)/ 4 份 shared/references

## 8 PR 时间线

### 跨 skill 系统性阶段(Liu 🔴)

| PR | 主合 commit | 解 Liu 条目 |
|---|---|---|
| **#29 PR1** | `2099439` | #3 level 词表两套 / #4 7 章节真相源 / #5 sharedPluginData namespace 治理 |
| **#30 PR2** | `eebf16f` | #1 design-review V15/V16 漂移 |
| **#31 PR3a** | `a08553e` | #2 design.md 没人审(design-review 加 design.md 模式 + 报告落文件) |
| **#32 PR3b** | `5802414` | #4 尾巴(Naming-conflict 抽 shared + relay 上游消费) |

**核心产物**:`.claude/shared/references/` 4 份共享真相源

```
level-vocab.md           # level 5 枚举 + 与 bg 边界
section-anchors.md       # 7 章节 canonical anchor slug
relay-namespaces.md      # sharedPluginData namespace 注册表
naming-conflict-rules.md # fingerprint 算法 + V15 已知冲突 + V15→V16 atom 延续
```

### 实战反馈环阶段(工具自我修正)

| PR | 主合 commit | 实战来源 | 工具修补条数 |
|---|---|---|---|
| **#33 PR4** | `e0f613b` | tabbar/design.md 首跑(bundle mode) | 6 |
| **#34 PR5** | `2006bac` | button/design.md 二跑(single mode) | 4 |

**核心机制**:**真实跑 design-review → 暴露 SKILL.md 描述漏洞 → 同一 PR 修工具 + 把产物入库当样例**。

PR4 修补点(tabbar 暴露):
1. Step 3b 反查没区分 role / atom 命名空间(9 条 atom 引用全误报)
2. Step 3b 未规定 typography role 反查归一化
3. Bundle mode 3b 数据源应从 spec.md 读
4. ai-schema.yaml / CHANGELOG.md 反向指针格式
5. Donts 上限 8 偏紧 → bundle 12
6. V15→V16 atom 层延续未追踪

PR5 修补点(button 暴露):
1. slug 语义启发(变体 vs 组件入口)
2. 段在但实质空判定 sub-rule(button 7 段全在但 4 段全 TODO 注释)
3. AI Schema 单 mode 内嵌 yaml block 检查
4. V16 spacing scale 真空 → 改报 ⚠️ V16-token-pending 而非 ❌ Off-token

### 单 skill 内部阶段(Liu 🟡)

| PR | 主合 commit | 关联 issue | 内部条数 |
|---|---|---|---|
| **#42 PR6** | `744d478` | closes #39 design-md-to-site | 4 |
| **#43 PR7** | `9cb1711` | closes #40 design-md-to-spec-page | 5 |
| **#44 PR8a** | `b13bd30` | tracks #41 relay-to-design-md | 4 / 6(剩 2 留 #45 / #46)|

## 反馈环节奏(实战 → 工具)

```
Liu review (2026-05-18 上午)
   ↓
PR1-3b 跨 skill 系统性闭环 (4 PR / 1 天)
   ↓
   实战 1: tabbar/design.md  →  PR4 修 6
   ↓
   实战 2: button/design.md  →  PR5 修 4
   ↓
PR6-8a 单 skill 内部修补 (3 PR / 4 + 5 + 4 = 13 条)
   ↓
开 issue #45 / #46 留 follow-up (大改)
   ↓
H 收尾文档(本文件)
```

收敛趋势:首跑 6 缺口 → 二跑 4 缺口,工具自我修正能力被实战验证。

## 4 份 shared/references 共享真相源

跨 skill 漂移的本质是**契约散落在各 skill 自己的 SKILL.md / references/**。本次反馈环抽出 4 份共享真相源 + 引导原则:

> **任何被 ≥2 个 skill 消费的契约都收在 `.claude/shared/references/`**,单 skill 私有规则留在该 skill 自己的 `references/`。

| 文件 | 谁消费 | 防漂作用 |
|---|---|---|
| `level-vocab.md` | 4 skill(relay 写 / site 分组 / spec-page 过滤 / design-review 校验) | 防 `bg` 值(如 `horizontal`)误当 level 用 |
| `section-anchors.md` | 3 skill(site / spec-page / design-review) | 7 章节 anchor slug 锁死,允许章节渲染深度差异化但 `id=` 不许漂 |
| `relay-namespaces.md` | 2 skill(relay-to-design-md / design-md-to-spec-page) | 防 sharedPluginData namespace 散落,清理契约统一登记 |
| `naming-conflict-rules.md` | 2 skill(design-review Step 3 前置 / relay-to-design-md Step 5.1 反查后) | fingerprint 算法 + V15 已知冲突表 + V15→V16 atom 延续追踪 |

## design-review 演进(5 PR 单 skill 重构)

design-review 经过 5 个 PR(PR2 / 3a / 3b / 4 / 5)从 V15-only Relay-only 演化到 V15/V16 双轨 + Relay + design.md 双模式 + 落文件 + 4 维校验:

| 版本 | 改 | 来源 |
|---|---|---|
| v0.1-0.4 | V15-only Relay-only 终端输出 | (历史)|
| v0.4 | (Liu review 起点) | Liu 2026-05-18 |
| **v0.5** | V15/V16 双轨,fileKey 路由 | PR2 |
| **v0.5.1** | 加 design.md 模式 + 落 design-review-report.md + 4 维校验 + 失败模式拆 Relay/md 两段 | PR3a |
| **v0.5.2** | Naming-conflict 抽 shared + 引用 | PR3b |
| **v0.6** | 实战 tabbar 6 处工具修补(atom 反查 / typography role 归一化 / bundle 数据源 / 反向指针 3 形式 / Donts 上限 mode 区分 / V15→V16 atom 延续) | PR4 |
| **v0.7** | 实战 button 4 处工具修补(slug 语义 / 段在但实质空 / single AI Schema 内嵌 yaml / V16 spacing 真空)| PR5 |

实战产物:
- `jd-design-system-md-v16/horizontal/components-base/tabbar/design-review-report.md`(174 行,bundle mode 黄金样例)
- `jd-design-system-md-v16/horizontal/components-base/button/design-review-report.md`(176 行,single mode 黄金样例)

## 当前开放 issues

| # | 类别 | 内容 | 待 |
|---|---|---|---|
| #35 | content | tabbar/button design.md 5 ❌ + 1 拍板 | 设计师 |
| #36 | v16-tokens | V16 spacing scale 建立 | V16 设计组 |
| #37 | v16-tokens | atom 真值核实(gray.6 / colortexthelp #888b94)| V16 设计组 |
| #38 | content | 子组件录入(joy-agent / icon-home)| V16 录入 |
| #41 | skill | relay-to-design-md 母 issue | 等 #45 / #46 |
| #45 | skill / 大改 | used_by O(N²) → backlinks 实时(需 bin/find-backlinks.sh)| 后续 PR |
| #46 | skill / 大改 | 5 处 TODO 强制反馈(status 联动 + validate.sh + CI block)| 后续 PR |

## 设计原则积淀

本次反馈环沉淀了几条引导设计原则,记录给未来 review 参考:

### 1. 单一真相源 / 防漂

> 任何被 ≥2 个 skill 消费的契约都抽到 `.claude/shared/references/`。修一处不更其他引用方 → 必加 grep 检测段(每份 shared reference 末尾有"变更规则"段)。

### 2. Zero-input + 事后审查(对齐 user memory)

> Skill 默认无 flag 跑能覆盖最常见场景。提供 flag 拆行为但**不拆 skill**(避免破坏一键完成)。例:design-md-to-spec-page 加 `--no-deploy` / `--dry-run` 而非拆 `spec-page-deploy` 独立 skill。

### 3. Fallback 永远兜底

> 任何依赖手动操作的资产(banner-art.png / preview.png / spacing token scale)都走"自动 fallback + 手动覆盖"模式,跑批永不卡住。

### 4. 实战驱动工具修补(反馈环)

> 工具 SKILL.md 描述只有跑过真实数据才能 verify。**首跑暴露 6 缺口,二跑暴露 4,收敛**。每次实战的产物入库当样例,未来重跑可对比。

### 5. 已知 tradeoff 显式化为契约

> 模板里不引入循环 DSL 是为了让模板"长得像最终产物",代价是循环段落由模型构造 — **这是契约不是缺陷**。把 tradeoff 写进 SKILL.md 比改实现更便宜。

### 6. V15→V16 命名启发标"待校"不静默

> design-review V15 启发跑到 V16 撞冲突时,不静默跳过 / 不强行套用,而是**报 ❌ + 加注"V15 启发,V16 待校"+ 开 follow-up issue**。让工具自我警示而非自我欺骗。

## 不解决的(明确不做)

| 条 | 理由 |
|---|---|
| Liu 🟢 顶层 design.md TOC 自动同步 | 写死"顶层 design.md 手写不联动"。理由:TOC 变更频率极低 + 你作为 owner 手动可控 + 多一个 skill 多一份漂移源 |
| 拆 `spec-page-deploy` 独立 skill | 违反 zero-input 偏好。加 flag(`--no-deploy`)即足够 |
| frontmatter-spec.md 与 level-vocab.md 4 vs 5 枚举值同步 | 影响小(`foundation` 当前没人用),引用统一指向 `level-vocab.md` 即可,未来 follow-up |

## 链接索引

- **PRs**: [#29](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/29) / [#30](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/30) / [#31](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/31) / [#32](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/32) / [#33](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/33) / [#34](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/34) / [#42](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/42) / [#43](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/43) / [#44](https://github.com/ShuaiMXu/jd-design-wiki-proposal/pull/44)
- **Issues**: [#35](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/35) / [#36](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/36) / [#37](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/37) / [#38](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/38) / [#41](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/41) / [#45](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/45) / [#46](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/46)
- **shared/references**: [level-vocab.md](../../.claude/shared/references/level-vocab.md) / [section-anchors.md](../../.claude/shared/references/section-anchors.md) / [relay-namespaces.md](../../.claude/shared/references/relay-namespaces.md) / [naming-conflict-rules.md](../../.claude/shared/references/naming-conflict-rules.md)
- **实战产物**: [tabbar/design-review-report.md](../../jd-design-system-md-v16/horizontal/components-base/tabbar/design-review-report.md)(174 行,bundle mode 样例)/ [button/design-review-report.md](../../jd-design-system-md-v16/horizontal/components-base/button/design-review-report.md)(176 行,single mode 样例)
