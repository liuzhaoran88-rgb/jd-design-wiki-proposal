# 双向追溯机制

> Relay ↔ DESIGN.md 互查规则。SKILL.md Step 9/10 调用本文件。

---

## 概览：3 条追溯链路

| 方向 | 入口 | 出口 | 机制 | v0.1 状态 |
|---|---|---|---|---|
| ① design.md → Relay | frontmatter `relay_source.url` | Relay 节点 | YAML 静态字段 | ✅ |
| ② Relay → design.md（仓库视角） | Relay 节点 file_id+node_id | wiki 中的 md 路径 | INDEX.md 索引 | ✅ |
| ③ Relay → design.md（Relay 视角） | Relay 节点 | md 路径 | sharedPluginData | ✅ v0.3 |
| ④ design.md ↔ design.md（组件层级） | `uses_components` ↔ `used_by` | 子/父 md 互查 | 双向 frontmatter | ✅ |

---

## ① design.md → Relay（已自动）

frontmatter `relay_source` 块：

```yaml
relay_source:
  file_id: "2029484645871009793"
  page_id: "47:1"
  node_id: "542:6495"
  url: "https://relay.jd.com/file/design?id=2029484645871009793&page_id=47%3A1&node_id=542%3A6495"
```

设计师 / 工程师 / AI 读到 design.md，点 `url` 直达 Relay。

URL 拼装规则：
```
https://relay.jd.com/file/design?id={file_id}&page_id={url-encoded page_id}&node_id={url-encoded node_id}
```

其中 page_id 和 node_id 里的 `:` → URL-encode 成 `%3A`。

---

## ② Relay → design.md (仓库视角) · 通过 INDEX.md

### INDEX.md 位置

`.claude/skills/relay-to-design-md/INDEX.md` —— **跟 skill 一起 ship**，offline 可查。

### INDEX.md 格式

```markdown
# Design Wiki Index

> 自动维护 — 不要手动编辑，会被 skill 覆盖。

## L1 通用组件 (horizontal)

| Slug | Path | Relay node | Owner | Last Synced |
|---|---|---|---|---|
| navbar-search-day | [horizontal/components-base/navbar-search-day/design.md](../../jd-design-system-md-v16/horizontal/components-base/navbar-search-day/design.md) | `2029...:542:6495` | @xushui2018 | 2026-05-13 |
| button | [horizontal/components-base/button/design.md](../../jd-design-system-md-v16/horizontal/components-base/button/design.md) | `2029...:33:5` | @TODO | 2026-05-13 |
| ... |

## L2 业务组件

### Retail BG
（v0.3+）

### Health BG
（v0.3+）

## L3 页面 (v0.4+)

## L4 流程 (v0.4+)
```

### INDEX.md 维护流程（Step 9）

```
1. 读现有 INDEX.md
2. 解析当前 BG + level 应该归到哪个 section
3. 该 slug 是否已存在？
   - 存在 → 更新 Last Synced 列 + 不重复添加行
   - 不存在 → 在对应 section 末尾追加新行
4. 写回 INDEX.md
5. 排序：按 slug 字典序（v0.2 可改成按 last_synced 倒序）
```

### Relay → design.md 反查（设计师怎么用）

```
设计师在 Relay 看到一个节点（如 542:6495）
↓
打开 INDEX.md（仓库根目录可见 / GitHub 网页可搜索）
↓
搜索 "542:6495"
↓
找到对应 md 路径
↓
打开 design.md 看完整文档
```

或者 grep：
```bash
grep -r '542:6495' .claude/skills/relay-to-design-md/INDEX.md
```

---

## ③ Relay → design.md (Relay 视角) · sharedPluginData ✅ v0.3

SKILL.md Step 10.5 在生成 design.md 成功后自动回写 5 个 key 到 Relay 节点。

**Namespace 锁定**：`jd-design-wiki`（与其他插件隔离）

**写入 keys**：

| Key | 值 | 用途 |
|---|---|---|
| `design_md_path` | `jd-design-system-md-v16/horizontal/components-base/button/design.md` | 设计师在 Relay 点节点 → 反查 md 路径 |
| `last_synced` | `2026-05-13` | 看节点是否需要重 sync |
| `slug` | `button` | 跨 wiki 引用辅助 |
| `level` | `component-base` | 业务方按 level 过滤节点 |
| `bg` | `horizontal` | 业务方按 BG 过滤节点 |

**写入算法**（use_design_script）：

```javascript
const node = await relay.getNodeByIdAsync(NODE_ID)
node.setSharedPluginData('jd-design-wiki', 'design_md_path', MD_PATH)
node.setSharedPluginData('jd-design-wiki', 'last_synced', TODAY_ISO)
node.setSharedPluginData('jd-design-wiki', 'slug', SLUG)
node.setSharedPluginData('jd-design-wiki', 'level', LEVEL)
node.setSharedPluginData('jd-design-wiki', 'bg', BG)
return { keys: node.getSharedPluginDataKeys('jd-design-wiki') }
```

**读取算法**（任何 Relay 插件可用）：

```javascript
const node = await relay.getNodeByIdAsync(NODE_ID)
const keys = node.getSharedPluginDataKeys('jd-design-wiki')
// → ['design_md_path', 'last_synced', 'slug', 'level', 'bg']
const path = node.getSharedPluginData('jd-design-wiki', 'design_md_path')
// → "jd-design-system-md-v16/horizontal/components-base/button/design.md"
```

**写入失败兜底**：
- Relay 离线 / 节点不存在 / 权限不足 → Step 10.5 报错，但**不阻断 skill 主流程**
- design.md 仍正常写入 + INDEX.md 仍正常更新
- 终端输出 `⚠️ Relay sharedPluginData 回写失败 (原因)，本地 INDEX.md 索引可用`
- 设计师可手动跑 `bin/sync-index.sh --push-shared-data` 一次性把所有遗漏节点的 sharedPluginData 补齐

**重置 / 清理**（如节点废弃时）：

```javascript
node.setSharedPluginData('jd-design-wiki', 'design_md_path', '')
// 空字符串视为删除（Relay Plugin API 行为）
```

> 注：sharedPluginData 与 Figma 同源概念。Namespace `jd-design-wiki` 是受控字符串（至少 3 字符，仅 `[a-zA-Z0-9_/.]`）。其他 wiki 维护者不要改 namespace，会破坏跨实例兼容。

---

## ④ design.md ↔ design.md (组件层级互查)

### 字段定义

- `references.uses_components`：本组件用到的 L1 子组件路径列表
- `used_by`：本组件被哪些更高层组件 / 页面引用

### 维护流程（SKILL.md Step 10）

新 design.md X.md 写完后：

```
for component_path in X.frontmatter.references.uses_components:
    if component_path is "TODO/...":
        skip  # 子组件还没录入，跳过
    else:
        # 读子组件 design.md
        sub_md = read(component_path)
        # 追加 X 的相对路径到 sub_md.frontmatter.used_by[]
        if X_path not in sub_md.used_by:
            sub_md.used_by.append(X_path)
            write(sub_md)
```

**关键**：only-append，不要从 used_by 里删条目（除非用户明确要求）。

### 同步问题

如果某个 design.md 被删了：
- v0.1：手动删（skill 不管）
- v0.2：加 `verify-index` 命令扫所有 used_by 引用，flag 死链

如果某个 design.md 改了 slug（mv 文件夹）：
- v0.1：手动更新引用方
- v0.2：加 `--rename old new` 模式

---

## 一致性校验（v0.2+）

写一个 `verify-traceability` 子命令，扫整个 wiki：

1. `relay_source.url` ↔ `file_id`/`page_id`/`node_id` 三个字段一致
2. 每个 design.md 在 INDEX.md 有对应条目
3. INDEX.md 里的 path 实际存在
4. 每个 `uses_components` 引用的目标存在且 `used_by` 包含本组件
5. （v0.3+）Relay sharedPluginData `design_md_path` 与实际 md 路径一致
