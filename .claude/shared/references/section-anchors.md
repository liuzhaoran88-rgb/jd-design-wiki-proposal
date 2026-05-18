# 7 章节 canonical anchors(跨 skill 共享真相源)

> 总站(`docs/design.html`)与单组件详情页(`{component}/spec-page.html`)的章节 **anchor slug 必须一致**,这样总站卡片摘要里的章节链接能 deep-link 到详情页对应章节。**章节渲染范式可以差异化**(总站简化、详情页完整),但 slug 不许漂。

## Canonical 章节表

| # | 章节名(中) | anchor `id` | 总站(design-md-to-site) | 详情页(design-md-to-spec-page) |
|---|---|---|---|---|
| 1 | 定义 | `sec-1` | ✅ 必渲染 | ✅ 必渲染 |
| 2 | 行为准则 | `sec-2` | ⚪ 可选(无内容跳过) | ✅ 必渲染 |
| 3 | 类型 | `sec-3` | ⚪ 可选 | ✅ 必渲染 |
| 4 | 结构 | `sec-4` | ✅ 必渲染 | ✅ 必渲染 |
| 5 | 布局 | `sec-5` | ⚪ 可选(总站习惯并入"结构") | ✅ 必渲染 |
| 6 | 正反案例 | `sec-6` | ⚪ 可选 | ✅ 必渲染(含错误示例) |
| 7 | 典型场景 | `sec-7` | ✅ 必渲染 | ✅ 必渲染 |

## anchor 规则

- 章节 anchor 统一用 `sec-{N}`(对齐 jd-toast-spec(1).html / 现行 spec-page.html 模板第 482-500 行)
- HTML 形如:
  ```html
  <h2 id="sec-4"><span class="num">4</span>结构</h2>
  ```
- 跨页 deep-link 用 `{component}/spec-page.html#sec-4` —— **不引入语义化辅 anchor**(否则两套 slug 维护成本翻倍,且现行模板都没用)

## 总站 vs 详情页范式差异(允许)

| 维度 | 总站 | 详情页 |
|---|---|---|
| 渲染深度 | 摘要 + 图卡 + 1-2 行文字 | 完整章节(原子表 / stage / 正反案例 grid / 7 章节固定) |
| 缺失章节 | 整段省略 | 保留 `<h2>` + TBD blockquote(7 章节是契约) |
| 章节顺序 | 可按内容密度跳序 | 严格 1→7 |
| 错误示例 | 通常合并到"正反案例" 或单列 | 必须在 "6. 正反案例" 内 |

## 各 skill 消费方式

| skill | 消费方式 |
|---|---|
| design-md-to-site | Step 3 渲染卡片章节按本表 anchor slug,缺失章节整段省略 |
| design-md-to-spec-page | Step 3 详情页 7 章节固定输出,引用 `design-md-to-spec-page/references/section-mapping.md` 拿 design.md / bundle → 7 章节的字段映射 |

## 变更规则

修改本表 → 必须同步:
1. 本文件章节表
2. `design-md-to-spec-page/references/section-mapping.md`(详情页详细字段映射)
3. `design-md-to-site/references/site-template.html`(总站 SPEC_SECTION 模板里的 `id=`)
4. `design-md-to-spec-page/templates/spec-page.html`(详情页模板里的 `id=`)

**禁止**:在单 skill 里改 anchor slug 而不更本表。
