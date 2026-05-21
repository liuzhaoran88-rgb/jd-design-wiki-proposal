# Foundation Token 表 · auto-pull + 反查协议

> 实现 skill **Step 0 (Sync Foundation)** 与 **Step 2.5 (Build Foundation token table)** 的详细规范。

## 目标

Skill 任何时候用到 fill / stroke / cornerRadius / fontSize / spacing / motion / material 等视觉值,都必须**从 V16 Foundation 反查绑定**,禁止裸 hex / 裸 px。

实现这一点要做到 2 件事:

1. **Foundation 永远最新**:每次跑 skill 都从 upstream main pull 最新
2. **Token 双向反查可用**:既能 `name → value`(渲染时),也能 `value → name`(校验时)

## Step 0 · Foundation auto-pull

### 默认行为

```bash
git -C ~/code/jd-design-wiki-proposal pull --ff-only origin main
```

| 状态 | 处理 |
|---|---|
| ✅ 成功 fast-forward | 记录 `foundationVersion.commit` = upstream HEAD,`pullStatus = "success"` |
| ⚠️ 已是 up-to-date | 同上,`pullStatus = "up-to-date"` |
| ❌ 非 fast-forward(本地有冲突 commit) | **不强 reset**;输出 warn:「本地 foundation 有未推送改动,使用本地版本(commit X)」`pullStatus = "diverged"` |
| ❌ 网络故障 | 输出 warn:「无法连接 upstream,使用本地 foundation(commit X,X 分钟前 pull)」`pullStatus = "offline"` |
| ❌ 仓库不存在 | strict 模式 fail。提示用户先 clone:`git clone https://github.com/ShuaiMXu/jd-design-wiki-proposal.git ~/code/jd-design-wiki-proposal` |

### 可绕开的 flags

| Flag | 含义 |
|---|---|
| `--no-pull` | 跳过 pull,直接用本地。报告 `pullStatus = "skipped"` |
| `--foundation-from <path>` | 完全用指定路径(调试 PR 分支 / fork 验证)。报告 `foundationSource = <path>` |

### 输出契约里的字段

```json
{
  "foundationVersion": {
    "commit": "99c2e6f",
    "pulledAt": "2026-05-21T14:32:00Z",
    "pullStatus": "success",
    "remote": "ShuaiMXu/jd-design-wiki-proposal@main",
    "foundationSource": "~/code/jd-design-wiki-proposal/jd-design-system-md-v16/foundations/"
  }
}
```

`commit` 是可追溯的硬保证 —— user 一眼能看出「这次跑动用的是哪版 foundation」。

## Step 2.5 · 建 Token 表

### 输入

读 `~/code/jd-design-wiki-proposal/jd-design-system-md-v16/foundations/` 下全集:

```
foundations/
├── visual/
│   ├── colors/        ← color_*, gray_*, jdred, white 等
│   ├── typography/    ← 苹方 Regular/Medium/Semibold/Bold + fontSize_N_W
│   ├── ...
├── radius/            ← radius_xs/s/m/l/xl/xxl
├── spacing/           ← spacing_xs/s/m/l/xl/...
├── motion/            ← easing / duration tokens
├── materials/         ← liquid-glass / frosted-glass / 描边规则
└── icon/              ← icon 规范
```

### 输出(in-memory)

```js
const tokenTable = {
  colors: {
    byName: { "color_title": "#171a26", "gray_1": "#11141a", "jdred": "#ff0f23", ... },
    byHex:  { "#171a26": "color_title", "#11141a": "gray_1", "#ff0f23": "jdred", ... },
  },
  typography: {
    byName: { "pingfang_semibold/font_size_10_600": { family: "PingFang SC", style: "Semibold", size: 10, lineHeight: 14 }, ... },
    bySize: { /* size + weight 反查 */ },
  },
  radius: {
    byName: { "radius_xl": 12, "radius_xxl": 16, ... },
    byPx:   { 12: "radius_xl", 16: "radius_xxl", ... },
  },
  spacing: {
    byName: { /* ... */ },
    byPx:   { /* ... */ },
  },
  motion:    { /* ... */ },
  materials: { /* ... */ },
  icon:      { /* 规范集 */ },
};
```

### 关键工具方法

```js
// 渲染时(name → value)
paintFromToken(tokenTable, 'jdred')
  → { type: 'SOLID', color: { r: 1, g: 0.06, b: 0.137 }, ... }

cornerRadiusFromToken(tokenTable, 'radius_xl')
  → 12

fontFromToken(tokenTable, 'pingfang_semibold/font_size_10_600')
  → { fontName: { family: 'PingFang SC', style: 'Semibold' }, fontSize: 10, lineHeight: 14 }

// 校验时(value → name)
tokenForHex(tokenTable, '#ff0f23')
  → 'jdred'   // 找到 → 合规

tokenForHex(tokenTable, '#a8a8a8')
  → null      // 找不到 → 裸 hex,strict 模式 fail
```

## Step 6 · 强制 binding

任何视觉值赋值必须经过反查工具。**直接传 hex / px 是 anti-pattern**。

| 错 ❌ | 对 ✅ |
|---|---|
| `node.fills = [relay.util.solidPaint('#ff0f23')]` | `node.fills = [paintFromToken(tokenTable, 'jdred')]` |
| `node.cornerRadius = 12` | `node.cornerRadius = cornerRadiusFromToken(tokenTable, 'radius_xl')` |
| `text.fontSize = 10` | `text.fontSize = fontFromToken(tokenTable, '...').fontSize` |
| `frame.itemSpacing = 4` | `frame.itemSpacing = spacingFromToken(tokenTable, 'spacing_xs')` |
| `paint.color = { r: 110/255, g: 54/255, b: 221/255, a: 1 }` | 渐变色也要 foundation 提供;wiki 没有就开 issue 补 |

## Token 命中率审计

Step 8 strict post-verify 时,扫所有创建节点:

| 类目 | 审计逻辑 |
|---|---|
| `fills` / `strokes` | 扫 SolidPaint.color → tokenForHex 反查;找不到 → 计入 `rawHexCount` |
| `cornerRadius` | tokenForPx 反查;找不到 → `rawPxCount++` |
| `fontSize` / `lineHeight` | tokenForFontSize 反查 |
| `itemSpacing` / `padding*` | tokenForSpacing 反查 |

输出:

```json
"tokenCoverage": {
  "color_*": "12/12 ✓ 100%",
  "radius_*": "2/2 ✓ 100%",
  "font_*": "3/3 ✓ 100%",
  "spacing_*": "5/5 ✓ 100%",
  "rawHexCount": 0,
  "rawPxCount": 0
}
```

`rawHexCount` 或 `rawPxCount` 任一 > 0 → strict 模式 fail。

## 边界情况

| 情况 | 处理 |
|---|---|
| foundation 里没有目标 token | 不要凑近似;开 wiki gap issue 让 maintainer 补 token,然后用 `--no-pull --foundation-from PR-branch-path` 验证 |
| 同一 hex 多个 token alias | tokenTable 应保留全部 alias,反查返回主名 + alias 列表;报告里同时列出 |
| Foundation 自身 token 不闭合(命名漂移) | tabbar/design.md 已经发现 `gray_6` 与 `color_background_component` 数值漂移;skill 应识别这种 → flag 到 wikiGapsFound |
| typography 字体在用户机器没装 | `await relay.listAvailableFontsAsync()` 校验;缺失 → fail + 提示安装 PingFang SC |

## 关联

- 实现 Step 0 / Step 2.5 / Step 6 的核心规范
- 与 [`fidelity-thresholds.md`](fidelity-thresholds.md) 的「100% token binding」判定挂钩
- v0.2 实现时编 `bin/build-token-table.js`(或 inline 在 skill 主代码),输入 foundation 目录,输出 tokenTable 对象
