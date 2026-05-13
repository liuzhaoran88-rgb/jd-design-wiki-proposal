# Token 反查算法

> SKILL.md Step 5 调用本文件。把 Relay 抽出的实际值（hex / fontSize+weight / radius / spacing）反查到 V16 token 名。**没匹配到的不要编造**，标 ⚠️ token-miss。

---

## 0. 数据源

读 `jd-design-system-md-v16/foundations/tokens/tokens.json`，里面有：
- `atom.*`：V16 原子色板，每条有 light + dark hex
- `color.*`：L2 语义 token，引用 atom
- `typography.atom.size.*` + `typography.role.*`
- `radius.*`
- `spacing.*`

---

## 1. 色彩反查（hex → color token）

### 算法

```
INPUT: hex（如 "#FFFFFF" 或 "#000000@20%"）
OUTPUT: V16 color token 名（如 "color_background_overlay"）或 null

Step 1: 解析 hex 和 opacity
  hex_clean = strip(@xx%) // 去掉透明度后缀
  opacity = 0~1 / null

Step 2: 在 tokens.json#atom 找 light hex 匹配（精确匹配）
  for atom in tokens.json.atom:
    if atom.light == hex_clean:
      atom_name = atom.id (e.g., "gray_1", "white", "jdred_6")
      break

Step 3: 在 rgba 原子里找匹配（针对 maskgray / linegray / servicegold_2,3）
  if opacity != null:
    for atom in tokens.json.atom (rgba ones):
      if atom.light_rgba matches "(R, G, B, opacity)":
        atom_name = atom.id
        break

Step 4: 用 atom_name 反查 color token
  for color_token in tokens.json.color:
    if color_token.$value resolves to atom_name:
      return color_token.id (e.g., "color_primary", "color_background_overlay")

Step 5: 没匹配到
  return null  // → SKILL.md 标 ⚠️ token-miss
```

### 示例

| hex 输入 | 匹配 atom | 匹配 token | 输出 |
|---|---|---|---|
| `#FFFFFF` | white | color.primary_text / background_overlay | `color_background_overlay`（首选语义） |
| `#FF0F23` | jdred_6 | color.primary | `color_primary` |
| `#171A26` | gray_1 | color.title | `color_title` |
| `#11141A` | （未匹配） | — | ⚠️ token-miss + 写实际 hex |
| `#000000@40%` | maskgray_2 (rgba 0,0,0,0.4) | color.mask | `color_mask` |

### 边界处理

- 一个 atom 可能被多个 token 引用（如 white 既是 `color_primary_text` 又是 `color_background_overlay`）：**优先选语义层级最高的**（surface > text > body）
- 模糊匹配（hex 偏 1-2 个字节）：**不匹配**，标 ⚠️ token-miss，让设计师决策
- atom 在 tokens.json 里值是 `"TODO"`：忽略，不匹配

### rgba 反查算法（v0.2 增强）

针对带 opacity 的色值（如 `#FFFFFF@90%` / `#000000@40%`）：

```
INPUT: hex@opacity (如 "#FFFFFF@90%")
OUTPUT: V16 token 名 / "rgba-of-pure-color-suggestion" / null

Step 1: 解析
  pure_hex = "#FFFFFF"
  opacity_pct = 90

Step 2: 在 atom 里查 rgba 格式匹配（容差 ±2% opacity）
  for atom_id, atom_data in tokens.json.atom:
    if atom_data.light_rgba_pattern:
      // 例 gray_7.light = rgba(0,0,0,0.40)
      pattern_pure = "#000000"
      pattern_opacity = 40
      if pure_hex == pattern_pure AND |opacity_pct - pattern_opacity| <= 2:
        return token_referencing(atom_id)

Step 3: pure-color 启发式（当 Step 2 没命中）
  pure_color_map = {
    "#FFFFFF": "white",
    "#000000": "black",
    "#FF0F23": "jdred",     // V16 京东红
  }
  if pure_hex in pure_color_map:
    color_name = pure_color_map[pure_hex]
    return {
      status: "rgba-suggestion",
      suggestion: f"{color_name}-at-{opacity_pct}",
      note: f"未匹配 V16 atom，建议引入新 atom 或考虑硬编码合理性"
    }

Step 4: 都不匹配 → ⚠️ token-miss
```

### 示例（v0.2）

| hex 输入 | Step 2 结果 | Step 3 结果 | 输出 |
|---|---|---|---|
| `#000000@40%` | 命中 gray_7 (rgba(0,0,0,0.40)) | — | `color_mask` |
| `#000000@8%` | 命中 gray_9 (linegray_1, rgba(0,0,0,0.08)) | — | `color_border` |
| `#000000@2%` | 命中 gray_8 (maskgray_1, rgba(0,0,0,0.02)) | — | `color_mask_part` |
| `#000000@39%` | 命中 gray_7 (容差 1%) | — | `color_mask` |
| `#FFFFFF@90%` | 无匹配 | 启发式 "white-at-90" | ⚠️ rgba-suggestion + 注释 "未匹配 V16 atom" |
| `#FFFFFF@65%` | 无匹配 | 启发式 "white-at-65" | ⚠️ rgba-suggestion |
| `#FF0F23@50%` | 无匹配 | 启发式 "jdred-at-50" | ⚠️ rgba-suggestion |
| `#ABCDEF@30%` | 无匹配 | 不在 pure_color_map | ⚠️ token-miss + 原始 hex |

### 频繁 rgba-suggestion 怎么办

如果同一个 suggestion 名（如 "white-at-90"）在多个组件 design.md 里反复出现，说明这是一个**真实缺失的 V16 atom**。维护者应：

1. 在 V16 设计组提议增加 atom（如 `atom.white_90 = rgba(255,255,255,0.9)` light/dark）
2. 加完后在 V16 tokens.json 更新
3. 下次 skill 跑会自动命中 Step 2，把所有相关 design.md 的 ⚠️ rgba-suggestion 升级为 ✅ 正式 token

这是 design-system-driven 的良性循环：设计稿出现频繁 → 升级为正式 token → 跨组件复用。

---

## 2. 文字反查（fontSize + family + style → typography role token）

### 算法

```
INPUT: fontSize (number), family (string), style (string e.g., "Regular" / "Semibold")
OUTPUT: typography role token (如 "pingfang_regular/font_size_14_400") 或 null

Step 1: 标准化 family
  if family.startsWith("PingFang"): family_atom = "pingfang"
  else if family.startsWith("京东正黑"): family_atom = "zhenghei"
  else if family == "京东朗正体": family_atom = "DEPRECATED-xiangzheng" (← V15 brand 字体)
  else: family_atom = null

Step 2: 标准化 weight
  if style ~ /Regular/i: weight_atom = "regular", weight_num = 400
  else if style ~ /Semibold/i: weight_atom = "semibold", weight_num = 600
  else if style ~ /Bold/i: weight_atom = "semibold", weight_num = 600  // V16 zhenghei_bold 实际 600
  else: weight_atom = null

Step 3: 查 fontSize 是否在 V16 size atom (10/11/13/14/16/18/24)
  if fontSize in [10, 11, 13, 14, 16, 18, 24]: size_match = true
  else: size_match = false

Step 4: 组装 role token
  if family_atom != null && weight_atom != null && size_match:
    return f"{family_atom}_{weight_atom}/font_size_{fontSize}_{weight_num}"
  else:
    return null  // → SKILL.md 标 ⚠️ token-miss
```

### 示例

| 输入 | family_atom | weight_atom | size match | 输出 |
|---|---|---|---|---|
| 13pt PingFang SC Regular | pingfang | regular | ✅ | `pingfang_regular/font_size_13_400` |
| 14pt PingFang SC Semibold | pingfang | semibold | ✅ | `pingfang_semibold/font_size_14_600` |
| 24pt 京东正黑 Bold | zhenghei | semibold(600) | ✅ | `zhenghei_bold/font_size_24_600` (Relay 命名沿用 bold 组) |
| 12pt PingFang SC Regular | pingfang | regular | ❌ (V16 删 12) | ⚠️ token-miss + 注释 "V16 推荐 11 或 13" |
| 15pt PingFang SC Semibold | pingfang | semibold | ❌ (V16 删 15) | ⚠️ token-miss + 注释 "V16 推荐 16" |
| 14pt Helvetica Regular | null | regular | ✅ | ⚠️ token-miss + 注释 "V16 不支持 Helvetica family" |

---

## 3. 圆角反查（radius_px → radius token）

### 算法

```
INPUT: radius_px (number)
OUTPUT: radius token 名

V16_RADIUS_MAP = {
  0:  "radius_xxs",
  2:  "radius_xs",
  4:  "radius_s",
  6:  "radius_base",
  8:  "radius_l",
  12: "radius_xl",
  16: "radius_xxl",
}

if radius_px in V16_RADIUS_MAP:
  return V16_RADIUS_MAP[radius_px]
elif radius_px < 4:
  return null + 注释 "极小圆角（< 4px），可能是图标内部矢量曲率，不需要 token"
else:
  return ⚠️ token-miss + 注释 "V16 无 {radius_px}px 圆角 atom"
```

### 示例

| 输入 | 输出 |
|---|---|
| 6 | `radius_base` |
| 12 | `radius_xl` |
| 1.33 / 2.67 | 跳过（图标内部曲率） |
| 24 | ⚠️ token-miss + 注释 "V15 有 radius.structural (24) 但 V16 已废弃" |
| 9999 | ⚠️ token-miss + 注释 "V15 有 radius.full (9999 胶囊) 但 V16 已废弃 — Avatar/胶囊方案 V16 设计师 WIP" |

---

## 4. 间距反查（padding / spacing → spacing token）

### 算法

```
INPUT: 数值 px
OUTPUT: spacing token 名 或 null

V16_SPACING_VALUES = [0, 2, 4, 6, 7, 8, 12, 16, 20, 24, 28, 32, 40]
V16_SAFE_AREA = { 17: "spacing.safe-area.home-indicator-floating", 34: "spacing.safe-area.home-indicator", 44: "spacing.safe-area.status-bar" }

if px in V16_SAFE_AREA:
  return V16_SAFE_AREA[px]
elif px in V16_SPACING_VALUES:
  return f"spacing.{px}"
else:
  return ⚠️ half-step + 注释 "V16 标准间距 {V16_SPACING_VALUES}，{px}px 不在内，建议归到最近值"
```

### 示例

| 输入 | 输出 |
|---|---|
| 8 | `spacing.8` |
| 16 | `spacing.16` |
| 10 | ⚠️ half-step + 注释 "V16 无 10px，建议归到 spacing.8 或 spacing.12" |
| 20 | `spacing.20`（V16 有这个 atom） |
| 7 | `spacing.7`（Feeds 横纵特殊值） |
| 17 | `spacing.safe-area.home-indicator-floating`（V16 新加） |

---

## 5. 材质反查（INSTANCE name → material token）

### 算法

```
INPUT: instance.name (string, e.g. "Liquid Glass - Small")
OUTPUT: material token 名 或 null

按 name pattern 匹配：

  "Liquid Glass - Small"   → material.liquid-glass-small
  "Liquid Glass - Medium"  → material.liquid-glass-medium
  "Liquid Glass - Regular" → material.liquid-glass-small（V16 master 文件里有这个变体名，统一归 small）
  "Frosted Glass - Small"  → material.frosted-glass-small
  "Frosted Glass - Medium" → material.frosted-glass-medium

如果 name 含 "Glass" 但不匹配以上：
  return ⚠️ material-unknown + 注释 "未知材质变体 '{name}'"
```

---

## 6. 反查失败时的处理（关键约束）

**严禁**编造 token 名。反查失败时：

1. **不要**写 `color_unknown_1`、`color_navbar_bg` 等新名字
2. **要**在 frontmatter `uses_tokens` 里**省略**那一条（不写就是不写）
3. **要**在对应 section 的表格里把**实际值**填进去 + 加 ⚠️ token-miss 备注

例：色彩 section 里没匹配的：

```markdown
| 用途 | Token | 实际 hex |
|---|---|---|
| 容器底 | `color_background_overlay` | #FFFFFF |
| 搜索文案 | ⚠️ token-miss | #11141A (设计师确认是否应为 `color_title` #171A26) |
```

并在 design.md 末尾"本次自动同步发现的待办"段汇总所有 ⚠️。
