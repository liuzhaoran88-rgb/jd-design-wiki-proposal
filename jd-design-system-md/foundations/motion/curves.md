---
file: curves
last_updated: 2026-05-06
relay_source:
  node_id: "358:2428"
sync_status: relay-aligned
---

# 缓动曲线 · Easing Curves

> Relay 15.0 定义 **4 类曲线**,**禁止自定义新曲线**。增加缓动曲线会使动效产生韵律感,更贴近自然真实的运动效果,避免僵硬机械化。

---

## 四类曲线一览

| Token | 贝塞尔 | 速度形态 | 性格 | 适用场景 |
|---|---|---|---|---|
| `motion.easing.standard` | `cubic-bezier(0.4, 0, 0.4, 1)` | 加速 → 减速 | 加速期短,减速期长 | 屏幕内固有元素 |
| `motion.easing.decelerate` | `cubic-bezier(0, 0, 0, 1)` | 最快 → 静止 | 进入,减速冲入 | 屏幕外元素入场 |
| `motion.easing.accelerate` | `cubic-bezier(1, 0, 1, 1)` | 静止 → 最快 | 退出,加速离开 | 屏幕内元素出场 |
| `motion.easing.spring` | `cubic-bezier(0.5, 1.4, 0, 1)` | 过冲回弹 | 弹性 | 营销 / 强交互 |

---

## 详细说明

### 1. 标准曲线 · standard
**`cubic-bezier(0.4, 0, 0.4, 1)`**

> 元素从静止开始加速运动,到达最高速度后开始减速直至静止。**加速阶段相对于减速阶段用时更少**,用户将会更加清楚地观察到动效的最终呈现结果,从而更清晰地了解状态的变化。

**适用**:屏幕内固有元素,如选择器、Tab 切换、开关等一直存在的组件。

### 2. 减速曲线 · decelerate
**`cubic-bezier(0, 0, 0, 1)`**

> 元素以最快速度进入屏幕,速度逐渐降低,让用户注意到关键信息的进入,在结束时完全停止。

**适用**:屏幕外元素入场,如吐司、弹窗、通知、半弹层等临时层入场的组件。

### 3. 加速曲线 · accelerate
**`cubic-bezier(1, 0, 1, 1)`**

> 元素以静止状态启动,逐渐加速,以速度最快时出场,快速离开减少遮挡时间。

**适用**:屏幕内元素出场,如内容删除和吐司、弹窗、通知、半弹层等临时层出场。

### 4. 弹性曲线 · spring
**`cubic-bezier(0.5, 1.4, 0, 1)`**

> 较小尺寸的组件或营销类场景,适当加入弹性效果可使动效更活泼灵动。

**适用**:营销气泡、营销场景化元素、强交互的 Icon 或组件。

---

## 选择决策树

```
动效是什么?
├── 屏幕内固有元素(Tab / 开关 / 选择器)→ standard
├── 屏幕外元素入场(吐司 / 弹窗 / 半弹层)→ decelerate
├── 屏幕内元素出场(吐司消失 / 弹窗关闭)→ accelerate
└── 营销 / 强交互(气泡 / 强交互 Icon)→ spring
```

---

## 与时长的配合

| 时长 | 入场 | 出场 |
|---|---|---|
| `s` (150ms) | `decelerate`(若屏外)/ `standard`(若屏内) | `accelerate` / `standard` |
| `m` (200ms) | `decelerate` | `accelerate` |
| `l` (300ms) | `decelerate`(屏外)/ `standard`(屏内,容器继承) | `accelerate` |

**规则**:
- 容器继承等屏内转场用 standard(进 / 出对称)
- 递进上浮 / 推屏跳转等进出场用 decelerate / accelerate(配对)

---

## 已废弃 / 待迁移

| v0.9 token | 状态 | 迁移 |
|---|---|---|
| `motion.easing.linear` | TODO | Relay 15.0 未规范;持续型动效(进度条 / Loading)若需要可保留,等待治理 |
| `motion.easing.emphasized` | deprecated | 与 `decelerate` 行为接近,直接使用 `decelerate` |

---

## 反例

| ❌ 反面 | 解释 |
|---|---|
| 自定义新曲线(不在 4 类) | 与 15.0 体系不一致 |
| 屏外入场用 `standard` | 应用 `decelerate` |
| 屏内出场用 `accelerate` | 应用 `standard`(屏内固有元素)|
| 主流程用 `spring` | spring 仅营销 / 强交互 |
| 长动效用 `linear`(机械感) | 京东不接受机械感 |
| 微交互用 `emphasized`(过戏剧)| 喧宾夺主,15.0 中已无此 token |
