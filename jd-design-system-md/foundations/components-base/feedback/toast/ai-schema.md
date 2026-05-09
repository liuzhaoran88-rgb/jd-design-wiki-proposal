---
file: ai-schema.md
parent: toast
zone: foundations
category: feedback
last_updated: 2026-05-09
relay_source:
  file_id: "2002743945242628098"
  node_id: "45:11576"
  url: https://relay.jd.com/file/design?id=2002743945242628098&page_id=45%3A600&node_id=45%3A11576
sync_status: relay-aligned
---

# Toast · AI Schema

> 本文件是给 **AI / 工具链** 消费的机器可读字段。design-review skill / 自动校验工具 / 组件生成器都依赖此处。

---

```yaml
component: Toast
zone: foundations
category: feedback
version: 0.1
status: experimental
ai_consumable: true

# 类型(强制 4 选 1)
types:
  - id: success
    icon: check
    semantic_color: color.semantic.success
    default_text_pattern: "{verb}成功"
  - id: error
    icon: cross
    semantic_color: color.semantic.danger
    default_text_pattern: "{verb}失败"
  - id: warning
    icon: exclamation
    semantic_color: color.semantic.warning
    default_text_pattern: "{verb}{warning_state}"
  - id: loading
    icon: spinner
    semantic_color: null
    default_text_pattern: "{verb}中"
    auto_dismiss: false   # loading 由外部任务完成事件驱动消失

# 形态(自适应,由内容决定)
variants:
  - id: text-only
    name: 仅文字
    has_icon: false
    has_subtext: false
    container_height_pt: 46
  - id: icon-text-inline
    name: 图标+单行
    has_icon: true
    has_subtext: false
    container_height_pt: 46
    icon_position: left
  - id: icon-text-stacked
    name: 图标+双行
    has_icon: true
    has_subtext: true
    container_width_pt: 200
    container_height_pt: 98
    icon_position: top

# 字段约束
slots:
  text:
    required: true
    max_chars_zh: 12
    max_chars_en: 24
    style: "动词+形容词组合"
    forbidden_patterns: ["疑问句", "完整长句", "单字"]
  subtext:
    required: false
    max_chars_zh: 24
    max_chars_en: 48
    only_for_variant: icon-text-stacked

# 时长(单位:毫秒)
duration:
  enter_ms: 200
  display_short_ms: 2000   # 单行
  display_long_ms: 3000    # 双行
  exit_ms: 200
  loading_max_ms: 5000     # 超过即视为体验失败,改用全屏 loading

# 容器
container:
  background_token: color.mask
  background_value: "#000000b2"
  text_color_token: color.neutral.text-on-mask
  text_color_value: "#ffffff"
  radius_token: radius.8
  radius_value: 8
  padding_horizontal_token: spacing.16
  padding_vertical_pt: 13
  shadow: none

# 字体
typography:
  font_family: "PingFang SC"
  font_size_pt: 15
  weight_regular: 400
  weight_medium: 500
  line_height: 15

# 位置
position:
  alignment: center
  x_offset_pt: 0
  y_offset_pt: 0
  vertical_anchor: center

# 交互边界
interaction:
  clickable: false
  swipeable: false
  longpressable: false
  copyable: false
  manual_dismissable: false
  auto_dismiss: true
  modal: false
  blocks_underlying_ui: false
  z_index: highest

# 队列
queue:
  max_concurrent: 1
  queue_max_length: 3
  duplicate_dedup: true
  inter_toast_gap_ms: 100

# 互斥关系
exclusive_with:
  - FullscreenLoading

# 与其他模态的层级关系(Toast 始终最上)
above:
  - Dialog
  - Sheet
  - Page

# 无障碍
a11y:
  voiceover_announce: required
  voiceover_polite: true        # 非 assertive,不打断当前播报
  reduce_motion_fallback: instant
  contrast_ratio: 8.5
  contrast_ratio_meets: WCAG_AAA
  duration_extend_factor: 2     # 启用「延长展示」时持续时间 ×2

# 红线约束(违反即报错)
constraints_hard:
  - text_length_must_le_12_zh_chars
  - no_interactive_children
  - no_critical_error_only_via_toast
  - no_progress_indicator_in_loading_toast
  - no_brand_primary_as_background

# 软约束(违反需 review)
constraints_soft:
  - prefer_variant_a_or_b_over_c
  - avoid_frequent_trigger
  - prefer_short_4_to_8_chars

# 关联资源
dependencies:
  tokens:
    - color.mask
    - color.neutral.text-on-mask
    - color.semantic.success
    - color.semantic.danger
    - color.semantic.warning
    - radius.8
    - spacing.12
    - spacing.16
    - typography.body.regular.15
    - typography.body.medium.15
    - motion.duration.fast
    - motion.curves.standard
  components:
    - Icon
  related:
    - foundations/interaction/feedback.md
    - horizontal/a11y/checklist.md

# 不应用于的场景(给 AI 校验"是否该用 Toast"用)
not_for:
  - critical_error_blocking_user
  - long_text_over_12_zh
  - require_user_action
  - data_user_must_remember
  - copyable_content
```

---

## 引用规范

design-review skill 调用本 schema 的方式(伪代码):

```python
schema = load_yaml("foundations/components-base/feedback/toast/ai-schema.md")

# 字数硬约束校验
text_len = len(toast_text)
if text_len > schema["slots"]["text"]["max_chars_zh"]:
    raise ConstraintViolation(
        rule="text_length_must_le_12_zh_chars",
        actual=text_len,
        limit=schema["slots"]["text"]["max_chars_zh"]
    )

# 红线场景校验
if scenario == "critical_error_blocking_user":
    if used_component == "Toast":
        raise ConstraintViolation(
            rule="no_critical_error_only_via_toast",
            recommendation="使用 Dialog 替代"
        )
```
