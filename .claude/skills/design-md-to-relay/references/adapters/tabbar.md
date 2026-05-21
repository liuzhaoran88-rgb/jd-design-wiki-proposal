# Tabbar Adapter

This adapter captures Tabbar-specific lessons without making the main skill Tabbar-specific.

It is **not** a copy of `tabbar/design.md`. Always read the real Tabbar spec from the source wiki repository at runtime. This adapter only explains how to map Tabbar wiki fields into a Relay node plan.

## Scope Questions

If the user says "画一个底导" and does not specify scope, ask:

```text
你要的是一个底导放在手机页面里的示意，还是底导组件的多状态规范展示？
```

Do not create multiple Tabbar variants unless requested.

## Common Single-Instance Defaults

Use only when the wiki confirms them or the user scope matches a JD app phone page:

| Field | Value | Source |
|---|---|---|
| phone page | 375 × 812 | foundation/visual/layout.md |
| bottom layer | 69 | tabbar/design.md 02.1 |
| nav height | 52 | tabbar/design.md 02.1 |
| floating safe area | 17 | tabbar/design.md 02.1 |
| Joy Agent atom | 52 × 52 | tabbar/design.md 02.6 |
| Joy Agent outward offset | 16 | tabbar/design.md 02.6 |
| Joy Agent to capsule gap | 8 | tabbar/design.md 02.6 |
| capsule (with Joy Agent) | 319 × 52 | tabbar/design.md 02.1 |
| tab atom | 44 × 44 | tabbar/design.md 02.4 |
| icon box | 20 × 20, y=3 | tabbar/design.md 02.4 |
| label box | 44 × 14, y=27 | tabbar/design.md 02.4 |
| selected pill L/R inset | 4 (within slot) | Zero ground truth (wiki gap, see issue #60 Gap 1) |
| selected pill radius | radius_xl (12) | tabbar/design.md 设计令牌总表 |

## Text Rule

For Tabbar labels, use **fixed text boxes**:

```text
textAutoResize = NONE
width = 44
height = 14
y = 27
fontSize = 10
lineHeight = 14
align = center
```

This prevents Chinese label frames from auto-shrinking and drifting away from the icon center. (See R3 lesson #2.)

## Layering Rule

Separate:

- **slot distribution layer** (capsule's `layoutGrow=1` children)
- **selected background visual layer** (the pill: gray_6 fill + radius_xl)
- **44 × 44 tab atom content layer** (icon + label container)
- **icon box** (20 × 20 SVG container)
- **label box** (44 × 14 fixed-bound text)

Do not attach selected background directly to icon or label nodes. (See R3 lesson #3.)

## Ground Truth

Use original Relay Tabbar nodes (e.g., `266:475` Joy Agent form, `266:674` regular form) only to:

- fill missing dimensions
- detect stale/incomplete wiki fields
- generate wiki gap reports

Do **not** clone them unless the user explicitly asks.

## Asset Rule

- Icon SVG preferred. If `_assets-cdn.md` only registers PNG, use PNG and flag a wiki gap (see issue #60 Gap 4).
- Joy Agent atom (`312:58236` per `_assets-cdn.md`): 64 × 64 PNG currently; SVG source pending.
- Per-slot icons (home / category / message / profile): wiki currently only registers home; other slots must be flagged as missing in `assetUsage.placeholder` with explicit wiki gap.

## Variants Coverage (when user asks for all)

The full Tabbar variant matrix (per `tabbar/variants.md`):

| Dimension | Values |
|---|---|
| form | regular / Joy Agent combo |
| slot count | 2 / 3 / 4 / 5 |
| slot state | default / selected / marketing |
| badge state | none / red dot / number / text |
| dynamic island | none / regular / operational / promo |

A "full state matrix" output requires explicit user confirmation; default scope is one slot count × one state.

## Wiki Gaps Found (during R3 走查, 2026-05-20)

These gaps were surfaced when generating R3 reference. All filed in upstream [issue #60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60):

| Gap | Section | Symptom |
|---|---|---|
| 1 | 02.4 交互状态表 | Selected bg L/R inset (4 DP) + radius (`radius_xl`) not declared |
| 2 | Component layer table | Relay node IDs (`266:475`, `266:674`) listed but not anchored as ground truth |
| 3 | 02.x alignment description | Geometric results stated, but Auto Layout pattern not made explicit |
| 4 | `_assets-cdn.md` | Only PNG registered, no SVG channel |

When skill v0.2 runs, these gaps will appear in `wikiGapsFound` output until upstream PRs land.

## R3 Implementation Pitfalls (lessons)

1. **Selected bg sizing**: do not attach background to the 44×44 atom; use a separate pill layer sized `(slot − 8) × 44`.
2. **Label horizontal alignment**: do not rely on `textAlignHorizontal` with default `textAutoResize`; use fixed text box or Auto Layout center.
3. **State background layering**: keep visual (pill) and content (atom) on separate frames so state toggling doesn't fight content layout.
4. **Icon asset format**: SVG over PNG; per-slot SVG missing today, flag wiki gap rather than silently using PNG.
