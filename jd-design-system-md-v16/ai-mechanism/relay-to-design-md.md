---
zone: ai-mechanism
file: relay-to-design-md-skill
last_updated: 2026-05-18
status: released
version: v0.5.1
skill_path: .claude/skills/relay-to-design-md/
---

# 📥 /relay-to-design-md · Relay → design.md 录入

> 把 Relay 节点(单组件 OR page-doc 大节点)一键抽成 V16 编辑面的 `design.md`(单 md)或 **6 文件 bundle**(`design + spec + variants + behaviors + ai-schema.yaml + CHANGELOG.md`)。

本文档是 wiki 视角的索引页。**Skill 实现**在 `.claude/skills/relay-to-design-md/`,具体执行流程(8 步)见 [SKILL.md](../../.claude/skills/relay-to-design-md/SKILL.md)。

---

## 1. 它是什么

V16 体系下"编辑面"的入口 skill —— 把 Relay 设计稿的结构、token、章节、节点元数据,**机器抽**成符合 V16 frontmatter 约定的 `design.md` / bundle,**人写**(应用场景 / Donts / 行为准则等)留 TODO 占位让设计师补。

输出文件按 V16 目录约定落到:
```
jd-design-system-md-v16/<bg>/<level>/<slug>/design.md
                                        ├── spec.md
                                        ├── variants.md
                                        ├── behaviors.md
                                        ├── ai-schema.yaml
                                        └── CHANGELOG.md
```

---

## 2. 何时触发

| 场景 | 调用 |
|---|---|
| 用户给一个 Relay URL | `/relay-to-design-md <url>` |
| 用户说"把这个 Relay 节点录到 V16"/"抽成 design.md"/"page-doc bundle" | 主动调 |
| Relay 端节点改了 → 想同步 md | 主动调,bundle 模式下用 `.NEW` 后缀防覆盖 |

## 3. 不适用场景

| 场景 | 该走哪里 |
|---|---|
| 修单份 md 内容 | 手动 `Edit` |
| 出对外站点(总站) | `design-md-to-portal` |
| 出对外站点(单组件) | `design-md-to-spec-page` |
| 审单稿是否合规 | `design-review`(V15 范围,V16 走查 P2) |

---

## 4. 输入 / 输出

| | |
|---|---|
| 输入 | Relay 节点 URL(file_id + page_id + node_id) |
| MCP | `zero-design`(`get_design_metadata` / `get_design_context` / `use_design_script`) |
| 推断 | level(component-base / component-business / page / flow)/ bg(horizontal / vertical)/ slug / name_zh |
| 输出(普通组件) | `<slug>/design.md` 单文件 |
| 输出(page-doc 大节点) | 6 文件 bundle(v0.5.1)— design.md 作 index,relay_source 单点存储 |
| 已存在保护 | `<slug>/design.md` 已存在 → 改名 `.NEW` 后缀,**不覆盖**;v0.1 单 md → bundle 升级 → 全部 6 文件加 `.NEW` |

---

## 5. 当前版本(v0.5.1)的关键决定

- **6 文件 bundle**:`ai-schema.yaml` 独立(机器可读 schema 与人类文档分离)+ `CHANGELOG.md` 独立(design.md 保持薄 index)+ `relay_source` 单点存储到 design.md(子文件只留 `bundle_part_of` 反向指针)。改 Relay URL 只需改 1 处。
- **CHANGELOG.md 增量追加**:存在则 Read 原文件 → 表末追加一行 → 整体回写,**不覆盖**历史。
- **真文本抽取**:从 v0.4 起用 `get_design_context` 取 Relay 真文字(原 v0.1-v0.3 只能拿到节点几何属性 + variable 名)。

---

## 6. 与其他 skill 协作

```
Relay → /relay-to-design-md → design.md(编辑面)
                                  │
                                  ├─→ /design-md-to-portal → docs/design.html
                                  ├─→ /design-md-to-spec-page → <slug>/spec-page.html
                                  └─→ /design-review(V15)→ 5 段报告
```

- **上游**:Relay 是真相源,本 skill 是机器抽取入口
- **下游**:发布面两个 skill 都消费 `design.md` / bundle;审计面消费 Relay 节点 + tokens.json
- **平行约定**:发布面 skill 不修改 md,只读;本 skill 唯一可写 md 的 skill(除手动 Edit 外)

---

## 7. 演进路线

| 阶段 | 状态 |
|---|---|
| v0.1 单 md 抽取 | ✅ 已上线 |
| v0.2 slug 变体后缀 + token 反查 rgba 容差 | ✅ 已上线 |
| v0.3 page-doc 章节切分 + text bucket 分类 | ✅ 已上线 |
| v0.4 真文本抽取 + AI Schema 自动收 dont_rule | ✅ 已上线 |
| v0.5 multi-md bundle(4 文件) | ✅ 已上线 |
| **v0.5.1**(本) bundle 6 文件 + relay_source 单点 + CHANGELOG 增量 | ✅ **2026-05-18 已上线** |
| v0.6 page.md / flow.md 模板 + batch 模式 + Diff 模式(只更新机器抽取段) | 🔜 P1 |

---

## 8. 相关链接

- [SKILL.md](../../.claude/skills/relay-to-design-md/SKILL.md) —— 完整执行流程
- [references/auto-detect-rules.md](../../.claude/skills/relay-to-design-md/references/auto-detect-rules.md) —— level / bg / slug 推断规则
- [references/token-reverse-lookup.md](../../.claude/skills/relay-to-design-md/references/token-reverse-lookup.md) —— hex / fontSize / radius 反查 V16 token
- [templates/page-doc/](../../.claude/skills/relay-to-design-md/templates/page-doc/) —— 6 文件 bundle 模板
