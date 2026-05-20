# 切图侦测（v0.5.2）

> SKILL.md Step 5.2 / 8.5 调用本文件。解决「skill 不知道哪里是切图、要不要上传 CDN」的问题（issue #54）。

---

## 1. 什么是切图（判据）

**切图 = 位图资产**：设计师手工绘制、token / 矢量都无法表达的栅格图形（卡通形象、彩色图标、实拍图、品牌插画等）。它必须以 PNG/JPG 形式由 CDN 托管，不能在代码里用 CSS 还原。

**自动判据**（[node-type-mapping.md](./node-type-mapping.md) 统一脚本 (g) 段已实现）：

> 一个节点的 `fills` 数组里若含 `type === 'IMAGE'` 且 `visible !== false` 的 fill —— 它就是切图。

抽取脚本返回 `imageNodes[]`，每条：

```typescript
{
  id: string,            // Relay 节点 ID
  name: string,          // 节点名 → 推断「用途」
  type: string,          // RECTANGLE / FRAME / ...
  size: { w, h } | null, // 来自 absoluteBoundingBox
  imageHash: string|null,// 同 hash = 同一张切图被多处复用
  scaleMode: string|null,// FILL / FIT / CROP / TILE
  chapter: {id,name}|null,// page-doc 模式下的章节归属
}
```

## 2. 去重

同一张切图常被多个节点复用（如一个图标出现在 5 个坑位）。**按 `imageHash` 去重** —— `imageHash` 相同的多条 `imageNodes` 合并成 1 个切图条目，「用途」取最具代表性的节点名，并在说明里标「N 处复用」。`imageHash` 为 `null` 时无法去重，逐条登记。

## 3. `_assets-cdn.md` 切图清单行格式

每个去重后的切图 = 清单表一行：

| 字段 | 取值 | 说明 |
|---|---|---|
| 用途 | 节点名清洗后的中文描述 | 如「Joy Agent 默认形态」「坑位图标 · home 选中态」 |
| Relay 节点 | `imageNodes[].id` | 多处复用取首个 + 标注 |
| 尺寸 | `{w}×{h} px` | 来自 `size`，缺失标 `待补` |
| CDN URL | **留空** | 设计师上传后回填 |
| 状态 | `⏳ 待上传 CDN` | 上传回填 URL 后由设计师改 `✅ 已上传` |

skill **只能自动填前 3 列 + 状态列**；CDN URL 必须留空待回填 —— 见 §6 边界。

## 4. 自动登记规则（Step 8.5，仅 `--confirm-outline`）

切图清单写进输出目录的 **`_assets-cdn.md`**（与 design.md 同目录）。

> **`_assets-cdn.md` 是辅助资产清单，不是第 7 个 bundle 文档**。下划线前缀标识它是 infra/manifest 性质，不计入 v0.5.1 封板的「6 文件 bundle」（封板针对的是增加 review 成本的正文文档）。普通组件 / page-doc bundle 只要侦测到切图都生成它。

**「存在则合并」规则**（同 CHANGELOG.md 思路，不覆写设计师已回填的 URL）：

- **不存在** → 套 [templates/_assets-cdn.md](../templates/_assets-cdn.md) 生成，所有切图行状态 `⏳ 待上传 CDN`
- **存在** → `Read` 原文件：
  - 已有行的 Relay 节点 ID 命中本次侦测 → **保留设计师已回填的 CDN URL / 状态**，只更新尺寸等机器字段
  - 本次新侦测到、原文件没有的 → 追加新行（状态 `⏳ 待上传 CDN`）
  - 原文件有、本次没侦测到的 → **保留**，不删（可能是 Relay 章节大图等手工登记项），仅终端提示「N 行未在本次节点出现，请人工确认是否过期」

## 5. outline 模式（Step 5.5）

未传 `--confirm-outline` 时**不写** `_assets-cdn.md`，但 outline 里要让设计师**提前看到**切图清单 —— 写进 `design-outline.md` 的 `## 切图清单（待上传 CDN）` 段，让设计师在确认大纲时就知道有哪些切图待处理。

## 6. 边界 —— skill 能做什么、不能做什么

| 能 | 不能 |
|---|---|
| 侦测 IMAGE fill 节点 | 自动上传到京东内部 CDN |
| 自动登记 `_assets-cdn.md`（⏳ 待上传） | 替设计师回填 CDN URL |
| 终端打 checklist 提醒 | 判断切图设计质量 / 是否该用切图 |

**京东内部 CDN 的上传动作无法自动化**，必须设计师 / 运维手动完成后回填 URL。skill 的职责是「主动揪出来 + 催」，不是「全自动上传」。

> 不做本地 PNG 自动导出（`exportAsync`）—— `_assets-cdn.md` 设计原则明确「不在本地仓库放位图」，自动导出会和该原则冲突。切图由设计师从 Relay 桌面端 export 后直传 CDN。

## 7. 终端 checklist 格式

`--confirm-outline` 模式末尾追加（侦测到切图时）：

```
🖼 检测到 {N} 处切图（IMAGE fill），需导出并上传 CDN：
   ├─ {用途1}  ({w}×{h})  节点 {id}   ⏳ 待上传
   ├─ {用途2}  ({w}×{h})  节点 {id}   ⏳ 待上传
   └─ ...
   已登记到 {slug}/_assets-cdn.md，请设计师 export → 上传京东 CDN → 回填 URL
```

outline 模式则并入 outline 终端提示的「风险项」计数。
