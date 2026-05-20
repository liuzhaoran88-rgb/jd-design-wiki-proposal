---
file: design
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

references:
  uses_components:
{{uses_components_list}}
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

used_by: []
---

# {{name_zh}} · {{name_en}}

> 自动同步 {{today_iso}} · skill {{skill_version}} · Relay [`{{node_id}}`]({{relay_url}})

## 一句话定义

<!-- TODO: 设计师补充。一句话讲清这个组件是什么、解决什么问题。 -->

## 应用场景

### ✅ 用

<!-- TODO: 设计师列举什么场景下用 -->

### ❌ 不用

<!-- TODO: 设计师列举什么场景下不能用 -->

## 视觉

### 预览

![{{name_zh}}](./preview.png)
{{preview_warning_if_any}}

### 色彩

{{section_colors_table}}

{{token_miss_note_colors}}

### 文字

{{section_typography_table}}

### 圆角

{{section_radius_table}}

{{radius_warning_if_any}}

### 间距 / 布局

{{section_layout_table}}

{{spacing_warning_if_any}}

### 材质

{{section_materials}}

## 交互

<!-- TODO: 设计师描述手势、转场、状态切换、边界情况 -->

## 变体 Variants

{{section_variants_or_none}}

{{section_chapter_details_or_empty}}

## Donts

{{section_donts_auto_or_todo}}

## AI Schema

```yaml
# TODO: 设计师补充。AI 消费者通过这个区块了解组件语义。
component_type: {{slug}}
states:
  default: TODO
slots:
  TODO
events:
  TODO
```

## 关联

- 此组件归属：`level: {{level}}`, `bg: {{bg}}`
- V16 Foundation 引用：见 frontmatter `references.uses_tokens`
- 父级页面：（待 L3 录入后由 skill 反向填 `used_by`）
{{assets_cdn_link_or_empty}}

## 变更记录

| 时间 | 操作 | 来源 | 备注 |
|---|---|---|---|
| {{today_iso}} | 创建 | skill {{skill_version}} | 自动生成 / {{todo_count}} 处 TODO 待补{{flag_count_note}} |

---

{{auto_sync_findings_section}}
