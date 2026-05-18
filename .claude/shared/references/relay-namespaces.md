# Relay sharedPluginData namespace 注册表

> Relay 节点的 `sharedPluginData` 一旦写入会永久挂在节点上(除非显式删除),写 namespace 前必须在本注册表登记。未登记的 namespace **禁止**写入。

## 注册表

| namespace | owner skill | 写入步骤 | keys | 生命周期 | 清理触发 |
|---|---|---|---|---|---|
| `jd-design-wiki` | `relay-to-design-md` | Step 10.5(写完 design.md 后回写) | `design_md_path` / `last_synced` / `slug` / `level` / `bg` | **永久**(双向追溯依赖,Relay 端反查 md 路径用) | 仅当 design.md 文件被永久删除时:relay-to-design-md 下次跑同节点要先清旧 keys(TBD) |
| `jd-spec-page-assets` | `design-md-to-spec-page` | Step 5b(chunked b64 切图导出) | `chunk_0` / `chunk_1` / ... / `chunk_count` / `mime` / `node_id` | **临时**(单次 spec-page 生成中转用) | Step 6 渲染完 spec-page.html 后,**必须**调 `use_design_script` 删本 namespace 全部 keys |

## 写入规范

1. **写之前**确认 namespace 在表中。新增 namespace 需先 PR 加进本表 + 列出 owner / 生命周期 / 清理触发,**不允许**直接代码里起新 namespace。
2. **永久** namespace:写入前先读旧值,若已存在且未变化就不重写(避免 Relay 文件版本号无意义跳动)。
3. **临时** namespace:对应 skill 的 SKILL.md 里必须显式写明清理步骤,且失败回滚也要清理(否则切图 b64 残留会让 Relay 文件膨胀到几 MB)。
4. **不允许**跨 skill 读他人 namespace —— 如果需要,应抽到本表并标 owner = 多个。

## 失败处理

- 永久 namespace 写失败:**不阻断**主流程(design.md 已落盘是核心产物),但要在终端**醒目** ⚠️ 提示用户手动重跑回写。当前 relay-to-design-md Step 10.5 满足这条。
- 临时 namespace 清理失败:**阻断**结束,要求用户手动跑清理 helper(避免膨胀)。当前 spec-page Step 5b 清理是"可选"——属于已知风险,见 TODO。

## 调试入口

查看某节点当前所有 namespace:

```js
node.getSharedPluginDataKeys('jd-design-wiki')      // ['design_md_path', 'last_synced', ...]
node.getSharedPluginDataKeys('jd-spec-page-assets') // 正常应为空,有值 = 上次没清理干净
```

清理所有 namespace 的 helper(应急):

```js
['jd-design-wiki', 'jd-spec-page-assets'].forEach(ns =>
  node.getSharedPluginDataKeys(ns).forEach(k => node.setSharedPluginData(ns, k, ''))
)
```

> 注意:Relay 没提供 `deleteSharedPluginData`,只能 set 空字符串。空字符串 = 已清理。

## 变更规则

新增 / 改用途 / 改清理触发 → 必须同步:
1. 本注册表行
2. owner skill 的 SKILL.md 对应步骤
3. owner skill 的 `references/` 里相关详细文档(如 spec-page `references/stage-images-export.md`)
