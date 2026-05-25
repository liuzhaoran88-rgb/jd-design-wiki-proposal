# Normalized Spec JSON · 归一化执行契约

Normalized spec JSON 是 wiki markdown 与 Relay/Zero 脚本之间机器可读的**执行契约**。

wiki 是给人看的:值散落在散文、表格、frontmatter、foundation token、视觉规则各处。**画之前**,本 skill 把这些源归一化成一个结构化对象。

## 为什么需要它

不归一化,agent 边读自然语言边画 —— 还在「理解」就开始「执行」。后果:

- **scope drift** —— 用户只要一个实例,却画出整张 spec 板
- **missing token** —— 用 literal 颜色而非 foundation 颜色
- **layout drift** —— spec 要固定 bounds,文本框却 auto-resize
- **component leakage** —— 把 Tabbar 的教训套到 Button / Toast 上
- **silent cloning** —— 从 ground truth 复制,而非从 wiki 生成

Normalized spec JSON 把**理解与执行分离**。

## Source Precedence · 来源优先级

```text
用户 scope
> ai-schema.yaml / spec.md 结构化字段
> design.md 显式字段
> foundation token + 视觉规则
> 组件 adapter 默认值
> ground truth(仅用于补缺失字段)
```

一个字段在多个源里都有定义 → 高优先级源胜出。低优先级源**只**补高优先级源缺失的部分。

## 最小形态

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

## 节点 Spec

每个规划节点描述预期 bounds、视觉 token、布局策略、源引用。

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

## 文本 Spec

wiki 定义了 label 框时,用**固定文本框**:

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

**只**在没有固定文本框、且文本处于 Auto Layout 内时用**自适应文本**。此时省略 `bounds.width`/`bounds.height`,把 `textAutoResize` 设为 `WIDTH_AND_HEIGHT`。

## 资产 Spec

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

## Assertion 断言

**生成之后**用来比对预期 metadata 与实际 Relay metadata:

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

容忍度默认值见 [`fidelity-thresholds.md`](fidelity-thresholds.md):

| 字段 | 容忍度 |
|---|---|
| 固定尺寸 | 0.5 DP |
| 位置锚点 | 0.5 DP |
| 重复分布 | 累计 1 DP |
| 颜色 | 精确 token,或显式接受的 literal |
| 圆角 | 精确 token,或显式接受的 literal |

## Tabbar 单实例示例

对于这样一个用户请求:

```text
只需要写一个底导页面,放在 375x812 的页面上。有 joy agent,右侧 4 个底导,首页、新品、游戏、我的
```

normalized spec 应当表达**一个页面 + 一个底导实例**,而不是全部状态:

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

注意:

- `scope.states` 只列一个状态(`home-selected`),不是全部 12 种 atom 组合
- `scope.allowedPlaceholders: false` —— 每个 icon 都必须有解析到的资产
- Joy Agent 浮动出血偏移(`x: -16`)是固定锚点,不是 Auto Layout

## 何时跳过归一化

任何 scope 只要有 1 个以上节点、1 个以上变体、或任何资产,就**必须**先建 normalized spec。平凡 scope(如「在已知坐标放一个矩形」)可以跳过。

所有真实的组件生成请求,都先建 normalized spec。
