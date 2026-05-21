# Foundation Token Table · auto-pull + 反查协议

实现 skill 的 **Step 1(Sync Foundation)** 与 Step 4 + Step 8 的 token 解析。

## 目标

skill 写任何 `fill` / `stroke` / `cornerRadius` / `fontSize` / `lineHeight` / `spacing` / `motion` / `material` 值时,都应当经过 V16 Foundation token 表反查。直接写 hex / px 仅在以下两条同时成立时可接受:(a) 没有匹配的 token;(b) 该值已记录为显式的 spec literal 或 `wikiGap`。

两件事必须可用:

1. **Foundation 永远最新** —— 每次跑动 auto-pull upstream,把 commit SHA 记进输出
2. **Token 双向反查可用** —— `name → value`(渲染)**和** `value → name`(验证)

## Step 1 · Foundation Auto-Pull

### 默认行为

```bash
git -C ~/code/jd-design-wiki-proposal pull --ff-only origin main
```

| 状态 | 处理 | `pullStatus` |
|---|---|---|
| ✅ fast-forward | 记录 commit SHA = upstream HEAD | `"success"` |
| ✅ up-to-date | 同上 | `"up-to-date"` |
| ⚠️ diverged(本地有未推 commit) | **不 reset**;用本地 + warn(带 SHA) | `"diverged"` |
| ⚠️ 网络故障 | 用本地缓存 + warn(带 SHA + 距上次 pull 时长) | `"offline"` |
| ❌ 仓库不存在 | fail;提示用户 `git clone https://github.com/ShuaiMXu/jd-design-wiki-proposal.git ~/code/jd-design-wiki-proposal` | — |

### 旁路 flag

| Flag | 效果 |
|---|---|
| `--no-pull` | 完全跳过 pull;`pullStatus = "skipped"` |
| `--foundation-from <path>` | 绕过仓库,用指定路径;`foundationSource = <path>` |

### 输出契约字段

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

`commit` 是追溯锚 —— 每次跑动都精确记录用的是哪一版 foundation 快照。

## Step 4 + Step 5 · 构建 Token 表

### 输入

完整读 `~/code/jd-design-wiki-proposal/jd-design-system-md-v16/foundations/`:

```text
foundations/
├── tokens/
│   ├── tokens.json         ← 首选源:结构化 token JSON
│   │                         (keys: color / typography / radius / lines / icon / spacing / palette / atom)
│   ├── color.md            ← color_*, gray_*, jdred, white 等 → hex
│   ├── typography.md       ← PingFang Regular/Medium/Semibold/Bold + font_size_N_W
│   ├── radius.md           ← radius_xs/s/m/l/xl/xxl → px
│   ├── spacing.md          ← spacing token
│   ├── icon.md             ← icon box / 描边规则
│   └── lines.md            ← 描边 / 分隔线 token
└── visual/
    ├── layout.md           ← canvas / grid / safe-area 规则
    └── materials.md        ← liquid-glass / frosted-glass / blur / shadow 规则
```

所有 token-class markdown(color / typography / radius / spacing / icon / lines)都在 `foundations/tokens/` 下 —— **没有** `foundations/visual/colors/`、`foundations/radius/`、`foundations/motion/` 这些目录。`foundations/visual/` 只放 `layout.md` 和 `materials.md`。

优先用 `tokens/tokens.json`(机器可读)。JSON 不完整时,回退到 `tokens/` 下的分类 markdown。

### 内存中的输出

```js
const tokenTable = {
  colors: {
    byName: { "color_title": "#171a26", "gray_1": "#11141a", "jdred": "#ff0f23", /* ... */ },
    byHex:  { "#171a26": "color_title", "#11141a": "gray_1", "#ff0f23": "jdred", /* ... */ },
  },
  typography: {
    byName: { "pingfang_semibold/font_size_10_600": { family: "PingFang SC", style: "Semibold", size: 10, lineHeight: 14 }, /* ... */ },
    bySize: { /* size + weight 反查 */ },
  },
  radius: {
    byName: { "radius_xl": 12, "radius_xxl": 16, /* ... */ },
    byPx:   { 12: "radius_xl", 16: "radius_xxl", /* ... */ },
  },
  spacing: {
    byName: { /* ... */ },
    byPx:   { /* ... */ },
  },
  motion:    { /* ... */ },
  materials: { /* ... */ },
  icon:      { /* ... */ },
};
```

### Resolver helper

```js
// 渲染 (name → value)
paintFromToken(tokenTable, 'jdred')
  // → { type: 'SOLID', color: { r: 1, g: 0.06, b: 0.137 }, ... }

cornerRadiusFromToken(tokenTable, 'radius_xl')
  // → 12

fontFromToken(tokenTable, 'pingfang_semibold/font_size_10_600')
  // → { fontName: { family: 'PingFang SC', style: 'Semibold' }, fontSize: 10, lineHeight: 14 }

// 验证 (value → name)
tokenForHex(tokenTable, '#ff0f23')
  // → 'jdred'(命中 → resolved)

tokenForHex(tokenTable, '#a8a8a8')
  // → null(无匹配 → unresolvedLiteral,可能是 wikiGap)
```

## Step 8 · 执行时的 Token Binding

写入 Relay 时,优先用 resolver helper,而非裸值:

| Anti-pattern ❌ | 推荐 ✅ |
|---|---|
| `node.fills = [relay.util.solidPaint('#ff0f23')]` | `node.fills = [paintFromToken(tokenTable, 'jdred')]` |
| `node.cornerRadius = 12` | `node.cornerRadius = cornerRadiusFromToken(tokenTable, 'radius_xl')` |
| `text.fontSize = 10` | `text.fontSize = fontFromToken(tokenTable, '...').fontSize` |
| `frame.itemSpacing = 4` | `frame.itemSpacing = spacingFromToken(tokenTable, 'spacing_xs')` |

某个值**没有匹配 token**且未声明为 spec literal → 列入 `tokenCoverage.unresolvedLiterals` 供 review。

## Step 10 · Token 覆盖率审计

验证阶段:

```text
for each created node:
  for each fill/stroke (SolidPaint):
    tokenName = tokenForHex(tokenTable, paint.color)
    if !tokenName && !specLiteral:  unresolved++

  if cornerRadius:
    tokenName = tokenForPx(tokenTable, cornerRadius)
    if !tokenName && !specLiteral:  unresolved++

  for text nodes:
    tokenName = tokenForFontSize(tokenTable, fontSize)
    if !tokenName:  unresolved++

  for spacing properties (padding*, itemSpacing):
    tokenName = tokenForSpacing(tokenTable, value)
    if !tokenName && !specLiteral:  unresolved++
```

输出:

```json
"tokenCoverage": {
  "resolved": ["color_title", "gray_1", "jdred", "radius_xl", "radius_xxl"],
  "specLiterals": [
    { "node": "Dynamic Island", "field": "cornerRadius", "value": 13.5, "source": "tabbar/design.md 02.3" }
  ],
  "unresolvedLiterals": [
    { "node": "...", "field": "fills[0].color", "value": "#A8A8A8", "wikiGap": "color not in foundations/tokens/color.md" }
  ]
}
```

按 [`fidelity-thresholds.md`](fidelity-thresholds.md),`unresolvedLiterals` 里的条目都算 **violation**,除非标了 `wikiGap`(此时改报到 `wikiGapsFound`,留给上游修)。

## 边界情况

| 场景 | 处理 |
|---|---|
| Foundation 没有匹配 token | 不要近似;记为 `unresolvedLiteral` + `wikiGap`,建议补 token |
| 同一 hex 对应多个 alias token | tokenTable 保留全部 alias;反查返回主名 + alias 列表 |
| Foundation token 命名漂移(如 `gray_6` 与 `color_background_component` 都是 `#f0f2f7`) | 两者都能反查;不一致记入 `wikiGapsFound` |
| 用户机器缺字体 | `await relay.listAvailableFontsAsync()` 校验;缺失 → fail 并明确提示「安装 PingFang SC」 |
| Foundation 读取错误(文件格式非法) | 画之前就 fail;报告是哪个文件导致失败 |

## 关联

- 实现 SKILL.md workflow 的 Step 1 / Step 4 / Step 5 / Step 8 / Step 10
- 为 [`fidelity-thresholds.md`](fidelity-thresholds.md) 的 `tokenCoverage` 字段提供解析逻辑
- v0.2 实现大概率会带一个 `bin/build-token-table.js`(或内联进 skill 主代码),读 foundation 目录并返回 tokenTable 对象
