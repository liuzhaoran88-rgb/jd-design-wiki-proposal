# Fidelity Thresholds · 验证容忍度

定义 **Step 10 Verify** 阶段的验证容忍度与 token 覆盖率规则。

## 核心原则

100% 像素精确**不是目标** —— Auto Layout 的浮点取整和字体度量会让亚像素 diff 不可避免。目标是:

> 每个视觉值要么反查到一个 foundation token,要么是显式接受的 literal;bounds 在一个公布的紧容忍度内匹配 wiki spec。

这让输出可验证、可追溯、可复现,而不强求做不到的精确。

## 验证容忍度表

| 字段 | 容忍度 | 超出后判定 |
|---|---|---|
| 固定尺寸(spec 节点的 width/height) | **0.5 DP** | violation |
| 位置锚点(spec 节点的 x/y) | **0.5 DP** | violation |
| 重复分布漂移(n 个 slot 均分) | 全部 slot 累计 **1 DP** | warning |
| Auto Layout 取整(n.7499... vs n.75) | 视为 0(round 到 0.01 DP) | 忽略 |
| 文本字形垂直度量 | 文本框内 0.5 DP | 框尺寸匹配时忽略 |
| 颜色 | 精确 token,或列入 `unresolvedLiterals` 的 literal | 两者都不是则 violation |
| 圆角 | 精确 token,或列入 `unresolvedLiterals` 的 literal | 两者都不是则 violation |
| FontSize / lineHeight | 精确 token(来自 typography) | 缺失则 violation |
| Spacing(padding / itemSpacing) | 精确 token,或显式接受的 literal | warning |

## Token 覆盖率规则

每个字面视觉值都应落入以下三桶之一:

1. **Resolved** —— 值经 token 表来自一个 foundation token
2. **Spec literal** —— 值在组件 spec 里显式声明(如 `tabbar/spec.md` 写灵动岛圆角为 `13.5`)
3. **Unresolved** —— 值是一个 literal,既无 token 也无 spec 声明;**必须**列入 `tokenCoverage.unresolvedLiterals`

落入 **unresolved** 桶时,验证判定为 **violation**,除非:

- 用户传了 `--allow-literals` flag
- 该 literal 已在 `wikiGapsFound` 里登记,并给了建议 token

## 判定逻辑

```text
violations.length === 0  &&  warnings 可为 0 或多个  →  PASS
violations.length > 0                               →  FAIL(提前返回,不静默放行)
```

输出:

```json
{
  "verification": {
    "passed": true,
    "warnings": [
      {
        "node": "Slot 1 (home)",
        "field": "width",
        "expected": 80.75,
        "actual": 79.75,
        "delta": 1.0,
        "note": "wiki 02.2 表声明 80.75,实测 319÷4=79.75。capsule 319 与 80.75×4=323 不自洽,wiki 内部冲突;归到 wikiGapsFound"
      }
    ],
    "violations": []
  },
  "wikiGapsFound": [
    {
      "section": "02.2 表",
      "kind": "internal-inconsistency",
      "note": "Agent 组合容器宽 319 与单 slot 宽 80.75 × 4 = 323 不自洽",
      "suggestedFix": "capsule 319 或单 slot 80.75 二选一"
    }
  ]
}
```

## Strict Mode 不是什么

本 skill 早期草稿曾规定 `strict mode = 0 DP / 0 placeholder / 100% token binding,任何 > 0 即 fail`。该规定已**撤回**,原因:

- Auto Layout 会产生亚像素浮点 diff(0.01 DP),不是真实缺陷
- Spec literal(如灵动岛的 `13.5`)合法存在
- 强制 100% token binding 会让 skill 在 wiki 有 token gap 时根本无法生成

当前模型是:**对已声明字段严,对未声明字段松**。Wiki gap 以 `wikiGapsFound` 形式浮出供上游修,而不是当作 skill failure。

## 何时调整容忍度

| 场景 | 调整后的容忍度 |
|---|---|
| Foundation 值本身就是亚像素(罕见) | 接受;在 spec 里记录 |
| 组件 spec 声明了分数值(如 `79.75`) | 用 spec 值作 expected,容忍度仍为 0.5 DP |
| 5 个以上 slot 的重复分布 | 漂移容忍度放宽到累计 2 DP |
| 文本框用默认 `textAutoResize` | 关闭宽度容忍度(文本按内容自适应) |
| 导入的 SVG 内容位置 | 容忍度跟随父级 icon box,而非 SVG path |

## 与 Source Precedence 的关系

验证步骤比对三者:

- **created node**(实际)
- **normalized spec**(Step 5 给出的 expected)
- **wiki bundle 源**(按 source precedence 排序)

diff vs normalized spec → 套容忍度。
diff vs wiki bundle → 归到 `wikiGapsFound`(可能是 wiki 错,不是 skill 错)。

这让 skill 不会把 wiki 的不自洽静默掩盖成「passed」。

## 关联

- [`normalized-spec.md`](normalized-spec.md) —— assertion 在归一化阶段声明
- [`foundation-token-table.md`](foundation-token-table.md) —— token 解析决定 `resolved` vs `unresolvedLiterals` 分桶
- [`adapters/tabbar.md`](adapters/tabbar.md) —— 组件特异的容忍度覆盖(如有)
