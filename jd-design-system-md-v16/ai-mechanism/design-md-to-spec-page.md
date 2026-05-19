---
zone: ai-mechanism
file: design-md-to-spec-page-skill
last_updated: 2026-05-18
status: released
version: v0.5
skill_path: .claude/skills/design-md-to-spec-page/
---

# 📐 /design-md-to-spec-page · 单组件规范详情页

> 把**单个组件**的 `design.md`(或 6 文件 page-doc bundle)渲染成一份对外公开、可展示的 **7 章节单页 HTML 规范**,输出到 `<bundle-dir>/spec-page.html`。结构对齐 `jd-toast-spec(1).html` 范式。

本文档是 wiki 视角的索引页。**Skill 实现**在 `.claude/skills/design-md-to-spec-page/`,具体执行流程(11 步)见 [SKILL.md](../../.claude/skills/design-md-to-spec-page/SKILL.md)。

---

## 1. 它是什么

V16 体系下"发布面"的两个 skill 之一(另一个是 `design-md-to-portal`)。负责**单 design.md / bundle → 单 HTML 详情页**:

- 读 design.md 单文件 OR 6 文件 bundle(`design + spec + variants + behaviors + ai-schema.yaml + CHANGELOG.md`)
- 全文 + frontmatter 解析,按 [references/section-mapping.md](../../.claude/skills/design-md-to-spec-page/references/section-mapping.md) 把字段塞进 **7 章节**:
  1. 定义
  2. 行为准则
  3. 类型 / 形态
  4. 结构
  5. 布局
  6. 正反案例
  7. 典型场景
- **Pro / Basic 双视图切换**(v0.3):Basic 入门暖场版,Pro 完整规范版
- **切图能力**(v0.2):chunked b64 export + sharedPluginData 中转 + jq 解 dump file → `_assets/sec-N-*.png`
- **v0.5 增量启发**:默认跳过切图重导(`_assets/*.png` 最旧 mtime vs `frontmatter.last_synced`),3-5min → <10s
- **版本标签护栏**:V16 目录生成页头 / meta / 临时演示页时必须显示 `JD APP 16.0` / `V16.0`,不得继承旧 V15 示例页的 `JD APP 15.0` 文案。

---

## 2. 何时触发

| 场景 | 调用 |
|---|---|
| 用户调 `/design-md-to-spec-page <slug>` | 直接走 |
| 用户说"为 X 生成 spec 页"/"用 design.md 出一份 HTML 规范"/"按 jd-toast-spec 7 点重做 X" | 主动调 |
| 单份 design.md 内容更新 → 同步刷 spec-page | 主动调(默认走增量) |

## 3. 不适用场景

| 场景 | 该走哪里 |
|---|---|
| 全仓库 design.md 聚合成总站 | `design-md-to-portal` |
| 从 Relay 抽稿生成新 design.md | `relay-to-design-md` |
| 审稿 design.md 是否合规 | `design-review` |

---

## 4. 输入 / 输出

| | |
|---|---|
| 输入(3 种形态) | `<slug>`(自动找路径)/ bundle 目录 / 单 design.md 文件 |
| 输入(读多深) | 全文 + frontmatter 深层结构(`uses_tokens`, `references` 等) |
| MCP | `zero-design`(切图阶段) |
| 输出 | `<bundle-dir>/spec-page.html` + `<bundle-dir>/_assets/sec-N-*.png` |
| 部署 | 默认自动 `git add + commit + push`(GitHub Pages auto-rebuild ~30s),`--no-deploy` 关闭 |

---

## 5. v0.5 CLI flag

| flag | 默认 | 行为 |
|---|---|---|
| `--refresh-assets` | 关 | 强制走 Step 5b 完整切图重导(Relay 节点 / 切图源动了 → 必加) |
| `--no-refresh-assets` | — | 强制跳过 Step 5b(debug / source 切图实验时用) |
| `--dry-run` | 关 | Step 4 渲染后只 diff 不写文件,跳过 Step 9 部署 |
| `--no-deploy` | 关 | 渲染完不自动 git push(v0.4 加) |

**默认行为**(无 flag):走 Step 5a 增量启发,根据 mtime + `frontmatter.last_synced` 自动决定是否跳切图重导。80% 场景(只改 md 文字、Relay 没动)秒级 re-render。

---

## 6. 当前版本(v0.5)的关键决定

- **增量启发跳切图**(本期主菜):比对 `_assets/*.png` 最旧 mtime vs `design.md frontmatter.last_synced`。若 `last_synced` 缺失/解析失败,自动回退到 source md/yaml 最新 mtime。3 个 flag 提供逃生门。
- **跨平台 mtime / date**:`_mtime()` helper 同时兼容 macOS BSD `stat -f %m` 与 Linux GNU `stat -c %Y`;`_iso_to_ts()` 同时兼容 BSD `date -j -f` 与 GNU `date -d`。**不要**用 `find -printf`(GNU-only)。
- **Pro / Basic 双视图**(v0.3 起):CSS class 控制 + JS + localStorage 记住偏好;Basic 不出现 token 名,Pro 完整精度。
- **切图融合**(v0.4):`.stage--image` class 自动 margin -48px 跨出 doc padding 显示 1024 宽。

---

## 7. 与其他 skill 协作

```
单 design.md / bundle  ──/design-md-to-spec-page──▶  <slug>/spec-page.html  ──▶  GitHub Pages
                                  │                          │
                                  │                          │ (规划)
                                  │                          │  ⬅ portal footer 反向链
                                  │                          ▼
                                  │                    docs/design.html
                                  │                    (portal section card)
                                  │
                                  └──(被消费)── /design-md-to-portal (规划)
                                                探测同目录有无 spec-page.html
                                                有 → card 上加"📐 查看完整规范页"链接
```

**与 `design-md-to-portal` 不合并的理由**:
- 输出 scope 不同(单组件 N 份 vs 总站 1 份)
- 读取深度不同(全文 + 7 章节 vs 只 frontmatter)
- 触发节奏不同(单组件改 vs 加新组件)
- 详见 [[design-md-to-portal.md]] 第 6 节比较表

---

## 8. 实战产物

### Tabbar(2026-05-15)
- 入口:[tabbar/spec-page.html](../horizontal/components-base/tabbar/spec-page.html)
- 公网:https://shuaimxu.github.io/jd-design-wiki-proposal/jd-design-system-md-v16/horizontal/components-base/tabbar/spec-page.html
- 5 章节 Relay 章节结构 + 12 张切图 + Pro/Basic 双视图

### Foundation 总览(2026-05-15)
- 入口:[foundations/spec-page.html](../foundations/spec-page.html)
- 8 章节 = 8 token 类别;34 色块 + 26 字样 + 7 radius + 间距 bar + 材质卡

---

## 9. 演进路线

| 阶段 | 状态 |
|---|---|
| v0.1 7 章节 HTML 单文件渲染 | ✅ 已上线 |
| v0.2 切图能力(chunked b64 + sharedPluginData + dump-file readback) | ✅ 已上线 |
| v0.3 Pro / Basic 视图切换 + localStorage | ✅ 已上线 |
| v0.3.1 GitHub Pages 部署坑文档 | ✅ 已上线 |
| v0.4 Step 9 部署自动化 + cache-bust + 切图融合 + Basic 段 5 pattern | ✅ 已上线 |
| **v0.5**(本) 增量启发跳切图 + 3 flag + 跨平台 helper | ✅ **2026-05-18 已上线** |
| v0.6 批量模式(一次跑多组件)+ TOC 自动嵌套 + 切图节点自动选择 | 🔜 P2 |

---

## 10. 相关链接

- [SKILL.md](../../.claude/skills/design-md-to-spec-page/SKILL.md) —— 完整执行流程(11 步)
- [references/section-mapping.md](../../.claude/skills/design-md-to-spec-page/references/section-mapping.md) —— design.md 字段 → 7 章节映射
- [references/stage-images-export.md](../../.claude/skills/design-md-to-spec-page/references/stage-images-export.md) —— 切图导出 4 步流程
- [references/style-tokens.md](../../.claude/skills/design-md-to-spec-page/references/style-tokens.md) —— V16 token → CSS 变量映射
- [references/view-toggle.md](../../.claude/skills/design-md-to-spec-page/references/view-toggle.md) —— Pro/Basic 视图 5 pattern
- [references/deploy-notes.md](../../.claude/skills/design-md-to-spec-page/references/deploy-notes.md) —— GitHub Pages 部署坑
- [templates/spec-page.html](../../.claude/skills/design-md-to-spec-page/templates/spec-page.html) —— HTML 骨架模板
