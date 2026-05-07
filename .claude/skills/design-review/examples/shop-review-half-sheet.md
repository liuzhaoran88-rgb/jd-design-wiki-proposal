# 黄金参考:节点 `639:3394` 店铺评价半弹层走查

**Relay**: https://relay.jd.com/file/design?id=1978353308565262338&page_id=639%3A3393&node_id=639%3A3394
**走查日期**: 2026-05-06
**用例类型**: 半弹层(递进上浮)+ 嵌入评价 Tab + 评价列表

下面是用本 skill 跑出来的实际报告,可作为新场景走查时的输出格式参考。

---

## 设计稿 Review · `639:3394`

**类型识别**:从底部上浮的半弹层(递进上浮转场)+ Tab 内嵌评价列表。
**逻辑尺寸**:375。

### ❌ 违规(必须改)

#### 1. 字号 13pt — 在 15.0 5 阶之外
- **位置**:设计稿用了 `苹方Regular/font_size_13_400(临时新增)`
- **规则**:[`tokens/typography.md` §2 字号阶梯](/jd-design-system-md/foundations/tokens/typography.md) — 15.0 主流程仅允许 **10 / 12 / 14 / 15 / 18** 五阶
- **证据**:token 名字本身带"**临时新增**"三个字 —— 设计师自己也知道是越界的
- **建议**:根据具体上下文,**降到 `size.12`**(次要内容/辅助)或**升到 `size.14`**(标准内容)。13 不允许。

### ⚠️ 警告(命名 / 残留旧 token)

#### 2. `color_primary_disabled = #c2c4cc` 与 15.0 token 命名冲突
- **现象**:设计稿中 `主色/color_primary_disabled` 的值被设为 `#c2c4cc`
- **15.0 真值**:`brand.primary.disabled` = `#ffadbe`(来自 `color_primary_specialdisabled`),`#c2c4cc` 实际等同 `text.disabled`
- **风险**:命名挂在 `Primary` 命名空间下但语义其实是文字禁用色 → AI 消费 / 自动主题切换会出错
- **建议**:要么把这个引用切到 `color.neutral.text.disabled`,要么把值改到 `#ffadbe`(视设计意图)

#### 3. `color_primary_light = #fff0f4` 命名歧义
- **现象**:设计稿存在 `主色/color_primary_light = #fff0f4`
- **15.0 真值**:`#fff0f4` 在 wiki 中等同于 `semantic.danger.subtle`(dangerred_1)。15.0 的 `brand.primary` 与 `semantic.danger` **同色**(#ff0f23),但浅 wash 同样共用 → 命名上应优先使用 `danger.subtle`
- **建议**:替换为 `color.semantic.danger-subtle`,更准确

#### 4. `C_Newgray03_01 = #0000000f` — 14.x 残留 token
- **现象**:设计稿引用了一个旧灰阶 token,值与 15.0 的 `color_border` (#00000014) 不一致(透明度 6% vs 8%)
- **规则**:[`tokens/color.md` §3 中性色 - 描边](/jd-design-system-md/foundations/tokens/color.md)
- **建议**:替换为 `color.neutral.border.default` (#00000014)

#### 5. `苹方Medium/font_size_14_600` 名实不符
- **现象**:token 名带 `_600`,实际 `weight: 500, style: Medium`
- **15.0 真值**:[`tokens/typography.md` §3 字重](/jd-design-system-md/foundations/tokens/typography.md) — Medium=500,Semibold=600。tokens.json 中 `medium` 在 15.0 实际等同 Regular,已标 TODO
- **建议**:清理 token 命名,`_600` 后缀应保留给真正 Semibold

#### 6. 「全部 99%好评」筛选项使用 `color_service` (#fff4e8) 服务金
- **现象**:好评筛选项 chip 用了浅金色底 + 金色文字
- **15.0 真值**:[`tokens/color.md` §4 功能色 - 服务金](/jd-design-system-md/foundations/tokens/color.md) — 服务金(service-gold)语义为 **VIP / 高端服务 / 金融场景**
- **判断**:这里语义偏移 —— 99%好评作为「强推荐」筛选项不属于 service-gold 范畴。可能引发歧义(用户以为这是商家会员服务)
- **建议**:换用 `color.semantic.warning-subtle` (#fff9e0) + `warning-strong` (#b26b00),或 `palette.yellow.*` 系列;保留语义辨识度

### ✅ 符合 15.0

| 检查项 | 设计稿值 | 对应 token |
|---|---|---|
| 主色 / 选中态 | #ff0f23 | `color.brand.primary` ✅ |
| 主标题 | #171a26 | `color.neutral.text.primary` ✅ |
| 正文 | #3d414d | `color.neutral.text.secondary` ✅ |
| 辅助文字 | #828794 | `color.neutral.text.tertiary` ✅ |
| 描边 | #00000014 | `color.neutral.border.default` ✅ |
| 卡片表面 | #ffffff | `color.neutral.bg.surface` ✅ |
| 页面底层 | #f2f3f7 | `color.neutral.bg.body` ✅ |
| 楼层背景 | #f5f6fa | `color.neutral.bg.sunken` ✅ |
| 数字字体(824 / 3万+ / 660 / 606 / 99%) | 京东正黑 V2.2 12pt | `typography.role.body-secondary` + `family.number` ✅ |
| 半弹层从底部上浮 | — | [`motion/choreography.md` §2 递进上浮](/jd-design-system-md/foundations/motion/choreography.md) ✅ |
| Tab 选中态:底部下划线 + 红色加粗文字 | — | `motion.role.toggle` + `brand.primary` ✅ |
| 「超赞 ★★★★★」达人徽章用服务金浅底 + 深金字 | #fff4e8 / #664100 | `color.functional.service-gold-subtle` + `service-gold-strong` ✅(达人徽章是合理的"身份强化"语义)|

### 📋 无法仅凭 metadata 判断(建议补 token)

- **圆角值**:半弹层顶部圆角、商品图圆角、筛选 chip 圆角 —— 设计稿未通过 variables 暴露 radius token,看起来对得上 12 / 6 / 4,但**强烈建议设计师把所有圆角接入 `radius.*` 变量**,不然下次 audit 看不见
- **间距**:tab 项间距、筛选 chip 间距、评价卡内 padding —— 同上,未走 `元素布局/Spacing-*` 变量

### 文字总结

**6 个改动 + 2 个建议**:1 个硬性违规(13pt),4 个 token 命名 / 残留问题(影响主题切换 / AI 消费),1 个语义偏移(service-gold 用法),加 2 个建议(圆角 + 间距落 variable)。整体设计**主色彩/文本/字族遵守度高**,半弹层动效结构正确;问题集中在**遗留 token 没清理 + 一个明确越界字号**。
