---
zone: ai-mechanism
last_updated: 2026-05-18
---

# 🤖 AI 机制 · AI Mechanism (V16)

> 把 V16 设计系统的"编辑面 ↔ 发布面 ↔ 审计面"用 AI Skill 串起来。**这里不是写"AI 怎么用",而是写"AI 用什么协议跟 V16 对话"**。

V15 同名目录见 [[../../jd-design-system-md/ai-mechanism/README.md]](还在维护中,V15 token 走查仍走那边)。

---

## V16 Skill 全景

| Skill | 输入 | 输出 | 当前状态 | wiki 索引 |
|---|---|---|---|---|
| [`relay-to-design-md`](.claude/skills/relay-to-design-md/) | Relay URL | `design.md` / page-doc bundle(编辑面) | **v0.5.1**(6 文件 bundle) | [[relay-to-design-md.md]] |
| [`design-md-to-portal`](.claude/skills/design-md-to-portal/) | 所有 `design.md`(glob) | `docs/design.html`(发布面 · 总站门户) | v0.2 骨架 + TBD | [[design-md-to-portal.md]] |
| [`design-md-to-spec-page`](.claude/skills/design-md-to-spec-page/) | 单 `design.md` / bundle | `<slug>/spec-page.html`(发布面 · 单组件) | **v0.5**(增量启发) | [[design-md-to-spec-page.md]] |
| [`design-review`](.claude/skills/design-review/) | Relay URL | 5 段式 markdown 报告(审计面) | v0.1.1 已上线 | 仍按 V15 走查,见 [[../../jd-design-system-md/ai-mechanism/design-review.md]] |

> Skill 实现路径都在仓库根 `.claude/skills/<name>/` —— Claude Code 加载约定要求该路径,**不可挪动**。本目录下的 md 是 **wiki 视角的索引页**(从设计系统的角度讲"这个 skill 在 V16 体系里担什么职"),具体执行流程见各 skill 的 `SKILL.md`。

---

## 数据流(V16 三面)

```
            ┌─────────────────────────────────────────────┐
            │              Relay(设计源)                │
            └──────────────┬──────────────────────────────┘
                           │
                ┌──────────┴──────────┐
                ▼ (录入)              ▼ (审计)
    /relay-to-design-md          /design-review
                │                    │
                ▼                    ▼
   ┌─────────────────────┐    5 段式报告
   │  design.md / bundle │    (PR comment / Slack)
   │  (V16 编辑面)        │
   └──────────┬──────────┘
              │
    ┌─────────┴─────────┐
    ▼ (聚合)            ▼ (单组件深挖)
/design-md-to-portal  /design-md-to-spec-page
    │                  │
    ▼                  ▼
docs/design.html   <slug>/spec-page.html
   (总站门户)        (单组件规范页)
              │
              ▼
       GitHub Pages
       (公开发布面)
```

---

## 职能分工(编辑面 / 发布面 / 审计面)

- **编辑面**(谁写规范)
  - `relay-to-design-md` 把 Relay 节点抽成 md(自动 + TODO 占位)
  - 设计师手动 Edit 补 md 的人写段
- **发布面**(谁出对外站点)
  - `design-md-to-portal` 出**总站门户**(`docs/design.html` 一份)
  - `design-md-to-spec-page` 出**单组件规范页**(每组件一份 `spec-page.html`)
  - 两者职责分离,不合并,详见 [[design-md-to-portal.md]] / [[design-md-to-spec-page.md]] 的"与其他 skill 协作"段
- **审计面**(谁查合规)
  - `design-review` 给 Relay 节点出走查报告(V15 token 体系,V16 token 体系开发中)

---

## 跟 V15 ai-mechanism 的关系

V15 的 ai-mechanism 体系侧重**协议**(naming-bem / token-sync / schema-spec / agent-protocol)+ **走查 skill**(design-review)。V16 暂只继承走查 skill,新增**录入 + 发布** 三件套(`relay-to-design-md` / `design-md-to-portal` / `design-md-to-spec-page`),因为 V16 阶段的瓶颈是"怎么把 Relay 规范快速落成 md + HTML",而 V15 协议层还稳定。

未来计划:
- `relay-to-design-md` 加 page / flow 模板(v0.6,L2/L3/L4 节点)
- `design-md-to-portal` 从 v0.2 骨架 → v1.0 全章节填满
- 新增 `design-md-to-spec-v16-review`(V16 token 体系的走查 skill,接替 design-review V15 范围)→ 还在 P2

---

## 维护责任

| 角色 | 职责 |
|---|---|
| 平台基础设计组 | 决定哪些 skill 加进 V16 主链路 |
| AI 机制组 | 维护 SKILL.md 工作流;升级判定规则 |
| 业务设计师 | 跑 skill + 反馈实际产物质量(漏字段 / 误推断 / 占位太多) |
| 工程组 | 把 SKILL.md 提到的 helper(如 `_mtime` / `_iso_to_ts`)保持跨平台 |
