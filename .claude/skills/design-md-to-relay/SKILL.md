---
name: design-md-to-relay
description: 按 wiki design.md 规范在 Relay 当前打开文件里实例化一份**100% 还原的参考稿**。通用 component 生成器(任意 component-base),自动 auto-pull foundation 真相源、读 Relay 原版组件 ground truth、SVG 优先拉资产、用 Auto Layout 接管对齐、所有色/字/圆角强制绑定 V16 foundation token。补 V16 三面闭环的「md → Relay」反向。⚠️ v0.1 骨架版本,等 issue #60 P0 合并后启动实现。
allowed-tools: [mcp__zero-design__get_design_metadata, mcp__zero-design__get_design_context, mcp__zero-design__get_screenshot, mcp__zero-design__get_variables, mcp__zero-design__use_design_script, Bash, Read, Write, Edit]
---

# /design-md-to-relay · design.md → Relay 参考稿

> ⚠️ **v0.1 骨架版本** —— 流程已梳理,实现脚本尚未编写。完整实现等 issue [#60](https://github.com/ShuaiMXu/issues/60) P0 合并后启动。详见 [`README.md`](README.md)。

## 设计目标(硬约束)

| # | 目标 | 含义 |
|---|---|---|
| 1 | **通用 component 生成器** | 跑任意 `component-base` 组件,不绑定 tabbar 或具体业务 |
| 2 | **100% 还原度** | 几何 0 DP diff / 0 placeholder / 100% token binding,任一不达 strict 模式 fail |
| 3 | **符合 V16 Foundation** | 所有 fill / stroke / cornerRadius / fontSize / spacing 必须从 foundation 反查绑定,**禁止裸 hex / 裸 px** |
| 4 | **Foundation 实时同步** | skill 起手 auto-pull upstream main,产出报告附 foundation commit SHA(可追溯) |

## 这个 skill 做什么

读 wiki 里某个组件的 `design.md`(+ bundle 兄弟文件 spec.md / behaviors.md / variants.md / ai-schema.yaml / _assets-cdn.md),读 V16 foundation,按 wiki 规范在 **当前打开的 Relay 文件** 内创建一份对应设计稿,作为「按 wiki 规范实例化」的参考产物。

跟既有 4 skill 的位置关系:

```
                          Relay
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
/design-md-to-relay <slug> --strict                    # 默认即 strict;100% 还原硬门
/design-md-to-relay <slug> --no-strict                 # warn 模式,不 fail 占位 / DP diff
/design-md-to-relay <slug> --no-pull                   # 跳过 Step 0 foundation auto-pull(离线 / dev)
/design-md-to-relay <slug> --foundation-from <path>    # 用指定路径的 foundation(调试 / PR 分支验证)
```

例:

```
/design-md-to-relay jd-design-system-md-v16/horizontal/components-base/tabbar/design.md
/design-md-to-relay tabbar
/design-md-to-relay button --canvas-position 5600,100
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
- page-doc level / flow level(L2/L3/L4)→ v1.0 才支持,v0.1-v0.6 仅 component-base

## 前置条件

- Relay 桌面端已打开目标文件(同所有 zero-design 系列 skill)
- 当前 page 视口位置已确定(避免画到屏幕外)
- 本地 jd-design-wiki-proposal 仓库存在(默认路径 `~/code/jd-design-wiki-proposal/`)
- 当前 wiki 内有目标组件的 `design.md` bundle
- 网络可达 GitHub(`--no-pull` 时除外)

---

## Workflow · 10 步

> 详细 reference 见 [`references/workflow-10-steps.md`](references/workflow-10-steps.md)(v0.2 写)。

### Step 0 · Sync Foundation ★ 新加

⚠️ **Foundation 是真相源,必须最新**。skill 起手:

```bash
git -C ~/code/jd-design-wiki-proposal pull --ff-only origin main
```

- 成功 → 拿到 upstream 最新 foundation,记录当前 commit SHA
- 失败(网络故障 / 非 fast-forward)→ 降级用本地 cache,**输出 warn**:「foundation 用的是本地 X 分钟前快照(commit Y)」
- `--no-pull` flag → 跳过 pull,直接用本地
- `--foundation-from <path>` flag → 完全绕开本仓库的 foundation,用指定路径(调试用)

详见 [`references/foundation-token-table.md`](references/foundation-token-table.md)。

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

### Step 2.5 · Build Foundation token table ★ 新加

读 `jd-design-system-md-v16/foundations/` 全集,建本次跑动用的 token 表(in-memory):

| Foundation 类目 | 读什么 | 给 skill 用作什么 |
|---|---|---|
| `visual/colors/` | 全部 color token(`color_*` / `gray_*` / `jdred` / `white` / 等)→ hex 映射 | 反查 fill / stroke / 文字色 |
| `visual/typography/` | 字体 family + style + size + lineHeight 全套 | 反查 fontName / fontSize / lineHeight |
| `radius/` | `radius_xs/s/m/l/xl/xxl` → px 映射 | 反查 cornerRadius |
| `spacing/` | 间距 token | 反查 padding / itemSpacing |
| `motion/` | 动效 token | 用于变体的动效字段(v0.4+)|
| `materials/` | 液态玻璃 / 毛玻璃材质 | fill blend mode 配置 |
| `icon/` | icon 规范 | 校验 _assets-cdn.md 资产 |

输出:`tokenTable = { colorByName, colorByHex, typographyByName, radiusByPx, ... }` —— 双向反查能力。

详见 [`references/foundation-token-table.md`](references/foundation-token-table.md)。

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

### Step 6 · Fetch assets + bind tokens ★ 改名加强

按 `_assets-cdn.md` 解析资产清单 **并强制走 token 表绑定所有视觉值**:

| 字段 | 处理 |
|---|---|
| `svg_url` 存在 | `createFrameFromSvgAsync(svg)`(优先)|
| 仅 `png_fallback_url` | `createImageAsync(url)` + flag「资产应有 SVG」|
| 都缺失 | strict 模式 → fail;非 strict → placeholder + flag |
| 任何 fill / stroke / cornerRadius / fontSize | **必须经 token 表反查**,直接传 hex / px = anti-pattern,strict 模式 fail |

`relay.util.solidPaint('#FF0F23')` ❌ → `paintFromToken(tokenTable, 'jdred')` ✅

详见 [`references/asset-fallback-chain.md`](references/asset-fallback-chain.md)(v0.2 写)+ [`references/foundation-token-table.md`](references/foundation-token-table.md)。

### Step 7 · Execute use_design_script

分小步执行(< 5 个 batch),每步:

- 单一目标(创建容器 / 填子节点 / 替换资产 等)
- `return` 结构化数据(IDs + dimensions + status)
- 失败先停,读 err,修脚本再继续
- 所有视觉值**已 Step 6 绑定 token**,这里不应出现裸值

### Step 8 · Strict post-verify ★ 加 strict 模式

实现后:

1. `get_screenshot` 拉视觉截图自检
2. `get_design_metadata` 读所创建节点的 bounds + properties
3. 跟 wiki 字段 + Relay 原版做最终 diff
4. **strict 模式判定**(默认开):

| 维度 | strict 阈值 | 非 strict 阈值 |
|---|---|---|
| 几何 dimension diff | 0 DP → 任何 > 0 即 fail | > 0.5 DP warn / > 2 DP violate |
| Token binding 覆盖率 | 100%(0 个裸 hex / px)| 80%+ 即可 |
| Placeholder 数量 | 0 个 | 不限 |
| 变体完整性 | 100%(枚举状态全画)| 至少 1 个 |

任一不达 → strict 模式 ❌ fail,要求修复。详见 [`references/fidelity-thresholds.md`](references/fidelity-thresholds.md)。

### Step 9 · Sub-component composition ★ 新加

如组件 references 其他组件(如 tabbar references Joy Agent),递归处理:

- 解析 design.md frontmatter `references.uses_components` 字段
- 对每个 dependency:递归调用本 skill(slug + 上下文)
- 子组件生成在父组件之前(`useChild → useParent` 拓扑序)
- 循环引用检测:DFS + visited 集合,出现环 → 报错

详见 [`references/cross-component-deps.md`](references/cross-component-deps.md)(v0.2 写)。

---

## 输出契约

每次 skill 完整跑完返回 JSON:

```json
{
  "createdRootId": "59:xxxx",
  "createdNodeIds": ["59:xxxx", "..."],
  "foundationVersion": {
    "commit": "99c2e6f",
    "pulledAt": "2026-05-21T14:32:00Z",
    "pullStatus": "success",
    "remote": "ShuaiMXu/jd-design-wiki-proposal@main"
  },
  "tokenCoverage": {
    "color_*": "12/12 ✓ 100%",
    "radius_*": "2/2 ✓ 100%",
    "font_*": "3/3 ✓ 100%",
    "spacing_*": "5/5 ✓ 100%",
    "rawHexCount": 0,
    "rawPxCount": 0
  },
  "assetUsage": {
    "svg": ["home-default", "home-active"],
    "png_fallback": [],
    "placeholder": []
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
  "variantsCovered": ["default", "selected", "marketing", "with-bubble"],
  "strictMode": true,
  "fidelity": {
    "geometricDiffMaxDp": 0,
    "tokenBindingPercent": 100,
    "placeholderCount": 0,
    "variantCompleteness": "100%",
    "verdict": "PASS"
  },
  "warnings": [],
  "violations": []
}
```

---

## 核心规则 · 8 条

> 1-4 来自 R3 Tabbar 实战,5-8 来自本次设计目标硬化。完整记录见 [`references/lessons-from-r3-tabbar.md`](references/lessons-from-r3-tabbar.md)

1. **Step 3 不可跳过** —— 没读 Relay 原版组件直接动笔几乎必错(R3 选中态宽度 2 次错根因)
2. **手算 x/y 是 anti-pattern** —— 全部 Auto Layout(R3 label 偏 12 DP 根因)
3. **PNG icon 是退而求其次** —— 资产清单未登记 SVG 时,先 flag wiki gap 再 fallback
4. **状态切换不要叠加同一节点 fill** —— 用层职责分离,bg 在 pill,内容在 atom
5. **裸 hex / 裸 px 即违反 foundation 优先** —— strict 模式 fail。所有视觉值必须 token 反查绑定
6. **占位形状(ellipse / placeholder)不算「实现」** —— strict 模式 fail。无 SVG 即开 wiki gap issue
7. **> 0 DP 的几何 diff 即非 100% 还原** —— strict 模式 fail。Relay 原版组件实测为 0 DP 基准
8. **跨组件依赖必须递归全展开** —— 不允许「先画外壳留子组件 TODO」(违反目标 1 + 2)

---

## 边界与不做

- ❌ **不生成新 wiki 内容**:wiki gap 只 flag,不补;补由 owner 走 PR
- ❌ **不替代设计师创意**:只画「按 wiki 规范」的参考稿,不是创意稿
- ❌ **不处理 page-doc / flow level**:L2/L3/L4 等 v1.0
- ❌ **跨 Relay 文件操作**:只在当前打开稿件内画
- ❌ **不强行兼容 v0.5 及以下 wiki bundle**:v0.6 起的 frontmatter / 字段结构为准
- ❌ **不修改 foundation 本身**:foundation 是只读真相源,有问题走 wiki PR

---

## Reference Docs

| Doc | 用途 | 状态 |
|---|---|---|
| [`README.md`](README.md) | v0.1 状态 / 路线图 / 跟 issue #60 的依赖 | ✅ v0.1 |
| [`references/lessons-from-r3-tabbar.md`](references/lessons-from-r3-tabbar.md) | R3 完整实录 + 4 处反复错的根因(规则 1-4 依据)| ✅ v0.1 |
| [`references/foundation-token-table.md`](references/foundation-token-table.md) | Foundation auto-pull + token 表构建 + 反查协议 | ✅ v0.1 |
| [`references/fidelity-thresholds.md`](references/fidelity-thresholds.md) | 100% 还原度量化判定:几何 0 DP / 0 placeholder / 100% binding / 变体全枚举 | ✅ v0.1 |
| [`references/workflow-10-steps.md`](references/workflow-10-steps.md) | 10 步详细流程 + 每步可执行脚本 | ⏳ v0.2 |
| [`references/auto-layout-patterns.md`](references/auto-layout-patterns.md) | Auto Layout 对齐模式 cookbook | ⏳ v0.2 |
| [`references/ground-truth-anchors.md`](references/ground-truth-anchors.md) | Relay 节点作为真相源 SOP | ⏳ v0.2 |
| [`references/asset-fallback-chain.md`](references/asset-fallback-chain.md) | SVG → PNG → fail 链 | ⏳ v0.2 |
| [`references/cross-component-deps.md`](references/cross-component-deps.md) | 子组件依赖解析 / 递归生成 / 循环引用检测 | ⏳ v0.2 |
| [`references/foundation-coverage.md`](references/foundation-coverage.md) | 7 个 foundation 类目各自怎么消费 | ⏳ v0.2 |
