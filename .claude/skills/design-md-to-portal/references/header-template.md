# 16.0 GUIDELINE 板式页头模板

复刻自 Relay 文件 `2054468374020227073` 节点 `6:229`（设计系统文档头部），是 `design-md-to-portal` skill 的**视觉真相源**。

---

## 直接拷贝段（HTML 块）

把整块拷到 `docs/design.html` 全站顶部，或拷到每个 spec section 顶部。把 `{{title}}` 替换为节点名或全站名（保留原中文与横杠，例：`导航类-顶部导航栏`）。

```html
<!-- ╭─ JD APP 16.0 GUIDELINE 板式页头 ───────────────────────────────────╮ -->
<header class="banner">
  <div class="banner__text">
    <span class="banner__tag">JD APP 16.0&nbsp;&nbsp;GUIDELINE</span>
    <h1 class="banner__title">{{title}}</h1>
    <p class="banner__subtitle">设计与用研部 - AI 核心产品设计部</p>
  </div>
  <!-- 右侧装饰图位（548×240，mix-blend:multiply）。TBD：wiki 主题接入。 -->
  <div class="banner__art" aria-hidden="true"></div>
</header>
<!-- ╰────────────────────────────────────────────────────────────────────╯ -->
```

> 站点级 banner 用 `<h1>`，spec section 内的 banner 用 `<h2>`（结构语义保留）。
> 实际渲染样式见 `site-template.html` `<style>` 段。

---

## 占位符

| 占位 | 含义 | 来源 | 示例 |
|---|---|---|---|
| `{{title}}` | 主标题 | spec frontmatter `name_zh` 或全站 "设计系统" | `导航类-顶部导航栏` |

---

## 默认字段（一般不改）

| 字段 | 默认值 | 何时改 |
|---|---|---|
| 标签行 | `JD APP 16.0  GUIDELINE` | 跨大版本（如 17.0）时整体替换 |
| 副标题 | `设计与用研部 - AI 核心产品设计部` | 跨部门发布时整体替换 |
| 右侧装饰图 | CSS 占位（径向渐变） | TBD：换真图由 wiki 主题接入 |

---

## 设计参数（来自 Relay 节点 6:229，勿改）

| 项 | 值 |
|---|---|
| 整块尺寸 | `1666 × 240`（max-width 1666，自适应缩放） |
| 背景 | `rgba(17, 20, 26, 0.02)` |
| 边框 | `1px solid rgba(17, 20, 26, 0.08)` |
| 文字容器 | `padding: 54px 60px`，三行竖排，垂直间距 `28px` |
| 装饰图位 | 右上角 `548×240`，`mix-blend-mode: multiply` |
| 标签行字体 | `Intro 20 / 400 / line-height 20` |
| 主标题字体 | `PingFang SC 40 / 600 / line-height 40` |
| 副标题字体 | `PingFang-SC 16 / 400 / line-height 16` |
| 文字色 | `#11141A`（= `color/text/title`） |

---

## 与 site-template.html 的关系

- 本文件是**视觉规约**真相源（参数表 + 标记结构）
- `site-template.html` 是**可跑的实现**（含完整 CSS、占位符循环模板）
- 改板式（颜色 / 字号 / 内边距）时**两边同步**：先改本文件的参数表，再改 `site-template.html` 的 `<style>` 段
