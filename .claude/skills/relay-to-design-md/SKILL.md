---
name: relay-to-design-md
description: 把 Relay 设计稿一键转成 design.md。零输入，自动推断 level/bg/slug，自动反查 V16 token，自动维护双向追溯索引。设计师只需 review。
allowed-tools: [mcp__zero-design__get_design_metadata, mcp__zero-design__get_design_context, mcp__zero-design__get_screenshot, mcp__zero-design__get_variables, mcp__zero-design__use_design_script, Bash, Read, Write, Edit]
---

# /relay-to-design-md · Relay → design.md 一键同步

## 这个 skill 做什么

设计师传一个 Relay URL，输出一份**结构化、token 化、可 review** 的 `design.md`：

- 自动从 Relay 抽取节点视觉数据（fills / typography / radius / spacing / materials / instances / children）
- 自动反查 V16 token（hex → `color_*` / fontSize+weight → `font_size_N_W` / radius → `radius_*` 等）
- 自动推断 `level` / `bg` / `slug` / `name_zh` 字段
- 自动维护双向追溯：`design.md ↔ INDEX.md ↔ Relay sharedPluginData (v0.3+)`
- 自动 flag 视觉问题：token-miss / 半步间距 / 子组件未录入

## 调用方式

```
/relay-to-design-md <relay_url>
```

例：
```
/relay-to-design-md https://relay.jd.com/file/design?id=2029484645871009793&page_id=47%3A1&node_id=542%3A6495
```

只接受 1 个参数（URL）。**不要**问设计师额外问题 —— 全部字段自动推断。

## v0.1 范围（被 v0.4 / v0.5 扩展）

- ✅ L1 通用组件（component-base）
- ⏳ L2/L3/L4（component-business / page / flow）→ v0.6+
- ✅ 单一 design.md（普通组件） + **multi-md bundle**（page-doc，v0.5；v0.5.1 起 6 文件）
- ✅ **page-doc 大节点**（高 > 5000px 或 ≥3 个章节 FRAME）→ **v0.4 单 md 内章节切分** → **v0.5 拆 4 文件 bundle** → **v0.5.1 拆 6 文件**（+ `ai-schema.yaml` + `CHANGELOG.md`，`relay_source` 单点存储）

如果检测到 level ≠ component-base，**仍然写文件**，但 frontmatter `auto_detected.level` 标 ⚠️，并在终端输出"非 L1 节点，结果可能不准，请 review"。

**page-doc 模式**：
- v0.4：抽取脚本自动判定（`pageDocMode`），输出 `chapters[]` 元数据 + 每条 text/instance/layout 的 `chapter` 归属。模板渲染时在 `## 变体` 后追加 `## 设计规范细节(按章节)` 段
- **v0.5**：直接走 [templates/page-doc/](./templates/page-doc/) 4 模板 bundle，把 page-doc 内容拆成 design.md (index) + spec.md + variants.md + behaviors.md。design.md frontmatter 加 `bundle: page-doc` 标识 + `bundle_files: [...]` 清单

---

## 执行流程（严格按步骤跑）

### Step 1: Parse URL

从 URL 提取 3 个 id：

```
https://relay.jd.com/file/design?id={file_id}&page_id={page_id}&node_id={node_id}
```

注意：page_id / node_id 在 URL 里可能是 URL-encoded（`%3A` = `:`），需要 decode。

> 如果 URL 缺 `node_id`，**报错退出**："必须提供完整的 node_id，否则无法定位设计节点。"

### Step 2: 加载 Relay 节点 + 推断元数据

执行一次脚本（调 `use_design_script`），同时获取：

1. 节点本身：name / type / width / height
2. 父 page 名（用于 level 推断）
3. 是否在 V16 master 文件（用于 bg 推断）

```javascript
const node = await relay.getNodeByIdAsync('NODE_ID')
if (!node) return { error: 'node not found' }

// 找所属 page
let page = node
while (page && page.type !== 'PAGE') page = page.parent
if (page && page.loadAsync) await page.loadAsync()

return {
  node: {
    id: node.id, name: node.name, type: node.type,
    w: Math.round(node.width), h: Math.round(node.height),
  },
  page: { id: page.id, name: page.name },
  file_id: relay.fileKey,
}
```

### Step 3: 自动推断字段

按 [references/auto-detect-rules.md](./references/auto-detect-rules.md) 推断：
- `level` ← 看 page name 模式
- `bg` ← 看 file_id 查 [references/bg-mapping.json](./references/bg-mapping.json)
- `slug` ← 从节点名或 page 名提取英文，kebab-case
- `name_zh` ← 节点名去 emoji + 英文

记录"是否走兜底"，用于 frontmatter `auto_detected` 字段。

### Step 4: 抽取视觉数据

执行一个**完整提取脚本**（一次调用拿全部），见 [references/node-type-mapping.md](./references/node-type-mapping.md) 第 2 节"统一抽取脚本"。返回结构：

```typescript
{
  fills: string[],           // ["#FFFFFF", "#000000@20%", ...]
  textStyles: TextStyle[],   // [{chars, fontSize, family, style}]
  radii: number[],
  instances: Instance[],     // 子组件 / 材质 INSTANCE 引用
  layouts: Layout[],         // autoLayout padding / spacing
  variants: string[],        // COMPONENT_SET children 名
}
```

### Step 5: Token 反查

按 [references/token-reverse-lookup.md](./references/token-reverse-lookup.md) 把抽到的实际值反查到 V16 token：

- 读 `jd-design-system-md-v16/foundations/tokens/tokens.json`
- 色彩：hex → atom.* → color.* token 名
- 文字：fontSize + weight + family → `{family}_{weight}/font_size_N_W` role token
- 圆角：px → radius.* token
- 间距：px → spacing.* token
- 材质：INSTANCE name → material.* 引用

**没匹配到的 → 标 ⚠️ token-miss**，写到 frontmatter 注释 + section 表格说明，**不要尝试创建新 token**。

### Step 6: 导出 preview.png

按 [references/preview-export.md](./references/preview-export.md) 步骤：

1. `use_design_script` 调 `node.exportAsync({format: 'PNG', constraint: {type:'SCALE', value:2}})` + `relay.base64Encode(bytes)` 返回 base64
2. 体积检查（< 500KB 走 inline，超过降 SCALE=1 重试 / 跳过）
3. Bash `echo '<base64>' | base64 -d > <output-dir>/preview.png`
4. Bash `file <path>` 验证 PNG 头

> v0.2 链路通了。如果导出报错（节点不可见 / MCP 抖动），**继续往下走**，design.md 留 placeholder + 终端 warn，**不要 abort**。

### Step 7: 决定输出路径

按 [references/auto-detect-rules.md](./references/auto-detect-rules.md) 第 4 节路径规则：

```
component-base + horizontal → jd-design-system-md-v16/horizontal/components-base/{slug}/design.md
component-business + {bg}    → jd-design-system-md-v16/product-architecture/{bg}/components-business/{slug}/design.md
page + {bg}                  → jd-design-system-md-v16/product-architecture/{bg}/pages/{slug}/design.md
flow + {bg}                  → jd-design-system-md-v16/product-architecture/{bg}/flows/{slug}/design.md
```

#### v0.5.1 page-doc bundle 路径

如果 `pageDocMode === true`，**输出目录**与上面相同（`{slug}/`），但写 **6 个文件**（v0.5.1 起，issue #23）：

```
{slug}/
├── design.md       # index（含 bundle: page-doc 标识 + bundle_files 清单 + relay_source 单点存储）
├── spec.md         # 视觉规范（frontmatter 只 bundle_part_of，relay_source 见 design.md）
├── variants.md     # 变体维度
├── behaviors.md    # 应用场景 / 交互 / Donts / 多端适配（AI Schema 留摘要 + 链接）
├── ai-schema.yaml  # 机器可读 schema（forms / slots / states / events ...）
└── CHANGELOG.md    # 跨 bundle 变更记录
```

如果 `{slug}/design.md` 已存在 + 是 v0.1 单 md（`bundle:` 字段缺失）→ 全部 6 个文件都加 `.NEW` 后缀写入，让设计师手动迁移。终端输出："⚠️ {slug}/design.md 是 v0.1 单 md 形态，page-doc bundle 写入 design.md.NEW / spec.md.NEW / variants.md.NEW / behaviors.md.NEW / ai-schema.yaml.NEW / CHANGELOG.md.NEW，请手动迁移。"

> **frontmatter 单点存储约定（v0.5.1）**：`relay_source` 整段（file_id / page_id / node_id / node_name / node_type / bounds / url）**只在 design.md 写**。spec.md / variants.md / behaviors.md / ai-schema.yaml 顶部 frontmatter 只保留 `bundle_part_of: design.md` 反向指针。这样 Relay URL / file_id / node_name 变更时只需改 1 处。

如果路径已存在 `design.md`，**不要覆盖**：改名为 `design.md.NEW`，让设计师手动 diff。终端输出："⚠️ {path}/design.md 已存在，新版本写入 design.md.NEW，请 diff 后合并。"

### Step 8: 套模板生成 design.md

#### v0.5.1 模板分流（首先决定走哪套模板）

| 条件 | 模板 | 输出 |
|---|---|---|
| `rootInfo.pageDocMode === false` | [templates/component.md](./templates/component.md)（v0.1 单 md） | `{slug}/design.md` 一个文件 |
| `rootInfo.pageDocMode === true` | [templates/page-doc/](./templates/page-doc/) bundle 6 模板 | `{slug}/{design,spec,variants,behaviors}.md + ai-schema.yaml + CHANGELOG.md` 6 个文件 |

##### page-doc bundle 渲染规则

读 6 个模板各自渲染：

1. **[templates/page-doc/design.md](./templates/page-doc/design.md)** → `{slug}/design.md` (index)
   - frontmatter 含 `bundle: page-doc` 标识 + `bundle_files: [...]` 6 文件清单 + 完整 `relay_source` 整段（v0.5.1：单点存储）
   - 主体只放 Relay 章节大纲表 + 一句话定义 + 关联段 + 指向 CHANGELOG.md 的链接（不再内嵌变更表）
   - 占位符 `{{section_chapter_outline_table}}` = 章节 markdown table（# / 标题 / 节点 ID / 高度 / 内容要点 / bundle 落点）
   - 占位符 `{{chapter_count}}` = `chapters[].length`

2. **[templates/page-doc/spec.md](./templates/page-doc/spec.md)** → `{slug}/spec.md`
   - frontmatter 含 `file: spec` + `bundle_part_of: design.md` 反向指针 + 完整 `uses_tokens` 段。**不再含 `relay_source` 段**（v0.5.1：单点存储，见 design.md）
   - 主体含 colors / typography / radius / spacing / materials 全表 + 章节 01-02 原文引用块
   - 占位符 `{{section_chapter_01_02_full_text_or_empty}}` = 章节 01 设计原则全文 + 章节 02 组件设计属性核心规范文字（按 v0.4 抽取的 chapters[].notes 渲染）

3. **[templates/page-doc/variants.md](./templates/page-doc/variants.md)** → `{slug}/variants.md`
   - frontmatter 含 `file: variants` + `bundle_part_of`。**不再含 `relay_source` 段**（v0.5.1）
   - 主体含变体维度概览 + 各维度详细规范 + 章节 02 状态/招手 + 章节 03 灵动岛三型原文
   - 占位符 `{{section_variant_dimensions_overview}}` = 形态 / 状态 / 坑位 / 子组件 等维度的 bullet list
   - 占位符 `{{section_variant_details_per_dimension}}` = 每个维度展开（继承 v0.4 章节细分段的渲染逻辑）

4. **[templates/page-doc/behaviors.md](./templates/page-doc/behaviors.md)** → `{slug}/behaviors.md`
   - frontmatter 含 `file: behaviors` + `bundle_part_of`。**不再含 `relay_source` 段**（v0.5.1）
   - 主体含应用场景 ✅/❌ + 交互 + Donts + **AI Schema 摘要段（一句话 + 链到 `ai-schema.yaml`）** + 多端适配 + 章节 04-05 原文
   - 占位符 `{{section_donts_auto_or_todo}}` = v0.4 自动收的 dont_rule 聚合（每条标来源章节）
   - 占位符 `{{section_ai_schema_summary}}` = AI Schema 简短摘要（"含 9 个段：forms/slots/states/.../events。`on_island_*` 仍为 TODO"），完整 YAML 写到 ai-schema.yaml

5. **[templates/page-doc/ai-schema.yaml](./templates/page-doc/ai-schema.yaml)** → `{slug}/ai-schema.yaml` （v0.5.1 新增）
   - 顶部 4-5 行 `# bundle_part_of: design.md` 注释（YAML 不走 frontmatter）
   - 占位符 `{{section_ai_schema_yaml}}` = 完整 AI Schema YAML（原 v0.5 behaviors.md `{{section_ai_schema}}` 内容）

6. **[templates/page-doc/CHANGELOG.md](./templates/page-doc/CHANGELOG.md)** → `{slug}/CHANGELOG.md` （v0.5.1 新增）
   - 跨 bundle 的变更表，每次 skill 重跑追加一行（不覆写），design.md 内只保留指向 CHANGELOG.md 的链接
   - **"存在则追加"渲染规则**（仅本文件特殊，其它 5 个文件按"覆盖 / 或 .NEW"原路径处理）：
     - 渲染前先判 `[ -f "$BUNDLE_DIR/CHANGELOG.md" ]`
     - **存在** → `Read` 原文件，保留所有"标题 / 反向指针 / 已有 table 行"，**只在表末追加一行新 entry**（时间 / 操作 / 来源 / 备注），整体回写
     - **不存在** → 套模板生成首份（1 行"创建"）
   - 新增行字段约定：`时间`=`{{today_iso}}`，`操作`=本次升级语义（如"v0.5.1 优化"/"v0.6 升级"），`来源`=`skill {{skill_version}}` + flag 说明，`备注`=本次主要 diff 概述 + 关联 issue/PR

> **bundle 之间的反向引用**
>
> design.md (index) 在主体表格列出 6 文件链接;spec.md / variants.md / behaviors.md 顶部有 `> design.md → [index](./design.md) · 同 bundle: ...` 导航条;子文件 frontmatter 都有 `bundle_part_of: design.md` 标识；`relay_source` 整段只在 design.md 出现一次。

> **如果只是 `pageDocMode === false`（普通组件）**
>
> 走 v0.1 单 md 模板（`templates/component.md`），与 v0.4 兼容路径一致。下面的"v0.4 章节细分渲染"仅在 `pageDocMode === true` 但**未走 bundle 模式**时才生效（极少情况，比如设计师强制 `--single` flag，v0.5 暂未开启）。

---

#### 旧路径：v0.1 单 md 模板（`pageDocMode === false`）

读 [templates/component.md](./templates/component.md)，把模板里的 `{{...}}` 占位符替换成 Step 2-5 的实际数据。

> **v0.4：page-doc 模式渲染**（已被 v0.5 bundle 路径取代，但保留兼容）
>
> 如果 `rootInfo.pageDocMode === true`，渲染 `{{section_chapter_details_or_empty}}` 为完整的 "## 设计规范细节（按章节）" 段。对每个 chapter（来自返回的 `chapters[]`）：
>
> ```
> ### 章节 {N}：{chapter.name}（节点 `{chapter.id}`，{w}×{h}）
>
> - 章节标题：{第一条 bucket=chapter_title 的 text.chars}（无则省略）
>
> #### 图示
> | # | 标号 | 上下文 |
> |---|---|---|
> | 1 | {figure.label} | {figure.ctx 取同 frame 最近的 description bucket} |
> ...
>
> #### 尺寸标注
> | DP/px | 来源 |
> |---|---|
> | {dim.value} | {dim.ctx} |
>
> #### 禁止规则
> - {dont.chars}（章节 {N}）
>
> #### 关键说明
> > {notes[0].chars}
> > {notes[1].chars}
> > {notes[2].chars}（≤ 3 条，避免淹没）
> ```
>
> 如果 `pageDocMode === false`，`{{section_chapter_details_or_empty}}` 渲染为空字符串（不出现该段）。
>
> 同时，全局聚合所有 chapter 的 donts 数组到 `{{section_donts_auto_or_todo}}`：
> - 有 donts → 渲染为 markdown bullet 列表，每条标 `(章节 N)` 来源
> - 没 donts → 保留原 `<!-- TODO: 设计师列举常见误用 -->` 占位

#### 占位符语义 (v0.3.1 明确)

**简单字符串替换**，**不是** jinja2 / handlebars / mustache 等 DSL：
- `{{field_name}}` → 直接替换为对应字段的字面值（如 `{{slug}}` → `navbar`）
- **不支持**条件 (`{% if %}`)、循环 (`{% for %}`)、表达式 (`{{ a | b }}`)、嵌套引用
- 占位符位置如果数据缺失 → 替换为字面 `TODO` 或 ⚠️ 描述，**不要**留 `{{...}}` 在最终文件
- 需要循环生成的段落（如 `section_colors_table` 多行）—— **由模型自己构造完整段落**作为单个字符串塞进去，不依赖模板 control flow

例：
```
模板：name_zh: "{{name_zh}}"
数据：name_zh = "按钮"
结果：name_zh: "按钮"
```

```
模板：{{section_colors_table}}
数据：fills = [{用途:按钮底, token:color_primary, hex:#FF0F23}, ...]
结果（模型自己构造 markdown table）：
| 用途 | Token | 实际 hex |
|---|---|---|
| 按钮底 | `color_primary` | `#FF0F23` |
| 文字 | `color_primary_text` | `#FFFFFF` |
```

#### 严禁

- 任何 frontmatter 字段编造（缺数据 → 标 TODO）
- 任何 token 名编造（没反查到 → 标 ⚠️ token-miss）
- 任何视觉数据虚构（必须来自 Step 4 实际抽取）

frontmatter 必填字段见 [references/frontmatter-spec.md](./references/frontmatter-spec.md)。

5 处 TODO placeholder（设计师手填）：
- `## 一句话定义` 段
- `## 应用场景` 段 ✅/❌
- `## 交互` 段
- `## Donts` 段（**v0.4：page-doc 模式如果抽到 ≥1 条 dont_rule bucket，此段自动填**，不再 TODO）
- `## AI Schema` 段

其他全自动填。

#### v0.4.1 模板占位符补充

| 占位符 | 替换值 |
|---|---|
| `{{skill_version}}` | 当前 skill 版本号字符串（如 `v0.4.1`、`v0.5`），从 SKILL.md 版本历史最新一行取 |
| `{{todo_count}}` | 实际剩余 TODO 数（基础 5，page-doc 模式 + Donts 自动填 → 4） |

### Step 9: 更新 INDEX.md

[references/traceability.md](./references/traceability.md) 第 1 节"INDEX.md 维护"。读 `.claude/skills/relay-to-design-md/INDEX.md`，按 BG 分组追加新条目（如已存在 slug → 更新 last_synced 行不是追加）。

### Step 10: 维护反向引用

如果新 design.md 的 `references.uses_components` 列表非空，需要去每个被引用组件的 design.md 里把当前路径加到它们的 `used_by[]`。

```
新 X.md uses_components = [A, B]
→ A.md.used_by[] 追加 X 的路径
→ B.md.used_by[] 追加 X 的路径
```

如果被引用的 design.md 还不存在（典型：子组件还没录入），**跳过**，只在新文件的 frontmatter 留注释 `# 注：A 尚未录入 design.md，待后续`。

### Step 10.5: 回写 Relay sharedPluginData (v0.3 新加)

成功写完 design.md 后，把元数据回写到 Relay 节点。**namespace 固定 `jd-design-wiki`**。

通过 `use_design_script`：

```javascript
const node = await relay.getNodeByIdAsync('<NODE_ID>')
node.setSharedPluginData('jd-design-wiki', 'design_md_path', '<相对仓库根的 md 路径>')
node.setSharedPluginData('jd-design-wiki', 'last_synced', '<YYYY-MM-DD>')
node.setSharedPluginData('jd-design-wiki', 'slug', '<slug>')
node.setSharedPluginData('jd-design-wiki', 'level', '<level>')
node.setSharedPluginData('jd-design-wiki', 'bg', '<bg>')
return { keys: node.getSharedPluginDataKeys('jd-design-wiki') }
```

**写入失败 / Relay 离线 → 不阻断**：终端输出 `⚠️ Relay 回写失败，仅本地 INDEX.md 索引可用` 然后继续往下走。设计师后续手动跑 `bin/sync-index.sh --push-shared-data` 补回。

详见 [references/traceability.md](./references/traceability.md) 第 ③ 节。

### Step 11: 终端输出（给设计师）

完成后输出格式如下（中文，含 emoji，简短）：

```
✅ 已生成: {输出路径}
   ├─ level: {自动推断} {如走兜底 → 加 ⚠️}
   ├─ bg:    {自动推断} {同上}
   ├─ slug:  {自动推断} {同上}
   └─ {N} 处 <TODO: 设计师补充> 待填空

📎 已附 screenshot: {path}/preview.png  {或 ⚠️ 未导出}
📚 已更新 INDEX.md
🔗 双向追溯 OK: frontmatter.relay_source ↔ INDEX.md

{如有 token-miss / 半步间距 / 未录入子组件等}
⚠️ 检测到 {M} 个需要 review 的问题，详见 design.md 末尾 "本次自动同步发现的待办" 段
```

**TODO 计数 N 动态计算**：基础 5 处（一句话定义 / 应用场景 / 视觉预览 / 交互 / Donts / AI Schema 中无数据 placeholder）— 本次实际自动填上的（v0.4：page-doc 模式扫到 ≥1 条 dont_rule 时 Donts 自动填，N 减 1）。最少 4 处，最多 5 处。

---

## 关键约束

1. **不要问设计师任何问题**。所有字段自动推断，不确定就用兜底值 + TODO flag。
2. **不要编造 token**。反查不到就 flag ⚠️ token-miss，保留实际 hex 值。
3. **不要覆盖已存在的 design.md**。用 `.NEW` 后缀，让设计师 diff。
4. **不要把检测错的字段 silent 过**。Frontmatter `auto_detected` 字段显式记录"哪些是推断、哪些走了兜底"，让 review 时一眼可见。
5. **不依赖模型聪明度**。所有判断走 references 里的查找表 / 规则，模型只做 string substitution。
6. **5 处 TODO 模板**保留原样，不要尝试帮设计师填。

## References

| 文件 | 作用 |
|---|---|
| [templates/component.md](./templates/component.md) | 单 md 模板 (v0.1) — 普通组件 |
| [templates/page-doc/design.md](./templates/page-doc/design.md) | page-doc bundle index 模板 (v0.5)；v0.5.1 起 relay_source 单点存储于此，变更记录链到 CHANGELOG.md |
| [templates/page-doc/spec.md](./templates/page-doc/spec.md) | page-doc bundle 视觉规范模板 (v0.5)；v0.5.1 删 relay_source |
| [templates/page-doc/variants.md](./templates/page-doc/variants.md) | page-doc bundle 变体模板 (v0.5)；v0.5.1 删 relay_source |
| [templates/page-doc/behaviors.md](./templates/page-doc/behaviors.md) | page-doc bundle 行为模板 (v0.5)；v0.5.1 AI Schema 改为摘要 + 链接 |
| [templates/page-doc/ai-schema.yaml](./templates/page-doc/ai-schema.yaml) | page-doc bundle AI Schema 独立模板 (v0.5.1，issue #23) |
| [templates/page-doc/CHANGELOG.md](./templates/page-doc/CHANGELOG.md) | page-doc bundle 变更记录独立模板 (v0.5.1，issue #23) |
| [references/auto-detect-rules.md](./references/auto-detect-rules.md) | 推断 level / bg / slug / name_zh 的规则表（v0.2 加 slug 变体后缀） |
| [references/node-type-mapping.md](./references/node-type-mapping.md) | Relay 节点属性 → design.md section 对照 + 统一抽取脚本 |
| [references/token-reverse-lookup.md](./references/token-reverse-lookup.md) | hex / fontSize+weight / radius / spacing 反查 V16 token 算法（v0.2 加 rgba 容差） |
| [references/frontmatter-spec.md](./references/frontmatter-spec.md) | Frontmatter 字段定义 + 校验规则 |
| [references/traceability.md](./references/traceability.md) | INDEX.md 维护 + 反向引用维护 + （v0.3）Relay sharedPluginData |
| [references/bg-mapping.json](./references/bg-mapping.json) | file_id → bg 映射表（v0.1 仅 V16 master） |
| [references/variant-vocab.json](./references/variant-vocab.json) | VARIANT 中文值 → 英文 slug 片段映射（v0.2 加） |
| [references/preview-export.md](./references/preview-export.md) | preview.png 导出算法（v0.2 加） |
| [references/slug-pinyin-fallback.md](./references/slug-pinyin-fallback.md) | 节点名全中文时的 slug 词表（v0.3 加） |
| [references/checklist.md](./references/checklist.md) | 设计师提交 PR 前自检 10 条 |
| [bin/validate.sh](./bin/validate.sh) | 提交前自动校验（v0.2 加 / v0.3 加 cross-file） |
| [bin/sync-index.sh](./bin/sync-index.sh) | INDEX.md 自动重建（v0.3 加） |
| [examples/navbar-search-day/design.md](./examples/navbar-search-day/design.md) | 范例（搜索条日间 NavBar 实际跑出来的样本） |
| [references/text-pattern-rules.md](./references/text-pattern-rules.md) | text node 文本 5 类 bucket 分类规则（v0.4 加） |
| [INDEX.md](./INDEX.md) | 双向追溯索引（按 BG 分组） |

## 版本历史

- **v0.1** (2026-05-13) MVP：L1 通用组件 / 单 md / 仅 V16 master 文件 bg 推断 / 无 Relay sharedPluginData 回写
- **v0.1.1** (2026-05-13) 圆角抽取修复：
  - 统一抽取脚本 `all = [root, ...root.findAll()]`，root 自身被纳入遍历（原 `findAll` 不含 root）
  - 圆角支持 `relay.mixed`：抽取 4 个角的个体值（V15→V16 升级中可能出现 4 角不同的情况）
  - instances 过滤掉 root 自身（防止 root 是 INSTANCE 时被误算成"子组件引用"）
  - 影响范围：所有圆角在 root 节点上的组件（按钮 / 卡片 / 弹窗 / 容器类）现可正确抽到 radius
- **v0.2** (2026-05-13) 4 项升级：
  - **① slug 变体后缀**：用 `componentProperties` (VARIANT type) 自动 build 后缀；INDEX.md 冲突时数字后缀兜底；新建 `references/variant-vocab.json` 维护中→英映射
  - **② preview.png 自动导出**：`exportAsync({format:PNG, SCALE:2})` → base64 → Bash 写文件；新建 `references/preview-export.md`
  - **③ rgba 反查扩展**：rgba(R,G,B,opacity) 在 atom 里 ±2% 容差匹配；rgba-of-pure-color 启发式（white/black/jdred @opacity）→ 建议新 atom 名供设计组 review
  - **④ validate.sh 提交前校验**：扫所有 design.md，校验 frontmatter + 受控词表 + slug 格式 + relay URL + preview.png 存在 + TODO/⚠️ 残留；新建 `bin/validate.sh`
- **v0.3** (2026-05-13) 4 项升级：
  - **① Relay sharedPluginData 回写**：SKILL.md 新增 Step 10.5；写 5 个 key (`design_md_path`/`last_synced`/`slug`/`level`/`bg`) 到 Relay 节点的 namespace `jd-design-wiki`；设计师在 Relay 点节点可反查 md 路径；写失败不阻断
  - **② INDEX.md 全自动 sync**：新建 `bin/sync-index.sh` —— 扫所有 design.md 重建 INDEX；处理删除/移动/重命名/slug 冲突；支持 dry-run 和 --write；macOS bash 3.x 兼容
  - **③ slug 中文 fallback**：新建 `references/slug-pinyin-fallback.md` ~60 个 JD 设计常用词中→英映射；auto-detect S3 接入
  - **④ validate.sh cross-file 校验**：检查 `uses_components` 引用的子 design.md 是否存在、preview.png 非空、INDEX.md 是否含本 slug；新警告项
- **v0.4** (2026-05-13) page-doc 支持 — 兑现 issue #18 第一步：
  - **① page-doc 模式自动判定**：root.height > 5000 或 ≥3 个 FRAME 子项 ⇒ pageDocMode；抽取脚本返回 `chapters[]` 元数据
  - **② text node 5 类 bucket 分类**：chapter_title / figure_label / dont_rule / dimension_spec / description；新建 `references/text-pattern-rules.md`
  - **③ Donts 段自动收**：page-doc 模式下，扫到的禁止规则文本（"禁止*"/"不可*"/含 ❌）自动汇总到 `## Donts` 段，标注来源章节
  - **④ instance 加 size**：absoluteBoundingBox 抽 width/height，专治"灵动岛 131×44 DP"这类只在 instance 上的尺寸
  - **⑤ limit 全面提升**：textStyles 30→200，instances 30→150，layouts 20→50，text chars 80→200（page-doc 节点数据量大）
  - **⑥ 章节归属**：所有 text/instance/layout 加 `chapter` 字段（root.children 第 1 层），模板新增 `## 设计规范细节（按章节）` 段
- **v0.4.1** (2026-05-14) issue #20 follow-up — review 找到的 should-fix 集中收口：
  - **① chapterOf 修 root 边界 bug**：`if (n.id === root.id) return null` short-circuit（已在 PR #19 二次提交里修；本版加 rootChildIds Set 缓存优化性能）
  - **② pageDocMode 删冗余条件** `&& kids.length >= 3`（frameKids ⊆ kids，必然成立）
  - **③ text-pattern-rules.md 与 classifyText 1:1 对齐**：删英文 chapter 措辞、dimension_spec regex 加 `/`、章节聚合改为渲染层 group-by（抽取层只挂 `chapter` 字段）
  - **④ SKILL.md TODO 计数动态化**：原"5 处 TODO 待填空" → "{N} 处"，page-doc 模式 Donts 自动填时 N=4
  - **⑤ 模板加 `{{skill_version}}` / `{{todo_count}}` 占位符**：消除 `skill v0.1` 硬编码
  - **⑥ Radius token 改 T-shirt size**：tabbar design.md `Radius_6/8/12/16` (atom) → `radius_base/l/xl/xxl` (token)，与 V16 tokens.json `radius.*` 命名对齐
  - **⑦ frontmatter spacing list 类型规整**：`- TODO: xxx` (map) → `- "TODO: xxx"` (string)
  - **⑧ frontmatter 长行注释拆出独立块**：auto_detected.level 行内 100 字符注释 → 上方独立 # 块
- **v0.5** (2026-05-14) page-doc multi-md bundle —— 兑现 issue #18:
  - **① 新建 [templates/page-doc/](./templates/page-doc/) 4 模板**：design.md (index) / spec.md / variants.md / behaviors.md
  - **② Step 7 路径决策加 page-doc 分支**：同目录写 4 个文件，已存在 v0.1 单 md 时全 4 文件加 `.NEW` 后缀
  - **③ Step 8 模板分流**：`pageDocMode === true` 走 bundle 4 模板，否则走 v0.1 单 md。v0.4 单 md 内章节细分段保留作 fallback
  - **④ bundle 反向引用**：design.md frontmatter 加 `bundle: page-doc` + `bundle_files: [...]`；spec/variants/behaviors 三个子文件 frontmatter 加 `bundle_part_of: design.md` + 顶部导航条
  - **⑤ 回填重跑 tabbar**：540 行单 design.md 拆成 4 文件 bundle（PR 同时提交）
- **v0.5.1** (2026-05-18) issue #23 follow-up —— PR #22 review 找到的 bundle 优化集中收口：
  - **① AI Schema 拆独立 `ai-schema.yaml`**：原 behaviors.md 内嵌 108 行 yaml（机器可读 schema）和人类规范文字（应用场景 / 交互 / Donts / 多端适配）性质完全不同，拆为独立 `tabbar/ai-schema.yaml`；behaviors.md 改为一行摘要 + 链接；新建 [templates/page-doc/ai-schema.yaml](./templates/page-doc/ai-schema.yaml) 模板；bundle_files 清单加一项
  - **② 变更记录搬到独立 `CHANGELOG.md`**：design.md (index) 不该承担变更历史，原 8 行变更表移到 `tabbar/CHANGELOG.md`，design.md 只留指向链接；新建 [templates/page-doc/CHANGELOG.md](./templates/page-doc/CHANGELOG.md) 模板
  - **③ `relay_source` 单点存储到 design.md**：原 spec / variants / behaviors 三个子文件都重复 `relay_source: {node_id, url}`（一旦 url / file_id 变了要改 4 处）。改为只在 design.md 写完整 `relay_source` 整段，子文件 frontmatter 只保留 `bundle_part_of: design.md` 反向指针 + 一行注释说明
  - **④ tabbar bundle 同步回填**：tabbar/{design,spec,variants,behaviors}.md 按上面 3 项重组（新增 ai-schema.yaml + CHANGELOG.md，删 3 处 relay_source 重复，搬变更表）
- v0.6 (planned) 加 page.md / flow.md 模板 + batch 模式 + Diff 模式（只更新机器抽取段，保留人写段）
