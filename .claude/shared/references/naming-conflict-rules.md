# Token Naming-conflict 检测规则(跨 skill 共享真相源)

> 14.x → 15.0 迁移最普遍的残留模式:同一 token 概念在 variables 表里以 ≥2 个命名变体(kebab / snake / Camel / 中英混用)同时存在,且**值已漂移**。让 AI / 设计师选取时随机命中,是设计漂移最隐蔽的源头,占典型走查 30%+ 的违规来源。
>
> 本文件统一定义 fingerprint 算法 + 已知冲突表 + 两类消费方(design-review 检测违规、relay-to-design-md 防止上游写出冲突 token)契约。

---

## Fingerprint 算法

把任意 variable name 正规化成 fingerprint:

1. 取**最后一段**(`/` 后的部分,丢掉命名空间前缀,如丢掉 `色彩变量 Color/`)
2. `lowercase`
3. 删除所有 `-` 和 `_`(命名风格统一抹平)

```
color_text_help            → colortexthelp
color-text-help            → colortexthelp
色彩变量 Color/color-border → colorborder
平台色板/Spacing-8          → spacing8
元素布局/Spacing_4          → spacing4
元素布局/spacing-4          → spacing4
```

## 触发判定

按 fingerprint 分组,组内成员数 ≥ 2 时:

| 同组 `$value` 关系 | 判定 | 级别 |
|---|---|---|
| 不同 | **❌ Naming-conflict**(违规) | 严重 — 必须删一份 |
| 全相同,命名风格混用(snake vs kebab vs Camel) | **⚠️ Naming-style**(警告) | 轻 — 建议统一,不阻塞 |
| 全相同,命名风格一致 | 不报 | — |

---

## 已知冲突表(V15 实战发现)

> 对照 15.0 spec file `1896756863949619202` 中 node `513:25300` vs `4061:7288` 的 variables 数据漂移:

| fingerprint | snake_case 值 | kebab-case 值 | 漂移内容 | 建议保留 |
|---|---|---|---|---|
| `colorborder` | `#00000014`(透明 8%) | `#0000000f`(透明 6%) | 透明度 8% vs 6% | snake(`color_border`) |
| `colortexthelp` | `#828794` | `#888b94` | ~3 个色阶 | snake(`color_text_help`) |
| `colorbackgroundsunken` | `#f5f6fa` | `#f7f8fc` | 接近但不同 | snake(`color_background_sunken`) |

**保留策略**:优先 `snake_case + 色彩变量 Color/...` 命名空间的版本(与 V15 tokens.json 白名单值一致)。两版都不在该命名空间(如全是 `品牌色/Brand-x`)→ 先按命名空间合规挑,再按 snake_case 挑。

### V15 / V16 适用性

- 上表已知冲突源于 V15 实战,V16 启用后命名空间可能改变,部分冲突可能消失或新冲突出现
- Fingerprint **算法本身** V15 / V16 通用 — 任何 design system 都怕同概念双轨
- 跑 V16 撞已知冲突 → 仍按 ❌ 报,但报告里加注"V15 已知冲突,V16 是否已修请 follow-up 核";撞**新**冲突 → 单独报 + 开 follow-up issue,新冲突 fingerprint 由人评估后加进上表

### V15 → V16 atom 层延续追踪(2026-05-18 tabbar 首跑发现)

V15 已知 role 层冲突有可能以 atom 层"hex 漂移"形式延续到 V16,**外观是 Value-drift 不是 Naming-conflict**,但本质同源。**fingerprint 检查跑在 role 名上扫不到**——atom 层只有 dot path,不参与 fingerprint。已知延续:

| V15 role 层 fingerprint | V16 atom 层延续点 | 漂移 |
|---|---|---|
| `colorbackgroundsunken`(`#f5f6fa` vs `#f7f8fc`) | `atom.gray.6.light = #F5F6FA` 在 V16 已 canon,但部分 V16 design.md(如 tabbar/spec.md 注释)仍标 `#f0f2f7` | `#F5F6FA` vs `#f0f2f7` 一色阶差 |
| `colortexthelp`(`#828794` vs `#888b94`) | `atom.gray.3.light = #828794`(V16 canon) | (待 V16 实战验证是否仍有漂移点) |
| `colorborder`(`#00000014` vs `#0000000f`) | (待 V16 实战验证) | — |

**消费方处理**:
- design-review 跑到 V16 design.md 撞 atom 层延续 hex → 报 ⚠️ Value-drift + 加注"V15 已知 fingerprint X 延续,详 shared/references/naming-conflict-rules.md V15→V16 段"
- relay-to-design-md 反查 atom 层 token 时若实际值与 V16 tokens.json 不一致 → frontmatter 加 ⚠️ + 同上注释

V16 实战发现新的延续 → 加进上表 + 加新 follow-up issue(由 V16 设计组判断 atom canon 值)。

---

## 消费方契约

### 消费方 1:`design-review`(Relay 模式 Step 3 前置规则)

走任何颜色 / 字体 / 圆角白名单匹配**之前**,先对 `get_variables(nodeId)` 返回的 variables 表跑一次 fingerprint 唯一性检查。

- 检测命中 → 报告 ❌ Naming-conflict 段顶部,优先于 Off-token / Legacy 输出
- 该 fingerprint 组内其他错误(Off-token / Legacy)**仍要标**,但归并到同一组建议下
- 报告每条违规给出**保留哪个 / 删除哪个**

### 消费方 2:`relay-to-design-md`(Step 5 token 反查后)

Token 反查完拿到 `references.uses_tokens.{colors, typography, ...}` 列表时,对每条 token 名计算 fingerprint:

- **撞已知冲突表** → frontmatter 该 token 后加 `# ⚠️ naming-conflict: 与 {对端变体} 同 fingerprint,值漂移,详 shared/references/naming-conflict-rules.md`,终端 warn 设计师慎用
- **未撞已知** + 反查返回 ≥2 个 fingerprint 一致候选且 `$value` 不同 → 同上,但报告"**新**未登记冲突",开 follow-up issue 把新 fingerprint 加进上表
- **未撞** → 不报,照常写

这样上游(relay→md)就**不会**把已知冲突 token 名静悄悄写进 frontmatter 让设计师无感踩坑。

---

## 变更规则

新增 / 删除 / 修复已知冲突 → 必须同步:
1. 本文件已知冲突表
2. `design-review/SKILL.md` Step 3 前置规则(已引用本文件,通常不需要再改)
3. `design-review/references/tokens-snapshot.md` 第 0 节(已引用本文件)
4. `relay-to-design-md/SKILL.md` Step 5 Naming-conflict 检测子节(已引用本文件)

**禁止**:在单 skill 里改 fingerprint 算法 / 已知冲突表而不更本表。
