# docs/assets/ · 设计站点静态资产

`docs/design.html` 引用的图片切图，从 Relay 设计文件**手动导出**后扔进这里。

> 为什么手动？`mcp__zero-design__get_screenshot` 返回的截图只在 Claude 对话上下文里以图像形式出现，**无法直接落盘成 PNG**（架构限制）。所以设计师 / Owner 需要在 Relay 桌面端选中目标节点，右键 Export → PNG，再放到本目录对应路径。

## 资产清单

| 文件 | 来源 | 用途 | 尺寸 |
|---|---|---|---|
| `banner-art.png` | Relay file `2054468374020227073` 节点 **`6:229;6:10`**（`Untitled@2x 2.png_7NySLs`） | banner 右侧装饰图（site banner + spec banner 共用） | 548×240（@2x 建议 1096×480） |

## 切图规范

- **格式**：PNG（透明背景 OK，会与 banner 的浅灰底叠加）
- **导出倍率**：建议 @2x（即 1096×480），CSS 用 `background-size: cover` 自动适配 548×240 容器
- **路径**：`docs/assets/<文件名>.png`
- **命名**：kebab-case，描述用途（不写 Relay 节点 ID）

## Fallback

若资产文件不存在（404 加载失败）：
- `banner-art.png` 缺失 → `docs/design.html` 的 banner 右侧退化为「粉球 + 紫晕」径向渐变占位（CSS 中预置）
- 整版仍可用，只是装饰效果差点意思

## TBD

- 截图自动化 —— 若未来 Relay MCP 暴露可下载 URL 或者 `use_design_script` 能导出图，本目录可改为脚本生成
- 每个 spec 单独的截图（`docs/assets/<spec-slug>.png`），目前 spec 截图复用 `jd-design-system-md-v16/.../preview.png`，是否要迁移到本目录待定
