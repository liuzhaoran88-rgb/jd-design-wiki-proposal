---
file: _assets-cdn
slug: {{slug}}
last_synced: "{{today_iso}}"
purpose: 维护 {{name_zh}} 依赖的位图切图 CDN 引用清单，让渲染产物不依赖本地 _assets/ 目录
{{bundle_part_of_line_or_empty}}---

# {{name_zh}} · 位图切图 CDN 清单

> 本组件用到的**切图**（IMAGE fill 位图资产）。token / 矢量都无法表达位图，必须由 CDN 托管。
> 由 `relay-to-design-md` skill 自动侦测登记（v0.5.2+），CDN URL 留空待设计师回填。

## 切图清单

| 用途 | Relay 节点 | 尺寸 | CDN URL | 状态 |
|---|---|---|---|---|
{{section_cutouts_table}}

## 待办

- [ ] 上表 `⏳ 待上传 CDN` 行：设计师从 Relay 桌面端选中节点 → Export PNG → 上传京东内部 CDN
- [ ] 回填「CDN URL」列，状态改 `✅ 已上传`
- [ ] 渲染产物（spec-page.html 等）引用本清单 URL，不引用本地 `_assets/` 路径

## 设计原则

- **不在本地仓库放位图**：所有切图通过 CDN URL 引用，仓库不存 PNG 二进制
- **每张切图都登记**：Relay 节点 ID + 用途 + 尺寸 + CDN URL + 状态
- **skill 侦测、人工上传**：skill 自动揪出 IMAGE fill 并登记 `⏳`，京东 CDN 上传由设计师 / 运维手动完成

## 关联

- 同目录：[design.md](./design.md)
- 侦测规则：`relay-to-design-md` skill 的 `references/cutout-detection.md`（v0.5.2 起切图自动登记）
