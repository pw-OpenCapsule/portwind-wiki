#!/usr/bin/env bash
# cleanup-dup-children.sh — 清理飞书 wiki 父节点下同名重复子节点
#
# 按 title 分组：保留每组中 obj_create_time 最新的一个，其余加 archive 前缀
# 或直接删除（看 --mode）。默认 dry-run，看清楚再 --apply。
#
# 用法:
#   cleanup-dup-children.sh <space_id> <parent_node_token> [--apply] [--mode delete|archive]
#
# 例子:
#   # 看哪些 title 有重复
#   cleanup-dup-children.sh 7642234757744496151 CpEjwWGavio9G0kK5w2jtordpqg
#
#   # 实际删旧的（保留最新）
#   cleanup-dup-children.sh 7642234757744496151 CpEjwWGavio9G0kK5w2jtordpqg --apply
#
#   # 不删，加 [archived YYYY-MM] 前缀（更安全）
#   cleanup-dup-children.sh 7642234757744496151 CpEjwWGavio9G0kK5w2jtordpqg --apply --mode archive
#
# 前置:
#   - lark-cli 已登录
#   - user 对目标 wiki 空间有 admin / editor 权限

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <space_id> <parent_node_token> [--apply] [--mode delete|archive]" >&2
  exit 64
fi

SPACE_ID="$1"
PARENT="$2"
shift 2

APPLY=false
MODE="delete"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --apply) APPLY=true ;;
    --mode) MODE="$2"; shift ;;
    *) echo "unknown flag: $1" >&2; exit 64 ;;
  esac
  shift
done

case "$MODE" in
  delete|archive) ;;
  *) echo "--mode must be delete or archive, got: $MODE" >&2; exit 64 ;;
esac

# Fetch children
RAW=$(lark-cli wiki nodes list \
  --params "{\"space_id\":\"${SPACE_ID}\",\"parent_node_token\":\"${PARENT}\"}" \
  --as user 2>&1)
BODY=$(awk '/^\{/,/^\}/' <<<"$RAW")

# Sanity check
COUNT=$(jq -r '.data.items | length' <<<"$BODY" 2>/dev/null || echo 0)
if [ "$COUNT" = "0" ]; then
  echo "[cleanup] no children under $PARENT — nothing to do"
  exit 0
fi
echo "[cleanup] $COUNT children under $PARENT"

# Group by title, find dups (count > 1), pick oldest as "to-delete/archive"
# Output: tab-separated lines "title<TAB>victim_node_token<TAB>victim_obj_token<TAB>keeper_node_token"
DUPS=$(jq -r '
  .data.items
  | group_by(.title)
  | map(select(length > 1))
  | .[]
  | (sort_by(-(.obj_create_time | tonumber)) | .[0]) as $keeper
  | .[]
  | select(.node_token != $keeper.node_token)
  | [.title, .node_token, .obj_token, $keeper.node_token, .obj_create_time] | @tsv
' <<<"$BODY")

if [ -z "$DUPS" ]; then
  echo "[cleanup] no duplicates ✓"
  exit 0
fi

echo "[cleanup] duplicates found (will $MODE if --apply):"
echo "$DUPS" | while IFS=$'\t' read -r title node obj keeper created; do
  printf '  · %s  victim_node=%s  victim_created=%s  keeper_node=%s\n' \
    "$title" "$node" "$created" "$keeper"
done

if ! $APPLY; then
  echo "[cleanup] DRY-RUN (default). Add --apply to actually $MODE."
  exit 0
fi

echo "[cleanup] applying $MODE..."
TS=$(date -u +%Y-%m)
echo "$DUPS" | while IFS=$'\t' read -r title node obj keeper created; do
  if [ "$MODE" = "delete" ]; then
    echo "  - deleting node=$node ($title)"
    lark-cli wiki +node-delete --space-id "$SPACE_ID" --node-token "$node" --obj-type wiki --as user --yes 2>&1 \
      | grep -E '"ok"|"message"' | head -2
  else
    NEW_TITLE="[archived ${TS}] ${title}"
    echo "  - renaming node=$node → $NEW_TITLE"
    lark-cli drive +file-title-update --token "$obj" --type docx --title "$NEW_TITLE" --as user 2>&1 \
      | grep -E '"ok"|"message"' | head -2
  fi
done

echo "[cleanup] ✓ done"
