# Pro / Basic 视图切换(v0.3)

> SKILL.md Step 4c 调用。模板自带 view-tabs UI + CSS + JS。**生成内容时按下面规则给元素加 class**,常规版用户与专业版用户各看一份合适的内容。

---

## 设计原则

| 模式 | 受众 | 看到 |
|---|---|---|
| **常规版**(默认) | 设计师入门 / 跨职能(PM / 运营 / 客户)/ 决策者 | 组件干嘛、用在哪、什么时候不要、原稿切图 |
| **专业版** | 资深设计师 / 工程师 / 走查 reviewer | 全部 + token 名 / DP 数 / 字号字重 / API / ASCII / 来源标注 |

**核心约束**:
1. **不复制段落** —— 用 CSS class 控制可见性,不要给同一信息写两遍
2. **常规版自洽** —— 隐藏详细规范后,常规版仍能成段(必要时加 `basic-only summary` 概述)
3. **专业版无遗漏** —— 隐藏 basic 概述后,专业版仍能从 0 看到完整规范
4. **inline 优于段** —— 在表格 / li 内 inline `<span class="pro-only">` 比包整段更细粒度

---

## Class 规则

### 元素级(整段隐藏)

```html
<!-- 整段只在专业版可见 -->
<div class="pro-only">
  <h3>4.1 容器</h3>
  <table>...token / DP / 字号详细规范...</table>
</div><!-- /pro-only -->

<!-- 整段只在常规版可见(替代专业版被隐藏的内容) -->
<div class="basic-only summary">
  <p><strong>基础结构(常规版概述)</strong>:容器 + N 坑位 + 可选 Agent + 可选灵动岛。具体 token / DP 见<strong>专业版</strong>。</p>
</div>
```

`basic-only.summary` 默认渲染为 info 蓝引用块(模板 CSS 已加),视觉上一眼能认出是「概述模式」。

### Inline 级(段内细粒度)

```html
<!-- li 中部分细节只在专业版可见 -->
<li><strong>iOS 安全区不可放置任何操作</strong><span class="pro-only pro-inline"> — 17 DP(章节 02 基础布局 a)</span></li>

<!-- 段落中 token 名只在专业版可见 -->
<p>Tabbar 容器圆角 16px<span class="pro-only pro-inline"> · token <code>radius_xxl</code> / atom <code>Radius_16</code></span></p>
```

加 `.pro-inline` 后:
- 在 pro 模式下作为小字号灰色提示文字附加(`color: --c-text-3, font-size: 12px, margin-left: 6px`)
- 不打断主句的可读性

### 标记 / 不标记 决策表

| 内容性质 | 标记 |
|---|---|
| Token 名(`color_primary` / `radius_xxl` / `pingfang_regular/font_size_10_400`) | `pro-only` 或 inline `pro-only pro-inline` |
| 精确 DP 数(`44×44 DP` / `131×44`) | inline `pro-only pro-inline`(常规版可保留约数如"约 50 DP" 或粗概念) |
| 字号 / 字重 / 行高规则 | `pro-only` |
| 章节来源标注(`(章节 02 基础布局 a)`) | inline `pro-only pro-inline` |
| ASCII 框图 / 内部布局示意 | `pro-only`(整段) |
| API 速查 / 代码块 | `pro-only`(整段) |
| Atom 名 / Hex 值 | inline `pro-only pro-inline` |
| 大原则数字(`2~5 坑位` / `4 个汉字` / `18 汉字`) | **共享**(规范的可记忆点,常规版也要看到) |
| 应用场景 ✅ / Donts ❌ | **共享**(规范的核心) |
| 切图 stage(原稿展示) | **共享** |
| 章节 H2 / H3 标题 | **共享** |
| 类型枚举值(`regular` / `agent_combo`)在 ul / 文本中 | **共享**(常规版用户也需要识别) |
| 类型枚举值在 table 单独列 | 整列 `pro-only`(整列改成 inline 太碎,常规版用 summary list 替代) |

---

## 7 章节标记策略(典型)

### 章节 1 定义

- **共享**:一句话定义 / 边界对比表 / 立场 blockquote / 原稿切图
- **inline pro-only**:立场 blockquote 中的精确 token / DP 数

### 章节 2 行为准则

- **共享**:每条 `<li><strong>` 主干语义("不可放置任何操作" / "建议 2~5 坑位" / "最多 4 个汉字")
- **inline pro-only**:括号内"(章节 0X)"来源标注 + 精确 DP / token 引用

### 章节 3 类型

- **共享**:章节综述 + 切图(各形态原稿) + Donts blockquote
- **basic-only summary list**:形态 + 类型 名称 + 用途(中文短句)
- **pro-only**:`<div class="pro-only">` 包 3.1 / 3.2 详细 token / DP 表

### 章节 4 结构

- **共享**:章节顶部综述 p + 4.5 / 4.6 实体预览切图
- **basic-only summary**:章节 4 头部加 1 段 info 蓝概述,讲组件由哪些原子组成
- **pro-only**:`<div class="pro-only">` 包 4.1-4.4 token / DP / 字号详细表

### 章节 5 布局

- **共享**:5.1 位置规则表 / 5.3 多端切图 / 5.4 动效(blockquote)
- **pro-only**:5.2 ASCII 内部布局示意(整段 h3 + pre)

### 章节 6 正反案例

- **共享**:正例切图 + 反例 mockup + 问题描述 p / ul
- **inline pro-only**:case ul 中精确 token 引用(可选,案例描述本身常需要数字)

### 章节 7 典型场景

- **共享**:典型场景表 / 反场景表
- **可选 pro-only**:表的"形态 / 招手"列(若 basic 用户不需要识别 form 名)

### 附加段

- **API 速查** → 整段 `pro-only`(`<h3>` + `<pre>`)
- **引用** → 共享(都需要看 Relay 节点链接)
- **底部 meta** → 共享

---

## Skill 渲染 Checklist

跑完 Step 4 字符串替换后,model 必做:

- [ ] 章节 4 加 `<div class="pro-only">` 包 4.1-4.4,加 `</div><!-- /pro-only 4.1-4.4 -->` 闭合
- [ ] 章节 4 头部加 `<div class="basic-only summary">` 概述
- [ ] 章节 5.2 h3 + pre 加 `class="pro-only"`
- [ ] API 速查 h3 + pre 加 `class="pro-only"`
- [ ] 章节 2 行为准则 8 条:括号注 + 精确 DP 用 `<span class="pro-only pro-inline">` 包
- [ ] 章节 3 形态/类型表(若两个表都 token-heavy)整段 `pro-only` + 加 basic-only summary list
- [ ] **检查 `pro-only` 开 / 闭 div 数量平衡**:`grep -c '<div class="pro-only"' file == grep -c '/pro-only' file`(可选 close marker 注释)
- [ ] **检查 basic 模式可读**:`grep -v 'pro-only' rendered_basic | wc -l` 不应只剩骨架,常规版每章节至少 1 段非 ⚠️ TBD 内容

---

## 失败模式

| 失败 | 原因 | 修法 |
|---|---|---|
| pro / basic 切换无反应 | JS 未加载 / view-tab 选择器不匹配 | 看 `<script>` 是否在 body 末尾;dataset.view 是否 `pro` / `basic` 二选一 |
| 默认页面闪烁 (pro-only 短暂可见) | CSS `body:not(.mode-basic):not(.mode-pro)` 规则缺 | 模板自带,不要删 |
| basic 模式某章节空白 | 整段 pro-only 没加 basic-only summary 替代 | 加 `<div class="basic-only summary">` 简述 |
| 整列 pro-only 在 table 错位 | HTML table 不能让 1 列消失只能整 td 隐藏 | 改方案:整表 pro-only + basic-only summary list |
| 锚点链接跳到 pro-only 内容时 basic 模式找不到 | 锚点 `<h3 id="...">` 标了 pro-only | 锚点章节标题不要标 pro-only(只标内部 table / pre);或主动切 mode |

---

## 用户偏好持久化

JS 用 `localStorage.spec-page-view-mode` 存 `'basic'` 或 `'pro'`。下次打开同站点(同 origin)的任何 spec-page,自动恢复用户上次选择。

清除偏好:浏览器 devtools / Application / Local Storage 删 `spec-page-view-mode` key。
