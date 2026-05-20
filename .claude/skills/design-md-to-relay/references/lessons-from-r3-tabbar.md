# R3 Tabbar 走查实录 · skill 设计依据

> 本文是 `design-md-to-relay` skill 8 步工作流 + 4 条核心规则的**完整由来**。每条规则都对应一处具体踩坑。
>
> 实录时间:2026-05-20
> 实录文件:Relay `2002743945242628098`(MCP 写入能力测试)/ R3 区
> 实录组件:Tabbar(Joy Agent 形态 + 4 坑位 + 选中态)
> 实录依据:wiki v0.6 · `jd-design-system-md-v16/horizontal/components-base/tabbar/design.md`

## 完整时间轴

```
14:00  开始:基于 wiki v0.6 在 375×812 画 tabbar + Joy Agent
14:15  R3-v1:Auto Layout 还没用,手算 x/y 凑居中
14:25  发现 label「首页」偏左 12 DP,以为是 PNG 切图内部居中问题
14:35  深查发现是 textAlignHorizontal='CENTER' 没生效(textAutoResize 没锁)
14:45  R3-v2:重构改用 Auto Layout(VERTICAL + 双向 CENTER)
14:55  发现选中态 bg 只罩 atom (44×44),应该是 slot 全宽
15:05  R3-v3:bg 上移到 slot 层,撑满 79.75
15:15  对照 Zero spec 图发现 bg 应该 L/R inset 各 4 DP
15:25  R3-v4:在 slot 内引入 pill 容器,bg 在 pill 上 (71.75 × 44)
15:35  用户问 icon 为什么 PNG,要 SVG
15:45  R3-v5:替换 4 个 PNG icon 为 SVG(createFrameFromSvgAsync)
15:50  全部踩坑梳理为 issue #60 4 个 gap
```

## 4 处反复错的根因

### 错 1 · 选中态 bg 尺寸算错 2 次

- **第一版**:bg = 44×44(只罩 atom)
- **第二版**:bg = slot 全宽 79.75 × 44(漏了 inset)
- **真实**:bg = 71.75 × 44(L/R 各 inset 4 DP)

**根因**:wiki `design.md` 02.4 表「背景」列只写「灰阶 / gray_6」,**没写 bg 尺寸 / inset / 圆角**。我只从文字脑补,没去读 Relay 原版组件 `266:475` 的实际子节点 bounds。

读了 ground truth 才发现:Relay 里那个组件的选中 bg 就是「`(slot 宽 − 8) × 44`,R12」。

→ 沉淀为 skill **Step 3 · Probe Relay ground truth ★**
→ 升级为 wiki gap [issue #60 Gap 1](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60)(02.4 表加列)+ [Gap 2](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60)(Relay 节点 anchor 为 ground truth)

### 错 2 · icon 与 label 视觉错位 12 DP

- icon 居中位 22 DP(atom 内坐标),label「首页」实际渲染中心位 10 DP,**差 12 DP**

**根因**:我设了:

```js
lbl.characters = '首页';
lbl.fontName = pingfangSemibold;     // 顺序错:characters 后 set font
lbl.textAlignHorizontal = 'CENTER';
lbl.resize(44, 14);                  // textAutoResize 没显式锁 NONE
```

两个问题叠加:

1. characters 先 set 时 font 还没就位,后续 fontName 重设过程中 alignment 被静默忽略
2. textAutoResize 默认 `WIDTH_AND_HEIGHT`,文字框逻辑宽 = 内容宽 ≈ 20,textAlignHorizontal='CENTER' 在 20 DP 框内居中而非 44 DP 外框

修法:**改用 Auto Layout 接管对齐,完全不依赖 textAlignHorizontal**:

```
atom (44×44, VERTICAL Auto Layout, primary CENTER, counter CENTER, itemSpacing 4)
  ├── icon (20×20)
  └── label (text, textAutoResize 默认即可)
```

父 frame Auto Layout 把两个子节点都居中,label 不论实际宽多少都对齐 icon 中线。

→ 沉淀为 skill **Step 5 · Plan structure with Auto Layout ★**
→ 升级为 wiki gap [issue #60 Gap 3](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60)(明文写 Auto Layout 规则,反模式 text.resize 标黑)

### 错 3 · 状态背景挂错节点层

- 第一版 selected bg 挂在 atom(44×44)上 → 后来要扩到 slot 宽时被 atom 大小锁死
- 必须把 atom 撑大,但 atom 是行为容器,撑大破坏「44×44 atom」语义
- 第二版上移到 slot 层,但又导致整个 slot 被 bg 占满
- 最终引入 Pill 容器作为视觉层,职责分离

**根因**:我把「视觉(选中 bg)」和「行为(icon+label 容器)」叠加到同一个 frame。

修法:**层职责分离**:

```
slot (HORIZONTAL Auto Layout, paddingLR=4, counterAxisStretch)
  └── pill (layoutGrow=1, layoutAlign=STRETCH)   ← 视觉层:bg / R12
       └── atom (VERTICAL Auto Layout, center+center)  ← 行为层:icon+label 容器
            ├── icon
            └── label
```

3 个 frame,各自管一件事。状态切换只动 pill 的 fill / cornerRadius。

→ 沉淀为 skill **Step 5 · 层职责分离**(规则 4)
→ 跟 [issue #60 Gap 3](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) 合并(Auto Layout pattern 一并明文化)

### 错 4 · 资产用 PNG 而非 SVG

- 4 个 slot icon 都用了 PNG(从 `_assets-cdn.md` 拉的京东 CDN)
- 视觉上糊,缩放退化
- 设计师手里有 SVG 源,但 wiki 不知道

**根因**:`_assets-cdn.md` Atom 切图表里**只登记 PNG URL**,没有 SVG 字段。AI 看清单 → 默认 PNG。

修法:

1. SVG 优先,PNG 仅 fallback
2. `createFrameFromSvgAsync(svg)` 接 SVG string
3. 用户提供的 home-active / home-default SVG 顶替 PNG(已落实 R3-v5)

→ 沉淀为 skill **Step 6 · Fetch assets · SVG 优先**(规则 3)
→ 升级为 wiki gap [issue #60 Gap 4](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60)(`_assets-cdn.md` 表头加 svg_url / png_fallback_url 双列)

---

## 从踩坑到 skill 规则的映射表

| R3 踩坑 | skill 沉淀 |
|---|---|
| 选中 bg 算错(没读 Relay 原版) | Step 3 · Probe Relay ground truth |
| label 偏 12 DP(textAlignHorizontal 不生效) | Step 5 · Auto Layout 取代手算 |
| selected bg 挂错层 | Step 5 · 层职责分离 |
| icon 用 PNG | Step 6 · SVG 优先 |
| wiki 字段不闭合 | Step 4 · Diff & report wiki gaps |
| 实现完没自校验 | Step 8 · Post-verify |

## 这次走查的元教训

> wiki 假设读者是「人 + 有缺省常识」。
> 但目标读者是 AI 时,**默认值必须明文写**,缺省 = 错。

这条元教训驱动了 issue #60 整个的存在。skill `design-md-to-relay` 是 issue #60 修完后的「正确做法固化」;issue #60 是 skill 设计中暴露的「wiki 不闭合点」反馈。两者互为产物。

## 关联材料

- **R3 设计稿**:`https://relay.jd.com/file/design?id=2002743945242628098&page_id=54:465&node_id=59:1355`
- **upstream issue**:[ShuaiMXu/jd-design-wiki-proposal#60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60)
- **wiki 源**:`jd-design-system-md-v16/horizontal/components-base/tabbar/design.md` v0.6
