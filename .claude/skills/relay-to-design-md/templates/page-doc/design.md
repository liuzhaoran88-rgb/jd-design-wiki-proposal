---
file: design
bundle: page-doc          # v0.5: multi-md bundle 标识
level: {{level}}
bg: {{bg}}
slug: {{slug}}
name_zh: "{{name_zh}}"
name_en: "{{name_en}}"

owner: "{{owner}}"
contributors: []
status: draft
version: "0.1"
last_synced: "{{today_iso}}"

# skill 自动推断的字段。如不对，请改 frontmatter + mv 文件夹后告知。
# ⚠️ page-doc 模式：本文件是 index，详细规范拆到 spec.md / variants.md / behaviors.md。
auto_detected:
  level: {{level}}{{level_fallback_flag}}
  bg: {{bg}}{{bg_fallback_flag}}
  slug: "{{slug}}"{{slug_fallback_flag}}
  page_doc: true            # v0.4 自动判定（root.height > 5000 或 ≥ 3 个 FRAME 子项）

relay_source:
  file_id: "{{file_id}}"
  page_id: "{{page_id}}"
  node_id: "{{node_id}}"
  node_name: "{{node_name}}"
  node_type: {{node_type}}
  bounds: { w: {{node_w}}, h: {{node_h}} }
  url: "{{relay_url}}"

bundle_files:
  - design.md       # 本文件，index + frontmatter (含 relay_source 单点存储) + 章节链接
  - spec.md         # 视觉规范：token / colors / typography / radius / spacing / materials
  - variants.md     # 形态 / 状态 / 各维度变体
  - behaviors.md    # 应用场景 / 交互 / Donts / 多端适配（文字部分）
  - ai-schema.yaml  # 机器可读 schema（v0.5.1 从 behaviors.md 拆出）
  - CHANGELOG.md    # 跨 bundle 变更记录（v0.5.1 从 design.md 搬出）

references:
  uses_components:
{{uses_components_list}}

used_by: []
---

# {{name_zh}} · {{name_en}}

> 自动同步 {{today_iso}} · skill {{skill_version}} (page-doc bundle) · Relay [`{{node_id}}`]({{relay_url}})

## 这是 page-doc bundle

本组件来自 Relay page-doc 节点（高 {{node_h}}px，{{chapter_count}} 大章节），内容超出单 md 承载量，已按 v0.5.1 multi-md bundle 模板拆分为 **6 份**：

| 文件 | 内容 | 章节来源 |
|---|---|---|
| **[spec.md](./spec.md)** | 视觉规范：colors / typography / radius / spacing / materials | 章节 01-02 |
| **[variants.md](./variants.md)** | 形态 / 状态 / 坑位 / 子组件 各维度变体 | 章节 02-03 |
| **[behaviors.md](./behaviors.md)** | 应用场景 / 交互 / Donts / 多端适配 | 章节 04-05 |
| **[ai-schema.yaml](./ai-schema.yaml)** | 机器可读 schema（forms / slots / states / events ...） | 章节 01-05 抽取 |
| **[CHANGELOG.md](./CHANGELOG.md)** | 跨 bundle 变更记录 | — |
| **design.md**（本文件） | frontmatter（含 relay_source 单点存储）/ Relay 章节大纲 / 链接索引 | — |

## 一句话定义

{{section_one_liner_or_todo}}

## Relay 原稿章节大纲

{{section_chapter_outline_table}}

## 关联

- 此组件归属：`level: {{level}}`（page-doc bundle），`bg: {{bg}}`
- V16 Foundation 引用：见 [spec.md](./spec.md) 的 `references.uses_tokens`
- 父级页面：（待 L3 录入后由 skill 反向填 `used_by`）
{{assets_cdn_link_or_empty}}

## 变更记录

见 [CHANGELOG.md](./CHANGELOG.md)（v0.5.1：跨 bundle 变更记录搬到独立文件，design.md 保持薄 index 形态）。

---

{{auto_sync_findings_section}}
