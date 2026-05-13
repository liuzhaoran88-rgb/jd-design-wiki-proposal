# slug 中文 fallback 词表

> SKILL.md Step 3 slug 推断 S3 规则查本表。当节点名 + PAGE 名都没有英文段（S1 / S2 都不命中），按本表中→英映射。
>
> 仅维护**JD APP 设计常见词**，不是全字典。维护者按需追加。

---

## 算法

```
输入: 中文字符串（如 "↘️ 顶部导航栏" 去 emoji 后的 "顶部导航栏"）
输出: slug 候选 / null

Step 1: 整字符串精确匹配 `exact` 字典 → 命中输出
Step 2: 按 substring 长 → 短 扫 `parts` 字典，最长前缀 / 子串匹配
        多片段组合用 "-" 连接
        例 "顶部导航栏" → "顶部" + "导航栏" → "top-navbar"
Step 3: 都不命中 → 输出 null（SKILL.md 走 todo-slug 兜底）
```

---

## exact 表（整字符串 = 整 slug）

| 中文 | slug |
|---|---|
| 按钮 | button |
| 顶部导航栏 | navbar |
| 底部导航栏 | tabbar |
| 侧边导航栏 | sidebar |
| 标签栏 | tabs |
| 锚点导航 | anchor-nav |
| 分页符 | pagination |
| 分段选择器 | segmented |
| 悬浮按钮 | fab |
| 步进器 | stepper |
| 单选 | radio |
| 多选 | checkbox |
| 开关 | switch |
| 评分 | rate |
| 搜索 | search |
| 滑动操作 | swipe |
| 价格 | price |
| 优惠券 | coupon |
| 优惠卷 | coupon |
| 卡片容器 | card |
| 列表 | list |
| 图片预览 | image-preview |
| 动作面板 | action-sheet |
| 全局加载 | loading |
| 下拉刷新 | pull-to-refresh |
| 上滑加载 | infinite-loading |
| 吐司提示 | toast |
| 气泡 | popover |
| 飘新提示 | badge |
| 提示条 | prompt-bar |
| 半弹层 | popup |
| 弹窗 | dialog |
| 抽屉 | drawer |
| 输入框 | input |
| 表单 | form |
| 标签 | tag |
| 头像 | avatar |
| 徽标 | badge |
| 选择器 | picker |
| 时间选择器 | date-picker |
| 日历 | calendar |
| 步骤条 | steps |
| 进度条 | progress |
| 骨架屏 | skeleton |
| 占位图 | placeholder |
| 缺省图 | empty |
| 兜底图 | fallback |
| 主图 | hero |
| 图标 | icon |
| 价格组 | price-group |
| 商品卡 | product-card |
| 文案 | text |
| 文字 | text |
| 标题 | title |
| 段落 | paragraph |
| 容器 | container |
| 区块 | section |
| 工具栏 | toolbar |
| 操作栏 | action-bar |
| 折叠面板 | collapse |
| 树 | tree |
| 表格 | table |
| 走马灯 | carousel |
| 轮播 | carousel |
| 滚动条 | scrollbar |
| 锚点 | anchor |
| 返回顶部 | back-top |

---

## parts 表（中文子串 → 英文片段，用于组合）

> 按**长度从长到短**匹配，避免 "导航栏" 被先吃成 "导航"。

| 中文 | slug 片段 | 长度 |
|---|---|---|
| 导航栏 | navbar | 3 |
| 提示条 | prompt-bar | 3 |
| 工具栏 | toolbar | 3 |
| 操作栏 | action-bar | 3 |
| 滚动条 | scrollbar | 3 |
| 步骤条 | steps | 3 |
| 进度条 | progress | 3 |
| 标签栏 | tabs | 3 |
| 输入框 | input | 3 |
| 选择器 | picker | 3 |
| 顶部 | top | 2 |
| 底部 | bottom | 2 |
| 左侧 | left | 2 |
| 右侧 | right | 2 |
| 侧边 | side | 2 |
| 全局 | global | 2 |
| 局部 | local | 2 |
| 浮动 | floating | 2 |
| 悬浮 | floating | 2 |
| 固定 | fixed | 2 |
| 主要 | primary | 2 |
| 次要 | secondary | 2 |
| 三级 | tertiary | 2 |
| 默认 | default | 2 |
| 禁用 | disabled | 2 |
| 选中 | selected | 2 |
| 激活 | active | 2 |
| 错误 | error | 2 |
| 成功 | success | 2 |
| 警告 | warning | 2 |
| 警示 | warning | 2 |
| 信息 | info | 2 |
| 加载 | loading | 2 |
| 下拉 | pulldown | 2 |
| 上滑 | scrollup | 2 |
| 滚动 | scroll | 2 |
| 滑动 | swipe | 2 |
| 拖拽 | drag | 2 |
| 缩放 | zoom | 2 |
| 旋转 | rotate | 2 |
| 翻页 | flip | 2 |
| 按钮 | button | 2 |
| 文字 | text | 2 |
| 文案 | text | 2 |
| 文本 | text | 2 |
| 标题 | title | 2 |
| 价格 | price | 2 |
| 图标 | icon | 2 |
| 图片 | image | 2 |
| 标签 | tag | 2 |
| 卡片 | card | 2 |
| 列表 | list | 2 |
| 弹窗 | dialog | 2 |
| 弹层 | popup | 2 |
| 抽屉 | drawer | 2 |
| 气泡 | popover | 2 |
| 吐司 | toast | 2 |
| 反馈 | feedback | 2 |
| 操作 | action | 2 |
| 数据 | data | 2 |
| 输入 | input | 2 |
| 表单 | form | 2 |
| 表格 | table | 2 |
| 头像 | avatar | 2 |
| 徽标 | badge | 2 |
| 进度 | progress | 2 |
| 评分 | rate | 2 |
| 搜索 | search | 2 |
| 筛选 | filter | 2 |
| 排序 | sort | 2 |
| 折叠 | collapse | 2 |
| 展开 | expand | 2 |

---

## 兜底（v0.3）

如果 exact + parts 都不命中：

1. 取**首字符**的拼音 + `-unk-N`（N = INDEX.md 里已有 todo 数 + 1）
2. 例：节点名 "咖啡色按钮" → 找不到 → slug = `ka-unk-1`
3. ⚠️ flag 让设计师 review 时改名

> 拼音算法 v0.3 暂不实现（避免引入 Python/Node 依赖），直接用首字母英文。v0.4+ 可考虑引入 pinyin-pro 或简化版查表。

---

## 维护

新增映射的格式：

```markdown
| 中文 | slug |
```

放对应表（exact / parts）的字典序合适位置。更新本文档后 skill 立即生效（无缓存）。

> 维护者：碰到 skill 报 `slug fallback unk` 时，把那个中文加进 exact 表，再让设计师重跑 skill。
