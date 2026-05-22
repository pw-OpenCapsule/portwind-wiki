# Template: Skill 沉淀 子节点

> 自研 CLI / 插件 / agent skill 的标准条目格式。父节点：**🛠️ Skill 沉淀**

## 标题约定

直接用项目名（GitHub repo 名）。比如 `openapi-lark` / `wrangler-accounts`。

## 模板（复制粘贴改）

```xml
<title>项目名</title>

<callout emoji="🛠️" background-color="light-blue" border-color="blue">
  <p>一句话定位（≤ 50 字）。</p>
  <p>当前版本 vX.Y.Z · 状态：active / deprecated</p>
</callout>

<h2>🔗 链接</h2>
<ul>
  <li><b>仓库</b>：<a type="url-preview" href="https://github.com/...">user/repo</a></li>
  <li><b>npm</b>：<a type="url-preview" href="https://www.npmjs.com/package/...">@org/name</a></li>
  <li><b>所有 release</b>：<a type="url-preview" href="https://github.com/.../releases">GitHub Releases</a></li>
</ul>

<h2>💡 为什么有这个 / 解决什么</h2>
<p>2-4 句话：现状的痛点 + 本工具的解法。</p>

<h2>🚀 安装</h2>
<pre lang="bash"><code>npx skills add user/repo -y -g
# 或 npm i -g @org/name</code></pre>

<h2>🎯 核心命令 / 用法</h2>
<table>
  <colgroup><col width="280"/><col width="380"/></colgroup>
  <thead><tr>
    <th background-color="light-gray"><p>命令</p></th>
    <th background-color="light-gray"><p>用途</p></th>
  </tr></thead>
  <tbody>
    <tr><td><p><code>tool subcommand</code></p></td><td><p>说明</p></td></tr>
  </tbody>
</table>

<h2>📜 版本节点</h2>
<table>
  <colgroup><col width="100"/><col width="500"/></colgroup>
  <thead><tr>
    <th background-color="light-gray"><p>版本</p></th>
    <th background-color="light-gray"><p>主题</p></th>
  </tr></thead>
  <tbody>
    <tr><td><p><b>vX.Y.Z</b></p></td><td><p>主要改动</p></td></tr>
  </tbody>
</table>

<callout emoji="ℹ️" background-color="light-gray">
  <p>完整 release 列表见 <a href="https://github.com/.../releases">GitHub Releases</a>。</p>
</callout>

<h2>🌐 跟其它项目的关系</h2>
<ul>
  <li>跟 <a href="...">X</a> 的区别 / 配合方式</li>
</ul>
```

## 然后回到「Skill 沉淀」索引页加一行

在「📦 已沉淀项目」表里加：

```markdown
| [**项目名**](wiki-url) | vX.Y.Z | 🟢 active | 一句话用途 |
```

## 配套：发版自动同步

如果项目用 GitHub Releases，加 `.github/workflows/release-notes-to-wiki.yml` 让每次 release 自动建子文档。范本见 [release-automation.md](../release-automation.md)。
