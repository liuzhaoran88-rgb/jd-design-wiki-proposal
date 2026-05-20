---
zone: horizontal
last_updated: 2026-04-29
---

# 🚀 横向专项 · Horizontal

> 跨部门治理、横向规则、品牌资产、多端适配、设计系统治理。**这里是"超过单一组件 / 单一事业部"的规则集**。

---

## 5 大横向板块

| 板块 | 文档 | 用途 |
|---|---|---|
| ♿ [[a11y/README.md]] | 无障碍 | WCAG 2.1 AA / 适老 / 极端字号 |
| 🎨 [[brand/README.md]] | 品牌与运营 | Logo / 京东红 / Joy / 大促 / 子品牌 |
| 📱 [[multi-platform/README.md]] | 多端适配 | iOS / Android 差异 / 折叠屏 / 深色 / 字号 |
| 🏛 [[governance/README.md]] | 治理 | 流程 / 评审 / 版本 / 责任人 |
| 🎴 [[double-column-card/README.md]] | 双列卡专项 | 跨部门双列卡治理(已有 Skill)|

---

## 横向 vs 其他 Zone

| Zone | 关注 |
|---|---|
| Zone 2 Foundations | 全公司共用的 Token + 原子组件 |
| Zone 4 组织架构 | 各事业部各自维护 |
| **Zone 5 Horizontal** | 跨事业部规则 + 横向资产 + 治理 |

---

## 何时进入 Horizontal

判断标准:
- 规则适用于多个事业部 → Horizontal
- 资产是品牌级别(Logo / Joy)→ Horizontal/brand
- 治理流程跨多个组件 → Horizontal/governance
- 多端适配(iOS / Android / 折叠屏)→ Horizontal/multi-platform
- 跨业务一致性问题(如双列卡)→ Horizontal/{specific}

**不进 Horizontal**:
- 单一事业部内的规则 → Zone 4 该 BG 目录
- 单一组件的细则 → Zone 2 该组件目录

---

## 与 Zone 3 AI 机制的边界

- **Zone 3 AI 机制**:协议 / 工具链 / Schema / Skill 制作
- **Zone 5 Horizontal**:规则内容 / 流程 / 治理

横向 Skill(如双列卡)的:
- **规则内容**(family DNA / L1-5 规约) → Zone 5
- **Skill 实现**(SKILL.md / prompts/ / agentskills.io 标准) → Zone 5(因为是横向资产)
- **AI 协议**(怎么调用 Skill) → Zone 3
