---
file: spec
bundle_part_of: design.md       # 反向指回 index；relay_source 单点存储在 design.md
slug: {{slug}}
last_synced: "{{today_iso}}"

# v0.5 page-doc bundle: 视觉规范
# 来源：Relay 节点 {{node_id}} 章节 01-02（设计原则 + 组件设计属性）
# v0.5.1 起 relay_source 单点存储在 design.md，本文件不重复

uses_tokens:
  colors:
{{tokens_colors_list}}
  typography:
{{tokens_typography_list}}
  radius:
{{tokens_radius_list}}
  spacing:
{{tokens_spacing_list}}
  materials:
{{tokens_materials_list}}
---

# {{name_zh}} · 视觉规范

> design.md → [index](./design.md) · 同 bundle: [variants](./variants.md) · [behaviors](./behaviors.md)

## 预览

![{{name_zh}}](./preview.png)
{{preview_warning_if_any}}

## 色彩

{{section_colors_table}}

{{section_colors_atom_table_or_empty}}

{{token_miss_note_colors}}

## 文字

{{section_typography_table}}

## 圆角

{{section_radius_table}}

{{radius_warning_if_any}}

## 间距 / 布局

{{section_layout_table_full}}

{{spacing_warning_if_any}}

## 材质

{{section_materials_table}}

---

## 章节原文（来源 Relay 章节 01-02）

{{section_chapter_01_02_full_text_or_empty}}
