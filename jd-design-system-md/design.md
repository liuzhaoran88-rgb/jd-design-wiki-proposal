---
title: 京东 APP 设计系统 · DESIGN.md
version: v1.0
owner: 综合业务设计组
last_updated: 2026-04-29
schema: jd-wiki/v0.4
ai_ready: true
zone_index: ["foundations", "knowledge", "ai-mechanism", "product-architecture", "horizontal"]
---

# 京东 APP 设计系统 · DESIGN.md

> 这是一份**入口文档**,不是百科全书。它做两件事:
> 1. **给人**:30 秒看完整张地图,知道想找的内容在哪个 md 文件里
> 2. **给 AI**:一次 Read 拿到全局拓扑、字段约定、版本边界,无需把 60+ 子 md 全部塞入上下文
>
> 想看具体规范请按本文末尾"路径速查"跳转到对应 md。本文不复述细则。

---

## 0. 一句话定位

> 这不是一本"设计字典",是一套**让 12 个章节、5 个 Zone、~60 个 md 文件协同生长的拓扑结构**。
> 京东 APP 设计系统 v1.0 之所以做成多文件而非单文件,是因为我们要让它**被 AI 消费、被业务线分别贡献、被工具链分头消费**——单一长文档做不到。

**适用产品**:京东 APP(iOS / Android / iPad / 折叠屏 / 深色模式)
**覆盖范围**:全端(原生 + H5 + 小程序桥接区域)
**版本号**:Major.Minor.Patch(SemVer),当前 v1.0

---

## 1. 五大 Zone 拓扑(全局认知)

```
京东 APP Design System
│
├── 📚 Zone 1 · Design 知识        → 设计哲学 / 用研产出 / 标杆调研 / 历史决策
├── 🎨 Zone 2 · Design 基础        → Token / 原子组件 / 视觉规范(全公司共用)
├── 🤖 Zone 3 · AI 机制            → Skill / 协议 / Agent 守则 / Schema 约定
├── 🏗 Zone 4 · 组织架构 ★         → 部门 → 业务 → 业务组件目录(各业务线主战场)
└── 🚀 Zone 5 · 横向专项           → 跨部门治理(双列卡 / 大促 / 深色模式 / 无障碍)
```

**12 章 → 5 Zone 映射总表**:

| PDF 章节 | 主要归属 Zone | 拆分到的 md 数 | 备注 |
|---|---|---|---|
| 一、设计哲学 | Zone 1 + Zone 4 README | 4 | 哲学是"为什么",落到每个组件的 README 顶部 |
| 二、Design Tokens | Zone 2 foundations | 6 | color/typography/spacing/radius/shadow/elevation |
| 三、视觉规范 | Zone 2 visual | 7 | 与 Token 分离:Token 是数据,visual 是用法 |
| 四、交互规范 | Zone 2 interaction | 6 | 手势/导航/模态/表单/反馈/通知 |
| 五、动效规范 | Zone 2 motion | 5 | 原则/曲线/时长/编排/场景 |
| 六、无障碍设计 | Zone 5 horizontal/a11y | 1+ | 横向治理,所有组件需引用 |
| 七、基础组件库 | Zone 2 components-base | ~30 | 每个原子组件一个目录,内含 multi-md |
| 八、业务组件库 | Zone 4 各部门下 | ~40+ | 商品/订单/营销 → 进入对应业务部门的目录 |
| 九、页面模板 | Zone 4 各部门 pages/ | ~12 | 首页/搜索/PDP/购物车/结算 等 |
| 十、品牌与运营 | Zone 5 horizontal/brand | 6 | Logo / 大促 / 应用体系(子品牌)|
| 十一、多端适配 | Zone 5 horizontal/multi-platform | 5 | iOS-Android 差异 / 折叠屏 / 深色 / 字号 |
| 十二、设计系统治理 | Zone 3 + Zone 5 | 7 | 流程进 horizontal,Schema 进 AI 机制 |

> **设计判断**:Token 和视觉规范分两个目录,因为 Token 是**机器读**的(JSON),visual 是**人读**的(用法/案例/donts)。混在一起 AI 消费效率会下降。

---

## 2. 单组件 / 单单元的标准 multi-md 文件结构

不论是原子组件、业务组件、还是页面模板,落到目录粒度都遵循同一个文件结构:

```
{组件}/
├── README.md          # 这是什么 + Meta(版本/owner/状态)+ 30 秒摘要
├── business.md        # PM 视角:解决什么问题、覆盖什么场景、KPI 关联
├── research.md        # 用研视角 ★:用户痛点、调研数据、竞品对比
├── experience.md      # 体验设计师视角 ★:信息架构、流程、状态机
├── visual.md          # 视觉设计师视角 ★:Token 引用、视觉细则、变体
├── interaction.md     # 交互视角:手势、反馈、动效衔接
├── content.md         # 内容运营视角:文案规则、空状态、错误提示
├── donts.md           # 协作收集:反例、典型错误、踩过的坑
├── ai-schema.md       # AI 消费字段:JSON 描述、变体枚举、约束条件
├── CHANGELOG.md       # 版本日志(自动生成)
├── variants/          # 变体案例图(PNG / Figma 链接)
└── examples/          # 真实使用示例(部门 + 业务定位)
```

**为什么是 multi-md 而不是单 README?**

| 维度 | 单 README | multi-md |
|---|---|---|
| 多角色协作 | 一个人写,其他人评审 | 每个角色写自己专业的部分,降低 review 阻塞 |
| AI 消费 | 一次性塞 token,贵 | 按需 Read 对应文件,精准且省 token |
| 局部更新 | 改一个字段全 PR review | 改 visual.md 不影响 business.md 的 owner |
| 工具链对接 | Figma 插件难精准引用 | `visual.md#color-primary` 可锚定 |
| Git 冲突 | 经常多人改同一文件 | 角色分文件,冲突率显著下降 |

> **核心判断**:multi-md 不是为了"多",是为了**让贡献边界对齐组织角色边界**。

---

## 3. 章节详解(按 12 章顺序,标出归属 Zone 和拆分清单)

### 一、设计哲学(Zone 1 + 落到各组件 README)

**归属**:Zone 1 `knowledge/philosophy/`(顶层) + 每个组件 README.md 顶部引用

**拆分**:
```
knowledge/philosophy/
├── README.md              # 哲学总览(对外讲故事用)
├── focused-effective.md   # 聚焦实效:为转化让路 / 信息密度 / 决策路径
├── simple-unified.md      # 简洁统一:模块化 / 跨业务一致性
├── inclusive.md           # 多元包容:无障碍 / 老年模式 / 极端字号
└── brand-expression.md    # 品牌表现:京东红 #fa2c19 / Joy / 节庆基因
```

**为什么不直接写在 README**:四大原则是**判断标准**,要被每个组件、每次评审引用。独立成 md 让"我是否符合聚焦实效"可被锚链接(`philosophy/focused-effective.md#decision-path`)直接引用,不用复制粘贴。

**ai-schema 提示**:
```yaml
philosophy:
  principles:
    - id: focused-effective
      keywords: [转化, 信息密度, 决策路径]
      conflict_with: [decoration-heavy, brand-led-cta]
```

---

### 二、Design Tokens(Zone 2 / foundations)

**归属**:`foundations/tokens/`(W3C DTCG 兼容)

**拆分**:
```
foundations/tokens/
├── README.md           # Token 体系总览 + 命名规则(BEM)
├── color.md            # 色彩 Token(主品牌/语义/中性/功能/数据可视化)
├── typography.md       # 字体 Token(SF Pro/苹方/Roboto/思源黑体 + size/weight/lineheight)
├── spacing.md          # 间距 Token(4 的倍数体系)
├── radius.md           # 圆角 Token(0/4/8/12/16/24/full)
├── shadow.md           # 阴影 Token(elevation 0-5)
├── motion.md           # 动效 Token(duration / easing)
└── tokens.json         # 单一真相源(给开发/Figma/AI 消费)
```

**关键判断**:
- **tokens.json 是单一真相源**,其他 md 是它的"人类可读视图"
- **不允许在组件 visual.md 里写硬编码色值**,必须引用 `color.brand.primary`
- **深色模式映射在 color.md 中维护**(不另起 dark-color.md,Token 自带 light/dark variant)
- **设计 Token 与代码 Token 通过 Style Dictionary 双向同步**

**与 PDF 11.4 深色模式的关系**:深色模式不是独立 Zone,而是 Token 的一个 dimension。每个 color token 自带 `{ light: '#xxx', dark: '#xxx' }`。

---

### 三、视觉规范(Zone 2 / visual)

**归属**:`foundations/visual/`(用法层,引用 Token)

**拆分**:
```
foundations/visual/
├── README.md          # 视觉规范导航
├── color-usage.md     # 色彩用法(语义对照、组合规则、对比度)
├── typography.md      # 字体用法(标题/正文/辅助/数字 4 套阶梯)
├── icon.md            # 图标(线性/面性/双色 三种风格 + sizing 规则)
├── imagery.md         # 图像(商品图比例/banner/插画/吉祥物 Joy 用法)
├── layout.md          # 布局(栅格 4dp 基线 / 安全区 / 屏幕断点)
└── donts.md           # 视觉反例集合(从历史案例汇总)
```

**与 Token 的边界**:
- Token 回答"主色是什么"(`#fa2c19`)
- visual 回答"主色用在哪"(主 CTA、价格、加购、品牌区,**不**用于次要按钮、辅助说明)

---

### 四、交互规范(Zone 2 / interaction)

**归属**:`foundations/interaction/`

**拆分**:
```
foundations/interaction/
├── README.md
├── gesture.md         # 手势规范(点击/长按/滑动/双指 + 触发区域)
├── navigation.md      # 导航规范(Tab Bar / 顶导 / 返回 / 路由层级)
├── modal.md           # 模态规范(Toast / Dialog / Sheet / 全屏蒙层)
├── form.md            # 表单规范(输入/校验/键盘衔接/错误提示)
├── feedback.md        # 反馈规范(Loading / 空状态 / 错误状态 / 成功)
└── notification.md    # 通知规范(系统级/应用内/角标/消息中心)
```

---

### 五、动效规范(Zone 2 / motion)

**归属**:`foundations/motion/`

**拆分**:
```
foundations/motion/
├── README.md
├── principles.md      # 设计原则(目的导向/克制/物理感)
├── curves.md          # 曲线体系(ease-in/ease-out/spring,引用 Token)
├── duration.md        # 时长(immediate 100ms / fast 200ms / normal 300ms / slow 500ms)
├── choreography.md    # 编排(阶梯入场 / 元素串场 / 转场关系)
└── scenes.md          # 场景(加购飞动画 / 大促礼花 / 翻牌)
```

---

### 六、无障碍设计(Zone 5 / horizontal/a11y)

**为什么是横向 Zone**:无障碍不是某个组件的属性,是**所有组件都必须满足的横向约束**。WCAG 2.1 AA 是底线。

**归属**:`horizontal/a11y/`

**拆分**:
```
horizontal/a11y/
├── README.md          # WCAG 2.1 AA 京东实现总览
├── color-contrast.md  # 对比度规范(正文 4.5:1 / 大字 3:1 / 非文本 3:1)
├── touch-target.md    # 可点击区最小尺寸(44pt × 44pt)
├── screen-reader.md   # 旁白支持(VoiceOver / TalkBack 标签 / 顺序)
├── keyboard.md        # 键盘导航(主要用于 iPad / 折叠屏)
├── motion-reduce.md   # 减少动效(响应系统设置)
├── font-scaling.md    # 字号缩放(85%-150% 极端字号布局)
└── checklist.md       # 组件接入无障碍的 checklist(给 PR review 用)
```

**与组件的关系**:每个组件 `visual.md` 顶部必须列出"a11y 接入状态",链接到 `horizontal/a11y/checklist.md`。

---

### 七、基础组件库(Zone 2 / components-base)

**归属**:`foundations/components-base/`

**6 大类 → 6 个子目录**:
```
foundations/components-base/
├── action/        # 操作类:Button / IconButton / FAB / SegmentedControl
├── input/         # 输入类:Input / Textarea / Select / Picker / Switch / Slider
├── display/       # 展示类:Avatar / Badge / Tag / Card / Divider / Empty
├── navigation/    # 导航类:TabBar / NavBar / Breadcrumb / Pagination / Stepper
├── feedback/      # 反馈类:Toast / Dialog / Loading / Skeleton / Progress
└── data/          # 数据类:Table / List / Tree / Calendar / Chart
```

**每个组件目录** 都遵循 §2 的 multi-md 结构(README + business + research + experience + visual + interaction + content + donts + ai-schema + CHANGELOG + variants/ + examples/)。

**示例:Button 组件目录**:
```
components-base/action/button/
├── README.md          # 用途、状态(default/loading/disabled)、版本
├── business.md        # PM:覆盖 80%+ 操作场景,主 CTA 转化率指标
├── research.md        # 用研:点击区域感知边界、视障用户识别
├── experience.md      # 体验:层级(主/次/文字)、组合排布(横/竖)
├── visual.md          # 视觉:5 种尺寸(L/M/S/XS/Mini)× 4 种类型 × 5 种状态
├── interaction.md     # 交互:点击/长按/loading 状态衔接
├── content.md         # 文案:动词优先、字数上限、loading 文案规则
├── donts.md           # 反例:不要用品牌色做次要按钮、不要堆叠 3+ 主按钮
├── ai-schema.md       # AI 字段
└── CHANGELOG.md
```

**ai-schema.md 范例**(给 AI 生成 / 校验组件用):
```yaml
component: Button
version: 1.4.2
status: stable
props:
  size: [L, M, S, XS, Mini]
  type: [primary, secondary, text, danger]
  state: [default, hover, pressed, disabled, loading]
  block: boolean
  icon_position: [left, right, none]
constraints:
  - 主按钮一屏不超过 1 个(详见 donts.md#multiple-primary)
  - 文字按钮不能用品牌色(详见 visual.md#text-button-color)
a11y:
  min_touch_target: 44pt
  contrast_ratio: 4.5:1
  voiceover_label: required
```

---

### 八、业务组件库(Zone 4 / 各部门下)

**归属**:**不进 Zone 2**,而是按部门下沉到 Zone 4。

**为什么**:商品卡(`ProductCard`)在主站、超市、生鲜、健康四个事业部的形态完全不同,把它当"全公司共用"会变成最大公约数,失去差异化。**正确做法是各部门维护自己的 ProductCard 变体,共享 Zone 5 的双列卡治理规则**。

**目录范例**:
```
product-architecture/
├── retail-bg/                       # 主站事业群
│   ├── components-business/
│   │   ├── product-card/            # 主站商品卡
│   │   ├── cart-item/
│   │   └── coupon/
│   └── pages/
│       ├── home/
│       ├── search/
│       └── pdp/
├── fresh-bg/                        # 生鲜事业部
│   ├── components-business/
│   │   ├── product-card/            # 生鲜商品卡(产地/保鲜标记 不同)
│   │   ├── time-window-picker/
│   │   └── ...
│   └── pages/
└── health-bg/                       # 健康事业部
    └── ...
```

**8.x 子章节落位**:
- 8.1 商品组件 → 各部门 `components-business/product-*`
- 8.2 购物流程 → 各部门 `components-business/cart-*` + `pages/checkout/`
- 8.3 订单组件 → 各部门 `components-business/order-*`
- 8.4 搜索筛选 → 各部门 `components-business/filter-*`
- 8.5 用户中心 → `cross-bg/user-center/`(跨事业部)
- 8.6 营销组件 → 主站 `marketing/` + Zone 5 horizontal/promotion

**横向治理规则**:`horizontal/double-column-card/` 已有的双列卡 Skill 是横向治理范例——五大家族 DNA 跨部门通用,具体子卡型由各部门自主。

---

### 九、页面模板与场景规范(Zone 4 / pages)

**归属**:`product-architecture/{bg}/pages/`(每个事业部各自维护)

**12 个核心页面 → 12 个目录**(以主站为例):
```
retail-bg/pages/
├── home/              # 首页
├── search/            # 搜索页
├── category/          # 分类页
├── pdp/               # 商品详情(Product Detail Page)
├── cart/              # 购物车
├── checkout/          # 结算
├── pay/               # 支付
├── order/             # 订单
├── me/                # 我的
├── auth/              # 登录注册
└── message/           # 消息中心
```

每个页面目录依然遵循 multi-md(business / research / experience / visual / interaction + 模块清单 + 异常态)。

---

### 十、品牌与运营规范(Zone 5 / horizontal/brand)

**归属**:`horizontal/brand/`

**拆分**:
```
horizontal/brand/
├── README.md
├── logo.md            # Logo 使用、安全距离、最小尺寸、禁用变形
├── brand-color.md     # 京东红 #fa2c19、辅助品牌色
├── mascot-joy.md      # Joy 吉祥物使用规范
├── promotion/
│   ├── 618.md         # 618 视觉体系
│   ├── 1111.md        # 双 11 视觉体系
│   └── seasonal.md    # 春节/520/中秋等
├── decoration.md      # 装饰图形(扁平/渐变/3D)
└── sub-brands.md      # 子品牌(京东超市/京东健康/京东金融 等)的视觉差异化边界
```

---

### 十一、多端适配规范(Zone 5 / horizontal/multi-platform)

**归属**:`horizontal/multi-platform/`

**拆分**:
```
horizontal/multi-platform/
├── README.md
├── ios-android-diff.md    # iOS / Android 差异表(导航/Tab/字体/手势/状态栏/弹窗)
├── screen-size.md         # 屏幕尺寸适配(320/375/414/430/折叠展开)
├── ipad.md                # 平板双栏布局
├── dark-mode.md           # 深色模式(链回 tokens/color.md 的 dark variant)
└── font-scaling.md        # 字体缩放(链回 a11y/font-scaling.md)
```

**关键设计**:不在这里**复述** Token,而是**指引到 Token + 列出例外情况**。

---

### 十二、设计系统治理(Zone 3 + Zone 5)

**为什么跨两个 Zone**:
- 流程类(贡献流程、版本管理、文档维护、QA)→ Zone 5 horizontal/governance
- AI 协议类(组件命名 BEM、Schema 同步、Token 工具链)→ Zone 3 ai-mechanism

**Zone 5 部分** `horizontal/governance/`:
```
├── README.md
├── org.md             # 组织架构(联邦制 vs 集中制)
├── contribution.md    # 组件贡献流程(提案 → 评审 → 实现 → 文档 → 发布)
├── versioning.md      # 版本管理(SemVer + Breaking Change 通知)
├── design-dev-collab.md  # 设计开发协作(标注/Design QA/Token 实现)
├── doc-maintenance.md # 文档维护责任人 + 更新周期
└── quality.md         # 质量保障 checklist
```

**Zone 3 部分** `ai-mechanism/`:
```
├── README.md                # AI 消费总览
├── naming-bem.md            # BEM 命名(Block/Element/Modifier)
├── token-sync.md            # Design Token ↔ Code Token 同步机制
├── figma-organization.md    # Figma 文件组织(Library / 页面 / 图层命名)
├── schema-spec.md           # ai-schema.md 字段规范
├── ai-skills/               # 各类 Skill(双列卡 / 大促适配 / 无障碍 review)
└── agent-protocol.md        # Agent 评审契约
```

---

## 4. AI Schema 总约定(给 Agent 消费)

每个组件 / 业务单元的 `ai-schema.md` 必须遵守同一套字段约定,这样 AI 才能跨组件批量消费。

```yaml
# ai-schema.md 标准字段

meta:
  component_name: string         # 组件名(BEM Block)
  zone: enum[foundations, knowledge, ai-mechanism, product-architecture, horizontal]
  version: semver
  status: enum[experimental, beta, stable, deprecated]
  owner_role: string             # 维护责任角色
  ai_consumable: boolean         # 是否已通过 AI 消费验证

props:
  # 各 prop 的枚举值 / 约束 / 默认值

variants:
  # 变体清单 + 适用场景

constraints:
  # 硬约束(违反即报错)
  # 软约束(违反需 review)

a11y:
  min_touch_target: pt
  contrast_ratio: ratio
  voiceover_label: enum[required, optional, auto]

dependencies:
  tokens: [color.brand.primary, spacing.4, radius.8]
  components: [Icon, Loading]

related_skills:
  - skill_id
  - skill_id
```

---

## 5. 跨 md 引用规范(让 AI 能跳转)

**绝对路径锚点**(推荐):
```
[[foundations/tokens/color.md#brand-primary]]
[[product-architecture/retail-bg/pages/pdp/visual.md]]
[[horizontal/double-column-card/SKILL.md#family-dna]]
```

**相对路径**(同目录内):
```
[[./donts.md#multiple-primary]]
[[../button/visual.md]]
```

**禁止**:模糊指向("详见相关规范")—— AI 无法解析,人也得猜。

---

## 6. 路径速查(给人类用)

| 我想找... | 去哪里 |
|---|---|
| 设计哲学和四大原则 | `knowledge/philosophy/` |
| 主色 / 字体 / 间距等 Token | `foundations/tokens/` |
| 视觉用法、栅格、icon 风格 | `foundations/visual/` |
| 手势、导航、表单规则 | `foundations/interaction/` |
| 动效曲线 / 时长 / 编排 | `foundations/motion/` |
| 一个原子组件(Button、Input 等) | `foundations/components-base/{category}/{component}/` |
| 主站商品卡 | `product-architecture/retail-bg/components-business/product-card/` |
| 主站首页 / PDP / 购物车 | `product-architecture/retail-bg/pages/{page}/` |
| 京东红、Logo、Joy、618 | `horizontal/brand/` |
| iOS / Android 差异 | `horizontal/multi-platform/ios-android-diff.md` |
| 深色模式 | `horizontal/multi-platform/dark-mode.md` + `foundations/tokens/color.md` |
| 无障碍 checklist | `horizontal/a11y/checklist.md` |
| 双列卡治理 | `horizontal/double-column-card/SKILL.md` |
| 组件贡献流程 | `horizontal/governance/contribution.md` |
| AI Skill / Agent 协议 | `ai-mechanism/` |

---

## 7. 与 PDF 大纲的差异声明

PDF 大纲 v1.0 是**信息架构清单**,DESIGN.md 是**物理落地结构**。两者的差异都是**有意识的**:

| 大纲章节 | DESIGN.md 处理 | 理由 |
|---|---|---|
| 一、设计哲学 | 拆 4 个独立 md + 各组件 README 引用 | 让"是否符合哲学"可锚定引用 |
| 二、Token + 三、视觉规范 | 分两个目录(tokens / visual) | Token 是机器读,visual 是人读 |
| 七、基础组件库 | 按"操作/输入/展示/导航/反馈/数据"6 大类分目录 | 让贡献者能精准 own |
| 八、业务组件库 | **下沉到事业部目录,不进 foundations** | 业务组件本就是差异化的,共建会丢特色 |
| 十、品牌运营 | 子品牌、大促、装饰拆开 | 大促有时效性,子品牌有边界,不能混 |
| 十二、治理 | 流程进 horizontal,Schema 进 AI 机制 | 治理一半给人,一半给 AI,目标不同 |

---

## 8. 接下来怎么用

**业务线设计师**(贡献者视角):
1. 看 `horizontal/governance/contribution.md` 了解贡献流程
2. 找到自己事业部的 `product-architecture/{bg}/` 目录
3. 创建 / 维护组件目录,按 multi-md 结构填充
4. 视觉、内容、交互、用研同事各写各的 md
5. PR 评审,合入

**业务线 PM**:
1. 直接看 `business.md` 部分
2. 了解组件覆盖什么场景、KPI 怎么挂

**总部体验组**(Zone 2 维护者):
1. 维护 `foundations/` 全部内容
2. 评审各事业部贡献的横向规则提案

**AI Agent**:
1. 第一次 Read 本 DESIGN.md 拿到全局拓扑
2. 根据用户问题精准 Read 对应 md
3. 引用时使用 `[[路径#锚点]]` 格式

---

## 9. 待办与开放问题(诚实标注)

- [ ] 各组件目录的实际填充(预计 P1 阶段产出 5-10 个示范组件)
- [ ] tokens.json 的 W3C DTCG 化(目前各业务线 Token 命名不一)
- [ ] Figma Library 与本仓库的双向同步机制(需要插件支持)
- [ ] AI Skill 与组件 ai-schema.md 的自动化校验(CI 任务)
- [ ] 第三方商家入驻的视觉规范边界(10.3 章,目前只有大纲,无细则)
- [ ] 折叠屏 / iPad 的具体页面布局示例(11.3 章待补)
- [ ] 各事业部 owner 名单(governance/org.md 目前空,需各 BG 提名)

---

## 10. 版本与变更

```
v1.0 · 2026-04-29
  · 初版,基于 JD APP 设计系统大纲 v1.0 落地为 multi-md 结构
  · 完成 5 Zone × 12 章节的映射
  · 定义 multi-md 标准结构和 ai-schema 字段约定
```

下一版方向:
- v1.1:补充 5-10 个示范组件目录(Button / Input / ProductCard / TabBar 等)
- v1.2:tokens.json 完整版,Style Dictionary 双向同步打通
- v2.0:全量组件迁移完成,启动 AI 自动化评审

---

> **DESIGN.md 是入口,不是全部**。要看具体规范请按 §6 路径速查跳转。任何看不到 md 的地方,要么是 P1 阶段还没写,要么是该规则不存在(不是漏写)——别替系统脑补。
