---
file: interaction.md
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

# Toast · 交互规范

> Toast 的交互**最大特点是「没有交互」**——它不响应任何点击、滑动、长按。本文件主要规范的是**它自己的生命周期**:出现 → 持续 → 消失。

---

## 1. 生命周期(lifecycle)

```
触发 ─→ 入场 ─→ 持续 ─→ 出场 ─→ 销毁
       (200ms)  (2-3s)  (200ms)
```

| 阶段 | 时长 | 动效 |
|---|---|---|
| 入场 | 200ms | 透明度 0→1 + 轻微放大(0.96→1)+ `ease-out` |
| 持续 | 2s(短文本) / 3s(双行) | 静止,不响应交互 |
| 出场 | 200ms | 透明度 1→0(无缩放,避免「飞走」感) |

**Token 引用**:
- 入场 / 出场曲线:`motion.curves.standard`(`ease-out`)
- 入场时长:`motion.duration.fast`(200ms)
- 持续时长:**写死 2-3s,不进 Token**(语义性过强,Token 化无意义)

---

## 2. 加载特殊情况(loading-special-case)

> Toast 的 4 种 type 中,**`loading` 不遵循 2-3s 自动消失**——它的消失依据是「**外部异步任务完成**」。

```
loading toast 触发 → 显示 → 等待 → 任务完成事件 → 出场动画 → 销毁
                                  ↓
                    可替换为 success / error toast(不必先消失再出现)
```

**关键约束**:
- loading toast **不设最大显示时长**——但若超 5s 仍未完成,视为异步任务体验失败,应改为全屏 loading 或骨架屏
- loading toast **可被替换**:任务完成时,直接将 loading 替换为 success/error toast,**不要先消失再出现**(造成中间空白闪烁)

---

## 3. 队列(queue)

> 同屏**最多 1 条 toast**。后续触发的 toast **进队列**依次展示。

```
触发 toast A → A 入场 → A 持续 → 触发 toast B(此时 A 还在持续)
                                ↓
                              B 进队列
                                ↓
A 出场 → 间隔 100ms → B 入场 → B 持续 → B 出场
```

**约束**:
- 队列最大长度 **3 条**;超出丢弃最早的
- 同一会话内,**相同内容的 toast 触发时,合并为一条**(防止用户连点造成刷屏)
- loading toast 优先级最高:有 loading 在显示时,新 toast(非 loading)等待 loading 消失后再出

---

## 4. 模态边界(modal-boundary)

> Toast **不与模态共存竞争交互**,但层级始终在最上层。

| 当前界面 | 触发 toast 怎么办 |
|---|---|
| 普通页面 | 正常显示 |
| Sheet 半模态 / 全模态打开中 | Toast 显示在 Sheet **之上**(zIndex 最高) |
| Dialog 显示中 | Toast 显示在 Dialog **之上**(zIndex 最高) |
| 全屏 Loading | Toast **不显示**(避免与全屏 loading 冲突) |
| 系统通知 / 来电 | 由系统接管,Toast 不与之竞争 |

> 重要规则:Toast 永远在最上层,但**不会拦截**底层模态的交互——因为 Toast 本身不响应点击。

---

## 5. 不响应交互(no-interactive)

Toast **不响应**:
- 点击(无法手动关闭、无法跳转、无法触发 action)
- 滑动(无法滑掉、无法滑动复制文本)
- 长按(无法触发任何菜单)
- 键盘(VoiceOver 之外的键盘事件不处理)

**唯一例外**:VoiceOver / TalkBack 屏幕阅读器**可朗读** toast 文案(见 §6 a11y)。

详见 [[donts.md#1-不要在-toast-里放可点击元素no-interactive]]。

---

## 6. 无障碍(a11y)

| 要点 | 实现 |
|---|---|
| 屏幕阅读器播报 | toast 出现时自动 `announce(text)`,**polite 模式**(非中断式) |
| 减少动效 | 用户启用「减少动效」时,入场 / 出场动画改为瞬时切换(0ms) |
| 对比度 | 70% 黑蒙层 vs 白字 ≈ **8.5:1** ✓(WCAG AAA) |
| 持续时长 | 用户启用「无障碍延长展示时长」时,持续时间 × 2(2-3s → 4-6s) |

详见 [[horizontal/a11y/checklist.md]]。

---

## 7. 与 Token 的边界

- 动效曲线 / 时长 → [[../../tokens/motion.md]]
- 入场放大值 0.96→1 不进 Token(语义过强,只用于 Toast)
