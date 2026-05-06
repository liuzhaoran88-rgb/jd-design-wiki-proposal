---
token_category: motion
last_updated: 2026-05-06
relay_source:
  file_id: "1896756863949619202"
  page_id: "44:1827"
  node_id: "358:2428"
  url: https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=358%3A2428
sync_status: relay-aligned
---

# 动效 Token · motion

> 京东 15.0 动效 = **3 维度参数 (变化方式 + 持续时间 + 缓动曲线) + 3 阶时长 + 4 类曲线 + 3 类转场**。本文档与 [JD APP 15.0 设计语言 / 基础视觉设定 / 动效](https://relay.jd.com/file/design?id=1896756863949619202&page_id=44%3A1827&node_id=358%3A2428) 同步。
>
> **铁律**:动效 Token 引用强约束 —— 组件 visual.md 不允许写裸数字。

> **2026-05-06 同步说明**:本次将 v0.9 草案的 6 阶时长 (instant/immediate/fast/normal/slow/slower) 和 6 阶缓动 (linear/standard/decelerate/accelerate/spring/emphasized) 收敛到 Relay 15.0 实际投产的 **3 阶时长 (150/200/300ms) + 4 类曲线 (标准/减速/加速/弹性)**。多余阶梯标 TODO,等待治理流程升级或废弃。

---

## 1. 动效三维度

| 维度 | 含义 | Token 命名 |
|---|---|---|
| **变化方式** | 透明度 / 形状 / 颜色 / 旋转 / 缩放 / 位移 6 类 | 不作为单独 token,组件层定义 |
| **持续时间** | 150 / 200 / 300ms 三阶 | `motion.duration.*` |
| **缓动曲线** | 标准 / 减速 / 加速 / 弹性 4 类 | `motion.easing.*` |

**变化方式约束**:
- 透明度、形状、颜色 — 无固定数值,以视觉为准
- 旋转、缩放、位移 — 必须遵循「持续时间 + 缓动曲线」组合

---

## 2. 时长 · duration

> 持续时间按对象尺寸定义,**保证各类面积运动时在体感上达成一致**。引用自 Material Design 与 Windows 官方动效指南:< 100ms 为瞬时动效难识别,> 1000ms 有明显迟滞,最佳区间 100-500ms。

| Token | 值 | 适用尺寸 | 典型场景 |
|---|---|---|---|
| `motion.duration.instant` | 100ms | 可感知最短 | 瞬时反馈,边界值,慎用 |
| `motion.duration.s` | 150ms | 小尺寸 | 开关、选择器等小型组件;**所有出场默认值** |
| `motion.duration.m` | 200ms | 中尺寸 | 弹窗、吐司提示等中型组件入场 |
| `motion.duration.l` | 300ms | 大尺寸 | 半弹层、页面级转场入场 |

**铁律 — 进出场时机**:
- **进场**遵循尺寸对应时间(s / m / l 选一)
- **出场降低一个时间梯度**(便于在进场时关注入场元素,出场时快速离开提升效率)
  - l (300ms) → m (200ms)
  - m (200ms) → s (150ms)

> v0.9 中的 `slow=500ms` / `slower=800ms` 在 15.0 主流程中**不规范**,标记为 deprecated,等待迁移到 `motion.duration.l` 或装饰主题包。

---

## 3. 缓动 · easing

> 4 类曲线按运动「方向 + 性格」选取,**禁止自定义新曲线**。

| Token | 贝塞尔 | 性格 | 适用场景 |
|---|---|---|---|
| `motion.easing.standard` | `cubic-bezier(0.4, 0, 0.4, 1)` | 加速 → 减速,加速期短 | **屏幕内固有元素** —— 选择器、Tab 切换、开关等一直存在的组件 |
| `motion.easing.decelerate` | `cubic-bezier(0, 0, 0, 1)` | 减速曲线,最快进入逐渐停止 | **屏幕外元素入场** —— 吐司、弹窗、通知、半弹层入场 |
| `motion.easing.accelerate` | `cubic-bezier(1, 0, 1, 1)` | 加速曲线,静止启动加速到最快出场 | **屏幕内元素出场** —— 内容删除、临时层出场 |
| `motion.easing.spring` | `cubic-bezier(0.5, 1.4, 0, 1)` | 弹性,过冲回弹 | **营销 / 强交互** —— 营销气泡、营销场景化元素、强交互 Icon |

**性格说明 — 标准曲线**:加速期相对减速期用时更少,用户清晰观察动效最终结果,清晰了解状态变化。

> v0.9 中的 `linear` / `emphasized` 在 15.0 中**未规范**:
> - `linear` 在持续型动效(进度条、加载)中仍可用,但不在 15.0 token 列表 —— 保留 TODO
> - `emphasized` 与 `decelerate` 行为接近,15.0 直接用 `decelerate` 取代

---

## 4. 转场动效(Choreography)

> 三种转场对应**模块前后关系**:从属 / 递进 / 并列。

### a. 容器继承(Container Inheritance)
**关系**:从属 / 前后场景的连续感
**实现**:共用一个容器,扩展至全屏引出下一模块

| 方向 | 时长 | 缓动 | 变化方式 |
|---|---|---|---|
| 正向 | 300ms | standard | 位置(直线路径)、大小(等比例缩放)、形状(外形扩展) |
| 逆向 | 300ms | standard | 同正向(对称) |

### b. 递进上浮(Progressive Float)
**关系**:对当前模块的补充操作
**实现**:半弹层上浮,避免链路型操作的频繁跳出

| 方向 | 时长 | 缓动 | 变化方式 |
|---|---|---|---|
| 正向 | 300ms | decelerate | 位置 Y(-300 → 0)、透明度(0% → 100%) |
| 逆向 | 200ms | accelerate | 位置 Y(0 → -300)、透明度(100% → 0%) |

### c. 推屏跳转(Push Transition)
**关系**:流程型操作,推进关系
**实现**:从右侧推动至左侧

| 方向 | 时长 | 缓动 | 变化方式 |
|---|---|---|---|
| 正向 | 300ms | decelerate | 上层 X(375 → 0)、蒙层 #000000(0% → 70%)、下层 X(0 → -100) |
| 逆向 | 300ms | accelerate | 上层 X(0 → 375)、蒙层(70% → 0%)、下层 X(-100 → 0) |

---

## 5. 组件动效(典型示例)

> 以系统型弹窗为例:中型尺寸 + 屏幕外入场。

| 方向 | 时长 | 缓动 | 变化方式 |
|---|---|---|---|
| 正向(入场) | 200ms | decelerate | 位置、透明度 |
| 逆向(出场) | 150ms | accelerate | 位置、透明度 |

> **决策模式**:
> 1. 选尺寸 → 定时长(s/m/l)
> 2. 进场 / 出场?屏内 / 屏外?→ 定缓动
> 3. 出场时长 = 进场时长 - 1 档

---

## 6. 语义动效角色

> 用于组件 visual.md 引用,屏蔽底层细节。

| Token | 引用 | 用途 |
|---|---|---|
| `motion.role.toggle` | `duration.s` + `easing.standard` | 开关 / 选择器 / Tab 切换 |
| `motion.role.toast.enter` | `duration.m` + `easing.decelerate` | 吐司提示入场 |
| `motion.role.toast.exit` | `duration.s` + `easing.accelerate` | 吐司提示出场 |
| `motion.role.modal.enter` | `duration.m` + `easing.decelerate` | 弹窗入场 |
| `motion.role.modal.exit` | `duration.s` + `easing.accelerate` | 弹窗出场 |
| `motion.role.sheet.enter` | `duration.l` + `easing.decelerate` | 半弹层入场 |
| `motion.role.sheet.exit` | `duration.m` + `easing.accelerate` | 半弹层出场 |
| `motion.role.page.transition` | `duration.l` + `easing.decelerate / accelerate` | 推屏跳转 |
| `motion.role.container.expand` | `duration.l` + `easing.standard` | 容器继承 |
| `motion.role.marketing.bubble` | `duration.m` + `easing.spring` | 营销气泡 |

---

## 7. 减少动效 · reduced motion

iOS / Android 系统设置中"减少动效"开启时:

| 默认动效 | 减少动效后 |
|---|---|
| 容器继承 | 直接切换 |
| 递进上浮 | 淡入淡出 |
| 推屏跳转 | 直接切换 |
| 弹窗 / 吐司 | 淡入淡出(仅透明度变化)|
| 弹性曲线动画 | 改用 standard,无回弹 |

**实现**:`motion.reduced.duration.*` 自动映射到 `0ms`,`spring` → `standard`。组件代码不需要单独判断。

详见: [[../../horizontal/a11y/motion-reduce.md]]

---

## 8. 设计 / 研发交付

### 设计工具
- **Figma** —— 通过原型动画或 Smart Animate
- **After Effects + Flow 插件** —— 复杂动效 / 营销动画
- 资源: Figma 动效教程、AE Flow 插件下载(密码 `rrtj7n`)

### 研发交付
- 动效示意视频(建议 mp4 / mov)
- 动效文件: gif / mp4 / mov / json(Lottie)
- 动效具体参数: 变化方式 + 持续时间 + 缓动曲线贝塞尔函数

---

## 9. 反例

| ❌ 反面 | 解释 |
|---|---|
| `transition: all 250ms ease` | 250 不在 token 内;`ease` 不是 4 类曲线之一 |
| 模态出场使用入场时长(200ms 出场) | 违反「出场降一档」铁律 |
| 屏内组件用 `decelerate` | 应该用 `standard`(屏内固有元素) |
| 屏外入场用 `standard` | 应该用 `decelerate`(屏外入场需减速) |
| 主流程用 `spring` | spring 仅用于营销场景 |
| 自定义贝塞尔(不在 4 条之内)| 与 15.0 体系不一致 |
| 不响应"减少动效"系统设置 | 违反 a11y |
| 同一交互不同位置动效不一致 | 节奏混乱 |

---

## 10. 历史版本

- **v1.0(2026-05-06)**:与 Relay 15.0 实际投产对齐;时长收敛到 3 阶(150/200/300ms);缓动收敛到 4 类(standard/decelerate/accelerate/spring);新增 3 类转场动效定义。
- v0.9(2026-04):草案版,6 阶时长 + 6 阶缓动,与 15.0 不一致。
