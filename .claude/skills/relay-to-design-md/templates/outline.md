---
file: design-outline
level: {{level}}
bg: {{bg}}
slug: {{slug}}
name_zh: "{{name_zh}}"
name_en: "{{name_en}}"
last_synced: "{{today_iso}}"

auto_detected:
  level: {{level}}{{level_fallback_flag}}
  bg: {{bg}}{{bg_fallback_flag}}
  slug: "{{slug}}"{{slug_fallback_flag}}

relay_source:
  file_id: "{{file_id}}"
  page_id: "{{page_id}}"
  node_id: "{{node_id}}"
  node_name: "{{node_name}}"
  node_type: {{node_type}}
  bounds: { w: {{node_w}}, h: {{node_h}} }
  url: "{{relay_url}}"
---

# {{name_zh}} · Outline

> 自动同步 {{today_iso}} · skill {{skill_version}} · Relay [`{{node_id}}`]({{relay_url}})

## 稿件预检

{{section_preflight}}

## 本次识别范围

{{section_scope_summary}}

## 结构大纲

{{section_outline_tree}}

## 变体 / 状态维度

{{section_variant_overview}}

## 组合形态

{{section_composition_overview}}

## 已识别 Tokens / 材质 / 子组件

{{section_tokens_summary}}

## 切图清单（待上传 CDN）

{{section_cutouts_or_none}}

## 待设计师确认

{{section_confirmation_needed}}

## 自动发现的风险

{{section_risks_or_none}}

## 说明

- 本文件用于正式 `design.md` 生成前的确认门
- 未确认前，不写 `design.md` / `INDEX.md` / `used_by`
- 未确认前，不回写 Relay sharedPluginData
