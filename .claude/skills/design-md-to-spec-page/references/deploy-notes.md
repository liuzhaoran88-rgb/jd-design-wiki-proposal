# 部署到 GitHub Pages 的 2 个坑(v0.3.1 实战记录)

> 不在 skill 主流程(Step 1-8 不动文件之外),但 user 把 spec-page.html 推到 GitHub Pages 后会撞这 2 个,提醒一下。

---

## 坑 1:`.nojekyll` 是必须的(否则切图 404)

GitHub Pages 默认走 Jekyll 渲染。**Jekyll 忽略以 `_` 开头的文件 / 目录** —— 比如 `_assets/`、`_layouts/`、`_drafts/` 等。

我们的切图统一放在 `<bundle-dir>/_assets/` 下,所以默认部署上去**所有切图都会 404**。

修法:仓库根目录加 `.nojekyll` 空文件:

```bash
touch .nojekyll
git add .nojekyll
git commit -m "fix(pages): 加 .nojekyll 让 GitHub Pages 跳过 Jekyll"
git push
```

`.nojekyll` 让 Pages **跳过 Jekyll**,所有文件原样 serve。

> ⚠️ 如果仓库根已有 `.nojekyll`,跨多个组件 spec-page 共享,不需要每次重建。

> 替代方案:把 `_assets/` 改名为 `assets/`(不带下划线)。但 v0.2 模板和已落地产物都用 `_assets/`,改名成本大;`.nojekyll` 是 1 个空文件解决所有 underscore 目录的统一办法。

---

## 坑 2:GitHub Pages CDN 缓存 404 / 旧文件

GitHub Pages 用 Fastly CDN,**默认 cache 10 分钟左右**。即使源已经修了:

- 之前 404 的资源 → CDN 缓存住 404,后续请求仍命中缓存
- 之前 200 的资源 → 改完文件后,旧版本仍可能被 serve 10 分钟

修法:**给 HTML 内引用资源 URL 加 query string 强制 cache-bust**。

```html
<!-- 之前 -->
<img src="./_assets/sec-3-island-promo.png">

<!-- 改后 cache-bust -->
<img src="./_assets/sec-3-island-promo.png?v=2">
```

每次 `_assets/*` 内容真的有更新,把 `v=N` 递增。或者:

- 用 git commit short hash 作为 v= 值
- 用 build timestamp(YYYYMMDD)

skill 渲染 spec-page.html 时,**默认给每个 `<img src="./_assets/...">` 自动加 `?v={today_iso_or_commit}`**(v0.4 计划)。

### 用户视角的快速 unblock

如果发现页面切图加载不出,先做这两步:

1. **强刷浏览器**:`Cmd + Shift + R` / `Ctrl + Shift + R` 绕过浏览器自身缓存
2. **等 5-10 分钟** 让 CDN 自然失效
3. **诊断**: `curl -sI <img-url>` 直接拿到 200 + image/png 才算源 OK
4. **直接访问图片 URL**(`<spec-page-url>../_assets/<name>.png?v=N`)看是否能拿到图,排除 CDN

---

## 坑 3:私有仓的限制(顺便记录)

GitHub Pages **不支持私有仓**(除非升级 GitHub Pro / Team / Enterprise)。

如果 design wiki 是私有 repo,选项:

| 方案 | 优点 | 缺点 |
|---|---|---|
| 临时改 Public + 看完改回 Private | 0 成本 | 改回 Private 时 Google / 搜索引擎可能已 index,缓存几天 |
| Cloudflare Pages 连接 GitHub | 支持私有仓,持久 URL | 配 build settings + 绑域名 |
| Cloudflare R2 + Public URL | 支持私有仓的产物上传 | 需 wrangler CLI + dashboard 启 Public Development URL |
| Surge.sh 单独部署 | 一行命令 `npx surge .` | 跟仓库脱钩,改完要重 deploy |
| GitHub Pro($4/月) | 私有仓也能 Pages | 付费 |

实战推荐:
- **短期 / 老板看一次** → 临时 Public + 后续 Private
- **长期 / 团队访问** → Cloudflare Pages / R2(永久免费 tier)

---

## 部署后 checklist

1. [ ] 浏览器打开 spec-page URL,默认进入 mode-basic
2. [ ] 切换"专业版" tab,token 表 / DP / API 速查正常显示
3. [ ] 至少抽 2 张 stage 切图,**直接 curl 拿 200 + image/png**(排除 CDN cache)
4. [ ] 点击切图能在新 tab 打开原图(zoom-in 链接)
5. [ ] 强刷浏览器一次,确认没有 304 cache 残留
6. [ ] 移动端访问(iPhone Safari / Android Chrome)at least 一台,确认响应式 OK
