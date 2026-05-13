---
file: materials
version: 16.0-draft
last_updated: 2026-05-12
relay_source:
  file_id: "2029484645871009793"
  page_id: "12:260"
  spec_frame: "297:39"
  url: https://relay.jd.com/file/design?id=2029484645871009793&page_id=12%3A260
v15_predecessor: null   # V15 无 materials
relay_changelog:
  - "2026-04-17 ｜ 周峯 ｜ 创建液态玻璃、毛玻璃材质"
v16_status_overall: new
---

# 材质 Materials · V16.0 🚩 全新独立 foundation

> V16.0 新增「材质」作为独立 foundation。V15.0 没有 materials 概念，shadow 也只是 TODO（"Relay 15.0 暂未规范"）。
>
> V16 材质 = 多层背景渐变 + 混合模式 + 阴影的组合规则，**平台差异化实现**。

---

## 平台差异化策略

| 平台 / 系统 | 使用 |
|---|---|
| **iOS 高版本（17+）** | **Liquid Glass**（系统级液态玻璃，原生 API） |
| iOS 低版本 / Android / HarmonyOS | **Frosted Glass**（毛玻璃，CSS `backdrop-filter: blur(50px)` 兜底） |

---

## 1. Liquid Glass · 液态玻璃

> iOS 17+ 系统级材质，多层 gradient + blend mode 实现。

### 1.1 Liquid Glass - Small

> 用途：**iOS 高版本顶导组件** (40×40 容器, radius 12)

**Light variant**:
```css
.liquid-glass-small-light {
  width: 40px; height: 40px; border-radius: 12px;
  background:
    linear-gradient(0deg, #F7F7F7 0%, #F7F7F7 100%),
    #DDDDDD,
    rgba(255, 255, 255, 0.65);
  background-blend-mode: normal, color-burn, darken;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.12);
}
```

**Dark variant**:
```css
.liquid-glass-small-dark {
  width: 40px; height: 40px; border-radius: 12px;
  opacity: 0.60;
  background:
    linear-gradient(0deg, rgba(255, 255, 255, 0.06) 0%, rgba(255, 255, 255, 0.06) 100%),
    rgba(0, 0, 0, 0.60),
    rgba(204, 204, 204, 0.50);
  background-blend-mode: color-burn, normal, normal;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.12);
}
/* + 内嵌一层 rgba(0,0,0,0.20) 用 blend-mode: screen */
```

### 1.2 Liquid Glass - Medium

> 用途：**iOS 高版本底导组件** (120×120 容器, radius 16)

**Light**:
```css
.liquid-glass-medium-light {
  width: 120px; height: 120px; border-radius: 16px;
  background:
    linear-gradient(0deg, rgba(245, 245, 245, 0.60) 0%, rgba(245, 245, 245, 0.60) 100%),
    #262626;
  background-blend-mode: color-dodge, normal;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.12);
}
```

**Dark**:
```css
.liquid-glass-medium-dark {
  width: 120px; height: 120px; border-radius: 16px;
  opacity: 0.60;
  background:
    linear-gradient(0deg, rgba(255, 255, 255, 0.06) 0%, rgba(255, 255, 255, 0.06) 100%),
    rgba(0, 0, 0, 0.60),
    #CCCCCC;
  background-blend-mode: color-burn, normal, normal;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.12);
}
```

---

## 2. Frosted Glass · 毛玻璃

> iOS 低版本 / Android / HarmonyOS 兜底实现，标准 `backdrop-filter: blur()`。

### 2.1 Frosted Glass - Small

> 用途：**iOS 低版本 / 安卓 / 鸿蒙 顶导组件** (40×40)

**Light**:
```css
.frosted-glass-small-light {
  width: 40px; height: 40px;
  background:
    linear-gradient(0deg, rgba(255, 255, 255, 0.40) 0%, rgba(255, 255, 255, 0.40) 100%),
    rgba(255, 255, 255, 0.05);
  background-blend-mode: plus-lighter, color-dodge;
  backdrop-filter: blur(50px);
}
```

**Dark**:
```css
.frosted-glass-small-dark {
  width: 40px; height: 40px;
  background: rgba(0, 0, 0, 0.25);
  backdrop-filter: blur(50px);
}
```

### 2.2 Frosted Glass - Medium

> 用途：**iOS 低版本 / 安卓 / 鸿蒙 底导组件** (120×120)

**Light**:
```css
.frosted-glass-medium-light {
  width: 120px; height: 120px;
  background:
    linear-gradient(0deg, rgba(255, 255, 255, 0.60) 0%, rgba(255, 255, 255, 0.60) 100%),
    rgba(255, 255, 255, 0.25);
  background-blend-mode: plus-lighter, color-dodge;
  backdrop-filter: blur(50px);
}
```

**Dark**:
```css
.frosted-glass-medium-dark {
  width: 120px; height: 120px;
  background: rgba(0, 0, 0, 0.40);
  backdrop-filter: blur(50px);
}
```

---

## 共享属性

| 属性 | Liquid Glass | Frosted Glass |
|---|---|---|
| Shadow | `0 8px 40px rgba(0,0,0,0.12)` | 无 |
| Blur | 多层 gradient blend mode 模拟 | `backdrop-filter: blur(50px)` |
| Light opacity | 1.0 (multi-layer) | 1.0 |
| Dark opacity | 0.60（整体） | 1.0 (颜色 0.25/0.40) |

---

## 应用范围（推断）

| 场景 | iOS 17+ | 其他平台 |
|---|---|---|
| 顶导组件容器（40×40） | Liquid Glass Small | Frosted Glass Small |
| 底导组件容器（120×120） | Liquid Glass Medium | Frosted Glass Medium |
| Card / Modal 容器（其他尺寸） | ❓ 待规范 | ❓ 待规范 |

---

## 与 V15 的关系

V15 完全没有 materials / glass / shadow token。V15 tokens.json 标记：
- `TODO.shadow`: "shadow / elevation token 体系(Relay 15.0 暂未规范)"

V16 用「材质」概念把 shadow + blur + gradient 一起打包，作为**组合规则**而非孤立 token。**整组 v16_status = new**。

---

## 待办

- [ ] 材质的 token 化封装：组件层应该引用 `material.liquid-glass.small` 还是直接写多层 background？建议增加 token 层
- [ ] 中间尺寸（除 40 / 120 外）的材质方案是否需要规范？
- [ ] 平台检测策略：JS 判断 iOS 版本走 Liquid，还是 CSS `@supports` 探测特性？
- [ ] 性能影响评估：Liquid Glass 多层 blend mode 在低端机渲染开销
- [ ] Dark mode 切换是否走系统主题 OR 设计 token 主题
- [ ] 反馈到设计组：材质能否做成 token 形式（如 `material_glass_small_liquid_light`）
