# 设计师提交 PR 前自检清单

> 设计师跑完 skill 后，先用前半部分确认 outline；确认无误并生成正式 `design.md` 后，再用后半部分检查 PR 质量。

---

## 0. 生成前确认（outline gate）

- [ ] 组件边界正确，当前节点没有把无关 frame 一起带进来
- [ ] 章节拆分正确，outline 中的结构树和设计稿一致
- [ ] 状态 / 变体 / 组合维度没有漏项
- [ ] `待设计师确认` 里的内容确实是设计稿缺口，不是模型自由发挥
- [ ] `自动发现的风险` 已判断是否接受，或准备在正式稿中处理
- [ ] 确认后再执行 `/relay-to-design-md <relay_url> --confirm-outline`

---

## 1. 一键自动校验（v0.2 新加）

提 PR 前先跑：

```bash
bash .claude/skills/relay-to-design-md/bin/validate.sh
# 或单文件：
bash .claude/skills/relay-to-design-md/bin/validate.sh path/to/design.md
```

会自动检查：① 必填字段 ② 受控词表 ③ slug 格式 ④ relay URL 有效 ⑤ preview.png 存在 ⑥ TODO/⚠️ 是否残留（status=review/published 时）

退出码 1 = 有错（PR 不能提）；退出码 0 = 通过。

警告（warning）不算 fail，但建议处理。

---

## 🔵 必检 10 条（影响 review 通过）

- [ ] **Frontmatter `owner` 不是 `@TODO`** — 设计师确认自己 GitHub handle 已填
- [ ] **`auto_detected` 三项无 ⚠️ fallback 标记** — 如果有，确认 level/bg/slug 是否需要修正
- [ ] **`status: draft` → `review`** — 准备提 PR 时升级
- [ ] **5 处 `<!-- TODO -->` 都已填写** — 一句话定义 / 应用场景 / 交互 / Donts / AI Schema
- [ ] **preview.png 已附** — 如果 skill 没自动生成，手动从 Relay 截图放进去
- [ ] **⚠️ token-miss 已逐条 review** — 决定回归 token 还是组件特殊处理（不能 silent ignore）
- [ ] **⚠️ half-step 间距已 review** — 决定回归到 V16 spacing 倍数 4 还是新增 atom
- [ ] **`relay_source.url` 在浏览器能打开且对得上节点** — 防止 URL 编码错误
- [ ] **`uses_components` 引用的子组件路径正确**（或标 `TODO/...` 占位）
- [ ] **没有遗留任何 `{{...}}` 模板变量** — 全部已被实际值替换

---

## 🟡 推荐检查（提高文档质量）

- [ ] 一句话定义 ≤ 30 字
- [ ] 应用场景 ✅ 和 ❌ 各至少 1 条具体场景（不是泛泛"用在某处"）
- [ ] 交互描述包含**初始态 / 触发态 / 反馈态 / 边界态** 4 类
- [ ] Donts 至少 3 条常见误用
- [ ] AI Schema 完整（states / slots / events 都不为 TODO）
- [ ] 引用 V16 token 名拼写无误（与 [foundations/tokens/](../../../../jd-design-system-md-v16/foundations/tokens/) 完全一致）
- [ ] 变更记录表格保留所有历史行（不要删旧条目）

---

## 🟢 PR 描述模板

```markdown
## 新增 design.md：{name_zh} ({slug})

**Relay 源**：{relay_url}
**层级 / 业务**：{level} / {bg}

**Skill auto-detect 结果**：
- level: ✅ 正确推断 / ⚠️ fallback
- bg: ✅ 正确推断 / ⚠️ fallback
- slug: ✅ 正确推断 / ⚠️ fallback

**手填部分**：5 处 TODO 已补 / 一句话定义 / 应用场景 / 交互 / Donts / AI Schema

**Skill flag review 结果**：
- ⚠️ token-miss（{N} 处）：{逐条处理结果}
- ⚠️ half-step 间距（{N} 处）：{逐条处理结果}
- 子组件未录入（{N} 处）：占位 / 已联系负责人

**Review 关注点**：
- [ ] 视觉一致性（与 Relay 实际效果一致）
- [ ] token 引用准确性
- [ ] 交互描述完整性

🤖 部分自动同步 — skill v0.1
```
