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

## v0.1 范围

- ✅ L1 通用组件（component-base）
- ⏳ L2/L3/L4（component-business / page / flow）→ v0.3+
- ✅ 单一 design.md（不拆 multi-md bundle）→ multi-md bundle 留 v0.4+

如果检测到 level ≠ component-base，**仍然写文件**，但 frontmatter `auto_detected.level` 标 ⚠️，并在终端输出"非 L1 节点，结果可能不准，请 review"。

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

如果路径已存在 `design.md`，**不要覆盖**：改名为 `design.md.NEW`，让设计师手动 diff。终端输出："⚠️ {path}/design.md 已存在，新版本写入 design.md.NEW，请 diff 后合并。"

### Step 8: 套模板生成 design.md

读 [templates/component.md](./templates/component.md)，把模板里的 `{{...}}` 占位符替换成 Step 2-5 的实际数据。**严禁**：
- 任何 frontmatter 字段编造（缺数据 → 标 TODO）
- 任何 token 名编造（没反查到 → 标 ⚠️ token-miss）
- 任何视觉数据虚构（必须来自 Step 4 实际抽取）

frontmatter 必填字段见 [references/frontmatter-spec.md](./references/frontmatter-spec.md)。

5 处 TODO placeholder（设计师手填）：
- `## 一句话定义` 段
- `## 应用场景` 段 ✅/❌
- `## 交互` 段
- `## Donts` 段
- `## AI Schema` 段

其他全自动填。

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
   └─ 5 处 <TODO: 设计师补充> 待填空

📎 已附 screenshot: {path}/preview.png  {或 ⚠️ 未导出}
📚 已更新 INDEX.md
🔗 双向追溯 OK: frontmatter.relay_source ↔ INDEX.md

{如有 token-miss / 半步间距 / 未录入子组件等}
⚠️ 检测到 {N} 个需要 review 的问题，详见 design.md 末尾 "本次自动同步发现的待办" 段
```

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
| [templates/component.md](./templates/component.md) | 唯一模板 (v0.1) |
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
- v0.4 (planned) 加 page.md / flow.md 模板 + batch 模式 + 多 md bundle 拆分 (visual.md / interaction.md / donts.md)
- v0.5 (planned) Diff 模式：只更新机器抽取段，保留人写段
