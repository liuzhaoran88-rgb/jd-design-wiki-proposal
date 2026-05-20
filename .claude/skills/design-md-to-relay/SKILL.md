---
name: design-md-to-relay
description: 按 wiki design.md 规范在 Relay 当前打开文件里实例化一份参考设计稿。零输入(只需 design.md path 或 slug),自动读 bundle、读 Relay 原版组件作 ground truth、SVG 优先拉资产、用 Auto Layout 接管对齐。补 V16 三面闭环的「md → Relay」反向。⚠️ v0.1 骨架版本,等 issue #60 P0 合并后启动实现。
allowed-tools: [mcp__zero-design__get_design_metadata, mcp__zero-design__get_design_context, mcp__zero-design__get_screenshot, mcp__zero-design__get_variables, mcp__zero-design__use_design_script, Bash, Read, Write, Edit]
---

# /design-md-to-relay · design.md → Relay 参考稿

> ⚠️ **v0.1 骨架版本** —— 流程已梳理,实现脚本尚未编写。完整实现等 issue [#60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) P0 合并后启动。详见 [`README.md`](README.md)。

## 这个 skill 做什么

读 wiki 里某个组件的 `design.md`(+ bundle 兄弟文件 spec.md / behaviors.md / variants.md / ai-schema.yaml / _assets-cdn.md),按 wiki 规范在 **当前打开的 Relay 文件** 内创建一份对应设计稿,作为「按 wiki 规范实例化」的参考产物。

跟既有 4 skill 的位置关系:

```
                          Relay
                          ↑    ↓
                          ↑    ↓
  relay-to-design-md   ───┘    └───  design-md-to-relay (本 skill,补反向)
                                 ↓
                            design.md (bundle)
                                 ↓
                                 ├── design-md-to-portal (聚合发布)
                                 ├── design-md-to-spec-page (单组件发布)
                                 └── design-review (审计)
```

V16 编辑面、发布面、审计面三面闭环现已齐整。

## 调用方式

```
/design-md-to-relay <design-md-path-or-slug>
/design-md-to-relay <slug> --canvas-position <x,y>
/design-md-to-relay <slug> --skip-ground-truth   # 不推荐,跳过 Step 3 ground-truth probe
```

例:

```
/design-md-to-relay jd-design-system-md-v16/horizontal/components-base/tabbar/design.md
/design-md-to-relay tabbar
/design-md-to-relay tabbar --canvas-position 5600,100
```

默认只接受 1 个参数(design.md path 或 slug),其他全部自动推断。**不要**问额外问题。

## 何时触发

用户想:

- 「**按 wiki 规范在 Relay 里画一个 X**」
- 「**把 X 组件实例化到当前 Relay 文件**」
- 「**生成 X 组件的参考稿,用来对比设计师手稿**」
- 「**走查前先按 wiki 画一份对照**」
- 「**根据最新的 wiki 画一个 X**」

## 不适用场景

- 设计师想从零创意(不基于 wiki)→ 不走 skill
- wiki 里没有目标组件的 `design.md` → skill 不生成新 wiki 内容,先用 `relay-to-design-md` 反向产出 md
- 跨 Relay 文件操作 → 只在当前打开稿件内画
- page-doc level / flow level(L2/L3/L4)→ v1.0 才支持,v0.1-v0.5 仅 component-base

## 前置条件

- Relay 桌面端已打开目标文件(同所有 zero-design 系列 skill)
- 当前 page 视口位置已确定(避免画到屏幕外)
- 本地 jd-design-wiki-proposal 仓库存在(默认路径 `~/code/jd-design-wiki-proposal/`)
- 当前 wiki 内有目标组件的 `design.md` bundle

---

## Workflow · 8 步

> 详细 reference 见 [`references/workflow-8-steps.md`](references/workflow-8-steps.md)(v0.2 写)。

### Step 1 · Parse input

解析输入,定位 `design.md` path 与 bundle 兄弟文件位置。

- 接受全路径 / 短 slug(`tabbar` → 在 `jd-design-system-md-v16/**/tabbar/design.md` 查找)
- 容错:slug 多匹配时报歧义 + 列出候选

### Step 2 · Read bundle

读完整 bundle:

| 文件 | 取什么 |
|---|---|
| `design.md` | 主规范文本 + frontmatter(level / bg / slug / Relay 节点 ID)|
| `spec.md` | 视觉令牌精细字段(优先于 design.md 文字)|
| `variants.md` | 变体维度 |
| `behaviors.md` | 交互 / Donts |
| `ai-schema.yaml` | 机器可读 schema(若有)|
| `_assets-cdn.md` | 切图清单(SVG 优先,PNG fallback)|

### Step 3 · Probe Relay ground truth ★

⚠️ **这是 R3 走查反复错的根因门。不可跳过**。

读 `design.md` frontmatter 里登记的 Relay 原版组件节点(如 tabbar 的 `266:475` Joy Agent 形态 / `266:674` 普通形态),`get_design_metadata` 抽出真实子结构,**作为尺寸 / inset / 圆角的 ground truth**。

design.md 文字与 Relay 实测如果有冲突,**实测优先**。详见 [`references/ground-truth-anchors.md`](references/ground-truth-anchors.md)(v0.2 写)。

### Step 4 · Diff & report wiki gaps

把 Step 2 文字声明 vs Step 3 Relay 实测做字段 diff:

- 文字未声明、实测存在 → 标记为「wiki gap」,记录到产出报告
- 文字声明、实测不存在 → 标记为「wiki stale」
- 两者数值 diff > 0.5 DP → ⚠️ warn,> 2 DP → ❌ violate

产出 wiki gap 列表,可直接喂给 maintainer 开 issue(或 skill 内部触发 design-review skill)。

### Step 5 · Plan structure with Auto Layout ★

⚠️ **强制用 Auto Layout 接管对齐,禁止手算 x/y**。详见 [`references/auto-layout-patterns.md`](references/auto-layout-patterns.md)(v0.2 写)。

核心规则:

- **子节点位置:不写 x/y**,父 frame 用 `layoutMode` + `primaryAxisAlignItems` + `counterAxisAlignItems` 接管
- **均分场景**:子节点 `layoutGrow=1`,父 frame `primaryAxisSizingMode='FIXED'`
- **状态切换**:**层职责分离**(bg 层 / 行为层 / 视觉层),用不同 frame 承担
- **text 节点**:`fontName` 先 set,`characters` 后 set;**不依赖 `textAlignHorizontal`**,用父 frame Auto Layout 居中(参 R3 实录)

### Step 6 · Fetch assets · SVG 优先

按 `_assets-cdn.md` 解析资产清单:

| 字段 | 处理 |
|---|---|
| `svg_url` 存在 | `createFrameFromSvgAsync(svg)`(优先)|
| 仅 `png_fallback_url` | `createImageAsync(url)` + flag「资产应有 SVG」|
| 都缺失 | 用 ellipse placeholder + 标 `wikiGapsFound.missingAsset` |

详见 [`references/asset-fallback-chain.md`](references/asset-fallback-chain.md)(v0.2 写)。

### Step 7 · Execute use_design_script

分小步执行(< 5 个 batch),每步:

- 单一目标(创建容器 / 填子节点 / 替换资产 等)
- `return` 结构化数据(IDs + dimensions + status)
- 失败先停,读 err,修脚本再继续

### Step 8 · Post-verify

实现后:

1. `get_screenshot` 拉视觉截图自检
2. `get_design_metadata` 读所创建节点的 bounds + properties
3. 跟 wiki 字段做最终 diff,差 > 0.5 DP ⚠️ warn

---

## 输出契约

每次 skill 完整跑完返回 JSON:

```json
{
  "createdRootId": "59:xxxx",
  "createdNodeIds": ["59:xxxx", "..."],
  "tokenCoverage": {
    "color_*": "12/12 ✓",
    "radius_*": "2/2 ✓",
    "font_*": "3/3 ✓"
  },
  "assetUsage": {
    "svg": ["home-default", "home-active"],
    "png_fallback": [],
    "placeholder": ["category", "message", "profile"]
  },
  "wikiGapsFound": [
    {
      "section": "02.4",
      "missing_field": "selected_bg_inset_lr",
      "suggested_value": "4 DP",
      "source": "Relay ground truth 266:475 sec-2-states 实测"
    }
  ],
  "groundTruthDiff": [],
  "warnings": [],
  "violations": []
}
```

---

## 核心规则 · R3 实战沉淀

> 完整实录见 [`references/lessons-from-r3-tabbar.md`](references/lessons-from-r3-tabbar.md)

1. **Step 3 不可跳过** — 没读 Relay 原版组件直接动笔,几乎必错。R3 选中态宽度 2 次都错在跳过这一步。
2. **手算 x/y 是 anti-pattern** — 全部 Auto Layout。R3 第一版 textAlignHorizontal 不生效导致 label 偏 12 DP,根因是手算坐标 + 不锁 `textAutoResize`。
3. **PNG icon 是退而求其次** — 资产清单未登记 SVG 时,先 flag wiki gap 再 fallback。
4. **状态切换不要叠加同一节点 fill** — 用层职责分离。R3 把选中 bg 挂在 atom 上 → bg 大小被 atom 锁死,后来不得不引入 pill 重做一遍。

---

## 边界与不做

- ❌ **不生成新 wiki 内容**:wiki gap 只 flag,不补;补由 owner 走 PR
- ❌ **不替代设计师创意**:只画「按 wiki 规范」的参考稿,不是创意稿
- ❌ **不处理 page-doc / flow level**:L2/L3/L4 等 v1.0
- ❌ **跨 Relay 文件操作**:只在当前打开稿件内画
- ❌ **不强行兼容 v0.5 及以下 wiki bundle**:v0.6 起的 frontmatter / 字段结构为准

---

## Reference Docs

| Doc | 用途 | 状态 |
|---|---|---|
| [`README.md`](README.md) | v0.1 状态 / 路线图 / 跟 issue #60 的依赖 | ✅ v0.1 |
| [`references/lessons-from-r3-tabbar.md`](references/lessons-from-r3-tabbar.md) | R3 完整实录 + 4 处反复错的根因(skill 设计依据)| ✅ v0.1 |
| [`references/workflow-8-steps.md`](references/workflow-8-steps.md) | 8 步详细流程 + 每步可执行脚本 | ⏳ v0.2 |
| [`references/auto-layout-patterns.md`](references/auto-layout-patterns.md) | Auto Layout 对齐模式 cookbook | ⏳ v0.2 |
| [`references/ground-truth-anchors.md`](references/ground-truth-anchors.md) | Relay 节点作为真相源 SOP | ⏳ v0.2 |
| [`references/asset-fallback-chain.md`](references/asset-fallback-chain.md) | SVG → PNG → placeholder fallback 链 | ⏳ v0.2 |
