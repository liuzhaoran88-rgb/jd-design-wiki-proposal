# 100% 还原度量化判定

> 实现 skill **Step 8 (Strict post-verify)** 的详细判定规则。

## 核心原则

> 「100% 还原」不是模糊的「视觉差不多」,而是**4 个维度全部硬达标,任一不达即 fail**。

## 4 维度判定矩阵

| 维度 | strict 模式(默认)| 非 strict 模式(`--no-strict`)| 来源 |
|---|---|---|---|
| **几何尺寸 diff** | 0 DP,任何 > 0 即 fail | > 0.5 DP warn / > 2 DP violate | 跟 Relay 原版组件实测 bounds 对照 |
| **Token binding 覆盖率** | 100%(0 个裸 hex / px) | 80%+ 即可 | 跟 Foundation token 表反查 |
| **Placeholder 数量** | 0 个 | 不限 | _assets-cdn.md 资产清单是否齐全 |
| **变体完整性** | 100%(枚举状态全画) | 至少 1 个变体 | variants.md / spec.md 声明的状态矩阵 |

## 维度 1 · 几何尺寸 diff

### 判定逻辑

```
for each created node:
  对应 Relay 原版子节点 = find by name pattern in 原版组件 (266:475 等)
  if 对应节点存在:
    diffX = abs(created.x - 原版.x)
    diffY = abs(created.y - 原版.y)
    diffW = abs(created.width - 原版.width)
    diffH = abs(created.height - 原版.height)
    
    strict: diffMax = max(diffX, diffY, diffW, diffH)
      if diffMax > 0 → fail
    non-strict:
      if diffMax > 2 → violate
      elif diffMax > 0.5 → warn
```

### 例外

| 例外 | 处理 |
|---|---|
| Auto Layout 引擎计算的浮点(如 79.74999 vs 79.75) | 视为 0 DP diff(diffMax ≤ 0.01 时舍入) |
| 文字 frame 因字体 metrics 微小差异 | 视为 0 DP diff(diffMax ≤ 0.5 时归零,但仅 text 节点适用) |
| 浮动节点(`layoutPositioning='ABSOLUTE'` + 出血到屏幕外) | 跟原版同样为浮动 → 用 absoluteTransform 对比 |

## 维度 2 · Token Binding 覆盖率

### 判定逻辑

详见 [`foundation-token-table.md`](foundation-token-table.md) 「Token 命中率审计」节。

```
for each created node:
  for each fill / stroke in fills/strokes:
    if type === 'SOLID':
      tokenName = tokenForHex(tokenTable, paint.color)
      if !tokenName:
        rawHexCount++
        violations.push({ nodeId, field: 'fills', value: paint.color })
  
  if cornerRadius:
    tokenName = tokenForPx(tokenTable, cornerRadius)
    if !tokenName: rawPxCount++
  
  if type === 'TEXT':
    tokenName = tokenForFontSize(tokenTable, fontSize)
    if !tokenName: rawPxCount++
  
  if itemSpacing / padding*:
    tokenName = tokenForSpacing(tokenTable, value)
    if !tokenName: rawPxCount++

strict:
  if rawHexCount > 0 || rawPxCount > 0 → fail
non-strict:
  binding% = (totalRefs - rawCount) / totalRefs
  if binding% < 80% → warn
```

### 例外

| 例外 | 处理 |
|---|---|
| 透明色 `rgba(0,0,0,0)` | 不参与 binding 检查 |
| 渐变色 GradientPaint | 每个 stop 走 tokenForHex 反查;全部命中 → 通过;有一个未命中 → fail |
| 切图 ImagePaint | 不参与 binding 检查(资产自身已是 token-resolved) |
| 浮点 cornerRadius(如 `13.5` 灵动岛) | 若 wiki 自身就声明这个非 token 数值 → 允许;否则 → fail |

## 维度 3 · Placeholder 数量

### 判定逻辑

```
for each "icon" or "asset" position (per _assets-cdn.md 应当登记的位置):
  if 当前创建的是 ellipse / rectangle 占位:
    placeholderCount++
    violations.push({ position, expectedAsset: '...' })

strict:
  if placeholderCount > 0 → fail
non-strict:
  无限制
```

### 例外

| 例外 | 处理 |
|---|---|
| _assets-cdn.md 自身就标 "无资产" 的位置 | 允许 placeholder |
| 设计稿本身就是 placeholder 区域(如内容卡片占位) | 允许;skill 应识别 design.md 是否把该位置标为 "示意" |

### 修法引导

placeholder 出现 → skill 必须输出明确动作建议:

```json
{
  "placeholderViolations": [
    {
      "slot": "分类",
      "position": "tabbar slot 2 icon",
      "currentAsset": "ellipse placeholder",
      "expectedAsset": "category icon SVG",
      "action": "请设计师在 _assets-cdn.md 补 'category-default.svg' + 'category-active.svg' 登记;skill 不主动占位"
    }
  ]
}
```

## 维度 4 · 变体完整性

### 判定逻辑

```
variantMatrix = parseVariantsMatrix(variants.md)
// 例:tabbar 有「默认态/选中态/营销态」× 「无招手/红点/数字/文字」= 12 个组合

createdVariants = scan created nodes for variant markers (name + properties)

coverage = createdVariants.length / variantMatrix.length

strict:
  if coverage < 100% → fail
non-strict:
  if coverage < 1 (至少 1 个) → fail
  else → warn 列出 missing
```

### 例外

| 例外 | 处理 |
|---|---|
| user 显式跑 `--single-variant <name>` flag | 跳过此维度;只画 1 个变体 |
| design.md 标 「典型场景默认形态」时 | strict 模式仍要全枚举,只是把「典型」作为 highlighted |

## 复合判定:fidelity verdict

```js
const verdict = {
  geometricDiffMaxDp: maxDiffAcrossNodes,
  tokenBindingPercent: bindingPercent,
  placeholderCount: placeholderCount,
  variantCompleteness: coveragePercent,
  
  // strict 模式四维齐过 → PASS;任一不达 → FAIL
  verdict: strict
    ? (geometricDiffMaxDp === 0 && bindingPercent === 100 && placeholderCount === 0 && coveragePercent === 100)
      ? "PASS" : "FAIL"
    : (geometricDiffMaxDp <= 2 && bindingPercent >= 80 && coveragePercent > 0)
      ? "PASS-NONSTRICT" : "FAIL"
};
```

## 输出契约

```json
{
  "fidelity": {
    "geometricDiffMaxDp": 0,
    "tokenBindingPercent": 100,
    "placeholderCount": 0,
    "variantCompleteness": "100%",
    "verdict": "PASS",
    "perDimensionDetails": {
      "geometry": [/* 每个节点 diff 详情 */],
      "tokens": { "rawHexes": [], "rawPxes": [] },
      "placeholders": [],
      "variants": { "matrix": [...], "covered": [...], "missing": [] }
    }
  }
}
```

## strict 模式的意义

strict 默认开 = **「这个 skill 默认不留模糊空间」**。任何 0.5 DP / 一个 placeholder / 一个裸 hex,都强制 fail,让 user 看到具体 violation + 修法,而不是「差不多就行」混过去。

这条价值观直接对应 100% 还原度目标 —— 若允许「差不多」就不是 100% 了。

## 关联

- 维度 1 依赖 Step 3 (Probe Relay ground truth) + Step 8 自读
- 维度 2 依赖 [`foundation-token-table.md`](foundation-token-table.md)
- 维度 3 依赖 [`asset-fallback-chain.md`](asset-fallback-chain.md)(v0.2 写)
- 维度 4 依赖 variants.md 解析(v0.2 写在 `references/cross-component-deps.md` 或新加 `references/variants-matrix.md`)
