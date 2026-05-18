# Shared references

跨 skill 共享的真相源(level 词表 / 7 章节 anchor slug / Relay sharedPluginData namespace / Token naming-conflict 规则)。

任何被 ≥2 个 skill 消费的契约都收在这里,**单 skill 私有的规则留在该 skill 自己的 `references/`**。

## 当前文件

| 文件 | 谁消费 | 作用 |
|---|---|---|
| [level-vocab.md](./level-vocab.md) | relay-to-design-md(写)/ design-md-to-site(分组)/ design-md-to-spec-page(过滤)/ design-review(校验) | `level` frontmatter 枚举词表 + 与 `bg` 的边界 |
| [section-anchors.md](./section-anchors.md) | design-md-to-site(总站锚)/ design-md-to-spec-page(详情页章节)/ design-review(章节完整性) | 7 章节 canonical name + slug,锚跳锁死 |
| [relay-namespaces.md](./relay-namespaces.md) | relay-to-design-md / design-md-to-spec-page | Relay 节点 sharedPluginData namespace 注册表 + 生命周期 |
| [naming-conflict-rules.md](./naming-conflict-rules.md) | design-review(Step 3 前置)/ relay-to-design-md(Step 5.1 反查后防写) | Token fingerprint 算法 + V15 已知冲突表 + 消费方契约 |

## 增加新 shared reference 的条件

- 同一概念被 ≥2 个 skill 引用
- 概念变更会同时影响多个 skill 的产物
- 不属于单 skill 内部实现细节(渲染算法、提取启发等)

不满足上面三条的不要塞进来 —— 保持本目录小而锐。

## 漂移检测

修改本目录任一文件后,要保证 grep 引用方都已同步更新:

```bash
grep -rn "shared/references/<file>.md" .claude/skills/
```

引用方应至少包含该 reference 表头列出的 skill。
