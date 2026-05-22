#!/usr/bin/env bash
# sync-release-to-wiki.sh — 把 GitHub Release notes 同步到飞书 wiki 子文档
#
# 为什么不走 GitHub Actions:
#   飞书 wiki API 对 bot (tenant_access_token) 默认拒绝读写受限空间，
#   而 UI / Member API 都不支持把 bot 加进 wiki space，导致 CI 无法
#   用 app_id+app_secret 跑通。本地用 user 身份则一切正常。
#
# 用法:
#   sync-release-to-wiki.sh <repo> <wiki_space_id> <wiki_parent_node> [tag]
#
# 参数:
#   repo              GitHub repo (owner/name)
#   wiki_space_id     飞书 wiki 空间 id
#   wiki_parent_node  父节点 token (release notes 子文档建在它下面)
#   tag               可选 — release tag，省略则取最新 release
#
# 例子:
#   # 同步 portwind-wiki 最新 release 到 Skill 沉淀 / portwind-wiki 节点下
#   sync-release-to-wiki.sh pw-OpenCapsule/portwind-wiki \
#     7642234757744496151 CpEjwWGavio9G0kK5w2jtordpqg
#
#   # 同步特定 tag
#   sync-release-to-wiki.sh pw-OpenCapsule/portwind-wiki \
#     7642234757744496151 CpEjwWGavio9G0kK5w2jtordpqg v0.1.0
#
# 前置:
#   - gh CLI 已登录 (gh auth status)
#   - lark-cli 已登录 (lark-cli auth status)
#   - jq 已装

set -euo pipefail

if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
  echo "Usage: $0 <repo> <wiki_space_id> <wiki_parent_node> [tag]" >&2
  exit 64
fi

REPO="$1"
WIKI_SPACE_ID="$2"
WIKI_PARENT_NODE="$3"
TAG="${4:-}"

# Pick latest release if tag omitted
if [ -z "$TAG" ]; then
  TAG=$(gh release view --repo "$REPO" --json tagName --jq .tagName)
  echo "[sync] using latest release: $TAG"
fi

# Fetch release metadata
RELEASE_JSON=$(gh release view "$TAG" --repo "$REPO" --json name,body,url,tagName)
RELEASE_NAME=$(jq -r '.name // .tagName' <<<"$RELEASE_JSON")
RELEASE_URL=$(jq -r '.url' <<<"$RELEASE_JSON")
RELEASE_BODY=$(jq -r '.body' <<<"$RELEASE_JSON")

# Use tag as wiki node title (release name may contain em-dash / Chinese subtitle
# that gets re-encoded inconsistently — tag is stable and matches across runs)
TITLE="$TAG"
echo "[sync] title: $TITLE  (release name: $RELEASE_NAME)"

# Find existing child node with same title (single list call, both tokens)
NODES_JSON=$(lark-cli wiki nodes list \
  --params "{\"space_id\":\"${WIKI_SPACE_ID}\",\"parent_node_token\":\"${WIKI_PARENT_NODE}\"}" \
  --as user 2>&1)
NODES_BODY=$(awk '/^\{/,/^\}/' <<<"$NODES_JSON")
DOC_TOKEN=$(jq -r --arg t "$TITLE" '.data.items[]? | select(.title==$t) | .obj_token' <<<"$NODES_BODY" | head -1)
NODE_TOKEN=$(jq -r --arg t "$TITLE" '.data.items[]? | select(.title==$t) | .node_token' <<<"$NODES_BODY" | head -1)

if [ -n "${DOC_TOKEN:-}" ] && [ "$DOC_TOKEN" != "null" ]; then
  echo "[sync] found existing wiki child: $DOC_TOKEN — will overwrite"
else
  echo "[sync] no existing child — creating new wiki node"
  CREATE_OUT=$(lark-cli wiki +node-create \
    --space-id "$WIKI_SPACE_ID" \
    --parent-node-token "$WIKI_PARENT_NODE" \
    --title "$TITLE" \
    --obj-type docx \
    --node-type origin \
    --as user 2>&1)
  # lark-cli prepends human-readable lines before the JSON body — strip them
  CREATE_JSON=$(awk '/^\{/,/^\}/' <<<"$CREATE_OUT")
  DOC_TOKEN=$(jq -r '.data.obj_token' <<<"$CREATE_JSON")
  NODE_TOKEN=$(jq -r '.data.node_token' <<<"$CREATE_JSON")
  if [ -z "${DOC_TOKEN:-}" ] || [ "$DOC_TOKEN" = "null" ]; then
    echo "[sync] ✗ failed to create wiki node:" >&2
    echo "$CREATE_OUT" >&2
    exit 1
  fi
fi

# Build markdown body
BODY_FILE=$(mktemp -t release-body.XXXXXX.md)
trap 'rm -f "$BODY_FILE"' EXIT

cat > "$BODY_FILE" <<EOF
# ${TAG}

> Source: [GitHub Release ${TAG}](${RELEASE_URL})

${RELEASE_BODY}
EOF

# Push to wiki
echo "[sync] pushing release notes to wiki doc $DOC_TOKEN..."
lark-cli docs +update --api-version v2 \
  --doc "$DOC_TOKEN" \
  --command overwrite \
  --doc-format markdown \
  --content "$(cat "$BODY_FILE")" \
  --as user >/dev/null

# Wiki URL host: parse from lark-cli config (brand=lark → larksuite.com, brand=feishu → feishu.cn)
BRAND=$(lark-cli auth status 2>/dev/null \
  | sed -n 's/.*"brand": *"\([^"]*\)".*/\1/p' | head -1 || echo "lark")
case "${BRAND:-lark}" in
  feishu) WIKI_HOST="feishu.cn" ;;
  *)      WIKI_HOST="larksuite.com" ;;
esac

# Portwind tenant subdomain — hardcode for clarity (override via env if other tenant)
WIKI_TENANT="${WIKI_TENANT:-portwind.jp}"

echo "[sync] ✓ done"
echo "[sync]   node: https://${WIKI_TENANT}.${WIKI_HOST}/wiki/${NODE_TOKEN}"
