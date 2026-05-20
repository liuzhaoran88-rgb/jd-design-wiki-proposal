---
file: _assets-cdn
slug: tabbar
last_synced: "2026-05-19"
purpose: 维护 tabbar 组件依赖的位图(atom 切图 + Relay 章节大图)CDN 引用清单,让 spec-page.html 不依赖本地 _assets/ 目录
---

# Tabbar 位图 CDN 清单

> 本组件渲染依赖的所有位图资产(5 张 atom 切图 + 9 张 Relay 章节大图,共 14 张)。
>
> **当前 CDN**:[jsdelivr](https://www.jsdelivr.com)(GitHub mirror,免费、全球加速)
> **长期 TODO**:迁京东内部 CDN(由设计师 / 运维上传后替换下面所有 URL,本文件 + spec-page.html 同步更新)

## 设计原则

- **不在本地仓库放位图**:`_assets/` 目录最终应当删除,所有位图通过 CDN URL 引用
- **每张位图都登记**:在本清单列 Relay 节点 ID + 用途 + 当前 CDN URL + 长期 CDN URL(TBD)
- **URL 锁版本**:全部用 commit SHA 锁定 — atom = `aac981a` / sec-* = `79bc741`。这样无论 main 怎么动 / 本地 `_assets/` 是否删除,jsdelivr 都能从 git blob 历史 mirror 这些 PNG。

## Atom 切图

> Joy Agent atom 来源:Relay `312:58236`(完整版 atom)和 `312:58243`(父 frame 含招手气泡)。
> 坑位图标:Relay 章节 02 各坑位用 home / cart / msg 等图标,目前先给一个 home 示例。
> **默认态**与**选中态**是两张独立资产 —— 默认态走 CSS `mask` 染色(单色描边图),选中态用设计师专门切图(已含 `jdred` 填充 + 笑脸细节,非染色)。

| 用途 | Relay 节点 | 尺寸 | CDN URL | 说明 |
|---|---|---|---|---|
| Joy Agent 默认形态 | `312:58236` | 64×64 px / 8 KB | <https://img13.360buyimg.com/img/jfs/t1/434027/27/16417/14829/6a0c6236F67e0986e/027609c09c2c80cd.png> | ✅ **京东正式 CDN** |
| Joy Agent + 招手气泡 | `312:58243` | 待上传 | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@aac981a/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/atoms/joy-agent-bubble.png> | ⏳ jsdelivr 临时,待京东 CDN |
| 坑位图标 · home 默认态(示例) | 章节 02 各坑位 | 60×57 px / 1.5 KB RGBA | <https://img11.360buyimg.com/img/jfs/t1/435818/38/8886/1500/6a0c64ceFf9186b68/027603c0398a7c74.png> | ✅ **京东正式 CDN** · 默认态,用 CSS `mask` 染 `gray_1` |
| 坑位图标 · home 选中态(示例) | 章节 02 选中坑位 · 节点待补 | 60×60 px / 1 KB RGBA | <https://img14.360buyimg.com/img/jfs/t1/435193/37/14737/1001/6a0d284cF8944e60e/027603c03c327d14.png> | ✅ **京东正式 CDN** · 选中态专用彩色切图(`jdred` + 笑脸),直接 `background-image`,不染色 |
| 坑位营销态示例图 | 章节 02 营销态 · 节点待补 | 114×114 px RGBA | <https://img11.360buyimg.com/img/jfs/t1/437910/36/498/25382/6a0d4838Fd985a38b/0276072072721e5e.png> | ✅ **京东正式 CDN** · 营销态 38×38 圆形图占位示例;设计「仅可替换图片」,实际由业务投放图替换 |

## Relay 章节大图

> 由设计师手工从 Relay 桌面端 export(SCALE 1:1 PNG)上传到 `_assets/`。这 9 张是组件规范的「Relay 原稿对照」,展示真实视觉作为 ground truth。
> 节点 ID 不全对应章节根(部分是章节内某个子 frame),以 sec-N 编号为准。

| 文件 | 章节 | Relay 节点 | 大小 | CDN URL(当前) |
|---|---|---|---|---|
| sec-1-principles.png | 01 设计原则 | `312:46895` 周边 | 78 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-1-principles.png> |
| sec-2-regular-layout.png | 02.1 常规底导布局 | `312:46904` | 179 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-2-regular-layout.png> |
| sec-2-agent-layout.png | 02.2 Agent+底导布局 | `312:47132` | 191 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-2-agent-layout.png> |
| sec-2-states-badges.png | 02.4-02.5 状态+招手 | `312:47337` 周边 | 202 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-2-states-badges.png> |
| sec-2-joy-agent.png | 02.6 Joy Agent | `312:47431` | 108 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-2-joy-agent.png> |
| sec-3-island-regular.png | 03.1 常规灵动岛 | `312:47480` 周边 | 228 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-3-island-regular.png> |
| sec-3-island-operation.png | 03.2 运营灵动岛 | `312:47617` 周边 | 215 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-3-island-operation.png> |
| sec-3-island-promo.png | 03.3 大促灵动岛 | `312:47747` 周边 | 246 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-3-island-promo.png> |
| sec-5-multi-platform.png | 05 多端适配 | `312:52986` | 619 KB | <https://cdn.jsdelivr.net/gh/ShuaiMXu/jd-design-wiki-proposal@79bc741/jd-design-system-md-v16/horizontal/components-base/tabbar/_assets/sec-5-multi-platform.png> |

## 迁移到京东 CDN 的 TODO

- [ ] 14 张位图上传京东内部 CDN(由设计师 / 运维操作)
- [ ] 替换上表「CDN URL(当前)」为正式 CDN URL
- [ ] 删除本仓库 `_assets/` 目录(2.0 MB,迁完后无需保留)
- [ ] 更新 spec-page.html 引用为正式 CDN URL
- [ ] 在本文件加一列「CDN URL(正式)」记录迁移结果

## 为什么不在本地仓库放位图

1. **仓库轻量**:2.0 MB 位图占用 git 历史,clone 慢
2. **CDN 加速**:jsdelivr / 京东 CDN 都比 GitHub raw 更快(全球节点)
3. **生产一致**:spec-page.html 在 GitHub Pages / 京东 docs 都用同一份 CDN URL
4. **版本控制**:URL 锁 commit SHA 或正式 CDN 版本号,设计稿更新时可控替换

## 关联

- 同 bundle:[design.md](./design.md) / [design-outline.md](./design-outline.md) / [spec-page.html](./spec-page.html)
- spec-page.html 使用本清单的 URL,不引用本地 `_assets/` 路径
