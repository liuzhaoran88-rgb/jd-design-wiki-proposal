# Foundation Token Table · auto-pull + 反查协议

Implements skill **Step 1 (Sync Foundation)** and Step 4 + Step 8 token resolution.

## Goal

When the skill writes any `fill` / `stroke` / `cornerRadius` / `fontSize` / `lineHeight` / `spacing` / `motion` / `material` value, it should resolve through the V16 Foundation token table. Direct hex/px is acceptable only when (a) no matching token exists and (b) the value is documented as an explicit spec literal or `wikiGap`.

Two things must work:

1. **Foundation 永远最新** — auto-pull upstream every run, record commit SHA in output
2. **Token 双向反查可用** — `name → value` (rendering) **and** `value → name` (verification)

## Step 1 · Foundation Auto-Pull

### Default

```bash
git -C ~/code/jd-design-wiki-proposal pull --ff-only origin main
```

| State | Handling | `pullStatus` |
|---|---|---|
| ✅ fast-forward | record commit SHA = upstream HEAD | `"success"` |
| ✅ up-to-date | same | `"up-to-date"` |
| ⚠️ diverged (local commits ahead) | **do not reset**; use local + warn with SHA | `"diverged"` |
| ⚠️ network failure | use local cache + warn with SHA + age | `"offline"` |
| ❌ repo missing | fail; prompt user to `git clone https://github.com/ShuaiMXu/jd-design-wiki-proposal.git ~/code/jd-design-wiki-proposal` | — |

### Bypass flags

| Flag | Effect |
|---|---|
| `--no-pull` | skip pull entirely; `pullStatus = "skipped"` |
| `--foundation-from <path>` | bypass repo, use specified path; `foundationSource = <path>` |

### Output contract field

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

`commit` is the traceability anchor — every run records exactly which foundation snapshot was used.

## Step 4 + Step 5 · Building the Token Table

### Input

Read `~/code/jd-design-wiki-proposal/jd-design-system-md-v16/foundations/` in full:

```text
foundations/
├── tokens/
│   └── tokens.json         ← preferred source: all token-class structured JSON
├── visual/
│   ├── colors/             ← color_*, gray_*, jdred, white, etc → hex
│   ├── typography/         ← PingFang Regular/Medium/Semibold/Bold + fontSize_N_W
│   ├── layout.md           ← canvas, grid, safe-area rules
│   └── materials.md        ← liquid-glass / frosted-glass / blur / shadow rules
├── radius/                 ← radius_xs/s/m/l/xl/xxl → px
├── spacing/                ← spacing tokens
├── motion/                 ← easing / duration
└── icon/                   ← icon box rules
```

Prefer `tokens/tokens.json` (machine-readable). Fall back to per-category markdown when JSON is incomplete.

### In-memory output

```js
const tokenTable = {
  colors: {
    byName: { "color_title": "#171a26", "gray_1": "#11141a", "jdred": "#ff0f23", /* ... */ },
    byHex:  { "#171a26": "color_title", "#11141a": "gray_1", "#ff0f23": "jdred", /* ... */ },
  },
  typography: {
    byName: { "pingfang_semibold/font_size_10_600": { family: "PingFang SC", style: "Semibold", size: 10, lineHeight: 14 }, /* ... */ },
    bySize: { /* size + weight reverse lookup */ },
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

### Resolver helpers

```js
// rendering (name → value)
paintFromToken(tokenTable, 'jdred')
  // → { type: 'SOLID', color: { r: 1, g: 0.06, b: 0.137 }, ... }

cornerRadiusFromToken(tokenTable, 'radius_xl')
  // → 12

fontFromToken(tokenTable, 'pingfang_semibold/font_size_10_600')
  // → { fontName: { family: 'PingFang SC', style: 'Semibold' }, fontSize: 10, lineHeight: 14 }

// verification (value → name)
tokenForHex(tokenTable, '#ff0f23')
  // → 'jdred' (found → resolved)

tokenForHex(tokenTable, '#a8a8a8')
  // → null (no match → unresolvedLiteral, may be wikiGap)
```

## Step 8 · Token Binding During Execution

When writing to Relay, prefer resolver helpers over raw values:

| Anti-pattern ❌ | Preferred ✅ |
|---|---|
| `node.fills = [relay.util.solidPaint('#ff0f23')]` | `node.fills = [paintFromToken(tokenTable, 'jdred')]` |
| `node.cornerRadius = 12` | `node.cornerRadius = cornerRadiusFromToken(tokenTable, 'radius_xl')` |
| `text.fontSize = 10` | `text.fontSize = fontFromToken(tokenTable, '...').fontSize` |
| `frame.itemSpacing = 4` | `frame.itemSpacing = spacingFromToken(tokenTable, 'spacing_xs')` |

If a value has **no matching token** and is not declared as a spec literal, list it under `tokenCoverage.unresolvedLiterals` for review.

## Step 10 · Token Coverage Audit

During verification:

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

Output:

```json
"tokenCoverage": {
  "resolved": ["color_title", "gray_1", "jdred", "radius_xl", "radius_xxl"],
  "specLiterals": [
    { "node": "Dynamic Island", "field": "cornerRadius", "value": 13.5, "source": "tabbar/design.md 02.3" }
  ],
  "unresolvedLiterals": [
    { "node": "...", "field": "fills[0].color", "value": "#A8A8A8", "wikiGap": "color not in foundation/visual/colors" }
  ]
}
```

Per [`fidelity-thresholds.md`](fidelity-thresholds.md), entries in `unresolvedLiterals` are **violations** unless flagged as `wikiGap` (then reported in `wikiGapsFound` for upstream fix).

## Edge Cases

| Scenario | Handling |
|---|---|
| Foundation has no matching token | Do not approximate; record as `unresolvedLiteral` + `wikiGap` suggesting token addition |
| Same hex maps to multiple alias tokens | tokenTable keeps all aliases; reverse lookup returns primary name + alias list |
| Foundation token names drift (e.g. `gray_6` and `color_background_component` both `#f0f2f7`) | Both reverse-resolve; report inconsistency in `wikiGapsFound` |
| Typography font missing on user machine | `await relay.listAvailableFontsAsync()` validates; missing → fail with explicit "install PingFang SC" prompt |
| Foundation read error (file format invalid) | Fail before drawing; report which file caused failure |

## Related

- Implements Step 1 / Step 4 / Step 5 / Step 8 / Step 10 of SKILL.md workflow
- Provides resolution logic for [`fidelity-thresholds.md`](fidelity-thresholds.md) `tokenCoverage` field
- v0.2 implementation will likely include a `bin/build-token-table.js` (or inline in skill main code) that reads foundation directory and returns the tokenTable object
