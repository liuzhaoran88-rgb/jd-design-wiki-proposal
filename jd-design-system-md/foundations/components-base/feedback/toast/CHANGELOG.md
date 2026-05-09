---
file: CHANGELOG.md
parent: toast
zone: foundations
category: feedback
last_updated: 2026-05-09
---

# Toast · CHANGELOG

> 版本规则遵循 SemVer。Breaking change 必须走 governance 评审。

---

## v0.1 · 2026-05-09(初版)

**新增**:
- `README.md` / `visual.md` / `interaction.md` / `content.md` / `donts.md` / `ai-schema.md`
- 来源:Relay file `2002743945242628098` 的「反馈类/吐司」(node `45:11576`)
- 4 种 type:`success` / `error` / `warning` / `loading`
- 3 种形态:`text-only` / `icon-text-inline` / `icon-text-stacked`
- 字数硬约束 12 中文字符;时长 2-3s;loading 由任务事件驱动消失
- 队列规则:同屏 1 条,duplicate dedup,队列长 3
- a11y:VoiceOver 自动 announce、对比度 8.5:1(AAA)、reduce-motion fallback

**待补**:
- `variants/` 截图(P1 阶段补)
- `examples/` 真实使用案例(P1 阶段补)
- 深色模式(系统暗黑)下蒙层是否调整 — 待视觉决定

**已知风险**:
- fileKey `2002743945242628098` 非 memory 记录的 15.0 SSOT(`1896756863949619202`),内容声明遵循 15.0 GUIDELINE,Token 引用一致;待 Zone 大使下游 verify 后晋升 `stable`
- design-review skill 尚未对接 ai-schema.md 的 hard constraints(列入 P1 工具链路线)
