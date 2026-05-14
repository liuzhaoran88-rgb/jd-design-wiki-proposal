# CSS variable ↔ V16 tokens 映射

> SKILL.md Step 6 调用。模板 `<style>` 头部 `:root { --c-text: ... }` 等变量直接读 V16 tokens.json 的 hex 值，不要硬编码。

---

## CSS variable → V16 token 映射

| CSS variable | V16 token | V16 hex（写入模板时填这个值） |
|---|---|---|
| `--c-text` | `color_title` | `#171a26` |
| `--c-text-2` | `color_text` | `#3d414d` |
| `--c-text-3` | `color_text_help` | `#828794` |
| `--c-line` | `color_border` | `#00000014` |
| `--c-bg` | `white` | `#ffffff` |
| `--c-bg-sunken` | `color_background_component` | `#f5f6fa` |
| `--c-brand` | `color_primary` | `#ff0f23` |
| `--c-success` | （V16 待出 success token，暂用） | `#2aa32a` |
| `--c-success-bg` | （V16 待出） | `#ebfbeb` |
| `--c-danger` | `color_primary` | `#ff0f23` |
| `--c-danger-bg` | （V16 待出） | `#fff0f4` |
| `--c-warning` | `color_service_text` | `#b26b00`（V16 wiki 待对齐） |
| `--c-warning-bg` | （V16 待出） | `#fff9e0` |
| `--c-info` | （V16 待出） | `#0073ff` |
| `--c-info-bg` | （V16 待出） | `#e5f5ff` |
| `--c-mask` | （V16 mask 系列） | `rgba(0, 0, 0, 0.7)` |
| `--c-code-bg` | `color_background_component` | `#f5f6fa` |
| `--r-base` | `radius_base` | `6px` |
| `--r-detail` | `radius_l` | `8px`（v0.4.1 atom: Radius_8） |
| `--r-xl` | `radius_xl` | `12px` |
| `--r-xxl` | `radius_xxl` | `16px` |

> ⚠️ V16 暂无完整的语义化反馈色（success / warning / danger / info）token 体系，本 skill 暂用 jd-toast-spec(1).html v0.1 的硬编码值。待 V16 出 [foundations/tokens/feedback-color.md](../../../jd-design-system-md-v16/foundations/tokens/) 后回填。

---

## 字体 stack

模板继承 jd-toast-spec(1).html 字体 stack：

```css
font-family: "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", system-ui, sans-serif;
font-size: 15px;
line-height: 1.7;
```

代码块字体：

```css
font-family: "JetBrains Mono", "SF Mono", Menlo, Consolas, monospace;
font-size: 13px;
```

不要换字体 stack，对外发布物字体一致性比字体表达力更重要。

---

## h2 编号 chip 配色

`<h2><span class="num">N</span>` 数字 chip 默认 `--c-brand` 红底白字。如果未来要按章节分色，规则：

| 章节 | chip 颜色 |
|---|---|
| 1. 定义 | `--c-brand` |
| 2. 行为准则 | `--c-brand` |
| 3. 类型 | `--c-info` |
| 4. 结构 | `--c-text` |
| 5. 布局 | `--c-text` |
| 6. 正反案例 | `--c-warning` |
| 7. 典型场景 | `--c-success` |

v0.1 暂全部 `--c-brand`（与 jd-toast-spec 一致）。

---

## blockquote 三态

```css
blockquote                  /* 默认 info 蓝 */
blockquote.warn             /* warning 橙 */
blockquote.danger           /* danger 红，含 ❌ / 不允许 / 禁止 类规则 */
```

映射规则：
- 引用 Foundation 文档 → 默认 `blockquote`（info 蓝）
- `⚠️ TBD` / 缺失数据提示 → `blockquote.warn`
- 含"不允许 / 不引入 / 禁止 / 不要" 强约束 → `blockquote.danger`
