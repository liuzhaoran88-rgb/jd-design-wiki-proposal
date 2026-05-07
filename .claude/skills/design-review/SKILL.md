---
name: design-review
description: Audit a JD APP V15.0 design from Relay against the design system wiki (color / typography / radius / spacing / motion / icon / layout tokens). Triggered by relay.jd.com URLs or node IDs together with verbs like "审核", "走查", "review", "audit", "检查规范", "符合 15.0 吗". Outputs a structured pass/warn/violate report with citations back to wiki rules.
---

# /design-review · JD 15.0 设计稿合规走查

把 Relay 节点的设计稿与 `jd-design-wiki-proposal` 仓库的 15.0 token 体系做交叉校验,输出可读 + 可复核的合规报告。

---

## 何时触发

用户给出一个 Relay 设计链接或节点 ID,并要求:
- "审核 / 走查 / review / audit 这个设计稿"
- "符合 15.0 设计规范吗"
- "检查一下用了哪些 token"
- "这个 token 用对了吗"

如果用户只是问"这个设计长啥样",**不要**触发本 skill —— 那是单纯的 `get_design_context` 用法。

## 不适用场景

- 非 JD 内部 Relay 文件(只有 15.0 wiki 覆盖)
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

### Step 2 — 加载 15.0 token 真相源

按优先级尝试:
1. `~/code/jd-design-wiki-proposal/jd-design-system-md/foundations/tokens/tokens.json` —— 仓库克隆存在时,**首选**(最新)
2. 本 skill 内嵌的 `references/tokens-snapshot.md` —— fallback

读 tokens.json 时只关心 `color` / `typography` / `radius` / `spacing` / `icon` / `motion` 6 大块的 `$value`。

### Step 3 — 交叉校验

#### 3a. 颜色

把 variables 里每个 `色彩变量 Color/...` 与 `平台色板/...` 与 `灰阶/...` 等命名空间下的 token,逐一与 tokens.json `color.*` 路径对照:

判定 4 种结果:
| 状态 | 条件 |
|---|---|
| ✅ Pass | 设计稿 token 名 + 值都能映射到 tokens.json 某条目 |
| ⚠️ Naming | 值在 tokens.json 中存在,但**命名空间错位**(如 `color_primary_disabled = #c2c4cc`,#c2c4cc 实际是 `text.disabled` 而非 primary) |
| ⚠️ Legacy | token 命名带 `日间` / `C_Newgray` / `Newgray` 等 14.x 前缀 → 残留旧 token,15.0 已用新名 |
| ❌ Off-token | 值不在 tokens.json 的任何条目中(且非透明度组合) |

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

### ⚠️ 警告(命名 / 残留 / 语义偏移)
<同上>

### ✅ 符合 15.0
<表格:检查项 | 设计稿值 | 对应 token>

### 📋 无法仅凭 metadata 判断
<列出建议设计师补 variable 引用的项,如 radius / spacing>

### 文字总结
<1 段,X 个改动 + Y 个建议;主色彩 / 文本 / 字族遵守度评价;问题集中在哪>
```

每条违规 / 警告 **必须** 链接到 wiki 文件 + 章节,例如:
```
- 规则:[`tokens/typography.md` §2 字号阶梯](/jd-design-system-md/foundations/tokens/typography.md)
```

路径基于 `jd-design-wiki-proposal` 仓库根。如果用户没本地 clone,链接到 GitHub:
```
https://github.com/ShuaiMXu/jd-design-wiki-proposal/blob/main/jd-design-system-md/foundations/tokens/typography.md
```

---

## 失败模式

| 现象 | 处置 |
|---|---|
| `get_screenshot` 返回 transport dropped | 串行重试 1 次;再失败就只用 variables + metadata 出报告,在「📋 无法判断」中说明缺截图 |
| `get_variables` 返回 `{}` | 节点不引用变量(可能纯绘图 / 旧设计稿)→ 标注无变量,报告章节降级到只看结构与字号(从 metadata) |
| `get_design_metadata` 输出 > 25k tokens | grep 不要全读,模式见下面"片段提取" |
| 用户给的 fileKey 不是 1896756863949619202(15.0 spec file) | 仍可走 review,但在报告顶部标注「**警告:此设计稿不属于 15.0 规范文件,token 引用可能存在历史版本**」|

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
