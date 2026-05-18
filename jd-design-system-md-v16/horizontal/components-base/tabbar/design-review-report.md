# design.md Review · `jd-design-system-md-v16/horizontal/components-base/tabbar/design.md`

**版本**: V16.0 | **fileKey**: `2029484645871009793` | **last_synced**: 2026-05-18 | **bundle**: page-doc(6 文件) | **审查工具**: /design-review v0.6(PR #29-32 落地后首跑)

**类型识别**: bundle / 通用基础组件(level=component-base, bg=horizontal)
**审查范围**: design.md + spec.md + variants.md + behaviors.md + ai-schema.yaml + CHANGELOG.md 全 bundle

---

## ❌ 违规(必须改)

### ❌ Off-token #1: `pingfang_medium/font_size_10_500` 在 V16 typography 中不存在

- **位置**: `spec.md` frontmatter `uses_tokens.typography[4]` + 正文文字段
- **事实**: V16 `tokens.json` `typography.role` 仅 4 family — `pingfang_regular` / `pingfang_semibold` / `zhenghei_regular` / `zhenghei_bold`,**无 pingfang_medium**
- **证据**: `jq '.typography.role | keys' jd-design-system-md-v16/foundations/tokens/tokens.json`
- **建议**: 改用 `pingfang_regular/font_size_10_400`(若需 Regular)或 `pingfang_semibold/font_size_10_600`(若需中等-粗强调);或与设计组提议补 V16 token `typography.role.pingfang_medium.font_size_10_500`(若灵动岛小字号必须 weight=500)
- **规则**: [`tokens/typography.md`](/jd-design-system-md-v16/foundations/tokens/typography.md) §role token 列表

### ❌ Off-token #2: `color_primary_specialdisabled` 命名错位

- **位置**: `spec.md` frontmatter `uses_tokens.colors[9]` + 正文色彩表
- **事实**: V16 `tokens.json` 正确名为 `color.primary_disabled_special`(`relay_token_name`: `color_primary_disabled_special`),spec.md 把 `_disabled_special` 写成了 `_specialdisabled`,下划线位置 + 词序都错
- **证据**: `jq '.color | keys[] | select(contains("disabled"))' → "primary_disabled_special"`
- **建议**: 改 `color_primary_specialdisabled` → `color_primary_disabled_special`
- **规则**: [`tokens/color.md`](/jd-design-system-md-v16/foundations/tokens/color.md)

---

## ⚠️ 警告(命名 / 残留 / 不完整)

### ⚠️ Value-drift #1: `atom.gray.6` 实际值 vs spec.md 注释漂移

- **位置**: `spec.md` Line 28 注释"gray_6 # `#f0f2f7` — 灵动岛常规底色 + 选中背景"
- **事实**: V16 `tokens.json` `atom.gray.6.light = "#F5F6FA"`,**不**是 `#f0f2f7`
- **设计师已注意**: `design.md` 第 7 段"本次自动同步发现的待办" 第 2 条同样指出此漂移,标注"疑命名空间冲突,待设计组核对"
- **建议**:
  - 若 Relay 端 atom.gray.6 实际值 = `#f0f2f7`,则 V16 tokens.json 需修(可能是 PR3b naming-conflict-rules.md 已知冲突 `colorbackgroundsunken` 的扩散变体)
  - 若 tokens.json `#F5F6FA` 为准,设计稿 atom.gray.6 应改 → 触发后端 review

### ⚠️ Atom 层 token 反查规则缺失

- **位置**: `spec.md` `uses_tokens.colors[12-21]` 共 **9 条 atom 层引用**(`jdred` / `jdred_6` / `gray_1` / `gray_6` / `gray_8` / `gray_9` / `gray_10` / `white` / `black`)
- **事实**: V16 `tokens.json` `atom.*` 节点**没有** `relay_token_name` 标注;atom 层用 dot path 寻址(`atom.jdred.6` / `atom.gray.6.light` 等)
- **影响**: design-review SKILL.md Step 3b 反查算法只查 `$extensions.relay_token_name` → 这 9 条全部误报为 ❌ Off-token,但**实际有效**
- **建议**: 这条不是 design.md 的问题,而是 **design-review SKILL.md Step 3b 规则不完整**(见末尾"工具自身待改进")。报告里**不计入 ❌**,只占位 ⚠️ 提示设计师注意 atom 引用没在 tokens.json 反查规则中

### ⚠️ Spacing tokens 占位字符串

- **位置**: `spec.md` `uses_tokens.spacing` 仅一条 `"TODO: spacing tokens 待回填"`
- **事实**: V16 tokens.json 应该有 `spacing.{xxs,xs,s,base,l,xl,xxl}`(参考 radius / typography 结构),spec.md 25+ 处 DP 标注未绑定
- **设计师已注意**: design.md 待办段第 4 条
- **建议**: 等 V16 spacing token 表录入后回填映射

### ⚠️ Materials token 空缺

- **位置**: `spec.md` `uses_tokens.materials` 写 `liquid-glass` / `frosted-glass` 字符串,无 INSTANCE 引用
- **事实**: V16 tokens.json 暂无 `material.*` 段;spec.md 注释"待 V16 materials token 表确立后回填"
- **建议**: V16 token 系统建立 materials 类别后回填

### ⚠️ preview.png 未生成

- **位置**: `spec.md` 章节 `## 预览` 引用 `./preview.png`(不存在)
- **事实**: Relay 节点高 18519px 超 base64 编码栈,自动 export 失败;design.md / spec.md 待办段都提到
- **建议**: 手动从 Relay export 分章节 5 张(如 `preview-01-principles.png`)

### ⚠️ uses_components 单条未录入

- **位置**: `design.md` frontmatter `references.uses_components[0]` = `horizontal/components-business/joy-agent`
- **事实**: 子组件 design.md 尚未录入,relay-to-design-md 双向 used_by 维护链断了
- **建议**: 录 joy-agent 组件后,relay-to-design-md Step 10 自动反向填 used_by

### ⚠️ Donts 数量 = 9,超启发上限 8

- **位置**: `behaviors.md` `## Donts` 段,9 条 ❌ 列表
- **事实**: design-review SKILL.md Step 3d 启发:Donts > 8 → ⚠️ "建议精简到核心 8 条以内"
- **判读**: 9 条 / 8 上限 差 1,Liu 启发是软约束。9 条覆盖了"iOS 安全区 / 营销态 / 招手字符限制 / Agent 招手字符限制 / 坑位数上限 / 灵动岛红区 / 配色禁忌 / 浅色背景必须 / 透明底素材必须"9 个核心规则,**实际不冗余**
- **建议**: 接受 9 条,或合并 6+8(配色禁忌 / 浅色背景必须)为单条 — 取决于设计师判断

---

## ✅ 符合 V16.0

### Frontmatter 合规(10 维校验)

| 维度 | 状态 | 备注 |
|---|---|---|
| 必填字段 12 项全在 | ✅ | file / level / bg / slug / name_zh / owner / contributors / status / version / last_synced / auto_detected / relay_source / references / used_by 全部存在(`bundle: page-doc` + `bundle_files[6]` 额外) |
| `file: "design"` | ✅ | 固定值正确 |
| `level: component-base` | ✅ | 在 [shared/references/level-vocab.md](.claude/shared/references/level-vocab.md) 5 枚举词表内 |
| `bg: horizontal` | ✅ | 在受控词表内 |
| `slug: tabbar` | ✅ | kebab-case ✅,2-50 字符 ✅,非数字开头 ✅ |
| `level + bg` 组合 | ✅ | `component-base + horizontal` 符合常规 |
| `last_synced: "2026-05-18"` | ✅ | ISO date 格式 |
| `relay_source.url` 可解析 | ✅ | 提取出 file_id / page_id / node_id 三者 |
| `auto_detected` 无 ⚠️ fallback | ✅ | level / bg / slug 推断均无 fallback 标记;page_doc=true 自动判定 |
| Bundle 单点存储 | ✅ | spec.md / variants.md / behaviors.md frontmatter 仅含 `bundle_part_of: design.md` 反向指针,无重复 `relay_source` 块;ai-schema.yaml / CHANGELOG.md 用 yaml 注释 / markdown quote 形式标 `bundle_part_of`(SKILL.md 未明说但合理) |

### Token 反查正确性(spec.md uses_tokens)

| 类别 | 总数 | ✅ Pass | ❌ Off-token | ⚠️ |
|---|---|---|---|---|
| color(role 层) | 11 | 10 | 1(specialdisabled) | — |
| color(atom 层) | 9 | — | — | 9(反查规则缺失,见 ⚠️ #2) |
| typography | 5 | 4 | 1(pingfang_medium) | — |
| radius | 4 | 4 | 0 | — |
| spacing | 1 占位 | — | — | 1 |
| materials | 2 字符串 | — | — | 2 |

### 章节完整性(bundle mode 7 章节映射)

| # | 章节 | 实际位置 | 状态 |
|---|---|---|---|
| 1 | 定义 | `design.md ## 一句话定义` | ✅ |
| 2 | 行为准则 | `behaviors.md ## 交互` | ✅ |
| 3 | 类型 | `variants.md ## 变体维度概览` + `## 各维度详细规范` 6 子段 | ✅ |
| 4 | 结构 | `spec.md ## 色彩 / ## 文字 / ## 圆角` 表格 ≥1 张 | ✅ |
| 5 | 布局 | `spec.md ## 间距 / 布局` 5 子段(总高度 / 宽度 / 坑位 / 灵动岛 / Joy Agent) | ✅ |
| 6 | 正反案例 | `behaviors.md ## 应用场景` ✅/❌ 子段 + `## Donts` 9 条 | ✅ |
| 7 | 典型场景 | `behaviors.md ## 应用场景 ### ✅ 用` | ✅ |

7 章节 canonical 覆盖完整,跟 [shared/references/section-anchors.md](.claude/shared/references/section-anchors.md) 对得上。

### AI Schema 完整性

- YAML 可解析 ✅
- 顶层 10 个段:`component_type / forms / slots / states / badges / island / agent / material / typography / events`
- 4 核心段 `forms / slots / states / events` 全部存在 ✅(超出 SKILL.md 启发的"至少 1 个"门槛)

### Naming-conflict(PR3b 落地的 shared 规则)

对 spec.md uses_tokens 中所有 token 名跑 fingerprint 检查:

- 已知 V15 冲突表(`colorborder` / `colortexthelp` / `colorbackgroundsunken`)— tabbar 用 snake_case `color_border` / `color_text_help` / `color_background_component`,**未撞 kebab 变体**(因为 V16 tokens.json 只标注 snake_case relay_token_name),✅
- 内部 fingerprint 唯一性 — uses_tokens 内无 ≥2 个变体撞同 fingerprint,✅
- **但**:Value-drift #1(`atom.gray.6` 实际 `#F5F6FA` vs spec.md 注释 `#f0f2f7`)实质上是 V15 已知冲突 `colorbackgroundsunken` 的同款表现(`#f5f6fa` vs `#f7f8fc`)。这条 V16 是否已修需 follow-up

---

## 📋 无法仅凭 design.md 判断

- **spec.md 章节 02-03 原文中嵌入的 25+ DP 数值** 与未来 V16 spacing tokens 是否能完全映射 — 需 V16 spacing 表落地后批量回填校验
- **liquid-glass / frosted-glass 材质** 当前是文本描述,无 INSTANCE 引用 — 需 V16 materials token 落地
- **运营 / 大促灵动岛"同频色"** 无固定 token,理论上需 dynamic-color 类别 — 见 design.md 待办 #7
- **AI Schema events 段缺 `on_island_click` / `on_island_dismiss`** — 见 design.md 待办 #10
- **章节 04 应用场景无独立 description** — design.md 待办 #8

---

## 文字总结

tabbar bundle 是 V16 第一份 page-doc 形态 design.md,**结构合规度高**:

- frontmatter 12 维全部 ✅,bundle 6 文件单点存储契约严守
- 章节完整性 7/7 ✅
- AI Schema 10 段含 4 核心
- Token 反查 25 条候选中,**2 条真违规**(pingfang_medium 不存在 / color_primary_specialdisabled 错位),**1 条值漂移**(atom.gray.6),**9 条 atom 引用反查规则缺失**(工具问题非 design.md 问题)

**实战暴露的工具自身问题**(见末尾):design-review SKILL.md Step 3b 对 atom 层 token 反查规则不完整 + token 反查规则没区分 role / atom 命名空间。

主体结论:**tabbar/design.md 可发布(状态从 draft → review),修两条 ❌ token 命名 + 核 atom.gray.6 漂移后可进 status: published 流程**。

---

## 工具自身待改进(实战暴露)

> 本次跑出的 ⚠️ 中,有部分不是 design.md 的问题,而是 design-review SKILL.md / 反查算法不完整。汇总给下一轮 PR 输入:

1. **Step 3b 反查没区分 role / atom 命名空间** — V16 tokens.json `atom.*` 节点无 `relay_token_name` 标注;反查算法只看 `$extensions.relay_token_name` → atom 层引用(`jdred` / `gray_6` 等)100% 误报 ❌ Off-token。**修法**:Step 3b 加 atom 层兜底逻辑,先按 `relay_token_name` 反查,落空再按 atom path 直接匹配(`atom.{family}.{shade}`)。
2. **Step 3b 未规定 token 名归一化** — `pingfang_medium/font_size_10_500` 是 `{family}/{role}` 形式,V16 tokens.json 是 `typography.role.{family}.{role}` 路径。SKILL.md 没写出转换规则。**修法**:Step 3b 加 typography role token 反查算法子节(`{x}/{y}` → `typography.role.{x}.{y}`)。
3. **Bundle mode 3b 数据源** — SKILL.md Step 3b 写"对 frontmatter `references.uses_tokens` 中每条 token 名" — 但 bundle mode 下 uses_tokens 在 spec.md 而非 design.md(index)。**修法**:Step 3b 加 "若 bundle: page-doc,从 spec.md frontmatter 读 uses_tokens" 显式规则。
4. **ai-schema.yaml / CHANGELOG.md 反向指针格式** — 不是 markdown frontmatter,SKILL.md Step 1.4 "各取 frontmatter 验 bundle_part_of" 不严格成立;实测它们用 yaml 注释 / markdown quote 形式存指针。**修法**:Step 1.4 加 "ai-schema.yaml 在文件顶部 yaml 注释验;CHANGELOG.md 在文件顶部 blockquote 验"。
5. **Donts 上限 8 启发偏紧** — 实战 9 条都对应独立规则,合并损失语义。**修法**:Step 3d 把"> 8 → ⚠️"门槛放宽到 12,或加注"组件复杂度高(bundle / page-doc)可接受 12 条"。
6. **Naming-conflict 应跨 design.md/spec.md 注释整体扫** — 实测 `atom.gray.6` 在 V16 tokens.json `#F5F6FA` 但 spec.md 注释 `#f0f2f7` 漂移,实质是 V15 已知 `colorbackgroundsunken` 冲突在 V16 atom 层的延续。当前 PR3b naming-conflict-rules.md 仅 V15 spec file 已知 3 条,**未追踪 V16 atom 层的同款延续**。**修法**:V16 实战发现的 atom-层 hex 漂移补进 naming-conflict-rules.md V15/V16 适用性段。
