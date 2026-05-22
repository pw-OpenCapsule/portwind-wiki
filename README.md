# portwind-wiki

Portwind 团队飞书 wiki 沉淀的结构、模板、路由规则。

把日常零散的产出（工具推荐 / 踩坑 / design doc / 复盘 / 新人入门 / 技术分享）按固定 7 个父节点分类沉淀，AI agent 按本 skill 的路由表自动归位、按模板填内容。

## 这是什么

一个 **Claude Code / Cursor / Codex / Gemini CLI 通用的 skill**。安装后，跟 agent 说一句「沉淀进 wiki」「记一个坑」「写复盘」，agent 自动按本团队约定的结构和模板写到飞书 wiki 对应位置。

**本 skill 是路由表 + 模板库**，不是 CLI；实际写 wiki 走 `lark-wiki` / `lark-doc` skill。

## 安装

```bash
npx skills add pw-OpenCapsule/portwind-wiki -y -g
```

前置：

- [lark-cli](https://github.com/larksuite/cli) ≥ 1.0.34
- `lark-cli auth login --recommend` 已完成
- 已装 `lark-wiki` / `lark-doc` skill（agent 实际写 wiki 时用）

## 7 个父节点（路由总表）

| 节点 | 放什么 |
|---|---|
| 🛠️ Skill 沉淀 | 团队自研 CLI / 插件 / agent skill — **怎么用** |
| 📦 产品沉淀 | 自研 SaaS / 部署型产品 |
| 📐 架构 & 调研 | design doc / 选型 / RFC — **为什么这么设计** |
| 🩹 踩坑 & 复盘 | `[坑]` gotcha · `[复盘]` 线上故障 RCA |
| 🚀 团队入门 | 新人第一周：环境 / 账号 / 脚手架 |
| 📌 工具雷达 | 团队发现的**外部**工具（不是自研） |
| 🎤 技术分享 | 历史分享归档 + 待分享 backlog |

完整定义、子节点命名、索引页范式见 [`references/structure.md`](references/structure.md)。

## 5 条治理规则

1. **不删，只归档** —— `[archived YYYY-MM]` 前缀
2. **模板必填段不能跳** —— 没填完 = 未完成条目
3. **外部工具用群体归因** —— `来源：via <群名>，YYYY-MM`，不点 @ 人名
4. **外部工具带 `review_at`** —— 默认 6 月后，季度自清
5. **cross-link** —— design doc 链工具页；分享归档链 design doc

详见 [`references/governance.md`](references/governance.md)。

## 新团队怎么用

跟 agent 说：「按 portwind-wiki 给我搭一个团队知识库」

Agent 跟着 [`references/bootstrap.md`](references/bootstrap.md) 一步步：

1. 找飞书 wiki 空间（用现成的 / 新建）
2. 自动建 7 个父节点
3. 每个父节点填模板化的索引页
4. 在 Homepage 加导航表
5. 给同事发个群通告

整套搭好约 5 分钟。

## 不替代的事

- 写 wiki 实际操作 → 用 `lark-wiki` / `lark-doc` skill
- 一般 prompt 工程 → 看 Claude Code 官方文档
- 公司内部业务知识 → 走 design doc + 私人空间，本 skill 不收录

## License

MIT
