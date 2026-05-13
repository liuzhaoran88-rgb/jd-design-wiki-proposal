# 自动推断规则

> SKILL.md Step 3 调用本文件。所有字段全自动推断，**不问设计师**。推不出来就走兜底 + flag。

---

## 1. level 推断

输入：Relay PAGE name（节点所属页面名）

按以下顺序匹配，**第一条命中即返回**：

| 规则 | PAGE name 包含 | 推出 level |
|---|---|---|
| R1 | "通用类" / "导航类" / "信息展示类" / "信息输入类" / "反馈类" / "引导提示类" / "其他类" / "↘️ 顶部导航栏" / "↘️ 底部导航栏" / "↘️ 按钮" / "↘️ 单选" / "↘️ 多选" / "↘️ 评分" / "↘️ 开关" / "↘️ 步进器" / "↘️ 搜索" / "↘️ 标签栏" / "↘️ 滑动操作" / "↘️ 锚点导航" / "↘️ 悬浮按钮" / "↘️ 分页符" / "↘️ 分段选择器" / "↘️ 价格" / "↘️ 优惠卷" / "↘️ 优惠券" / "↘️ 卡片容器" / "↘️ 列表" / "↘️ 图片预览" / "↘️ 动作面板" / "↘️ 全局加载" / "↘️ 下拉刷新" / "↘️ 上滑加载" / "↘️ 吐司提示" / "↘️ 气泡" / "↘️ 飘新提示" / "↘️ 提示条" / "↘️ 半弹层" / "↘️ 弹窗" / "↘️ 侧边导航栏" / "↘️ 底部工具栏" | `component-base` |
| R2 | "↘️ 多端" / "↘️ 暗黑版" / "↘️ 大字版" / "↘️ 长辈版" / "↘️ 多语言版" / "↘️ 无障碍设计" | `component-base`（特殊版本组件） |
| R3 | "↘️ 主图" / "↘️ 缺省图" / "↘️ 兜底图" / "↘️ 图标" | `component-base`（资源类） |
| R4 | 节点尺寸 width ≈ 375 ± 10, height ≥ 600 | `page`（页面级，全屏尺寸） |
| R5 | 节点尺寸 width ≥ 1000, height ≥ 1000 | `flow`（流程级，多屏并列） |
| **兜底** | 都不匹配 | `component-business` + ⚠️ flag |

> 注：JD APP 16.0 标准设计尺寸是 375×812（iPhone 12-15 mini 逻辑分辨率）。如未来基准尺寸变化，更新 R4 阈值。

## 2. bg 推断

输入：Relay `file_id`

查 [bg-mapping.json](./bg-mapping.json)：

```json
{
  "2029484645871009793": "horizontal",   // V16 master file → 所有都 horizontal
  "1896756863949619202": "horizontal",   // V15 master file (历史)
  // 后续业务文件请由 skill 维护者追加
}
```

| 规则 | 输入 | 输出 bg |
|---|---|---|
| 查表命中 | file_id 在 bg-mapping.json | 用表值 |
| **兜底** | file_id 不在表 | `horizontal` + ⚠️ flag |

> 维护说明：当业务方发新 Relay 文件 ID 给你时，往 [bg-mapping.json](./bg-mapping.json) 加一行（不需改 SKILL.md）。

## 3. slug 推断

输入：Relay 节点 name + Relay PAGE name + componentProperties (v0.2)

### 3.1 base slug

按以下顺序，**第一条命中即返回**：

| 规则 | 提取来源 | 处理 |
|---|---|---|
| S1 | 节点名里的英文 `[A-Z][A-Za-z]+`（首字母大写连续单词） | 取**最长**英文段，kebab-case |
| S2 | PAGE 名里的英文 `[A-Z][A-Za-z]+` | 同上 |
| S3 (v0.3) | 节点名 / PAGE 名是已知中文映射 | 查 [slug-pinyin-fallback.md](./slug-pinyin-fallback.md) exact + parts 表 |
| **兜底** | 都没匹配 | `<首字符拼音首字母>-unk-N` + ⚠️ flag（让设计师 review 时改名） |

### 3.2 变体后缀（v0.2 新增）

如果节点是 `INSTANCE` 或 `COMPONENT`，且 `componentProperties` 含 `VARIANT` 类型项：

```
1. 拿到 variantProps 字典（节点抽取脚本已抽，见 node-type-mapping.md）
   例：{ "样式": "主要操作（红色填充）", "状态": "默认" }

2. 对每个 (key, value)：
   a) 在 variant-vocab.json exact 表中查 value 全字符串 → 命中 → 输出英文片段
   b) 不命中 → 在 exact 表中按 substring 查 value（去括号补充后）→ 命中 → 同上
   c) 都不命中 → 取 value 拼音 / 字面 + "-unk"

3. 组装 slug = base + "-" + variants.join("-")
   例：slug = "button" + "-" + ["primary", "default"].join("-") = "button-primary-default"

4. 顺序：按 variantProps 字典插入顺序（Relay 通常稳定）
   如果想强制某个 key 优先（如"样式"在"状态"之前），可在 variant-vocab.json 里加 priority 字段（v0.3+）
```

### 3.3 INDEX.md 冲突检测 (v0.2 新增)

slug 推完后，**必检 INDEX.md**：

```
查 INDEX.md：本 slug 是否已被占用？
  否 → 直接用
  是 → 检查占用方的 node_id 是否等于当前 node_id
    是 → 同一节点重跑 → 直接覆盖（实际上是更新）
    否 → 不同节点同 slug 冲突 → 自动加数字后缀 -2 / -3 (按现有 INDEX.md 找最小可用)
         并 flag "auto-suffix" 让设计师 review
```

例：
- 第一次跑 Button primary default → slug `button-primary-default` → 入 INDEX
- 重跑同节点 → 同 slug → 覆盖（设计师改了 5 处 TODO 后想重新 sync）
- 跑 Button primary disabled → variantProps={样式:主要操作, 状态:禁用} → slug `button-primary-disabled` → 不冲突
- 跑某节点 variantProps 为空且 PAGE 也叫 Button → slug `button` → 与现有冲突 → 自动 `button-2` + flag

### 例子（端到端）

| 节点 | PAGE | componentProperties.VARIANT | 推出 slug |
|---|---|---|---|
| "样式=主要操作（红色填充）, 状态=默认" | "↘️ 按钮 Button" | `{样式:主要操作（红色填充）, 状态:默认}` | `button-primary-default` |
| "搜索条日间" | "↘️ 顶部导航栏 NavBar" | （无 VARIANT，FRAME 类型） | `navbar` → INDEX 已存在 → `navbar-2`（v0.1 时是覆盖，v0.2 改为加后缀） |
| "↘️ 顶部导航栏 NavBar" 总入口 | 同上 | （是 PAGE 直接子 COMPONENT_SET） | `navbar` |

## 4. name_zh 推断

输入：Relay 节点 name

处理流程：
1. 去掉 emoji（unicode 范围 `[\u{1F300}-\u{1FAFF}]`、`[\u{2600}-\u{27BF}]`、`[\u{2700}-\u{27FF}]`、`[\u{1F000}-\u{1F02F}]`）
2. 去掉 `↘️` `🟡` `⭐️` `✅` 等特殊符号
3. 去掉英文段（已被 slug 用走）
4. trim 多余空格 / 斜杠

例：
- "↘️ 顶部导航栏 NavBar 🟡" → "顶部导航栏"
- "搜索条日间" → "搜索条日间"
- "导航类/顶部导航栏" → "顶部导航栏"

兜底：返回 trim 后的原名。

## 5. owner 推断

输入：本地 git config

```bash
git config user.email
# → xushui2018@gmail.com
```

处理：
1. 取 `@` 前部分（如 `xushui2018`）
2. 看是否有 GitHub handle 别名映射（[owner-aliases.json](./owner-aliases.json) — v0.2 加）
3. 输出 `@xushui2018`

兜底：`@TODO-填手柄` + flag。

## 6. 输出路径规则

```
component-base + horizontal
  → jd-design-system-md-v16/horizontal/components-base/{slug}/design.md

component-business + {bg}（v0.3+）
  → jd-design-system-md-v16/product-architecture/{bg}/components-business/{slug}/design.md

page + {bg}（v0.4+）
  → jd-design-system-md-v16/product-architecture/{bg}/pages/{slug}/design.md

flow + {bg}（v0.4+）
  → jd-design-system-md-v16/product-architecture/{bg}/flows/{slug}/design.md
```

> v0.1 实际上只走第一行。其他三行**仍然按规则写文件**（不要拒绝），但 frontmatter 标 ⚠️。

## 7. 编码 fallback flag 写法

在 frontmatter `auto_detected` 字段：

```yaml
auto_detected:
  level: component-base              # 正常推断，无 flag
  bg: horizontal ⚠️ fallback         # 走了兜底
  slug: "navbar"
```

`⚠️ fallback` 是一个**注释级别**的标记，跟在值后面，YAML parser 不会出错（它会被当字符串的一部分）—— 这是有意的，让 review 者一眼看见。

终端输出也要把 fallback 标记带上：

```
✅ 已生成: ...
   ├─ level: component-base
   ├─ bg:    horizontal ⚠️ fallback   ← 走了兜底
   ├─ slug:  navbar
```
