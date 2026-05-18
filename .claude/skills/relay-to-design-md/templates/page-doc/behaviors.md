---
file: behaviors
bundle_part_of: design.md       # 反向指回 index；relay_source 单点存储在 design.md
slug: {{slug}}
last_synced: "{{today_iso}}"

# v0.5 page-doc bundle: 应用场景 / 交互 / Donts / 多端适配（文字部分）
# 来源：Relay 节点 {{node_id}} 章节 04-05 + 跨章节 dont_rule 聚合
# v0.5.1 起 AI Schema 抽到独立 ai-schema.yaml；relay_source 单点存储在 design.md
---

# {{name_zh}} · 交互 / 禁止 / 适配

> design.md → [index](./design.md) · 同 bundle: [spec](./spec.md) · [variants](./variants.md)

## 应用场景

### ✅ 用

{{section_use_cases_or_todo}}

### ❌ 不用

{{section_anti_cases_or_todo}}

## 交互

{{section_interactions_or_todo}}

## Donts

{{section_donts_auto_or_todo}}

## AI Schema

> v0.5.1 起抽到独立机器可读文件 → [`ai-schema.yaml`](./ai-schema.yaml)
>
> {{section_ai_schema_summary}}

## 多端适配

{{section_multi_platform_adapt}}

---

## 章节原文（来源 Relay 章节 04-05）

{{section_chapter_04_05_full_text_or_empty}}
