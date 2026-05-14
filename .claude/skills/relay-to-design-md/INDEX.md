# Design Wiki Index

> **自动维护 — 不要手动编辑，会被 `bin/sync-index.sh` 覆盖。**
>
> Relay ↔ design.md 双向追溯索引。给一个 Relay node_id，能反查到 wiki 中的 md 路径。
>
> 见 [references/traceability.md](./references/traceability.md) 了解维护机制。
>
> 上次 sync: 2026-05-14

---

## L1 通用组件 (horizontal · component-base)

| Slug | Path | Bundle | Relay node | Owner | Last Synced |
|---|---|---|---|---|---|
| button | [jd-design-system-md-v16/horizontal/components-base/button/design.md](../../../jd-design-system-md-v16/horizontal/components-base/button/design.md) | single | `2029484645871009793 / 33:5 / 608:1031` | @xushui2018 | 2026-05-13 |
| navbar-search-day | [.claude/skills/relay-to-design-md/examples/navbar-search-day/design.md](../../../.claude/skills/relay-to-design-md/examples/navbar-search-day/design.md) | single | `2029484645871009793 / 47:1 / 542:6495` | @xushuai133 | 2026-05-13 |
| tabbar | [jd-design-system-md-v16/horizontal/components-base/tabbar/design.md](../../../jd-design-system-md-v16/horizontal/components-base/tabbar/design.md) | **page-doc** (4 files) | `2029484645871009793 / 31:1 / 312:46893` | @xushui2018 | 2026-05-14 |

---

## L2 业务组件 (component-business)

_（空 — 待 v0.3+ 业务文件接入）_

---

## L3 页面 (page)

_（空 — v0.4+ 启用）_

---

## L4 流程 (flow)

_（空 — v0.4+ 启用）_

---

## 统计

- L1 通用组件：3 个
- L2 业务组件：0 个
- L3 页面：0 个
- L4 流程：0 个
- **总计**：3 个

---

## 使用方式

### 1. 从 Relay 反查 design.md

#### 仓库视角（offline 可用）

```bash
grep '542:6495' .claude/skills/relay-to-design-md/INDEX.md
```

#### Relay 视角（v0.3+，需 MCP 在线）

在 Relay 插件里点节点 → 读 `sharedPluginData('jd-design-wiki', 'design_md_path')`。

### 2. 从 design.md 反查 Relay

打开 design.md，frontmatter `relay_source.url` 字段。
