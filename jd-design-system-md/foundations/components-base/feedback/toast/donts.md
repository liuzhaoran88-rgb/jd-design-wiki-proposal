---
file: donts.md
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

# Toast · 反例集合(★ 必看)

> Toast 因为「轻量」属性,被滥用是高发问题。本文档持续收集反例,**任何人发现新反例都可提交 PR 加入此处**。

---

## 1. 不要在 Toast 里放可点击元素(no-interactive)

❌ 反例:

```
┌────────────────────┐
│ 加购成功 [查看购物车]    │  ← 不要这样
└────────────────────┘
```

**为什么**:Toast 设计上不响应交互,出现 2-3s 后自动消失,用户来不及反应就点不到了。**强行加按钮**会有以下后果:
- 用户点了没生效(惨)
- 为了让用户点到,延长 Toast 时长 → 变相阻塞用户(更惨)
- 持续时长 + 按钮 = 你做的其实是 NoticeBar / Snackbar,改用对应组件

✓ 正确:
- 想让用户跳转:**用 Dialog 或 Sheet**(允许停留)
- 想要持续提示:**用 NoticeBar / 顶通知条**

---

## 2. 不要用 Toast 承载重要错误(no-critical-error)

❌ 反例:用户支付失败,弹一个 toast「支付失败」就消失。

**为什么**:用户可能正在 input 字段或滚动,3s 完全错过,以为支付成功。

✓ 正确:重要错误用 **Dialog 阻断**,让用户主动确认,并提供「重试」「取消」选项。

| 错误等级 | 用什么 |
|---|---|
| 信息类(收藏失败,可重试) | Toast |
| 操作影响小(网络重连) | Toast |
| 涉及金钱 / 数据丢失 / 流程中断 | **Dialog 阻断** |

---

## 3. 不要堆叠多个 Toast(no-stack)

❌ 反例:用户连点 5 次「关注」,屏幕上同时出现 5 个 Toast 叠加。

**为什么**:超出认知负担、视觉污染、影响下层模态识别。

✓ 正确:
- 同一会话内**相同内容合并**为一条
- 不同内容**进队列依次展示**(同屏 1 条)
- 详见 [[interaction.md#3-队列queue]]

---

## 4. 不要让 Toast 文案超过 12 字(no-long-text)

❌ 反例:「您已成功订阅本商品到货提醒,稍后会通过短信通知您」(28 字)

**为什么**:用户根本读不完,你的提示等于失效。

✓ 正确:
- 截到 12 字内:「订阅成功」
- 长信息改用 Sheet 或全屏弹窗
- 见 [[content.md#1-字数硬约束max-length]]

---

## 5. 不要在 loading toast 上放进度数字(no-progress-in-toast)

❌ 反例:「上传中… 32%」

**为什么**:Toast 是非模态轻提示,用户可能正在做别的;频繁刷新进度数字 = 高频重绘 + 不可读 + 抢焦点。

✓ 正确:
- 进度展示用全屏 Loading + Progress Bar
- Toast 只表达"在 / 不在"两态:`加载中` / `加载完成`

---

## 6. 不要把 Toast 放在屏幕边缘(no-edge-placement)

❌ 反例:Toast 贴底部 Tab Bar 上方 / 贴顶部状态栏下方。

**为什么**:
- 顶部:遮挡状态栏 / 路由切换交互
- 底部:被手指遮挡(尤其拇指操作区)
- 也容易让用户误以为 Toast 是 NavBar / TabBar 的一部分

✓ 正确:**屏幕垂直居中,水平居中**。详见 [[visual.md#5-位置position]]。

---

## 7. 不要让屏阅用户感知不到反馈(no-a11y-skipped)

❌ 反例:Toast 是视觉的,屏幕阅读器用户完全感知不到。

**为什么**:依赖屏阅的用户(视障 / 阅读障碍)无法获得反馈,等同于无反馈。

✓ 正确:
- Toast 出现时,**自动 announce 文案**(详见 [[interaction.md#6-无障碍a11y]])
- 关键反馈不要**仅依赖**视觉

---

## 8. 不要让 Toast 阻断后续操作(no-blocking)

❌ 反例:Toast 出现时,把整个屏幕设为不可点击。

**为什么**:Toast **不是**模态。把它做成模态等于做了一个又轻又看着没用的 Dialog。

✓ 正确:Toast 出现时,用户**可以继续点击页面其他元素**——Toast 只是「飘过」,不阻断。

---

## 9. 不要用 brand.primary 做 Toast 背景(no-brand-color-bg)

❌ 反例:为了"突出 Toast 视觉",用京东红做 Toast 蒙层。

**为什么**:Toast 与品牌色解耦——蒙层底是 70% 黑(`color.mask`),状态语义靠图标 + 文字传达,不靠色相。

✓ 正确:严格使用 `color.mask`,不引入 `color.brand.*`。详见 [[visual.md#1-容器container]]。

---

## 历史背景(可选阅读)

> 京东 APP 在 v14 之前曾用过「toast 加按钮」的形态(行业内俗称 Snackbar),v15.0 已废弃此形态。决策记录见 governance 历史。

> 收集 owner:DS 维护组。新反例提交格式:**反例 + 为什么 + 正确做法**,三段必填。
