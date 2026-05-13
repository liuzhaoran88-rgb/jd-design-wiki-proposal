#!/usr/bin/env bash
#
# sync-index.sh — 全自动重建 INDEX.md (skill v0.3+)
#
# 扫所有 design.md 解析 frontmatter，按 level + bg 重新分组排序，重写 INDEX.md
# 处理：
#   - 删了的 design.md → 从 INDEX 移除
#   - 移了 / 重命名了 → INDEX 重新指对
#   - INDEX 里漏的 design.md → 补齐
#   - 同 slug 冲突 → 警告
#
# 用法：
#   bash bin/sync-index.sh                     # dry-run 看 diff
#   bash bin/sync-index.sh --write             # 写回 INDEX.md
#   bash bin/sync-index.sh --push-shared-data  # 列出需要回写 sharedPluginData 的节点
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
INDEX_FILE="$SKILL_DIR/INDEX.md"

WRITE_MODE=false
PUSH_SHARED_DATA=false
for arg in "$@"; do
  case "$arg" in
    --write) WRITE_MODE=true ;;
    --push-shared-data) PUSH_SHARED_DATA=true ;;
    --help|-h)
      sed -n '2,16p' "$0"
      exit 0
      ;;
  esac
done

# ============================================================
# 工具
# ============================================================

get_field() {
  local file=$1 key=$2
  awk -v key="$key" '
    /^---$/ { fm = !fm; next }
    fm && $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "")
      gsub(/^"|"$/, "")
      print
      exit
    }
  ' "$file"
}

get_nested_field() {
  local file=$1 key=$2
  awk -v key="$key" '
    /^---$/ { fm = !fm; next }
    fm && $0 ~ "^[[:space:]]+" key ":" {
      sub("^[[:space:]]+" key ":[[:space:]]*", "")
      gsub(/^"|"$/, "")
      print
      exit
    }
  ' "$file"
}

# ============================================================
# 扫描 + 解析所有 design.md
# ============================================================

# bash 3.x 兼容：不用 mapfile / readarray
ALL_FILES=()
while IFS= read -r line; do
  ALL_FILES+=("$line")
done < <(find \
  "$REPO_ROOT/jd-design-system-md-v16" \
  "$SKILL_DIR/examples" \
  -name 'design.md' -type f 2>/dev/null | sort)

# 用 TAB 作为内部字段分隔（slug/bg/row），避免与 markdown table `|` 冲突
declare -a ENTRIES_L1
declare -a ENTRIES_L2
declare -a ENTRIES_L3
declare -a ENTRIES_L4

DUPLICATE_SLUGS=()
# bash 3.x 兼容：用换行分隔的字符串模拟 set
SEEN_SLUGS=$'\n'

TOTAL_FILES=0

for f in "${ALL_FILES[@]}"; do
  [[ -z "$f" ]] && continue
  TOTAL_FILES=$((TOTAL_FILES + 1))

  level=$(get_field "$f" "level")
  bg=$(get_field "$f" "bg")
  slug=$(get_field "$f" "slug")
  owner=$(get_field "$f" "owner")
  last_synced=$(get_field "$f" "last_synced")
  file_id=$(get_nested_field "$f" "file_id")
  page_id=$(get_nested_field "$f" "page_id")
  node_id=$(get_nested_field "$f" "node_id")

  [[ -z "$slug" ]] && continue

  relpath="${f#$REPO_ROOT/}"

  # slug 冲突检测（同 bg+level 内）— bash 3.x 兼容：grep 换行字符串
  key="$bg/$level/$slug"
  if echo "$SEEN_SLUGS" | grep -qFx "$key"; then
    DUPLICATE_SLUGS+=("$slug ($relpath)")
  fi
  SEEN_SLUGS="${SEEN_SLUGS}${key}"$'\n'

  # 完整 row（markdown table 格式）
  row="| $slug | [$relpath](../../../$relpath) | \`$file_id / $page_id / $node_id\` | $owner | $last_synced |"

  # 用 TAB 分隔 bg / slug / row 用于后续按 bg 分组 + 按 slug 排序
  entry=$(printf '%s\t%s\t%s' "$bg" "$slug" "$row")

  case "$level" in
    component-base)     ENTRIES_L1+=("$entry") ;;
    component-business) ENTRIES_L2+=("$entry") ;;
    page)               ENTRIES_L3+=("$entry") ;;
    flow)               ENTRIES_L4+=("$entry") ;;
  esac
done

# ============================================================
# 排序辅助：按 (bg, slug) 字典序输出 row
# ============================================================

sort_rows() {
  # stdin: TAB-separated lines (bg<TAB>slug<TAB>row)
  # stdout: 排序后只保留 row 部分（cut -f3-）
  sort | cut -f3-
}

sort_rows_with_bg() {
  # 输出 bg<TAB>row 用于按 bg 分组
  sort | cut -f1,3-
}

# ============================================================
# 生成 INDEX.md
# ============================================================

{
  cat << HEADER
# Design Wiki Index

> **自动维护 — 不要手动编辑，会被 \`bin/sync-index.sh\` 覆盖。**
>
> Relay ↔ design.md 双向追溯索引。给一个 Relay node_id，能反查到 wiki 中的 md 路径。
>
> 见 [references/traceability.md](./references/traceability.md) 了解维护机制。
>
> 上次 sync: $(date +%Y-%m-%d)

---

## L1 通用组件 (horizontal · component-base)

| Slug | Path | Relay node | Owner | Last Synced |
|---|---|---|---|---|
HEADER

  if [[ ${#ENTRIES_L1[@]} -eq 0 ]]; then
    echo "_（空）_"
  else
    printf '%s\n' "${ENTRIES_L1[@]}" | sort_rows
  fi

  echo ""
  echo "---"
  echo ""
  echo "## L2 业务组件 (component-business)"
  echo ""

  if [[ ${#ENTRIES_L2[@]} -eq 0 ]]; then
    echo "_（空 — 待 v0.3+ 业务文件接入）_"
  else
    current_bg=""
    while IFS=$'\t' read -r entry_bg row; do
      if [[ "$entry_bg" != "$current_bg" ]]; then
        echo ""
        echo "### $entry_bg BG"
        echo ""
        echo "| Slug | Path | Relay node | Owner | Last Synced |"
        echo "|---|---|---|---|---|"
        current_bg="$entry_bg"
      fi
      echo "$row"
    done < <(printf '%s\n' "${ENTRIES_L2[@]}" | sort_rows_with_bg)
  fi

  echo ""
  echo "---"
  echo ""
  echo "## L3 页面 (page)"
  echo ""

  if [[ ${#ENTRIES_L3[@]} -eq 0 ]]; then
    echo "_（空 — v0.4+ 启用）_"
  else
    echo "| Slug | BG | Path | Relay node | Owner | Last Synced |"
    echo "|---|---|---|---|---|---|"
    while IFS=$'\t' read -r entry_bg row; do
      # 把 BG 插到 slug 后第一列
      modified=$(echo "$row" | sed "s|^| ${entry_bg} ||" )
      echo "$row" | awk -v bg="$entry_bg" -F'\\|' 'BEGIN{OFS="|"} {print $1,$2,bg" ",$3,$4,$5,$6,$7}' | sed 's/^|//' | sed 's/^/|/' || echo "$row"
    done < <(printf '%s\n' "${ENTRIES_L3[@]}" | sort_rows_with_bg)
  fi

  echo ""
  echo "---"
  echo ""
  echo "## L4 流程 (flow)"
  echo ""

  if [[ ${#ENTRIES_L4[@]} -eq 0 ]]; then
    echo "_（空 — v0.4+ 启用）_"
  else
    echo "| Slug | BG | Path | Relay node | Owner | Last Synced |"
    echo "|---|---|---|---|---|---|"
    while IFS=$'\t' read -r entry_bg row; do
      echo "$row"
    done < <(printf '%s\n' "${ENTRIES_L4[@]}" | sort_rows_with_bg)
  fi

  cat << FOOTER

---

## 统计

- L1 通用组件：${#ENTRIES_L1[@]} 个
- L2 业务组件：${#ENTRIES_L2[@]} 个
- L3 页面：${#ENTRIES_L3[@]} 个
- L4 流程：${#ENTRIES_L4[@]} 个
- **总计**：$TOTAL_FILES 个

---

## 使用方式

### 1. 从 Relay 反查 design.md

#### 仓库视角（offline 可用）

\`\`\`bash
grep '542:6495' .claude/skills/relay-to-design-md/INDEX.md
\`\`\`

#### Relay 视角（v0.3+，需 MCP 在线）

在 Relay 插件里点节点 → 读 \`sharedPluginData('jd-design-wiki', 'design_md_path')\`。

### 2. 从 design.md 反查 Relay

打开 design.md，frontmatter \`relay_source.url\` 字段。
FOOTER

} > /tmp/sync-index-output.md

# ============================================================
# 主流程
# ============================================================

if [[ "$WRITE_MODE" == "true" ]]; then
  mv /tmp/sync-index-output.md "$INDEX_FILE"
  printf "✅ INDEX.md 已更新\n"
  printf "   L1: %d | L2: %d | L3: %d | L4: %d | 总: %d\n" \
    "${#ENTRIES_L1[@]}" "${#ENTRIES_L2[@]}" "${#ENTRIES_L3[@]}" "${#ENTRIES_L4[@]}" \
    "$TOTAL_FILES"

  if [[ ${#DUPLICATE_SLUGS[@]} -gt 0 ]]; then
    printf "\n⚠️ slug 冲突 %d 处:\n" "${#DUPLICATE_SLUGS[@]}"
    for d in "${DUPLICATE_SLUGS[@]}"; do
      printf "   - %s\n" "$d"
    done
  fi
else
  printf "(dry-run，加 --write 实际写回)\n\n"
  if [[ -f "$INDEX_FILE" ]]; then
    diff -u "$INDEX_FILE" /tmp/sync-index-output.md || true
  else
    cat /tmp/sync-index-output.md
  fi
  rm -f /tmp/sync-index-output.md
fi

if [[ "$PUSH_SHARED_DATA" == "true" ]]; then
  printf "\n--push-shared-data 需 MCP 在线，请用 Claude Code 跑：\n"
  printf "  请 Claude 用 use_design_script 把以下节点的 sharedPluginData 全部 push 一次。\n"
  printf "  namespace = 'jd-design-wiki'，keys = [design_md_path, last_synced, slug, level, bg]\n\n"
  printf "  节点清单（file_id / page_id / node_id / md_path）：\n"
  for f in "${ALL_FILES[@]}"; do
    [[ -z "$f" ]] && continue
    file_id=$(get_nested_field "$f" "file_id")
    page_id=$(get_nested_field "$f" "page_id")
    node_id=$(get_nested_field "$f" "node_id")
    relpath="${f#$REPO_ROOT/}"
    printf "  - %s / %s / %s → %s\n" "$file_id" "$page_id" "$node_id" "$relpath"
  done
fi
