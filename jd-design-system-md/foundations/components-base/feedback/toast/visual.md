---
file: visual.md
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

# Toast · 视觉规范

> 一切色值、间距、圆角、字体均**引用 Token,不在本文件出现硬编码**。详细 Token 真相源见 `foundations/tokens/`。

---

## 1. 容器(container)

| 属性 | 值 | Token 引用 |
|---|---|---|
| 背景 | 70% 黑蒙层 | `color.mask`(`#000000b2`) |
| 文字 | 纯白 | `color.neutral.text-on-mask`(`#ffffff`) |
| 圆角 | 8pt | `radius.8` |
| 内边距(纯文本) | 上下 13pt / 左右 16pt | `spacing.16` |
| 内边距(图标+双行) | 上 13pt / 下 16pt / 左右 16pt | `spacing.16` |
| 图标-文字间距(同行) | 8pt | `spacing.8` |
| 图标-文字间距(图上字下) | 12pt(图标下沿到文字基线) | `spacing.12` |
| 阴影 | 不带阴影(蒙层已构成层级) | — |

> Relay 节点观察的实际宽度档位:**93pt(短文本)/ 200pt(中等) / 自适应文本宽 + 内边距**——具体宽度由内容决定,组件**不固定宽度**。

---

## 2. 字体(typography)

| 场景 | 字体 | 字号 | 字重 | Token 引用 |
|---|---|---|---|---|
| 单行文本 | 苹方 | 15pt | Regular(400) | `typography.body.regular.15` |
| 双行场景 - 主文字 | 苹方 | 15pt | Medium(500) | `typography.body.medium.15` |
| 双行场景 - 副文字 | 苹方 | 15pt | Regular(400) | `typography.body.regular.15` |

行高 15pt(与字号同),无段落间距。

---

## 3. 图标(icon)

| 属性 | 值 |
|---|---|
| 尺寸 | 20×20pt(图标+双行场景);24×24pt(loading 大图标场景) |
| 颜色 | 纯白 `#ffffff`(与文字同色,统一表现) |
| 来源 | [[foundations/visual/icon.md]] 系统图标库,**面性图标** |

**4 种状态图标**(由 `type` 决定):

| Type | 图标 | 备注 |
|---|---|---|
| `success` | 勾(✓) | 居中绘制,线条端点为圆头 |
| `error` | 叉(✕) | 两根 stroke 等粗 |
| `warning` | 感叹号(!) | 上粗下点,圆形终止 |
| `loading` | 旋转转圈 | 连续 1.2s 一周,`ease-linear` |

---

## 4. 形态(variant)

Toast **没有 `size` 维度**,而是按**内容形态**自适应。三种主要形态:

### 形态 A · 仅文字(单行)

```
┌─────────────────┐
│   发送失败        │   ← 单行文字,容器纵向居中
└─────────────────┘
```

- 容器高度:46pt(文字 15 + 上下内边距 16+15)
- 适用:简短状态反馈,不需要图标语义补强

### 形态 B · 图标 + 单行文字(横向)

```
┌─────────────────────┐
│  ✓  关注成功         │   ← 图标在左,文字在右
└─────────────────────┘
```

- 容器高度:46pt
- 适用:成功 / 失败 / 警告 / 提示等带语义的反馈
- 间距:图标距左 16pt,图标距文字 8pt,文字距右 16pt

### 形态 C · 图标 + 双行文字(纵向)

```
┌──────────────┐
│      ✓        │   ← 图标在上
│   关注成功      │   ← 主文字
│  稍后查看主页    │   ← 副文字(可选)
└──────────────┘
```

- 容器宽度:200pt(由副文字宽度决定)
- 容器高度:98pt(图标 20 + 间距 12 + 主文字 15 + 行间距 5 + 副文字 20 + 上下内边距)
- 适用:需要更多上下文的反馈

> **优先级**:能用 A/B 不用 C。Toast 越简短越好,C 形态是"已经濒临 Toast 承载边界"的信号——再复杂就该考虑 Sheet/Dialog。

---

## 5. 位置(position)

- **默认**:屏幕**垂直居中**,水平居中
- 不靠近顶部 / 底部 / 任何边缘——避开手指遮挡 + 状态栏 / Tab Bar 干扰
- 出现位置不随键盘 / 滚动 / 路由切换变化(始终中心)

详见 [[donts.md#6-不要把-toast-放在屏幕边缘no-edge-placement]] 反例。

---

## 6. 与 Token 的边界

| 关注点 | 在哪 |
|---|---|
| 70% 黑蒙层色值 | [[../../tokens/color.md#蒙层--colormask]] |
| 主色升级影响 | 本文件不涉及主色;Toast **不使用 brand.primary**,与品牌色解耦 |
| 圆角 8pt 来源 | [[../../tokens/radius.md]] |
| 苹方字号阶梯 | [[../../tokens/typography.md]] |

---

## 截图参考

源稿:[Relay 反馈类/吐司](https://relay.jd.com/file/design?id=2002743945242628098&page_id=45%3A600&node_id=45%3A11576)
本地变体截图待补:`variants/` 目录(P1 阶段)
