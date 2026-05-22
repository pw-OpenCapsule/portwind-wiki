# GitHub Releases → 飞书 wiki 半自动同步

每次自研项目发 GitHub Release，跑一行命令把 release notes 同步到飞书 wiki 对应项目节点下。

## 为什么不走 GitHub Actions

最初尝试过 CI 自动化（`.github/workflows/release-notes-to-wiki.yml`），但发现飞书 wiki 的一个**设计死结**：

1. CI 只能拿 `app_id + app_secret` → 走 `tenant_access_token`（bot 身份）
2. bot 调 wiki API 写受限空间的节点 → 报 `131006 permission denied: tenant needs read permission`
3. 想把 bot 加进 wiki space 作为 member → 飞书 UI 的「Add Editor」**不收 bot**（只收 user/group/department）
4. 飞书 `wiki.members.create` API 的 `member_type` 枚举也**不支持 `appid` 类型**
5. wiki space visibility 切「Members only」→「Org-wide」需要租户超管，而且改完也未必生效

绕了一圈，**唯一稳定可行的是用 user 身份在本机跑**。CI 自动化的边际收益（不切窗口）远低于排查 wiki 权限的成本。

详见 [`portwind-wiki/references/release-automation.md` 历史踩坑](https://portwind.jp.larksuite.com/wiki/...)（如有沉淀的话）。

## 用法

仓库根：[`scripts/sync-release-to-wiki.sh`](../scripts/sync-release-to-wiki.sh)

```bash
# 同步最新 release（不传 tag）
./scripts/sync-release-to-wiki.sh \
  <repo> <wiki_space_id> <wiki_parent_node>

# 同步特定 tag
./scripts/sync-release-to-wiki.sh \
  <repo> <wiki_space_id> <wiki_parent_node> <tag>
```

例子：把 portwind-wiki 最新 release 同步到 Skill 沉淀 / portwind-wiki 节点下：

```bash
./scripts/sync-release-to-wiki.sh \
  pw-OpenCapsule/portwind-wiki \
  7642234757744496151 \
  CpEjwWGavio9G0kK5w2jtordpqg
```

## 幂等性

- 脚本先 `wiki nodes list` 找同 tag 标题的子节点
- 存在 → `docs +update` overwrite
- 不存在 → `wiki +node-create` 再 update
- 同 tag 多次跑不会建多个节点

**标题用 git tag**（如 `v0.1.0`），不用 release name（避免 em-dash / 中文副标题在 wiki 端编码不一致）。

## 前置

| 依赖 | 验证 |
|---|---|
| `gh` CLI 已登录 | `gh auth status` |
| `lark-cli` 已登录 | `lark-cli auth status` |
| `jq` 已装 | `jq --version` |
| user 对目标 wiki 空间有写权限 | 自己建的 / admin 已加你 |

## 建议工作流

发完 release 后，shell history 里加这条 alias（替换实际参数）：

```bash
alias sync-wiki='~/github.com/portwind-wiki/scripts/sync-release-to-wiki.sh pw-OpenCapsule/portwind-wiki 7642234757744496151 CpEjwWGavio9G0kK5w2jtordpqg'

# 发完 release 后
sync-wiki         # 同步最新
sync-wiki v0.1.0  # 同步特定 tag
```

或者放进项目的 `package.json` scripts：

```json
{
  "scripts": {
    "release:sync-wiki": "scripts/sync-release-to-wiki.sh pw-OpenCapsule/<repo> <space_id> <parent_node>"
  }
}
```

发版后 `pnpm release:sync-wiki` 即可。

## 常见问题

| 现象 | 原因 / 解法 |
|---|---|
| `131006 permission denied` | wiki 空间不允许 bot 读 — 这就是为啥放弃 CI；用本脚本（user 身份）即可 |
| `--obj-type is required` | `wiki +node-delete` 需要 `--obj-type wiki`；本脚本不用此命令，但手动清理子节点时注意 |
| 出现重复子节点 | 上次 `wiki nodes list` 拉失败导致没 dedupe；本脚本已加 awk JSON 提取避免 |
| Brand 配错 | 默认 `lark`（larksuite.com）；国内 feishu.cn 用户脚本会自动检测 |
