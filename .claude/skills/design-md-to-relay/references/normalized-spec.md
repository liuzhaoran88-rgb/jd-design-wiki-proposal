# Normalized Spec JSON

Normalized spec JSON is the machine-readable execution contract between wiki markdown and Relay/Zero scripts.

The wiki is for humans. It spreads values across prose, tables, frontmatter, foundation tokens, and visual rules. **Before drawing**, this skill normalizes those sources into one structured object.

## Why It Exists

Without normalization, an agent reads natural language and starts drawing while still interpreting. That causes:

- **scope drift** — creating a full spec board when the user asked for one instance
- **missing tokens** — using literal colors instead of foundation colors
- **layout drift** — text boxes auto-resizing when the spec requires fixed bounds
- **component leakage** — applying Tabbar lessons to Button or Toast
- **silent cloning** from ground truth instead of generating from wiki

Normalized spec JSON **separates understanding from execution**.

## Source Precedence

```text
user scope
> ai-schema.yaml / spec.md structured fields
> design.md explicit fields
> foundation tokens and visual rules
> component adapter defaults
> ground truth for missing fields only
```

If a field is defined in multiple sources, the higher-priority source wins. Lower-priority sources may fill in **only** what's missing.

## Minimum Shape

```json
{
  "meta": {
    "component": "tabbar",
    "wikiVersion": "v16",
    "sourceFiles": [
      "jd-design-system-md-v16/horizontal/components-base/tabbar/design.md",
      "jd-design-system-md-v16/horizontal/components-base/tabbar/spec.md",
      "jd-design-system-md-v16/horizontal/components-base/tabbar/_assets-cdn.md"
    ],
    "foundationCommit": "99c2e6f"
  },
  "scope": {
    "level": "single-instance-on-phone-page",
    "canvas": {
      "width": 375,
      "height": 812
    },
    "states": ["selected-home"],
    "allowedPlaceholders": true
  },
  "tokens": {
    "color_background": "#F2F3F7",
    "color_primary": "#FF0F23",
    "radius_xxl": 16
  },
  "nodes": [],
  "assets": [],
  "assertions": [],
  "assumptions": [],
  "wikiGaps": []
}
```

## Node Spec

Each planned node describes expected bounds, visual tokens, layout strategy, and source references.

```json
{
  "name": "Tabbar Capsule",
  "type": "frame",
  "bounds": {
    "x": 44,
    "y": 743,
    "width": 319,
    "height": 52
  },
  "layout": {
    "mode": "horizontal",
    "distribution": "equal-slots",
    "padding": { "left": 0, "right": 0, "top": 4, "bottom": 4 }
  },
  "fills": [
    {
      "token": "color_background_component",
      "value": "#F5F6FA",
      "opacity": 1
    }
  ],
  "radius": {
    "token": "radius_xxl",
    "value": 16
  },
  "source": {
    "file": "tabbar/design.md",
    "section": "02.1 基础布局"
  }
}
```

## Text Spec

Use **fixed text bounds** when the wiki defines a label box:

```json
{
  "name": "Label / Home",
  "type": "text",
  "text": "首页",
  "bounds": {
    "x": 0,
    "y": 27,
    "width": 44,
    "height": 14
  },
  "textAutoResize": "NONE",
  "fontSize": 10,
  "lineHeight": 14,
  "align": "center",
  "fontToken": "pingfang_semibold/font_size_10_600",
  "fill": {
    "token": "color_primary",
    "value": "#FF0F23"
  },
  "source": {
    "file": "tabbar/design.md",
    "section": "02.4 交互状态"
  }
}
```

Use **auto-resizing text** only when no fixed text box exists and the text lives inside Auto Layout. In that case omit `bounds.width`/`bounds.height` and set `textAutoResize` to `WIDTH_AND_HEIGHT`.

## Asset Spec

```json
{
  "name": "icon-home-active",
  "type": "svg",
  "source": "_assets-cdn.md#home-active",
  "boundsInParent": { "x": 12, "y": 3, "width": 20, "height": 20 },
  "preserveColors": true,
  "fallback": "png",
  "wikiGapIfMissing": "home-active.svg is registered as PNG only in _assets-cdn.md"
}
```

## Assertions

Used **after generation** to compare expected metadata with actual Relay metadata:

```json
{
  "node": "Label / Home",
  "property": "bounds",
  "expected": {
    "x": 0,
    "y": 27,
    "width": 44,
    "height": 14
  },
  "tolerance": 0.5,
  "source": "tabbar/design.md"
}
```

Tolerance defaults per [`fidelity-thresholds.md`](fidelity-thresholds.md):

| Field | Tolerance |
|---|---|
| fixed dimensions | 0.5 DP |
| position anchors | 0.5 DP |
| repeated distribution | 1 DP total drift |
| colors | exact token or explicit accepted literal |
| radius | exact token or explicit accepted literal |

## Tabbar Single-Instance Example

For a user request like:

```text
只需要写一个底导页面，放在 375x812 的页面上。有 joy agent，右侧 4 个底导，首页、新品、游戏、我的
```

The normalized spec should say **one page and one bottom navigation instance**, not all states:

```json
{
  "meta": {
    "component": "tabbar",
    "wikiVersion": "v16"
  },
  "scope": {
    "level": "single-instance-on-phone-page",
    "canvas": {
      "width": 375,
      "height": 812
    },
    "states": ["home-selected"],
    "items": ["首页", "新品", "游戏", "我的"],
    "includeJoyAgent": true,
    "allowedPlaceholders": false
  },
  "layout": {
    "bottomLayerHeight": 69,
    "navHeight": 52,
    "safeAreaHeight": 17,
    "joyAgent": {
      "width": 52,
      "height": 52,
      "x": -16,
      "gapToCapsule": 8
    },
    "capsule": {
      "x": 44,
      "width": 319,
      "height": 52,
      "radiusToken": "radius_xxl"
    },
    "tabAtom": {
      "width": 44,
      "height": 44,
      "iconBox": {
        "width": 20,
        "height": 20,
        "y": 3
      },
      "labelBox": {
        "width": 44,
        "height": 14,
        "y": 27
      }
    }
  }
}
```

Notice:

- `scope.states` lists exactly one state (`home-selected`), not all 12 atom combinations
- `scope.allowedPlaceholders: false` — every icon must have a resolved asset
- Joy Agent floating offset (`x: -16`) is a fixed anchor, not Auto Layout

## When to Skip Normalization

The normalized spec is required for any scope that has more than one node, more than one variant, or any asset. Trivial scopes (e.g., "place one rectangle at known coordinates") can skip normalization.

For all real component generation requests, build the normalized spec first.
