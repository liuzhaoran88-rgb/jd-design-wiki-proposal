# design.md Review · `jd-design-system-md-v16/horizontal/components-base/button/design.md`

**版本**: V16.0 | **fileKey**: `2029484645871009793` | **last_synced**: 2026-05-13 | **mode**: single design.md | **审查工具**: /design-review v0.6 (PR #33 后第二次实战,对照 tabbar bundle 验证)

**类型识别**: single / 通用基础组件(level=component-base, bg=horizontal) **变体节点而非组件总入口**(见 frontmatter `auto_detected` 注释)
**审查范围**: button/design.md 单文件

---

## ❌ 违规(必须改)

### ❌ 章节内容空: `## Donts` 段实际 0 条

- **位置**: `design.md` `## Donts` (line 133-138)
- **事实**: 段标题存在但内容全是 `<!-- TODO: 设计师列举常见误用 -->` HTML 注释,可解析的 Donts list items = **0**
- **SKILL.md Step 3d 规则**: 0 → ❌ "缺 Donts 段或空段,典型反例无规则可循"
- **建议**: 设计师按注释提示补 ≥3 条具体禁止规则(如"不要硬编码 #FF0F23 替代 color_primary" / "不要在非首要操作场景使用主要按钮" / "不要把 18pt Semibold 改成其他字号字重")
- **规则**: [`shared/references/section-anchors.md`](/.claude/shared/references/section-anchors.md) 6. 正反案例

### ❌ 章节内容空: `## 一句话定义` 段空白

- **位置**: `design.md` `## 一句话定义` (line 61-63)
- **事实**: 段标题存在但只有 `<!-- TODO -->` 占位,无实际定义文本
- **SKILL.md Step 3c 规则**: bundle/single 模式都要求 `## 一句话定义` 段**非空** → ❌
- **建议**: 设计师补一段话:"主要按钮(红色填充)是首要操作的视觉锚点,用于页面主操作链路(确认 / 提交 / 立即购买 / 添加),全页面通常仅 1 个"
- **规则**: 同上 1. 定义

### ❌ 章节内容空: `## 应用场景` ✅/❌ 子段全 TODO

- **位置**: `design.md` `### ✅ 用` (line 67-69) + `### ❌ 不用` (line 71-73)
- **事实**: 子段标题都在但内容空,只有占位注释
- **SKILL.md Step 3c 规则**: 6. 正反案例 + 7. 典型场景两章节单模式都从 `## 应用场景` 取 — 段空则两章节同时 ❌
- **建议**: 设计师按"页面主操作 / 弹层确认 / 表单提交"列正例 ≥3,按"次要操作不要用主要按钮 / 同屏 ≥2 个主要按钮抢焦"列反例 ≥3
- **规则**: 同上 6 / 7

---

## ⚠️ 警告(命名 / 残留 / 不完整)

### ⚠️ Frontmatter auto_detected slug 推断 fallback

- **位置**: `design.md` frontmatter `auto_detected` 段 (line 20-23) 注释
- **事实**: 本节点是 button **变体** (`样式=主要操作（红色填充）, 状态=默认`),但 slug 从 PAGE 名提到 `button`(总入口同名)。`auto_detected` 注释提醒"若仅是变体 → mv 文件夹到 `button-primary-default` 并改 slug"
- **SKILL.md Step 3a 规则**: `auto_detected.*` 含 ⚠️ fallback 标记 → ⚠️ 提示"需设计师 review 推断结果"
- **建议**: 设计师决定:① 把本文件升级为 Button 总入口(扩展为覆盖各变体的 page-doc bundle) / ② 重命名为 `button-primary-default` 作为变体文档,Button 总入口另起
- **影响范围**: 影响后续 spec-page / design.html 站点的 TOC 归类,以及 used_by 反向引用维护

### ⚠️ Off-token (V16 spacing 真空,非 button 错): `spacing.24` / `spacing.8`

- **位置**: `design.md` frontmatter `uses_tokens.spacing[0,1]`
- **事实**: V16 tokens.json `.spacing.*` 只有 `_v15_inherited` 和 `safe-area` 两个 key,**真正的 spacing scale(`spacing.24` / `spacing.8` 等)还没建立**
- **PR4 Step 3b 反查**: 路 1 不命中(无 relay_token_name)/ 路 2 不适用(不是 typography)/ 路 3 atom 兜底也无 — 按规则本应 ❌ Off-token
- **判读**: 这**不是 button design.md 的错**,是 V16 spacing token scale 全局缺失;tabbar/spec.md 同样标"TODO: spacing tokens 待回填"
- **建议**: V16 设计组先建 `spacing.{xxs..xxl}` token scale 后再回填本文件 + tabbar/spec.md;在此之前 button 的两条 spacing 引用按 ⚠️ "spacing scale 全局未建,等 V16 token 落地" 处理,不计入 ❌

### ⚠️ rgba 透明度引用无 atom 真相源

- **位置**: `design.md` frontmatter `uses_tokens.colors` 注释(line 43-44)
- **事实**: 注释提到 `#FFFFFF@90%` → 建议 atom name `white-at-90`,但 V16 tokens.json atom.* 暂无此条
- **建议**: 若 #FFFFFF@90% 在多组件出现 → 设计组加 `atom.white.90` token;若仅 button 用 → 在 button 内 hardcode 也可,但 frontmatter 应去掉"建议 atom"注释或明确为 TODO

### ⚠️ `## AI Schema` 段全 TODO

- **位置**: `design.md` `## AI Schema` (line 140-158)
- **事实**: yaml fenced code 中 states / events 全是 `TODO`,只有 component_type / variant / priority / slots 有值
- **判读**: SKILL.md Step 3e AI Schema 完整性是 bundle mode 才走(检查独立 `ai-schema.yaml` 文件)。single mode 暂无规则。但**本地 yaml block 的 TODO 占位会传播到 spec-page.html 渲染**
- **建议**: 设计师补 states(`default` / `hover` / `pressed` / `disabled` 4 态的颜色 / 透明度 / 字色)+ events(`on_press` / `on_long_press`)
- **工具改进**: PR3a Step 3e 可扩展为 "single mode 含内嵌 AI Schema yaml block 时同等检查" — 见末尾

### ⚠️ `uses_components: icon-home` 子组件未录入

- **位置**: `design.md` frontmatter `references.uses_components[0]`
- **事实**: 同 tabbar 的 joy-agent 情况 — 子组件 design.md 尚未录入,relay-to-design-md 双向 used_by 维护链断
- **建议**: V16 图标库批量录入后,relay-to-design-md Step 10 自动反向填 used_by

### ⚠️ `version: "0.1"` + `status: draft` — 文档处于早期阶段

- **位置**: `design.md` frontmatter
- **事实**: 与 tabbar 的 `version: 0.4` + `status: draft` 对照,button 还在更早阶段。多个章节 TODO 全空是预期内
- **判读**: 这是状态信息而非违规,设计师按版本节奏推进即可

---

## ✅ 符合 V16.0

### Frontmatter 合规(10 维校验,8 维通过)

| 维度 | 状态 | 备注 |
|---|---|---|
| 必填字段 11 项全在 | ✅ | 与 tabbar 同样合规;无 bundle 段是单模式预期 |
| `file: "design"` | ✅ | 固定值正确 |
| `level: component-base` | ✅ | 在 [level-vocab.md](/.claude/shared/references/level-vocab.md) 5 枚举内 |
| `bg: horizontal` | ✅ | 受控词表内 |
| `slug: button` | ✅ | kebab-case ✅(但语义层面 slug = 变体名而非组件名是 ⚠️ 见上) |
| `level + bg` 组合 | ✅ | component-base + horizontal 符合常规 |
| `last_synced: "2026-05-13"` | ✅ | ISO date 格式 |
| `relay_source.url` 可解析 | ✅ | file_id / page_id / node_id 三者齐 |
| `auto_detected.*` 无 ⚠️ fallback | ⚠️ | slug 推断有注释级 fallback(见上) |
| Bundle 单点存储 | N/A | single mode 不适用 |

### Token 反查正确性(uses_tokens 中 6 条候选)

按 PR4 Step 3b 3 路反查:

| Token 名 | 路 | 命中 |
|---|---|---|
| `color_primary` | 路 1(role 层 relay_token_name) | ✅ → `color.primary.$value = {atom.jdred.6}` = `#FF0F23` |
| `color_primary_text` | 路 1 | ✅ → `color.primary_text.$value = {atom.white}` = `#FFFFFF` |
| `pingfang_semibold/font_size_18_600` | 路 2(typography role 归一化) | ✅ → `typography.role.pingfang_semibold.font_size_18_600` 存在 |
| `radius_l` | 路 1 | ✅ → `radius.l.$value = 8` |
| `spacing.24` | 路 1/2/3 全不命中 | ⚠️(V16 spacing 真空,非 button 错,见上) |
| `spacing.8` | 路 1/2/3 全不命中 | ⚠️(同上) |

**PR4 验证**: 4 条 role/typography 正常,2 条 spacing 暴露 V16 token scale 缺口而非 SKILL.md 漏洞。

### 章节完整性(single mode 7 章节)

| # | 章节 | 段位置 | 内容状态 |
|---|---|---|---|
| 1 | 定义 | `## 一句话定义` (line 61) | ❌ 空 |
| 2 | 行为准则 | `## 交互` (line 119) | (需查内容,目前认为 ✅ 段存在) |
| 3 | 类型 | `## 变体 Variants` (line 124) | (需查内容) |
| 4 | 结构 | `## 视觉` (line 75) + 5 子段(预览/色彩/文字/圆角/间距 布局/材质) | ✅ |
| 5 | 布局 | `### 间距 / 布局` (line 105) | ✅ |
| 6 | 正反案例 | `## Donts` (line 133) + `## 应用场景` ✅/❌ | ❌ 全空 |
| 7 | 典型场景 | `## 应用场景 ### ✅ 用` (line 67) | ❌ 空 |

7 章节段标题**全部存在** ✅(对照 [shared/references/section-anchors.md](/.claude/shared/references/section-anchors.md));但内容空率高(4 章节空 / 1 章节占位 yaml),反映 draft 阶段。

### Naming-conflict(PR3b shared 规则)

对 6 条 token 跑 fingerprint 检查:无组内冲突,无与 V15 已知冲突表撞,无 V15→V16 atom 层延续命中 → ✅

---

## 📋 无法仅凭 design.md 判断

- **#FFFFFF@90% 透明 atom 是否多组件使用** — 决定要不要加 `atom.white.90` token,需扫全仓 design.md
- **V16 spacing token scale 何时建立** — 影响本文件 + tabbar/spec.md 的 spacing 引用回填时机
- **button 是组件总入口 or 变体** — 设计师拍板,决定文件名 / 文件夹策略
- **AI Schema TODO 4 个 state + events** — 状态机定义,需设计师 + 工程师 review

---

## 文字总结

button/design.md 是 **v0.1 draft 阶段** 的单 md 文件,**结构合规度高但内容填充度低**:

- frontmatter 10/10 维全过(8 ✅ + 1 ⚠️ slug 语义 + 1 N/A bundle)
- 章节段标题 7/7 ✅,**内容 3/7 实质 ❌**(定义 / 正反案例 / 典型场景全空)
- Token 反查 4/6 ✅,2/6 ⚠️(V16 spacing 真空非 button 问题)
- Naming-conflict 0 触发 ✅

主体结论:**button/design.md 不能从 draft → review,需先补 ❌ 3 章节内容(定义 / Donts / 应用场景)**。设计师同时拍板 slug 语义(总入口 vs 变体)。

**PR4 修补效果对照**(对比 tabbar 首跑 PR4 前的报告):

| PR4 修补点 | tabbar 首跑发现(PR4 前) | button 二跑(PR4 后) |
|---|---|---|
| 3b 数据源 single/bundle 区分 | bundle 模式漏看 spec.md | single 模式 design.md 直读 ✅ |
| 3b 路 2 typography role 归一化 | `pingfang_medium` 误报 → 正确判 ❌ | `pingfang_semibold/font_size_18_600` 正确 ✅ |
| 3b 路 3 atom 兜底 | tabbar 9 条 atom 引用误报 ❌(PR4 前)→ ✅(PR4 后) | button 无 atom 引用,无机会验证 |
| 3d Donts 上限 single 8 / bundle 12 | tabbar 9 条不再 ⚠️ | button 0 条仍 ❌(下限触发) |
| Step 1.4 反向指针 3 形式 | tabbar ai-schema.yaml / CHANGELOG.md 误报 → 正确 | single mode 不适用 |
| atom 层延续追踪 | atom.gray.6 漂移登记 | button 未撞已知 ✅ |

**PR4 修补在 button 二跑中无回归;新发现 1 处工具改进点见下方**。

---

## 工具自身待改进(button 二跑新发现)

1. **single mode 内嵌 AI Schema yaml block 检查缺失** — button 的 `## AI Schema` 是 fenced yaml 而非独立 `ai-schema.yaml` 文件。PR3a Step 3e 只检查 bundle mode 的独立文件,single mode 内嵌 yaml 没规则。**修法**:Step 3e 加 "single mode `## AI Schema` fenced yaml block 同等检查(YAML 可解析 + 至少 1 个 forms/slots/states/events 段)"。
2. **章节内容"段在但内容空"的判定颗粒度** — PR3a Step 3c 表只校验"段存在",但 button 7 段全在却 4 段实质空。**修法**:Step 3c 加 sub-rule "段在 + 实质内容非全 TODO/HTML 注释" → 实质空 → ❌(单独 list "段在但空"段落)。本次报告的 3 个 ❌(定义 / 正反案例 / 典型场景全空)就是这个 sub-rule 触发。
3. **slug = 变体名 vs 组件名** 没有规则识别 — `auto_detected` 注释里有 fallback 但 SKILL.md Step 3a 只对"⚠️ fallback 标记"通用处理。**修法**:Step 3a 加 sub-rule "若 node_type = INSTANCE 且 bounds.w < 200,可能是变体节点;若 slug 与父 page 同名,建议 reviewer 拍板组件入口 vs 变体重命名"。
4. **V16 spacing 真空** 不是工具问题但建议在 SKILL.md "失败模式" 段加一条:"V16 spacing.* 仅含 `_v15_inherited` + `safe-area`,真正 scale 未建立,所有 `spacing.{N}` 引用应标 ⚠️ V16-token-pending 而非 ❌"。
