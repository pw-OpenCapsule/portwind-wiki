# GitHub Releases → 飞书 wiki 自动同步

每次自研项目发 GitHub Release，自动在飞书 wiki 对应项目节点下建一个 release notes 子文档。

## 为什么要做

- 团队不用每次发版都手动同步
- release notes 跟着代码版本走，自动有时间线
- 飞书 wiki 里直接看历史 release，不用切到 GitHub

## 一次性 setup（每个项目都要）

### 1. 在飞书 wiki 找到项目节点

通常在「Skill 沉淀」/「产品沉淀」下。记下：

- `WIKI_PARENT_NODE`：项目节点 token（release notes 子文档建在这个节点下）
- `WIKI_SPACE_ID`：节点所在空间 id

### 2. 飞书开放平台配 app + 加 bot

- 创建 / 拿一个 Lark app，记下 `app_id` + `app_secret`
- 把 bot 加进目标 wiki 空间作为**编辑协作者**（成员管理里加）

### 3. GitHub repo secrets

```
LARK_APP_ID:     cli_xxxxxxxx
LARK_APP_SECRET: xxxxxxxxxxxxx
```

### 4. 加 workflow 文件

放在 `.github/workflows/release-notes-to-wiki.yml`：

```yaml
name: Sync release notes to Lark wiki

on:
  release:
    types: [published, edited]

env:
  WIKI_PARENT_NODE: <你的项目节点 token>
  WIKI_SPACE_ID:    '<你的空间 id，加引号防被解析成数字>'

jobs:
  publish-release-notes:
    runs-on: ubuntu-latest
    steps:
      - name: Install lark-cli
        run: npx @larksuite/cli@latest install

      - name: Resolve / create wiki child for ${{ github.event.release.tag_name }}
        id: wiki
        env:
          LARKSUITE_CLI_APP_ID:     ${{ secrets.LARK_APP_ID }}
          LARKSUITE_CLI_APP_SECRET: ${{ secrets.LARK_APP_SECRET }}
          LARKSUITE_CLI_BRAND:      lark   # 或 feishu
          LARKSUITE_CLI_NO_UPDATE_NOTIFIER: '1'
          TAG: ${{ github.event.release.tag_name }}
          RELEASE_NAME: ${{ github.event.release.name }}
        run: |
          set -euo pipefail
          TITLE="${RELEASE_NAME:-$TAG}"
          EXISTING=$(lark-cli wiki nodes list \
            --params "{\"space_id\":\"${WIKI_SPACE_ID}\",\"parent_node_token\":\"${WIKI_PARENT_NODE}\"}" \
            --as user 2>/dev/null \
            | jq -r --arg t "$TITLE" '.data.items[] | select(.title==$t) | .obj_token' | head -1)
          if [ -n "${EXISTING:-}" ]; then
            DOC_TOKEN="$EXISTING"
          else
            DOC_TOKEN=$(lark-cli wiki +node-create \
              --space-id "$WIKI_SPACE_ID" \
              --parent-node-token "$WIKI_PARENT_NODE" \
              --title "$TITLE" --obj-type docx --node-type origin \
              --as user 2>&1 | jq -r '.data.obj_token')
          fi
          echo "DOC_TOKEN=$DOC_TOKEN" >> "$GITHUB_OUTPUT"

      - name: Push release body to wiki doc
        env:
          LARKSUITE_CLI_APP_ID:     ${{ secrets.LARK_APP_ID }}
          LARKSUITE_CLI_APP_SECRET: ${{ secrets.LARK_APP_SECRET }}
          LARKSUITE_CLI_BRAND:      lark
          TAG:  ${{ github.event.release.tag_name }}
          BODY: ${{ github.event.release.body }}
          URL:  ${{ github.event.release.html_url }}
          DOC_TOKEN: ${{ steps.wiki.outputs.DOC_TOKEN }}
        run: |
          cat > /tmp/release-body.md <<EOF
          # ${TAG}

          > Source: [GitHub Release ${TAG}](${URL})

          ${BODY}
          EOF
          lark-cli docs +update --api-version v2 \
            --doc "$DOC_TOKEN" --command overwrite --doc-format markdown \
            --content "$(cat /tmp/release-body.md)" --as user
```

## 幂等性保证

- workflow 先 `wiki nodes list` 找同标题节点
- 存在 → `docs +update` overwrite
- 不存在 → `wiki +node-create` 再 update
- 同一 tag 多次 publish / edit 不会建多个节点

## 例子

参考 `openapi-lark` 项目的实际 workflow：
- 仓库：`leeguooooo/openapi-lark`
- 路径：`.github/workflows/release-notes-to-wiki.yml`
- 触发：每次 publish v0.X.Y release

## 常见问题

| 现象 | 原因 / 解法 |
|---|---|
| workflow 跑成功但 wiki 没东西 | bot 没被加进 wiki 空间作为编辑协作者 |
| 报 invalid scope | secrets 里的 app 没开 `wiki:node:create` / `docx:document:write_only` scope，去飞书开放平台审批 |
| Brand 配错了 | `feishu`（国内）vs `lark`（国际 Lark Suite），按 wiki URL 域名判断（feishu.cn / larksuite.com） |
