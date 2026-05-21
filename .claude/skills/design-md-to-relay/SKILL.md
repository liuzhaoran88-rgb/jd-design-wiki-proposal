---
name: design-md-to-relay
description: Generate a Relay/Zero reference design from JD design wiki markdown. The workflow first clarifies scope, syncs foundation, reads wiki bundle + foundation rules, normalizes them into a machine-readable spec, creates only the requested scope in the current Relay file, and verifies with metadata + screenshot. Foundation is auto-pulled from upstream main with commit SHA traceability. Use for "按 wiki 规范画一个组件", "根据 design.md 生成 Zero 设计稿", "生成一个对照设计稿".
allowed-tools: [mcp__zero-design__get_design_metadata, mcp__zero-design__get_design_context, mcp__zero-design__get_screenshot, mcp__zero-design__get_variables, mcp__zero-design__use_design_script, Bash, Read, Write, Edit]
---

# /design-md-to-relay

Create a Relay/Zero reference design from JD design wiki markdown.

This skill is a **wiki-to-Relay generator**, not a component-specific Tabbar generator and not a creative design assistant. It faithfully instantiates the user-requested scope from wiki, foundation tokens, and visual rules.

> ⚠️ **v0.1 骨架** —— flow + contracts in place; executable scripts pending. v0.2 implementation starts after upstream [issue #60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) P0 merges. See [`README.md`](README.md).

## Prime Directive

**Do not guess the output shape.**

Before writing anything to Relay, clarify what the user actually wants. A request like "画一个底导设计稿" may mean one bottom navigation instance inside a 375x812 phone page, **not** a full component spec page, all state variants, or multiple examples.

If scope is ambiguous, ask **one concise** clarification question and wait.

Do not create extra variants, state grids, explanatory sections, business content, or multiple pages unless the user explicitly asks.

## When To Use

User asks any of:

- 按 wiki 规范画一个 X
- 根据 design.md 生成 Zero 设计稿
- 把 X 组件实例化到当前 Relay 文件
- 生成一个对照设计稿给设计师比对
- 根据最新 wiki 画一个页面/组件

Do not use for:

- freeform creative design not based on wiki
- writing or improving wiki docs only
- reviewing an existing Relay design only
- cloning an original Relay node when the user asks to generate from wiki

## Required Inputs

```text
/design-md-to-relay <design-md-path-or-slug>
/design-md-to-relay <slug> --scope "single instance on 375x812 page"
/design-md-to-relay <slug> --canvas-position 3200,-760
/design-md-to-relay <slug> --no-pull              # skip Foundation auto-pull (offline / dev)
/design-md-to-relay <slug> --foundation-from <path>   # use specified wiki path (debug fork / PR branch)
```

If no explicit path, infer slug from request and search local wiki repository.

Default wiki location: `~/code/jd-design-wiki-proposal`

If repository missing, search current workspace first, then ask user for the repo path.

## Source Of Truth

**Do not copy component `design.md` files into this skill's `references/` directory.**

Always read component specs from source wiki repository at runtime:

```text
jd-design-system-md-v16/**/<slug>/design.md
jd-design-system-md-v16/**/<slug>/spec.md
jd-design-system-md-v16/**/<slug>/variants.md
jd-design-system-md-v16/**/<slug>/behaviors.md
jd-design-system-md-v16/**/<slug>/ai-schema.yaml
jd-design-system-md-v16/**/<slug>/_assets-cdn.md
```

Skill `references/` directory is **only** for workflow docs, normalized spec schemas, adapter notes, and implementation guidance. It must not become a copied component spec library.

Adapters may describe how to interpret a component's wiki fields, but they must not duplicate full source wiki content.

## Source Precedence

```text
user scope
> ai-schema.yaml / spec.md structured fields
> design.md explicit fields
> foundation tokens and visual rules
> component adapter defaults
> ground truth Relay node (only for missing fields)
```

If ground truth conflicts with wiki fields, record a diff and **choose the wiki field** unless user explicitly asks to match the original Relay node.

---

## Workflow

### Step 0. Clarify Scope

Before reading or drawing, decide whether the user's desired output scope is clear.

Clarify these dimensions when missing:

| Question | Examples |
|---|---|
| Output level | single component, component inside phone page, state matrix, full business page |
| Quantity | one instance, all variants, selected states only |
| Canvas | component only, 375x812 phone page, existing page section |
| Content | labels, selected item, icon names, placeholder content |
| Freedom | strict wiki only, wiki plus reasonable placeholders |

Ask only **one concise** question if needed. Prefer:

```text
你要的是一个 X 放在页面里的示意，还是 X 的多状态规范展示？
```

If user answers narrow, keep output narrow. One bottom navigation in a 375x812 page = exactly that, not a spec board.

### Step 1. Sync Foundation

Foundation is the truth source. Sync upstream before reading:

```bash
git -C ~/code/jd-design-wiki-proposal pull --ff-only origin main
```

Record commit SHA in output `foundationVersion.commit` for traceability.

| State | Handling |
|---|---|
| ✅ fast-forward / up-to-date | `pullStatus = "success"` |
| ⚠️ diverged (local commits) | use local; warn with local SHA + reason; `pullStatus = "diverged"` |
| ⚠️ network failure | use local cache; warn with SHA + last-pull age; `pullStatus = "offline"` |
| ❌ repo missing | fail; prompt user to clone |
| `--no-pull` | skip; `pullStatus = "skipped"` |
| `--foundation-from <path>` | use specified path; `foundationSource = <path>` |

See [`references/foundation-token-table.md`](references/foundation-token-table.md).

### Step 2. Resolve Target

Resolve the target `design.md`.

Accept:

- absolute or relative `design.md` path
- component slug (e.g. `tabbar` → search `jd-design-system-md-v16/**/tabbar/design.md`)
- wiki URL

If slug matches multiple files, list candidates and ask the user to choose.

### Step 3. Read Wiki Bundle

Read the target bundle as available:

| File | Purpose |
|---|---|
| `design.md` | main component spec, frontmatter, anatomy, sizes, states |
| `spec.md` | detailed visual fields, if present |
| `variants.md` | variant dimensions |
| `behaviors.md` | interaction and don'ts |
| `ai-schema.yaml` | machine-readable source of truth, if present |
| `_assets-cdn.md` | asset inventory (SVG preferred, PNG fallback) |

Treat `ai-schema.yaml` and `spec.md` as more structured than prose. Use prose to fill gaps, not to override structured fields.

### Step 4. Read Foundation Rules

Read foundation sources relevant to the target wiki version:

| Source | Required Data |
|---|---|
| `foundations/tokens/tokens.json` | colors, radius, spacing, typography, effects |
| `foundations/visual/layout.md` | canvas, grid, layer, safe-area, page layout rules |
| `foundations/visual/materials.md` | material, glass, blur, shadow rules |
| icon docs / asset docs | icon box, stroke, active/default rules |

Every literal visual value in the generated design should either resolve to a token, come from the component spec, or be listed in `unresolvedLiterals`.

### Step 5. Build Normalized Spec JSON

Convert wiki bundle + foundation rules into a machine-readable normalized spec **before** writing to Relay.

The normalized spec is the execution contract. It must include:

- requested scope
- canvas size and background
- node tree plan
- component dimensions
- layout strategy
- token map
- text specs
- asset specs
- states to instantiate
- verification assertions
- unresolved fields and assumptions

See [`references/normalized-spec.md`](references/normalized-spec.md).

**Do not draw directly from prose when a normalized spec can be created.**

### Step 6. Probe Ground Truth Only When Useful

Ground truth = an existing Relay node referenced by wiki frontmatter or related docs.

Use it to:

- fill missing dimensions
- understand existing layer anatomy
- detect stale or incomplete wiki fields
- generate wiki gap reports

**Do not** use it to:

- clone an original design
- override explicit wiki or foundation tokens silently
- expand the requested scope
- ignore user instructions such as "不要用原稿 clone"

If ground truth conflicts with wiki fields, record a diff in `wikiGapsFound` and follow Source Precedence above.

### Step 7. Plan Relay Node Tree

Plan the node tree **before** executing scripts.

**Layout rule:**

- Use Auto Layout for repeated, distributed, naturally centered structures.
- Use fixed bounds (x/y + resize) for: canvas and device pages, safe areas, icon boxes, fixed-size atoms, text boxes with explicit spec dimensions, overlay/floating anchor positions, assets imported from SVG/PNG.
- Do not ban x/y globally. Use x/y for top-level placement and fixed spec anchors (e.g. Joy Agent x=-16 floating outward).
- Avoid ad hoc hand-positioning for repeated children.

**Text rule:**

- If the spec defines a text box, set `textAutoResize = 'NONE'`, then set `x/y`, `resize(width, height)`, alignment, font, line-height, characters.
- If text is natural content inside Auto Layout with no fixed box, auto-resize is allowed.

**Layer rule:**

- Keep visual layers, behavior containers, and content layers separate **when states affect only one layer** (e.g. selected background vs icon+label).
- Do not attach selected backgrounds, overlays, or masks to content nodes if the spec treats them as independent visual surfaces.
- Do not over-split layers when the spec treats them as one (avoid premature decomposition).

### Step 8. Fetch and Normalize Assets

Asset priority:

```text
SVG source
> vector path data in wiki
> PNG fallback
> placeholder with explicit warning
```

For SVG:

- import with `createFrameFromSvgAsync`
- normalize into specified icon/asset box
- ensure imported SVG does not resize parent
- preserve intended fill/stroke states

For PNG:

- use only as fallback
- mark `assetUsage.png_fallback`
- record missing SVG as a wiki gap

**Token binding for all visual values:**

- All `fill`/`stroke`/`cornerRadius`/`fontSize`/`lineHeight`/`itemSpacing`/`padding*` must resolve through Foundation token table when a matching token exists
- Direct hex/px values are anti-pattern; report in `tokenCoverage.unresolvedLiterals`

### Step 9. Execute In Small Batches

Before calling `mcp__zero-design__use_design_script`, ensure design-on-zero skill and Relay plugin API index are loaded.

Run no more than one logical operation per script:

1. create root canvas/page frame
2. create major containers
3. add repeated children
4. add text and assets
5. apply states and final fixed bounds

Every script must return structured data:

```json
{
  "createdNodeIds": [],
  "mutatedNodeIds": [],
  "bounds": [],
  "warnings": []
}
```

Stop and fix errors before continuing.

### Step 10. Verify

After writing:

1. call `get_design_metadata` on the created root
2. call `get_screenshot` on the created root
3. compare actual bounds against normalized spec assertions
4. compare token usage against token map
5. report unresolved literals, assumptions, warnings, violations

Verification tolerance:

| Field | Tolerance |
|---|---|
| fixed dimensions | 0.5 DP |
| position anchors | 0.5 DP |
| repeated distribution | 1 DP total drift |
| colors | exact token or explicit accepted literal |
| radius | exact token or explicit accepted literal |

If verification finds a fixable mismatch, fix it before final response.

See [`references/fidelity-thresholds.md`](references/fidelity-thresholds.md).

---

## Output Contract

Return a concise human summary plus a structured result:

```json
{
  "createdRootId": "59:xxxx",
  "scope": {
    "level": "single-instance-on-phone-page",
    "canvas": "375x812",
    "states": ["selected-home"]
  },
  "foundationVersion": {
    "commit": "99c2e6f",
    "pulledAt": "2026-05-21T14:32:00Z",
    "pullStatus": "success",
    "remote": "ShuaiMXu/jd-design-wiki-proposal@main",
    "foundationSource": "~/code/jd-design-wiki-proposal/jd-design-system-md-v16/foundations/"
  },
  "source": {
    "designMd": "jd-design-system-md-v16/.../design.md",
    "foundationTokens": "jd-design-system-md-v16/foundations/tokens/tokens.json",
    "visualRules": [
      "foundations/visual/layout.md",
      "foundations/visual/materials.md"
    ]
  },
  "tokenCoverage": {
    "resolved": ["color_background", "color_primary", "radius_xxl"],
    "unresolvedLiterals": []
  },
  "assetUsage": {
    "svg": [],
    "png_fallback": [],
    "placeholder": []
  },
  "verification": {
    "passed": true,
    "warnings": [],
    "violations": []
  },
  "wikiGapsFound": []
}
```

`foundationVersion.commit` is the traceability anchor — user can verify exactly which foundation snapshot was used.

---

## Component Adapters

The main skill is generic. Component-specific behavior belongs in adapters.

Adapters may define:

- required scope questions
- anatomy mapping
- default node tree patterns
- state model
- asset naming conventions
- verification assertions

Example adapter paths:

```text
references/adapters/tabbar.md
references/adapters/button.md
references/adapters/toast.md
references/adapters/navbar.md
```

If no adapter exists, use the generic normalized spec flow and ask for scope when component anatomy is unclear.

Adapters must **not** duplicate the source wiki — they only encode mapping decisions and skill-specific defaults.

---

## Guardrails

- Do not copy component markdown from source wiki into this skill. Read it at runtime.
- Do not create a spec page unless user asks for a spec page.
- Do not create all variants unless user asks for all variants.
- Do not invent business content unless scope requires a contextual page and user allows placeholders.
- Do not clone ground truth nodes unless user explicitly asks to clone or match an existing Relay node.
- Do not silently replace wiki fields with ground truth fields.
- Do not skip foundation tokens and visual rules.
- Do not finish without screenshot and metadata verification when Relay tools are available.
- Do not ban x/y globally; use it for top-level placement and fixed spec anchors.

---

## Relationship to Upstream Issue #60

This skill and upstream [issue #60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) are mutual products:

- **skill** = the "correct way" codified after wiki gaps are fixed
- **issue** = wiki gaps surfaced during skill design

v0.2 implementation depends on issue #60 P0 (Gap 1 + Gap 4) merging upstream. See [`README.md`](README.md) for full roadmap.

---

## References

| Doc | Purpose | Status |
|---|---|---|
| [`README.md`](README.md) | status, usage notes, roadmap, upstream dependency | ✅ v0.1 |
| [`references/normalized-spec.md`](references/normalized-spec.md) | normalized spec JSON schema + examples | ✅ v0.1 |
| [`references/foundation-token-table.md`](references/foundation-token-table.md) | Foundation auto-pull + token resolver protocol | ✅ v0.1 |
| [`references/fidelity-thresholds.md`](references/fidelity-thresholds.md) | verification tolerances + token coverage rules | ✅ v0.1 |
| [`references/adapters/tabbar.md`](references/adapters/tabbar.md) | Tabbar-specific mapping + R3 lessons distilled | ✅ v0.1 |
