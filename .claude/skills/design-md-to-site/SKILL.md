---
name: design-md-to-site
description: 把 jd-design-system-md-v16/**/design.md 集合一键聚合成 docs/design.html —— 一份对外公开的 16.0 GUIDELINE 设计系统总站。零输入、全量重建、覆写。仅做骨架，大量 section 留 TBD 占位，预期多轮迭代。Triggered by /design-md-to-site or verbs like "更新设计站", "重建 design.html", "发布最新设计系统", "把新规范挂上站点".
allowed-tools: [Bash, Read, Write, Edit, Glob]
---

# /design-md-to-site · design.md 集合 → docs/design.html

把仓库内**所有**已存在的 `design.md`（V16 规范源）聚合成一份 `docs/design.html` 对外站点。

**职能边界**（与姊妹 skill 配套）：

| Skill | 输入 | 输出 | 用户 |
|---|---|---|---|
| `relay-to-design-md` | Relay URL | `design.md`（编辑面） | 设计师 maintainer |
| **`design-md-to-site`（本）** | `design.md` 集合 | `docs/design.html`（发布面） | 公开站访客 |

本 skill **不调 Relay MCP**，**不**修改任何 `design.md` 源 —— 只读 + 渲染 + 覆写发布产物。

## 何时触发

满足任意一项：

- 用户调 `/design-md-to-site`
- 用户说「更新设计站」/「重建 design.html」/「把新规范挂上站点」/「发布最新设计系统」
- 任何一份 `design.md` 新增 / 修改后，希望对外站点同步

## 不适用场景

| 场景 | 该走哪里 |
|---|---|
| 从 Relay 抽稿生成新 `design.md` | `relay-to-design-md` |
| 修单份 `design.md` 内容 | 手动 `Edit` |
| 审单份稿是否合规 | `design-review` |
| 生成 V15 站点 | 不适用（本 skill 只扫 V16） |

## 输入解析

- **glob**：`jd-design-system-md-v16/**/design.md`（递归全量）
- **不扫**：`jd-design-system-md/`（V15 已冻结）
- 每份只读 **frontmatter**（不读正文，正文将来由「点详情」按需加载，本期 TBD）

### 必读 frontmatter 字段

| 字段 | 用途 | 缺失兜底 |
|---|---|---|
| `slug` | section id + TOC 锚点 | 从文件路径推断 |
| `name_zh` | section 标题 + TOC 文案 | `slug` |
| `name_en` | section 副标题 | 空 |
| `level` | section 分组（component-base / foundation / ...） | `uncategorized` |
| `bg` | 业务背景标签 | 空 |
| `status` | 角标（draft / wip / stable） | `draft` |
| `relay_source.url` | 源链接 | 空 |
| `version` | 版本号 | `0.0` |
| `last_synced` | 抓取时间 | 空 |

> **不强制**正文格式 —— 缺字段就 fallback，不报错退出。

### 配套资源

每份 spec **可选**有一张同目录截图（推测约定：`preview.png` / `design-screenshot.png`）。skill 启动时按以下顺序探测，命中即用，找不到就用占位灰底：

1. 同目录 `preview.png`
2. 同目录 `design-screenshot.png`
3. 占位灰底（CSS `background: #f0f0f0`）

### banner 装饰图资产

`docs/design.html` 顶部 banner 右侧的装饰图（Relay 节点 `6:229;6:10`，548×240）走**手动导出**约定：

- 设计师在 Relay 桌面端选中节点 → Export PNG → 落 `docs/assets/banner-art.png`
- skill 本身**不**抓这张图（MCP `get_screenshot` 返回内联截图，没法落盘）
- HTML 中已预置 fallback 径向渐变；PNG 缺失时仍能正常渲染（只是装饰差点意思）

详细规范见 `docs/assets/README.md`。

## 工作流

### Step 1 · 扫所有 design.md

```bash
find jd-design-system-md-v16 -name "design.md" -type f
```

### Step 2 · 解析每份 frontmatter

逐份读首 `---` ~ `---` 段，提取上表字段。frontmatter 解析按 YAML，但**只**取顶层 + `relay_source.url`，深层结构 TBD。

### Step 3 · 按 PDF 范式渲染 sections

每份 spec 按「design.html 范式」（见 `docs/design.html` v0.2）输出**示意黄头 + 7 圆点章节**：

| 章节（PDF 顺位） | 必/选 | 数据源 |
|---|---|---|
| 示意黄头 | — | `name_zh` / `name_en` / `status` / `version` / `relay_source.url` |
| `{{name_zh}} 定义` | 必写 | 正文 `## 定义` 段，缺则 TBD |
| `行为准则` | 选写 | 正文 `## 行为准则` 段，缺则 TBD |
| `{{name_zh}} 类型` | 选写 | frontmatter `variants` 或 references/variant-vocab，缺则 TBD |
| `{{name_zh}} 结构` | 必写 | 正文 `## 结构` 段，缺则 TBD |
| `设计属性` | 必写 | frontmatter `uses_tokens` 渲染表 + 正文 `## 属性` 段 |
| `典型场景示意` | 必写 | 同目录 `preview.png` + `relay_source.url` |
| `错误示例` | 选写 | 正文 `## 错误示例` 段，缺则 TBD |

**渲染规则**：
1. 复制 `references/site-template.html` 末尾的 **SPEC_SECTION 模板**
2. 替换 `{{spec_*}}` 占位符
3. 缺失字段保留 `<!-- TBD -->` 注释 + 一句话占位文案（不报错）

### Step 4 · 拼接 sections

- `{{spec_sections}}`：所有 spec sections 串联，按 frontmatter `level` 分组（component-base / foundation / horizontal）
- `{{generated_at}}`：ISO 时间戳
- **顶部 banner 和「规范要素参考」蓝框是固定的**，已写在 site-template.html 主体内，不需替换

### Step 5 · 覆写 docs/design.html

```bash
# 不 append，每次全量重建
```

写完跑 `git diff docs/design.html` 给用户看，等他 review。

## 输出契约（v0.2 PDF 范式）

`docs/design.html` 必须包含：

- ✅ **顶部唯一 banner**（16.0 GUIDELINE 板式，全站只一次）
- ✅ **规范要素参考蓝框**（按 PDF 完全照搬 7 条，固定不动）
- ✅ 每份 spec：**示意黄头 + 7 圆点章节**（定义 / 行为准则 / 类型 / 结构 / 设计属性 / 典型场景 / 错误示例）
- ✅ 页脚生成时间戳

**不要**：
- ❌ 每个 spec 再加 banner —— 顶部已唯一，spec 内只用 `<h3>` 圆点
- ❌ 加全站 TOC —— PDF 范式没有 TOC，长文章自然流式阅读

详见 `references/site-template.html` 顶部注释和文件末尾的 SPEC_SECTION 模板。

## 偏好默认值（无需追问）

| 项 | 默认 |
|---|---|
| 输入 glob | `jd-design-system-md-v16/**/design.md` |
| 输出路径 | 仓库根 `docs/design.html` |
| 截图相对路径 | 从 `docs/design.html` 看，是 `../jd-design-system-md-v16/.../preview.png` |
| 缺 frontmatter 字段 | 按上表 fallback，不报错 |
| 缺截图 | 占位灰底 |
| 全量重建 | 是，每次覆写 |
| 触发节奏 | 用户手动 `/design-md-to-site`，**不自动**跟 design.md 变更联动 |

## 与其他 skill 的关系

- `relay-to-design-md` 上游：先有 `design.md`，再聚合
- `design-review` 平行：reviews `design.md`，本 skill 渲染同一份
- 4 份手写 HTML（executive-summary / master-diagram / knowledge-tree / contributor-guide）：与本 skill 产出的 `design.html` **同级共存**在 `docs/` 下，footer 互链 TBD

## 参考资源

- `references/header-template.md` —— 16.0 GUIDELINE banner 板式（HTML 块 + 占位符 + 设计参数）
- `references/site-template.html` —— 完整站点 HTML 骨架 + SPEC_SECTION 模板 + 所有 TBD 占位
- `references/design-html-paradigm.pdf` —— **范式真相源**：design.html 文档范式 PDF（顶部 banner + 规范要素参考蓝框 + 示意黄头 + 7 圆点章节）。改板式结构前先重读这份 PDF。
