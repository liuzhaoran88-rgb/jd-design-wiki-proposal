---
zone: horizontal
section: double-column-card
file: ai-schema
last_updated: 2026-05-11
---

# AI Agent 接入契约 · AI Schema

> 给其他 AI agent 的接入说明。本文件**只描述接口**，执行算法和决策树伪代码在 Skill 仓库。

---

## 一、Skill 元信息

```yaml
name: jd-double-column-card
version: v0.5.2
status: WIP
owner: Shaka（综合业务设计组）
repo: https://github.com/ShuaiMXu/jd-double-column-card-skill
entry_for_agents: prompts/page-level-review.md
```

---

## 二、触发词

调用方在自然语言中包含以下任一短语时，agent 应路由到本 Skill：

**SKILL.md frontmatter 声明的官方触发词**：
- 「双列卡审查」「双列卡体验观察」「双列卡差异分析」
- 「页面级双列卡审查」「跨场景同物种识别」

**Shaka 全局记忆中扩展的触发词**：
- 「京东双列卡差异分析」「双列卡变体评估」

**隐式触发**：「这张双列卡有什么问题」/ 「这个卡跟其他卡有啥不一样」 等含「双列卡」的问句

> ⚠️ 触发词清单需与 [Skill 仓库 SKILL.md frontmatter](https://github.com/ShuaiMXu/jd-double-column-card-skill/blob/main/SKILL.md) 和 Shaka 全局记忆保持一致。新增触发词时三处同步。

---

## 三、三种工作流

| 工作流 | 入口文件 | 用例 | 主要输入 |
| --- | --- | --- | --- |
| **页面级审查**（生产主流）| `prompts/page-level-review.md` | 整页巡检 | 1 张页面截图 + business_line |
| **单卡快检** | `prompts/review-screenshots.md` | 单点 / Debug | 1~多张单卡截图 + business_line |
| **变体评估** | `prompts/evaluate-variant.md` | 新变体评审 | 变体截图 + 业务背景 |

> **如果 agent 只能读一个文件**：读 `prompts/page-level-review.md`（自包含执行契约，Step 0-6 完整算法 + 家族决策树 + 报告模板）。

---

## 四、输入协议

```yaml
business_line: <enum>          # 必填，人工显式声明
                               # 枚举：推荐 | 点评 | 圈子 | 新品 | 个人中心 | 直播
page_screenshot: <path>        # 必填（页面级审查）
screenshots: <path[]>          # 必填（单卡快检 / 变体评估）
page_name: <string>            # 必填
version: <string>              # 可选：Before / After / V1 等
focus: <string>                # 可选：聚焦关注点
```

**铁律**：缺失 `business_line` 或截图 → **拒绝执行**，不推断。

---

## 五、输出协议

### 5.1 页面级审查输出（三段式）

```markdown
# [页面名] 双列卡观察报告

## 整体印象
（≤ 3 句，描述页面整体特征 + 流级一致性）

## 差异观察
| # | 差异描述 | 体验代价 | 业务可能合理理由 | 讨论建议 |
|---|---|---|---|---|
| 1 | ≤30 字 | ≤40 字 | ≤25 字 | ≤30 字 |
| ... | ... | ... | ... | ... |
（最多 8 行）

## 下一步
（讨论方向，不是判决；指向具体的设计师/评审决策点）
```

### 5.2 报告字段约束

| 字段 | 类型 | 必填 | 约束 |
| --- | --- | --- | --- |
| 整体印象 | string | ✅ | ≤ 3 句 |
| 差异.差异描述 | string | ✅ | ≤ 30 字 |
| 差异.体验代价 | string | ✅ | ≤ 40 字，从 10 维工具箱选 1 个维度 |
| 差异.业务理由 | string | ✅ | ≤ 25 字（即便空也要诚实标 "暂未发现明显合理理由"）|
| 差异.讨论建议 | string | ✅ | ≤ 30 字 |
| 差异表行数 | — | — | ≤ 8 行 |

### 5.3 annotations（机器可读元数据）

```yaml
annotations:
  cards_detected: <int>        # 检测到的卡片数
  card_types:                  # 每张卡的家族归属
    - card_id: <string>
      family: <enum: 内容 | 商品 | 圈子 | 点评 | 新品 | unknown>
      sub_type: <string>
      activated_signals:       # 动态数据激活信号（不参与家族判定）
        has_seed_count: <bool>
        has_id_badge: <bool>
        has_view_count: <bool>
  unrecognized: <int>          # 未能识别家族的卡数
```

---

## 六、错误处理与兜底

| 场景 | 处置 |
| --- | --- |
| 缺失 `business_line` | 拒绝执行，返回错误 + 提示需要人工声明 |
| 缺失截图 | 拒绝执行，返回错误 |
| business_line 与采集到的家族**严重不匹配** | 在报告中标"业务线声明 vs 视觉识别冲突"，请调用方确认 |
| 截图中无可识别双列卡 | 输出"未检测到双列卡"，不强行造数据 |
| 检测到的家族不在已知 5 家族中 | 标 `family: unknown`，描述其结构特征供反哺 |
| L2 商品家族细则缺失 | 商品卡只走 L1，明确标"L2 待补，本卡只走 L1 观察" |

---

## 七、与其他 Skill 的协议关系

| 关联 Skill | 关系 |
| --- | --- |
| `jd-design-system-lint`（规划中）| 上游：lint 扫描通用 token 偏离；本 skill 处理双列卡领域知识 |
| `poster-design-knowledge` | 平级：横向专项 skill 范例 |
| `feishu-cli` / `feishu-doc` | 下游：观察报告可通过 feishu skill 导入飞书文档归档 |

---

## 八、版本协议

- 主版本号变更（v0.x.x → v1.x.x）：调用方需 review 接入契约
- 次版本号变更（v0.5.x → v0.6.x）：可能新增字段或工作流，向后兼容
- 修订号变更（v0.5.1 → v0.5.2）：修原则 / 决策树 / 报告纪律，调用方无需改接入

详细变更见 [`CHANGELOG.md`](./CHANGELOG.md) 和 Skill 仓库 [`references/changelog.md`](https://github.com/ShuaiMXu/jd-double-column-card-skill/blob/main/references/changelog.md)。
