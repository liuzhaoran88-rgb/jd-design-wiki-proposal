---
name: design-review
description: Audit a JD APP design from Relay (V15.0 or V16.0) against the design system wiki (color / typography / radius / spacing / motion / icon / layout tokens). Triggered by relay.jd.com URLs or node IDs together with verbs like "审核", "走查", "review", "audit", "检查规范", "符合 15.0 吗", "符合 16.0 吗". Routes to V15 or V16 token snapshot by source fileKey. Outputs a structured pass/warn/violate report with citations back to wiki rules.
---

# /design-review · JD V15.0 / V16.0 设计稿合规走查

把 Relay 节点的设计稿与 `jd-design-wiki-proposal` 仓库的 token 体系做交叉校验,**根据源 fileKey 自动选 V15 还是 V16 真相源**,输出可读 + 可复核的合规报告。

---

## 何时触发

用户给出一个 Relay 设计链接或节点 ID,并要求:
- "审核 / 走查 / review / audit 这个设计稿"
- "符合 15.0 设计规范吗" / "符合 16.0 吗"
- "检查一下用了哪些 token"
- "这个 token 用对了吗"

如果用户只是问"这个设计长啥样",**不要**触发本 skill —— 那是单纯的 `get_design_context` 用法。

## 不适用场景

- 非 JD 内部 Relay 文件(仅覆盖 V15.0 + V16.0 wiki)
- 用户要求**生成**新设计(那是 design-on-zero 的工作)
- 设计稿是 Figma 而非 Relay(zero-design MCP 只接 Relay)

---

## 输入解析

URL 形如 `https://relay.jd.com/file/design?id={fileKey}&page_id={pageId}&node_id={nodeId}`

提取:
- `fileKey` → query 参数 `id`
- `nodeId` → query 参数 `node_id`,把 `-` 替换为 `:`(例:`639-3394` → `639:3394`)

如果用户只给 `nodeId`(裸的 `xxx:yyy`),直接用。

---

## 工作流

### Step 1 — 拉设计稿三件套(尽量并行)

并行调用以下 MCP 工具:
1. `mcp__zero-design__get_screenshot(nodeId)` —— 视觉参考
2. `mcp__zero-design__get_variables(nodeId)` —— **核心数据源**,返回设计稿引用的全部 design token
3. `mcp__zero-design__get_design_metadata(nodeId)` —— 结构与命名,大节点会写到 tool-results 文件,**不要**强制读全文,grep 即可

> **限速**:同一 file 短时间并发 5 个以上 MCP 请求会让服务侧丢连接。三件套并行 OK,更多请串行。

### Step 2 — 加载 token 真相源(按 fileKey 路由 V15 / V16)

#### 2.1 判断版本

| 输入 `fileKey` | 版本 | tokens.json 路径 | fallback snapshot |
|---|---|---|---|
| `1896756863949619202` | V15.0(历史 spec file) | `~/code/jd-design-wiki-proposal/jd-design-system-md/foundations/tokens/tokens.json` | `references/tokens-snapshot.md`(V15) |
| `2029484645871009793` | V16.0(当前 master) | `~/code/jd-design-wiki-proposal/jd-design-system-md-v16/foundations/tokens/tokens.json` | TBD(暂未提供 V16 fallback,无 tokens.json 时报错退出) |
| 其他 | 未知 | 默认按 V16 路径尝试;失败再按 V15 | 同上 |

> file_id 映射与 `relay-to-design-md/references/bg-mapping.json` 共用同一份真值,变更必须同步双方。

#### 2.2 读取

按版本选定 tokens.json 路径,仓库克隆存在 → **首选** tokens.json;不存在 → 走对应版本的 fallback snapshot。读 tokens.json 时只关心 `color` / `typography` / `radius` / `spacing` / `icon` / `motion` 6 大块的 `$value`。

V15 / V16 两套 tokens.json **结构兼容**(都是 `$value` token 树),但具体 token 名 / 命名空间不完全相同 —— 走 V16 时下面 Step 3a-3f 的命名空间启发(如"`色彩变量 Color/...` 命名空间")可能不再适用,见 Step 3 前的注。

### Step 3 — 交叉校验

> **V15 / V16 命名启发适用性提醒**:下方 3a-3f 的命名空间识别(如 `色彩变量 Color/...` / `日间` / `C_Newgray` 等 14.x→15.0 迁移痕迹)、Naming-conflict fingerprint 表(`colortexthelp` 等)均源于 V15 实战。V16 启用后命名空间可能改变,启发可能误报 / 漏报。**走 V16 跑出意外结果时,先把规则贴到报告里、标"V15 启发,V16 待校",然后开 follow-up issue 而不是直接静默**。

#### 3·前置 · Token 命名唯一性检查(kebab/snake 双轨)

**强制规则(机器判定,无需人工分辨)**:同一 token 概念在 variables 表中出现 ≥ 2 个命名变体(kebab-case / snake_case / 大小写混用 / 中英混用)且**值不同** → **必标 ❌ Naming-conflict**(违规)。

#### 判定算法

1. 把每个 variable name 规范化:取最后一段(去掉命名空间前缀),`lowercase + 删除所有 - 和 _` → 得到 fingerprint。
2. 按 fingerprint 分组。
3. 同组内若存在 ≥ 2 个不同 `$value` → 触发 Naming-conflict。
4. 同组内 `$value` **相同**但命名风格不一致(snake vs kebab vs CamelCase)→ 仅标 ⚠️ Naming-style(警告,不阻塞)。

#### 案例

| 变量名 A | 变量名 B | fingerprint | 值 A | 值 B | 判定 |
|---|---|---|---|---|---|
| `color_text_help` | `color-text-help` | `colortexthelp` | `#828794` | `#888b93` | ❌ Naming-conflict |
| `color_border` | `color-border` | `colorborder` | `#00000014` | `#0000000f` | ❌ Naming-conflict |
| `color_background_sunken` | `color-background-sunken` | `colorbackgroundsunken` | `#f5f6fa` | `#f7f8fc` | ❌ Naming-conflict |
| `spacing_8` | `Spacing-8` | `spacing8` | `8` | `8` | ⚠️ Naming-style |
| `元素布局/Spacing-4` | `元素布局/spacing_4` | `spacing4` | `4` | `4` | ⚠️ Naming-style |

#### 报告规则

- Naming-conflict 类违规**置于 ❌ 段顶部**,优先于 off-token / legacy。
- 每条建议必须显式给出**保留哪个 / 删除哪个**:优先保留 snake_case 与 15.0 命名空间(`色彩变量 Color/...`)一致的版本。
- 若两版都不在 15.0 命名空间(如全是 `品牌色/Brand-x`),先按命名空间合规性挑,再按 snake_case。

#### 为什么这是前置全局规则

- 14.x → 15.0 迁移最普遍的残留模式——同一概念两个 token 同时存在,值已漂移。
- 让 AI / 设计师选取时随机命中,是设计漂移最隐蔽的源头。
- 占典型走查 30%+ 的违规来源——机器可判,**优先扫掉**避免后续 3a-3f 重复报。
- 触发后该 fingerprint 组内的其他错误(Off-token / Legacy)**仍要标**,但归并到同一组建议下输出。

---

#### 3a. 颜色

把 variables 里每个 `色彩变量 Color/...` 与 `平台色板/...` 与 `灰阶/...` 等命名空间下的 token,逐一与 tokens.json `color.*` 路径对照:

判定 5 种结果:
| 状态 | 条件 |
|---|---|
| ✅ Pass | 设计稿 token 名 + 值都能映射到 tokens.json 某条目 |
| ⚠️ Naming | 值在 tokens.json 中存在,但**命名空间错位**(如 `color_primary_disabled = #c2c4cc`,#c2c4cc 实际是 `text.disabled` 而非 primary) |
| ⚠️ Legacy | token 命名带 `日间` / `C_Newgray` / `Newgray` 等 14.x 前缀 → 残留旧 token,15.0 已用新名 |
| ❌ Off-token | 值不在 tokens.json 的任何条目中(且非透明度组合) |
| ❌ Naming-conflict | 已由 Step 3 前置规则识别——同 fingerprint 出现 ≥2 个变体且值不同 |

**特殊判定**:
- `color_primary_light = #fff0f4` → 实际同 `semantic.danger-subtle` (15.0 中 brand 与 danger 同色,wash 共用) → 标 ⚠️ Naming,建议改名
- `color_service*` 用在**非 VIP / 非金融场景**(如普通筛选 chip)→ 标 ⚠️ Semantic drift

#### 3b. 字体

对每个 `Font(...)` token 检查:

| 维度 | 15.0 白名单 |
|---|---|
| `family` | `京东朗正体 V2.0`(品牌) / `PingFang SC`(中文正文) / `京东正黑 V2.2`(数字) |
| `size`(基础) | **10 / 12 / 14 / 15 / 18** |
| `size`(价格特殊) | **15 / 18 / 24**(羊角符 / 角分最低 12) |
| `weight` | **400** / **600** / **700**(数字限定) |
| `lineHeight` | 字号 × 1(单行) / 字号 × 1.5 奇数 -1(段落) |
| `letterSpacing` | 0 |

❌ **硬性违规**:size ∉ 上述阶梯 → 标 ❌ Off-spec。**特别注意 token 名带"临时新增"的字段** —— 这是 15.0 设立后被绕开的明确证据。

⚠️ **名实不符**:token 名说 `_600` 但实际 `weight: 500` → 命名残留。

#### 3c. 圆角

值需 ∈ **{0, 2, 4, 6, 8, 12, 24, 9999/full}**。
对应 token: `radius.{0, xs, s, base, detail, xl, structural, full}`。

不在白名单 = ❌ Off-token。

#### 3d. 间距

值需 ∈ **{0, 2, 4, 6, 7, 8, 12, 16, 20, 24, 28, 32, 40, …(4 的倍数延展)}**。
- 7 是 Feeds 特殊值
- 2 仅导购型慎用
- 6 平台型慎用、导购型常规

判语义层级(塔式原理):
- 卡片内上下安全 = 平台 16 / 导购 12
- 卡片内左右安全 = 平台 12 / 导购 8
- 区块内子元素 = 平台 8 / 导购 6
- 紧密关联 = 4
- 非卡片元素左右 = 16

错乱 → 标 ⚠️ Hierarchy violation。

#### 3e. 动效(若 metadata 包含)

时长 ∈ **{100, 150, 200, 300}ms**。
缓动 ∈ **standard / decelerate / accelerate / spring** 4 类贝塞尔。
出场必须 ≤ 入场 1 档(进 300 出 ≤ 200 / 进 200 出 ≤ 150 / 进 150 出 = 150)。

#### 3f. 结构 / 布局(从 screenshot 判断)

- 逻辑尺寸 375?(默认)
- 内容详情型(商详 / 结算 / 订详)→ **平铺式**(直角拉通)
- 导购入口型(首页 / 搜索 / 购物车)→ **卡片式**(小圆角收拢)
- 状态栏 44 / 起始指示器 34 / 屏幕左右 8(沉浸式专用)是否被尊重
- 起始指示器 34 区域**禁放操作按钮**

错乱 → 标 ⚠️ Structure mismatch。

### Step 4 — 输出报告

固定 5 段式 markdown:

```
## 设计稿 Review · `<nodeId>`

**类型识别**:<根据 screenshot 判断:页面 / 半弹层 / 弹窗 / 卡片 / etc.>
**逻辑尺寸**:<375 / 自适应>

### ❌ 违规(必须改)
<对每条:位置 + 规则引用 + 证据 + 建议>
<排序:Naming-conflict 优先 → Off-token → 其他>

### ⚠️ 警告(命名 / 残留 / 语义偏移)
<同上>

### ✅ 符合 V{version}(根据 Step 2 路由的版本填 V15.0 或 V16.0)
<表格:检查项 | 设计稿值 | 对应 token>

### 📋 无法仅凭 metadata 判断
<列出建议设计师补 variable 引用的项,如 radius / spacing>

### 文字总结
<1 段,X 个改动 + Y 个建议;主色彩 / 文本 / 字族遵守度评价;问题集中在哪>
```

每条违规 / 警告 **必须** 链接到 wiki 文件 + 章节,**链接前缀跟随 Step 2 路由的版本**:

| 版本 | 仓库内路径前缀 | GitHub URL 前缀 |
|---|---|---|
| V15 | `/jd-design-system-md/foundations/...` | `https://github.com/ShuaiMXu/jd-design-wiki-proposal/blob/main/jd-design-system-md/foundations/...` |
| V16 | `/jd-design-system-md-v16/foundations/...` | `https://github.com/ShuaiMXu/jd-design-wiki-proposal/blob/main/jd-design-system-md-v16/foundations/...` |

V15 例:
```
- 规则:[`tokens/typography.md` §2 字号阶梯](/jd-design-system-md/foundations/tokens/typography.md)
```

V16 例:
```
- 规则:[`tokens/typography.md` §2 字号阶梯](/jd-design-system-md-v16/foundations/tokens/typography.md)
```

---

## 失败模式

| 现象 | 处置 |
|---|---|
| `get_screenshot` 返回 transport dropped | 串行重试 1 次;再失败就只用 variables + metadata 出报告,在「📋 无法判断」中说明缺截图 |
| `get_variables` 返回 `{}` | 节点不引用变量(可能纯绘图 / 旧设计稿)→ 标注无变量,报告章节降级到只看结构与字号(从 metadata) |
| `get_design_metadata` 输出 > 25k tokens | grep 不要全读,模式见下面"片段提取" |
| 用户给的 fileKey 不在已知 spec file 列表(V15 `1896756863949619202` / V16 `2029484645871009793`) | 仍可走 review:Step 2 按"其他"分支默认 V16 路径,失败回退 V15;报告顶部标注「**警告:此 fileKey 不在已知 spec file 列表,默认按 V16 真相源校验,如属其他业务文件请指明**」|
| V16 tokens.json 缺失 + V16 fallback snapshot 未提供 | Step 2 报错退出,提示用户先 clone 仓库或 follow-up 提供 V16 fallback |

### Metadata 片段提取(应对超大节点)

```bash
python3 - <<'PY'
import json, re
with open('<tool-results-file>') as f:
    xml = json.load(f)[0]['text']
# 颜色 hex
hexes = set(re.findall(r'#[0-9a-fA-F]{6,8}\b', xml))
# 长文本(中文描述)
texts = [t for t in re.findall(r'name="([^"]{15,500})"', xml)
         if any('一'<=c<='鿿' for c in t)]
print(hexes, texts[:20])
PY
```

---

## 引用约定

报告中引用 wiki 时:
- token 文件用文档链接(`tokens/typography.md` §X)
- 具体 token 用 BEM 命名(`color.brand.primary`、`radius.role.button`)
- Relay 节点用 `relay.jd.com/file/design?...&node_id=X:Y` 而非内部 ID,方便接收方直接打开

---

## 示例

见 [`examples/shop-review-half-sheet.md`](examples/shop-review-half-sheet.md) —— 对节点 `639:3394`(店铺评价半弹层)的完整走查。这是黄金参考输出。

---

## 与其他 skill / 工具的关系

| 工具 | 区别 |
|---|---|
| `mcp__zero-design__get_design_context` | 取设计 + 出参考代码;**不做合规判定**,本 skill 在其上加规则层 |
| `/security-review` | 安全审计,scope 完全不同 |
| `/review`(Claude Code 内置) | PR 评审,scope 完全不同 |
| `mcp__zero-design__create_design_system_rules` | 生成接入规则文档,**不做对单稿的审计** |

本 skill 输出的是「**对设计稿做的事**」,不是「**生成什么**」。
