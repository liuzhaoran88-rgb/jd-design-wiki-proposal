#!/usr/bin/env bash
#
# validate.sh — 提交前校验 design.md（skill v0.2+）
#
# 扫所有 design.md，按 frontmatter-spec.md 规则逐条检查：
#   ① frontmatter 必填字段都存在且非空
#   ② level/bg/status 在受控词表内
#   ③ slug 是 kebab-case
#   ④ relay_source.url 含 file_id/page_id/node_id 三段
#   ⑤ 同目录有 preview.png
#   ⑥ 5 处 <!-- TODO --> 是否仍残留（status=review/published 时必查）
#   ⑦ ⚠️ flag 是否仍残留（review 是否完成）
#
# 用法：
#   bash .claude/skills/relay-to-design-md/bin/validate.sh                    # 扫全仓
#   bash .claude/skills/relay-to-design-md/bin/validate.sh <path/to/design.md> # 单文件
#
# 退出码：
#   0 = 全过
#   1 = 有错（fail）
#   2 = 用法错误

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0
FILES_CHECKED=0

# 受控词表
VALID_LEVELS=("component-base" "component-business" "page" "flow")
VALID_BGS=("horizontal" "retail" "health" "finance" "logistics" "global" "jx" "industrial")
VALID_STATUSES=("draft" "review" "published" "deprecated")

# ============================================================
# 工具函数
# ============================================================

error() {
  printf "${RED}✗ ERROR${NC} %s: %s\n" "$1" "$2"
  ERRORS=$((ERRORS + 1))
}

warn() {
  printf "${YELLOW}⚠ WARN${NC}  %s: %s\n" "$1" "$2"
  WARNINGS=$((WARNINGS + 1))
}

ok() {
  printf "${GREEN}✓${NC} %s\n" "$1"
}

# 从 frontmatter 提取字段值（不依赖 yq，简单 awk）
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

in_array() {
  local needle=$1; shift
  for item in "$@"; do
    [[ "$item" == "$needle" ]] && return 0
  done
  return 1
}

# ============================================================
# 单文件校验
# ============================================================

check_file() {
  local file=$1
  FILES_CHECKED=$((FILES_CHECKED + 1))

  local relpath="${file#$REPO_ROOT/}"

  # 必填字段
  local level bg slug name_zh status owner last_synced
  level=$(get_field "$file" "level")
  bg=$(get_field "$file" "bg")
  slug=$(get_field "$file" "slug")
  name_zh=$(get_field "$file" "name_zh")
  status=$(get_field "$file" "status")
  owner=$(get_field "$file" "owner")
  last_synced=$(get_field "$file" "last_synced")

  [[ -z "$level" ]] && error "$relpath" "frontmatter.level 缺失"
  [[ -z "$bg" ]] && error "$relpath" "frontmatter.bg 缺失"
  [[ -z "$slug" ]] && error "$relpath" "frontmatter.slug 缺失"
  [[ -z "$name_zh" ]] && error "$relpath" "frontmatter.name_zh 缺失"
  [[ -z "$status" ]] && error "$relpath" "frontmatter.status 缺失"
  [[ -z "$owner" ]] && error "$relpath" "frontmatter.owner 缺失"
  [[ -z "$last_synced" ]] && error "$relpath" "frontmatter.last_synced 缺失"

  # 受控词表
  if [[ -n "$level" ]] && ! in_array "$level" "${VALID_LEVELS[@]}"; then
    error "$relpath" "level '$level' 不在受控词表 [${VALID_LEVELS[*]}]"
  fi
  if [[ -n "$bg" ]] && ! in_array "$bg" "${VALID_BGS[@]}"; then
    error "$relpath" "bg '$bg' 不在受控词表 [${VALID_BGS[*]}]"
  fi
  if [[ -n "$status" ]] && ! in_array "$status" "${VALID_STATUSES[@]}"; then
    error "$relpath" "status '$status' 不在受控词表 [${VALID_STATUSES[*]}]"
  fi

  # slug 格式：kebab-case
  if [[ -n "$slug" ]] && [[ ! "$slug" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    error "$relpath" "slug '$slug' 不是 kebab-case (regex: ^[a-z0-9]+(-[a-z0-9]+)*\$)"
  fi

  # owner != @TODO
  if [[ "$owner" == "@TODO" ]] || [[ "$owner" == "@TODO-填手柄" ]]; then
    warn "$relpath" "owner 仍是 @TODO，请填实际 GitHub handle"
  fi

  # last_synced ISO date 格式
  if [[ -n "$last_synced" ]] && [[ ! "$last_synced" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    error "$relpath" "last_synced '$last_synced' 不是 ISO date (YYYY-MM-DD)"
  fi

  # relay_source.url 三段检查
  local url
  url=$(awk '
    /^---$/ { fm = !fm; next }
    fm && /^[[:space:]]+url:/ {
      sub(/^[[:space:]]+url:[[:space:]]*/, "")
      gsub(/^"|"$/, "")
      print; exit
    }
  ' "$file")
  if [[ -z "$url" ]]; then
    error "$relpath" "relay_source.url 缺失"
  elif [[ ! "$url" =~ id= ]] || [[ ! "$url" =~ page_id= ]] || [[ ! "$url" =~ node_id= ]]; then
    error "$relpath" "relay_source.url 缺 id/page_id/node_id 之一: $url"
  fi

  # preview.png 存在
  local dir="$(dirname "$file")"
  if [[ ! -f "$dir/preview.png" ]]; then
    warn "$relpath" "同目录无 preview.png（v0.2 应自动导出）"
  elif [[ ! -s "$dir/preview.png" ]]; then
    error "$relpath" "preview.png 是空文件"
  fi

  # v0.3 cross-file: uses_components 引用的 design.md 是否存在
  local refs
  refs=$(awk '
    /^---$/ { fm = !fm; next }
    fm && /^  uses_components:/ { in_uc = 1; next }
    fm && in_uc {
      if (/^[[:space:]]+-/) {
        sub(/^[[:space:]]+-[[:space:]]+/, "")
        sub(/[[:space:]]*#.*/, "")
        gsub(/^[[:space:]]+|[[:space:]]+$/, "")
        if ($0 != "" && $0 !~ /^TODO/) print $0
      } else if (!/^[[:space:]]/) {
        in_uc = 0
      }
    }
  ' "$file")

  if [[ -n "$refs" ]]; then
    while IFS= read -r ref; do
      [[ -z "$ref" ]] && continue
      # 引用通常是相对仓库根的路径，去掉可能的引号
      ref="${ref//\"/}"
      # 拼出引用目标的 design.md 路径
      local target="$REPO_ROOT/$ref/design.md"
      # 也尝试一种：path 已经直接指向 design.md
      local target_direct="$REPO_ROOT/$ref"
      if [[ ! -f "$target" ]] && [[ ! -f "$target_direct" ]]; then
        warn "$relpath" "uses_components 引用 '$ref' 的 design.md 不存在（可能子组件待录入）"
      fi
    done <<< "$refs"
  fi

  # v0.3 cross-file: INDEX.md 是否含本文件的 slug
  if [[ -f "$SKILL_DIR/INDEX.md" ]] && [[ -n "$slug" ]]; then
    if ! grep -q "| $slug |" "$SKILL_DIR/INDEX.md"; then
      warn "$relpath" "INDEX.md 中未找到 slug '$slug'（请跑 bin/sync-index.sh --write）"
    fi
  fi

  # status=review/published 时必查 TODO/⚠️
  if [[ "$status" == "review" ]] || [[ "$status" == "published" ]]; then
    if grep -q '<!-- TODO' "$file"; then
      error "$relpath" "status=$status 但仍有 <!-- TODO --> 残留 → 设计师未填空"
    fi
    if grep -q '⚠️' "$file"; then
      warn "$relpath" "status=$status 但仍有 ⚠️ flag → 确认 review 是否完成"
    fi
  fi
}

# ============================================================
# 主流程
# ============================================================

main() {
  local target=${1:-}

  printf "validate.sh · skill v0.3 · design.md 提交前校验\n"
  printf "%.0s─" {1..60}; printf "\n"

  if [[ -n "$target" ]]; then
    if [[ ! -f "$target" ]]; then
      printf "${RED}用法错误${NC}: 文件不存在: %s\n" "$target"
      exit 2
    fi
    check_file "$target"
  else
    # 扫所有 design.md（jd-design-system-md-v16 / examples / horizontal / product-architecture）
    local files
    files=$(find "$REPO_ROOT/jd-design-system-md-v16" \
                "$REPO_ROOT/.claude/skills/relay-to-design-md/examples" \
            -name 'design.md' -type f 2>/dev/null || true)

    if [[ -z "$files" ]]; then
      printf "${YELLOW}没找到任何 design.md${NC}\n"
      exit 0
    fi

    while IFS= read -r f; do
      check_file "$f"
    done <<< "$files"
  fi

  printf "%.0s─" {1..60}; printf "\n"
  printf "扫描 %d 个文件 | " "$FILES_CHECKED"
  if [[ $ERRORS -eq 0 ]] && [[ $WARNINGS -eq 0 ]]; then
    printf "${GREEN}全过 ✓${NC}\n"
    exit 0
  elif [[ $ERRORS -eq 0 ]]; then
    printf "${YELLOW}%d warning${NC}\n" "$WARNINGS"
    exit 0
  else
    printf "${RED}%d error${NC} | ${YELLOW}%d warning${NC}\n" "$ERRORS" "$WARNINGS"
    exit 1
  fi
}

main "$@"
