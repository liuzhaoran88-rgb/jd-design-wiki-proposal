---
zone: ai-mechanism
file: design-md-to-portal-skill
last_updated: 2026-05-18
status: in-progress
version: v0.2
skill_path: .claude/skills/design-md-to-portal/
---

# 🏛 /design-md-to-portal · 总站门户聚合

> 把仓库内**所有**已存在的 `jd-design-system-md-v16/**/design.md` 一键聚合成一份 `docs/design.html`,作为 V16 设计系统对外的**总站门户**。

本文档是 wiki 视角的索引页。**Skill 实现**在 `.claude/skills/design-md-to-portal/`,具体执行流程见 [SKILL.md](../../.claude/skills/design-md-to-portal/SKILL.md)。

> 2026-05-18 改名:原 `design-md-to-site` → `design-md-to-portal`,跟姊妹 skill `design-md-to-spec-page` 在命名上拉开"总站门户 vs 单组件详情页"差异。

---

## 1. 它是什么

V16 体系下"发布面"的两个 skill 之一(另一个是 `design-md-to-spec-page`)。负责**多份 design.md → 一份 docs/design.html**:

- **glob 全扫**仓库内所有 V16 design.md(不扫 V15)
- **只读 frontmatter**(`slug` / `name_zh` / `name_en` / `level` / `bg` / `status` / `relay_source.url` / `version` / `last_synced`),不读正文
- 按"design.html 范式 PDF"渲染**示意黄头 + 7 圆点章节** section,大量 TBD 占位(预期多轮迭代)
- **全量重建、覆写**,不维护增量

---

## 2. 何时触发

| 场景 | 调用 |
|---|---|
| 用户调 `/design-md-to-portal` | 直接走 |
| 用户说"更新设计站"/"重建 design.html"/"发布最新设计系统"/"把新规范挂上站点" | 主动调 |
| 任意 design.md 新增 / 修改 → 想刷总站 | 主动调 |

## 3. 不适用场景

| 场景 | 该走哪里 |
|---|---|
| 单组件深挖详情页 | `design-md-to-spec-page` |
| 从 Relay 抽稿生成新 design.md | `relay-to-design-md` |
| 修单份 design.md 内容 | 手动 `Edit` |
| 审单稿是否合规 | `design-review` |
| 生成 V15 站点 | 不适用(本 skill 只扫 V16) |

---

## 4. 输入 / 输出

| | |
|---|---|
| 输入 glob | `jd-design-system-md-v16/**/design.md` |
| 不扫 | `jd-design-system-md/`(V15 已冻结) |
| 读取深度 | **只 frontmatter**(深度正文 TBD,本期不读) |
| 输出 | `docs/design.html`(单文件,**全量覆写**) |
| 截图资产 | 同目录 `preview.png` / `design-screenshot.png` → 没有则占位灰底 |
| banner 装饰图 | `docs/assets/banner-art.png`(手动 Relay 导出,不抓 MCP) |

---

## 5. 当前版本(v0.2)的关键决定

- **骨架优先,内容 TBD**:7 圆点章节(定义 / 行为准则 / 类型 / 结构 / 设计属性 / 典型场景 / 错误示例)全部预留占位,**故意不一次填满**,预期多轮迭代。详见 [[feedback_html_framework_loose]] 的产品节奏。
- **不调 Relay MCP / 不切图**:与 `design-md-to-spec-page` 的本质差异 —— 总站层级只索引,不深挖。
- **frontmatter-only**:解析按 YAML,**只**取顶层字段 + `relay_source.url`,深层结构 TBD。

---

## 6. 与其他 skill 协作

```
                                       /design-md-to-portal
                                        │
所有 V16 design.md  ───glob 扫────────────▶  docs/design.html
       │                                    (1 份总站)
       │
       └──── /design-md-to-spec-page ────▶ <slug>/spec-page.html
                                            (N 份单组件页)
```

**两个发布面 skill 不合并,职责分离**:

| | `design-md-to-portal` | `design-md-to-spec-page` |
|---|---|---|
| 输入 | 全部 design.md(glob) | 单 design.md / bundle |
| 输出 | 1 份 `docs/design.html` | N 份 `<slug>/spec-page.html` |
| 读多深 | 只 frontmatter | 全文 + 7 章节解析 |
| 切图 | ❌ 无 | ✅ chunked b64 + readback + jq |
| 类比 | 一本书的**目录 + 索引** | 一本书的**单章详情** |
| 触发节奏 | 新加组件 → 刷总站 | 单组件 md 改 → 刷详情 |

**轻量联动**(规划中,未做):
- portal 渲染 section card 时探测 `<bundle-dir>/spec-page.html` 存在 → 在 card 上加"📐 查看完整规范页"链接
- spec-page footer 加"⬅ 返回设计系统总站"面包屑

---

## 7. 演进路线

| 阶段 | 状态 |
|---|---|
| v0.1 单一骨架 + frontmatter 解析 | ✅ 已上线 |
| **v0.2**(本) PDF 范式对齐 + 7 圆点章节占位 + banner 装饰图约定 | 🟡 **2026-05 在做**(大量 TBD) |
| v0.3 正文摘要读取(读 `## 定义` / `## 行为准则` 段填进 card) | 🔜 P1 |
| v0.4 与 `design-md-to-spec-page` 反向链(card → spec-page) | 🔜 P1 |
| v0.5 mermaid 自动生成(component 关系图,从 frontmatter `references` 字段) | 📋 P2 |
| v1.0 全章节填满 + 改名为生产可用 | 🎯 P3 |

---

## 8. 相关链接

- [SKILL.md](../../.claude/skills/design-md-to-portal/SKILL.md) —— 完整执行流程
- [references/site-template.html](../../.claude/skills/design-md-to-portal/references/site-template.html) —— 完整 HTML 骨架 + 占位符
- [references/header-template.md](../../.claude/skills/design-md-to-portal/references/header-template.md) —— 16.0 GUIDELINE banner 板式
- [docs/design.html](../../docs/design.html) —— 当前产物
