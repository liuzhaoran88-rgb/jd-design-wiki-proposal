# Fidelity Thresholds

Defines verification tolerances and token coverage rules for the **Step 10 Verify** phase.

## Core Principle

100% pixel-exact fidelity is **not the goal** — Auto Layout floating-point rounding and font metrics make sub-pixel diffs unavoidable. The goal is:

> Every visual value either resolves to a foundation token or is an explicit accepted literal, with bounds matching the wiki spec within a tight published tolerance.

This makes outputs verifiable, traceable, and reproducible without forcing impossible exactness.

## Verification Tolerance Table

| Field | Tolerance | Verdict if exceeded |
|---|---|---|
| Fixed dimensions (width/height of spec'd nodes) | **0.5 DP** | violation |
| Position anchors (x/y of spec'd nodes) | **0.5 DP** | violation |
| Repeated distribution drift (n slots均分) | **1 DP total** across all slots | warning |
| Auto Layout rounding (n.7499... vs n.75) | treated as 0 (round to 0.01 DP) | ignored |
| Text glyph vertical metrics | 0.5 DP within text frame | ignored if frame size matches |
| Colors | exact token, OR literal listed in `unresolvedLiterals` | violation if neither |
| Radius | exact token, OR literal listed in `unresolvedLiterals` | violation if neither |
| FontSize / lineHeight | exact token (from typography) | violation if missing |
| Spacing (padding / itemSpacing) | exact token, OR explicit accepted literal | warning |

## Token Coverage Rules

Every literal visual value should fall into one of three buckets:

1. **Resolved** — value comes from a foundation token via the token table
2. **Spec literal** — value declared explicitly in component spec (e.g. `tabbar/spec.md` says `13.5` for dynamic island radius)
3. **Unresolved** — value is a literal with no token and no spec declaration; **must be listed** in `tokenCoverage.unresolvedLiterals`

If a value falls into the **unresolved** bucket, the verification verdict is **violation** unless:

- the user passed `--allow-literals` flag
- the literal is documented in `wikiGapsFound` with a suggested token

## Verdict Logic

```text
violations.length === 0  &&  warnings can be 0 or more  →  PASS
violations.length > 0                                   →  FAIL (return early, do not silent-pass)
```

Output:

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
      "suggestedFix": "either capsule 319 or single slot 80.75 — pick one"
    }
  ]
}
```

## What Strict Mode Is Not

Earlier drafts of this skill specified `strict mode = 0 DP / 0 placeholder / 100% token binding, any > 0 fails`. That spec is **withdrawn** because:

- Auto Layout produces sub-pixel float diffs (0.01 DP) that are not real defects
- Spec literals (e.g., `13.5` for dynamic island) exist legitimately
- Forcing 100% token binding makes the skill unable to generate when wiki has token gaps

The current model is: **strict on declared fields, flexible on undeclared**. Wiki gaps surface as `wikiGapsFound` for upstream fix, not as skill failures.

## When to Adjust Tolerances

| Scenario | Adjusted tolerance |
|---|---|
| Foundation values themselves are sub-pixel (rare) | accept; document in spec |
| Component spec declares fractional values (e.g. `79.75`) | use spec value as expected, tolerance still 0.5 DP |
| Repeated distribution across 5+ slots | extend drift tolerance to 2 DP total |
| Text frame with default `textAutoResize` | width tolerance disabled (text auto-fits content) |
| Imported SVG content position | tolerance follows the parent's icon box, not the SVG paths |

## Relationship to Source Precedence

The verification step compares:

- **created node** (actual)
- **normalized spec** (expected per Step 5)
- **wiki bundle source** (precedence per source precedence ordering)

Diff vs normalized spec → tolerance applies.
Diff vs wiki bundle → goes to `wikiGapsFound` (wiki may be wrong, not skill).

This keeps the skill from silently masking wiki inconsistencies as "passed".

## Related

- [`normalized-spec.md`](normalized-spec.md) — assertions are declared during normalization
- [`foundation-token-table.md`](foundation-token-table.md) — token resolution determines `resolved` vs `unresolvedLiterals` buckets
- [`adapters/tabbar.md`](adapters/tabbar.md) — component-specific tolerance overrides (if any)
