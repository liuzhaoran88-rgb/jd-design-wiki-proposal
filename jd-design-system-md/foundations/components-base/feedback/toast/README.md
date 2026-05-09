---
component: Toast
zone: foundations
category: feedback
version: 0.1
status: experimental
owner: 综合业务设计组
ai_consumable: true
last_updated: 2026-05-09
relay_source:
  file_id: "2002743945242628098"
  page_id: "45:600"
  node_id: "45:11576"
  url: https://relay.jd.com/file/design?id=2002743945242628098&page_id=45%3A600&node_id=45%3A11576
sync_status: relay-aligned
sync_warning: "fileKey 非 15.0 SSOT(1896756863949619202),但 frame 顶部声明遵循 JD APP 15.0 GUIDELINE,Token 引用与 15.0 一致;待 Zone 大使下游 verify"
---

# Toast · 吐司

> 响应操作结果或提示状态变化的**轻量级**反馈组件。**关键特征:非模态、不可交互、自动消失**——它是用户感知系统状态的「弱信号」,但因为出现频率高,字段、时长、节奏的容错必须严苛。

---

## 30 秒摘要

| 维度 | 取值 |
|---|---|
| 类型 | `success`(成功) / `error`(失败) / `warning`(警告) / `loading`(加载) |
| 形态 | 纯文字 / 图标+单行 / 图标+双行(图标在文字上方) |
| 字数 | 建议不超过 12 字符,动词+形容词组合(如「加载中」「关注成功」「发送失败」) |
| 显示时长 | 2s–3s,加载完成后自动消失 |
| 关闭方式 | **强制自动消失**——非模态、无关闭按钮、不响应点击 |
| 容器 | 圆角 8pt / 蒙层底 70% 黑 `#000000b2` / 白字 |
| 文字字号 | 苹方 Regular/Medium · 15pt |
| 同屏数量 | **不超过 1 条**(后续 toast 进队列依次播放) |

---

## 文件结构

```
toast/
├── README.md           ← 你在这里
├── visual.md           视觉:容器/图标/字体/状态色
├── interaction.md      交互:时序/动效/堆叠/模态边界
├── content.md          内容:文案规则、字数上限
├── donts.md            反例集合(★ 必看)
├── ai-schema.md        AI 消费字段(YAML)
├── CHANGELOG.md
├── variants/           变体截图(P1 阶段补)
└── examples/           真实使用案例(P1 阶段补)
```

> 与 Button 的 multi-md 结构对比:Toast **不需要** `business.md`(非业务组件,不挂 KPI)、不需要 `research.md`(组件太轻量,无独立用研议题)、不需要 `experience.md`(信息架构极简)。这一裁剪符合 Tier 0 四份必填(README / visual / donts / ai-schema)+ 按需扩展原则。

---

## 维护责任

| 文件 | 主 owner | 副 owner |
|---|---|---|
| visual.md | 视觉设计师 | DS 维护组 |
| interaction.md | 交互设计师 | 前端工程师 |
| content.md | 内容运营 | UX writer |
| donts.md | **集体**(任何人发现新反例都可提交) | DS 维护组 review |
| ai-schema.md | DS 维护组 | AI 平台工程师 |

---

## 引用关系

**依赖**:
- [[foundations/tokens/color.md]] —— `color.semantic.*`(状态色) / `color.mask`(蒙层底) / `color.neutral.text-on-mask`(白字)
- [[foundations/tokens/typography.md]] —— 苹方 Regular/Medium 15pt
- [[foundations/tokens/spacing.md]] —— `spacing.12` / `spacing.16`(内边距、图标-文字间距)
- [[foundations/tokens/radius.md]] —— `radius.8`(容器圆角)
- [[foundations/tokens/motion.md]] —— `duration.fast` + `ease-out`(出现 / 消失)
- [[foundations/interaction/feedback.md]] —— Toast 是反馈体系成员,与 Loading / 空状态 / 错误状态分工
- [[horizontal/a11y/checklist.md]] —— VoiceOver 播报、对比度

**被依赖**:几乎所有需要"轻量结果反馈"的场景——加购成功 / 关注成功 / 删除成功 / 发送失败 / 加载中 …

**互斥**:Toast **不与 Dialog / Sheet 等模态共存竞争交互**;若需阻断用户操作请用 Dialog,Toast 不背这个责任。

---

## 版本与状态

- **当前版本**:v0.1(2026-05-09 初版)
- **状态**:`experimental` —— 首版从 Relay v15.0 GUIDELINE 「反馈类/吐司」节点抽取,待 Zone 大使评审晋升 `stable`
- **下一版**:v0.2 计划 —— 补 `variants/` 截图、补 `examples/` 真实用例、对比度核验、深色模式蒙层是否调整

---

## 快速判断:我该不该用 Toast?

```
要反馈一件事 → 是「立即操作的结果」吗?
              │
       ┌──────┴──────┐
       是             否
       │             │
       ↓             ↓
  ┌─是否短文本(≤12字)─┐    → 用 Dialog/Sheet,不要用 Toast
  │                  │
  是                  否
  │                  │
  ↓                  ↓
  Toast            截短到 12 字以内,再用 Toast;
                   或改成持续提示(NoticeBar)
```

**红线**:重要错误(支付失败 / 数据丢失风险)**永远不**用 Toast 单独承载——必须 Dialog 阻断。

---

## 我有问题,该看哪份 md?

| 问题 | 去哪 |
|---|---|
| Toast 容器是什么色? | [[visual.md#1-容器container]] |
| 加载中 toast 多久消失? | [[interaction.md#2-加载特殊情况loading-special-case]] |
| 文案最多写几个字? | [[content.md#1-字数硬约束max-length]] |
| 连续触发多个 toast 怎么办? | [[interaction.md#3-队列queue]] |
| 我能在 toast 里放按钮吗? | [[donts.md#1-不要在-toast-里放可点击元素no-interactive]](答案:不能) |
| AI 自动生成 toast 引用什么? | [[ai-schema.md]] |

---

## 来源声明

本组件首版从 Relay [反馈类/吐司](https://relay.jd.com/file/design?id=2002743945242628098&page_id=45%3A600&node_id=45%3A11576)节点取材生成。fileKey 非 15.0 SSOT,但内容声明遵循 JD APP 15.0 GUIDELINE,Token 引用与 15.0 一致——晋升 `stable` 前需 Zone 大使下游 verify。
