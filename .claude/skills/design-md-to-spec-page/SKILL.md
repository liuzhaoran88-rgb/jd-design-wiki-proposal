---
name: design-md-to-spec-page
description: 把单份 design.md（普通组件）或 page-doc bundle（design.md + spec.md + variants.md + behaviors.md）渲染成一份对外、可展示的 7 章节单页 HTML 规范文档。参考 jd-toast-spec(1).html 的样式与结构（定义/行为准则/类型/结构/布局/正反案例/典型场景），输出到组件目录下 spec-page.html。Triggered by /design-md-to-spec-page 或 "为 X 生成 spec 页"、"design.md to html"、"出一份 X 的规范 HTML"。
allowed-tools: [Bash, Read, Write, Edit, Glob]
---

# /design-md-to-spec-page · 单组件 design.md → 7 章节 spec HTML

## 这个 skill 做什么

把**单个组件**的 design.md（或 page-doc 4 文件 bundle）渲染成一份**对外公开、可展示**的单页 HTML 规范，结构对齐 [jd-toast-spec(1).html](外部参考) 的 **7 章节模板**：

1. **定义** — 一句话定义 + 跟相邻组件的对比表 + 立场 blockquote
2. **行为准则** — 编号 list（核心规则，每条 ≤ 1 行）
3. **类型** — 类型/形态表 + 实时演示 stage + 不允许扩展的 blockquote
4. **结构** — 视觉规范子表（容器 / 图标 / 文字）+ 实体预览 stage
5. **布局** — 位置规则表 + 内部布局 ASCII / mockup + 浅深底应用 + 动效参数
6. **正反案例** — case good/bad block（含演示 + 问题分析）
7. **典型场景** — 大表（场景 / 类型 / 参数 / 文案 / 触发演示）

附加段：API 速查（如有）、引用列表（Relay 节点 + token 文件）、底部 meta（生成时间 / Relay 节点）。

## 何时触发

| 场景 | 调用 |
|---|---|
| 用户调 `/design-md-to-spec-page <slug>` | 直接走 |
| 用户说"为 X 生成 spec 页" / "用 design.md 出一份 HTML 规范" / "把 X 的 design.md 渲染成对外站点单页" | 主动调 |
| 用户说"按 jd-toast-spec 7 点重做 X" | 主动调 |
| 单份 design.md 内容更新 → 同步更新 spec-page.html | 主动调 |

## 不适用场景

| 场景 | 该走哪里 |
|---|---|
| 把仓库**所有** design.md 聚合成总站 | `design-md-to-site` |
| 从 Relay 抽稿生成新 design.md | `relay-to-design-md` |
| 审稿 design.md 是否合规 | `design-review` |

## 职能边界（与姊妹 skill 配套）

| Skill | 输入 | 输出 |
|---|---|---|
| `relay-to-design-md` | Relay URL | design.md / bundle（编辑面） |
| `design-md-to-site` | design.md 集合 | docs/design.html（总站发布面） |
| **`design-md-to-spec-page`（本）** | 单 design.md / bundle | `<slug>/spec-page.html`（单组件发布面） |
| `design-review` | design.md | review 报告（不改文件） |

---

## 执行流程

### Step 1: 解析输入

支持 3 种调用形态：

```
/design-md-to-spec-page tabbar                    # 仅 slug，自动找路径
/design-md-to-spec-page jd-design-system-md-v16/horizontal/components-base/tabbar/  # bundle 目录
/design-md-to-spec-page jd-design-system-md-v16/.../tabbar/design.md                # 单文件
```

输出路径：**`<bundle-dir>/spec-page.html`**（与 design.md 同目录）。

### Step 2: 识别 bundle 还是 single

读 `design.md` 的 frontmatter：
- `bundle: page-doc` + `bundle_files: [...]` 存在 → **page-doc bundle 模式**
- 否则 → **single 模式**

bundle 模式下追加读取 `spec.md` / `variants.md` / `behaviors.md`，按 [references/section-mapping.md](./references/section-mapping.md) 把字段映射到 7 章节。

### Step 3: 映射到 7 章节

按 [references/section-mapping.md](./references/section-mapping.md) 把 design.md / bundle 字段塞进 7 章节的对应位置。**严禁编造**：

| HTML 章节 | 来源（single） | 来源（bundle） |
|---|---|---|
| 1. 定义 | `## 一句话定义` + frontmatter | `design.md ## 一句话定义` |
| 2. 行为准则 | `## 交互` 段提炼 ≤ 8 条 | `behaviors.md ## 交互` |
| 3. 类型 | `## 变体 Variants` 形态/类型维度 | `variants.md` 形态/类型表 |
| 4. 结构 | `## 视觉` 色彩/文字/圆角/材质 | `spec.md` colors/typography/radius/materials |
| 5. 布局 | `## 视觉 / 间距` 表 | `spec.md` 间距/布局 |
| 6. 正反案例 | `## Donts` + `## 应用场景` ✅ | `behaviors.md` Donts + 应用场景 |
| 7. 典型场景 | `## 应用场景` ✅ | `behaviors.md` 应用场景 ✅ |

数据缺失的章节 → 渲染为 `<blockquote class="warn">⚠️ TBD：本组件 design.md 暂未提供「{section_name}」内容</blockquote>`，**不要**跳过整段。

### Step 4: 读模板 + 字符串替换

读 [templates/spec-page.html](./templates/spec-page.html)。占位符语义与 `relay-to-design-md` 一致：

- `{{field}}` → 字面值替换
- 缺失数据 → 标 TBD，不留 `{{}}`
- 段落性内容（如 `{{section_2_behavior_list}}`）由模型构造完整 HTML 字符串塞进去

### Step 5: 演示 stage 处理

3 种 stage 形态（按优先级）:

| 形态 | 何时用 | 备注 |
|---|---|---|
| **切图 stage**（v0.2 推荐） | 组件来自 Relay,节点 ID 已知,展示标准形态 | 走 [references/stage-images-export.md](./references/stage-images-export.md) |
| 静态 mockup | 反例（违反规范的形态）或 Relay 上没有的形态 | 简化 div + class,不要复杂还原 |
| JS engine | feedback 类组件需要交互演示（如 toast 按钮触发） | 参考 jd-toast-spec 内嵌 script,模板留 `{{embedded_demo_script_or_empty}}` |

判断启发:
- 单组件（例如 button） → 切图 1 张 + variants 各 1 张
- page-doc bundle（例如 tabbar） → 章节 02-05 各章节子段 1 张,加 章节 01 整章 1 张
- 仅 feedback 组件（toast / loading / spinner） → 切图 + JS engine
- 反例 → 简化 div+class CSS mockup,不强求像

### Step 5b: 切图导出（v0.2 新）

走 [references/stage-images-export.md](./references/stage-images-export.md) 4 步流程:

1. **chunked b64 export 到 sharedPluginData**（use_design_script）:必须 chunkedB64 helper 避免栈溢出;namespace 固定 `jd-spec-page-assets`;一次脚本可批 export 7-12 张
2. **批量 readback 触发 dump**（use_design_script）:MCP 自动把 result 落到磁盘文件,不污染 LLM context
3. **jq + base64 -d 写 PNG**（Bash）:`jq -r '.[0].text | fromjson | to_entries[] | "\(.key)\n\(.value)"' "$SRC" | while ...`
4. **清理 sharedPluginData**（use_design_script,可选）:避免 Relay 文件膨胀

切图统一存 `<bundle-dir>/_assets/`,命名 `sec-{N}-{slug}.png`（如 `sec-3-island-promo.png`)。模板 `<style>` 已有 `.stage--image` class 自动适配宽度。

### Step 6: token CSS 变量

`templates/spec-page.html` `<style>` 头部 `:root { --c-text: ... }` 等 CSS 变量按 [references/style-tokens.md](./references/style-tokens.md) 映射：

- 直接复用 V16 [foundations/tokens/tokens.json](../../../jd-design-system-md-v16/foundations/tokens/tokens.json) 的 hex 值
- 不要硬编码 V15 风格的颜色，但保留对外站点的"白底卡片" CSS 风格（避免对外页面变成黑底）

### Step 7: 写文件 + 校验

1. `Write` 到 `<bundle-dir>/spec-page.html`
2. Bash `grep -E '\{\{[^}]+\}\}' <output>` 确认无残留占位符
3. Bash `wc -l` + `head -10 / tail -10` 抽查
4. **不要**自动打开浏览器（对外发布物，由用户决定何时 publish）

### Step 8: 终端输出

```
✅ 已生成: {output_path}
   ├─ 章节齐全度: 7/7
   ├─ TBD 段: {N} 个（详见 HTML 内 blockquote.warn）
   ├─ 演示 stage: {static-mockup | js-engine}
   └─ 字数: {N} 字 / 行数: {M}

📎 来源: {bundle 或 single design.md path}
📌 渲染样式: 基于 jd-toast-spec(1).html v0.1 (2026-05-09)

{如有 TBD / 字段缺失}
⚠️ 检测到 {K} 处来源 design.md 数据缺失，已在 HTML 内标 ⚠️ TBD，建议回补 design.md 后重跑
```

---

## 关键约束

1. **不要修改 design.md / spec.md / variants.md / behaviors.md** —— 这个 skill 是只读源 + 渲染发布物
2. **不要编造数据** —— design.md 缺哪段，HTML 对应章节就标 TBD
3. **不要 invent CSS 风格** —— 严格基于 jd-toast-spec(1).html 模板。需要调样式时改 [templates/spec-page.html](./templates/spec-page.html)
4. **不要把 7 章节合并 / 拆分** —— 数量固定 7。即使内容稀薄也要保留章节标题（标 TBD）
5. **不要嵌入 inline-style hex 颜色** —— 走 CSS variable
6. **演示 stage 默认静态 mockup** —— 除非组件性质明确是 feedback / 状态指示类
7. **Output 路径固定**：`<bundle-dir>/spec-page.html`，不要换文件名/位置

## References

| 文件 | 作用 |
|---|---|
| [templates/spec-page.html](./templates/spec-page.html) | 7 章节单页 HTML 模板（基于 jd-toast-spec(1).html v0.1） |
| [references/section-mapping.md](./references/section-mapping.md) | 7 章节 ↔ design.md / bundle 字段映射表 |
| [references/style-tokens.md](./references/style-tokens.md) | CSS variable ↔ V16 tokens.json 映射 |
| [references/stage-images-export.md](./references/stage-images-export.md) | 切图导出流程（v0.2 加）— chunked b64 / sharedPluginData 中转 / jq 解 dump |

## 版本历史

- **v0.1** (2026-05-14) MVP：
  - 模板基于 jd-toast-spec(1).html v0.1（外部参考节点 45:11576）
  - 7 章节固定结构
  - 支持 single design.md + page-doc bundle 两种输入
  - 演示 stage 静态 mockup（feedback 组件可走 JS engine fallback）
  - 输出固定 `<bundle-dir>/spec-page.html`
- **v0.2** (2026-05-14) 切图能力(实战兑现):
  - **① chunked b64 export 流程**:helper 60KB 块包装,绕过 `relay.base64Encode` 栈递归爆栈;实测对 1426×2154 的灵动岛节点(247KB raw)成功
  - **② sharedPluginData 中转**:b64 字符串通过 Relay 节点 sharedPluginData 持久化,namespace `jd-spec-page-assets`,单 value 实测 800k+ chars 无问题
  - **③ Dump-file readback 模式**:批量 readback 故意触发 MCP result-too-large,落地到磁盘 dump 文件,然后 `jq -r '.[0].text | fromjson | to_entries[] | "\(.key)\n\(.value)"'` 一次性提取所有 b64,bash 解码写 PNG。**整个流程不污染 LLM context**
  - **④ Stage block 模板支持**:`<style>` 加 `.stage--image` 自动适配宽度,`<img>` 替代 CSS+div mockup
  - **⑤ 实战:tabbar 9 张切图入页**:章节 01-05 各章节子段 export 到 `_assets/`,spec-page.html 12 处 `<img>` 替代原 mockup,文件从 994 → 806 行(精简 188 行 mockup CSS+div)
  - **⑥ References 加 stage-images-export.md**:完整 4 步流程文档
- v0.3 (planned) 加批量模式(一次跑多组件)+ 增量 diff(保留人写演示 mockup)+ TOC 自动嵌套(含 h3 子标题)+ 切图节点自动选择(避免每次手枚举)
