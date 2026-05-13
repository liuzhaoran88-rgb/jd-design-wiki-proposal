---
zone: foundations
section: tokens
version: 16.0-draft
owner: 设计与用研部 · AI 核心产品设计部
last_updated: 2026-05-12
single_source_of_truth: tokens.json
relay_source:
  file_id: "2029484645871009793"
  page_id: "58:9"   # 语义化统一（Token 真相源页）
  url: https://relay.jd.com/file/design?id=2029484645871009793&page_id=58%3A9
---

# Design Tokens · V16.0

> V16.0 引入 **3 层 Token 架构**。组件只引用 **Token 层**；Token 引用 **Atom 层**；Atom 给 **Hex 值** 与 **Light/Dark 双 variant**。
>
> 这是 V15.0 → V16.0 最大的架构变更：**解耦色值与语义**。换肤、暗黑、子品牌只需替换 Atom 层，Token 层零改动。

---

## 3 层架构

```
┌─────────────────────────────────────────────────────────────┐
│  L3  组件                                                    │
│      .button-primary { background: var(--color_primary); }  │
└─────────────────────────────────────────────────────────────┘
                              ↓ 引用
┌─────────────────────────────────────────────────────────────┐
│  L2  Token 层（语义层）                                       │
│      color_primary       → jdred_6                          │
│      color_error         → errorred_2                       │
│      color_service       → servicegold_2                    │
│      color_text          → gray_2                           │
└─────────────────────────────────────────────────────────────┘
                              ↓ 引用
┌─────────────────────────────────────────────────────────────┐
│  L1  Atom 层（原子色板）                                      │
│      jdred_6        light: #ff0f23   dark: TODO             │
│      errorred_2     light: #xxxxxx   dark: TODO             │
│      gray_2         light: #xxxxxx   dark: #xxxxxx          │
└─────────────────────────────────────────────────────────────┘
```

**好处**：
- 业务方调色 → 只动 Atom（如 618 主题把 `jdred_6` 替换成渐变）
- 暗黑模式 → Atom 自带 dark variant，Token 透传
- 命名稳定 → Token 名永远是 `color_primary`，组件代码不用改

---

## 命名规则

V16.0 改用 **snake_case 平铺**，对应 Relay 设计变量的原始命名：

```
{category}_{role}_{state?}_{modifier?}

举例:
color_primary                  # 品牌主色（默认态）
color_primary_pressed          # 品牌主色 按下态
color_primary_disabled         # 品牌主色 禁用态
color_primary_disabled_special # 品牌主色 特殊禁用态（可转默认）
color_primary_light            # 品牌主色 镂空背景
color_primary_light_pressed    # 品牌主色 镂空背景按下
color_text                     # 文字 二级辅助/可操作
color_title                    # 标题 一级重要内容
color_service_bground          # 服务金背景
color_mask_fault_toleran       # 容错蒙层
```

**与 V15.0 命名对照**：

| V15.0 | V16.0 | 变化类型 |
|---|---|---|
| `color.brand.primary` | `color_primary` | upgraded（命名扁平化） |
| `color.semantic.danger` | `color_error` | **decoupled**（独立色族 errorred） |
| `color.neutral.text.primary` | `color_title` | upgraded（语义更精确） |
| `color.neutral.text.secondary` | `color_text` | upgraded |
| `color.neutral.text.tertiary` | `color_text_help` | upgraded |
| `color.neutral.bg.surface` | `color_background_overlay` | upgraded |
| `color.functional.service-gold` | `color_service` | **decoupled**（4 件套） |
| - | `color_primary_light_pressed` | **new** |
| - | `color_mask_fault_toleran` | **new** |

---

## tokens.json 结构（V16.0 新格式）

```json
{
  "$schema": "https://design-tokens.github.io/community-group/format/",
  "$description": "JD APP 16.0 design tokens — Token + Atom 双层结构",
  "$metadata": {
    "version": "16.0-draft",
    "relay_file_id": "2029484645871009793",
    "v15_predecessor": "../../../jd-design-system-md/foundations/tokens/tokens.json"
  },

  "atom": {
    "$description": "L1 原子色板 — 由色板真相源（平台色板）维护",
    "jdred": {
      "6": { "$value": { "light": "#ff0f23", "dark": "TODO" }, "$type": "color" }
    },
    "errorred": {
      "2": { "$value": { "light": "TODO", "dark": "TODO" }, "$type": "color" }
    }
  },

  "color": {
    "$description": "L2 语义 Token — 引用 atom，组件层只用这一层",
    "primary": {
      "$value": "{atom.jdred.6}",
      "$type": "color",
      "$description": "品牌主色调默认态。Relay: 设计变量 color_primary → 原子 jdred_6",
      "$extensions": {
        "v16_status": "upgraded",
        "v15_equivalent": "color.brand.primary",
        "rationale": "命名扁平化（dot → snake），值未变",
        "relay_node": "591:1796"
      }
    },
    "error": {
      "$value": "{atom.errorred.2}",
      "$type": "color",
      "$description": "错误状态。V16 从 primary 解耦为独立色族。",
      "$extensions": {
        "v16_status": "decoupled",
        "v15_equivalent": "color.semantic.danger（与 brand.primary 同色）",
        "rationale": "V15 通过 wash + 图标区分 danger 和 primary；V16 直接用独立色族 errorred，色相不再共用"
      }
    }
  }
}
```

---

## 每条 token 的 frontmatter / $extensions 字段

| 字段 | 必填 | 说明 |
|---|---|---|
| `v16_status` | ✅ | `unchanged` / `upgraded` / `decoupled` / `new` / `deprecated` |
| `v15_equivalent` | ⚠️ | V15.0 路径，`v16_status != new` 时必填 |
| `rationale` | ✅ | 一句话写为什么这样改（review 时回溯依据） |
| `relay_node` | ⚠️ | 对应 Relay 节点 ID，方便溯源 |
| `replacement` | ⚠️ | `v16_status = deprecated` 时必填，指向 V16 替代 token |

---

## Token 类别（V16.0）

| 类别 | 文档 | Relay 真相源 |
|---|---|---|
| 🎨 [color.md](./color.md) | 色彩 Token（10 大语义组 + atom 原子层） | `58:9 / 591:1785` |
| ✏️ [typography.md](./typography.md) | 字体 Token | `58:9 / 363:655` |
| 📐 [spacing.md](./spacing.md) | 空间 Token | `6:3`（规范 1/2/3） |
| 🟫 [radius.md](./radius.md) | 圆角 Token | `58:9 / 363:507` |
| 📏 [lines.md](./lines.md) | 线 Token（**V16 新独立**） | `58:9 / 363:636` |
| 🖼 [icon.md](./icon.md) | 图标尺寸/笔触 Token | `12:263` |

> 材质 Materials 不在 tokens 层，而是组合规则，见 `../visual/materials.md`。
> 动效 Motion 在 V16.0 录入计划中未列入，沿用 V15.0（如果 V16.0 文件后续提供动效页再补）。

---

## 待办

- [ ] 录入所有 V16.0 Foundation token（按推荐顺序）
- [ ] Atom 层全量 Light hex 值（从色板真相源提取）
- [ ] Atom 层 Dark hex 值（从彩色/灰阶/平台色板暗黑映射表提取）
- [ ] V16 tokens.json 与 V15 做 diff 报告，输出 MIGRATION 表
- [ ] 工具链：v15→v16 token 映射 codemod
