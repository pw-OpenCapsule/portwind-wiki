# Template: 产品沉淀 子节点

> 自研 SaaS / 部署型产品的条目格式。父节点：**📦 产品沉淀**

## 跟 Skill 沉淀 的区别

| | Skill 沉淀 | 产品沉淀 |
|---|---|---|
| 装在哪 | 用户本机 | 服务器 / 边缘 |
| 谁运维 | 用户自己 | 项目方运维，多租户 |
| 升级 | 用户拉新版 | 项目方推线上 |
| 故障域 | 用户本机 | 服务端 + DNS + 边缘 |

边界争议（既是工具又是上架产品的）默认放 Skill 沉淀，除非有自己的后端 + 多租户。

## 模板

```xml
<title>产品名</title>

<callout emoji="📦" background-color="light-blue" border-color="blue">
  <p>一句话定位 + 关键技术栈。</p>
  <p>当前版本 vX.Y.Z</p>
</callout>

<h2>🔗 链接</h2>
<ul>
  <li><b>Live</b>：<a type="url-preview" href="https://...">demo / 主站</a></li>
  <li><b>仓库</b>：<a type="url-preview" href="https://github.com/...">user/repo</a></li>
  <li><b>所有 release</b>：<a type="url-preview" href="...">GitHub Releases</a></li>
</ul>

<h2>💡 为什么做这个</h2>
<p>3-5 句话讲清楚问题域 + 现有方案不够用的原因。</p>

<h2>🏗️ 技术栈</h2>
<table>
  <colgroup><col width="200"/><col width="500"/></colgroup>
  <thead><tr>
    <th background-color="light-gray"><p>组件</p></th>
    <th background-color="light-gray"><p>选型</p></th>
  </tr></thead>
  <tbody>
    <tr><td><p>运行时</p></td><td><p>Cloudflare Workers / Vercel / 自建 K8s ...</p></td></tr>
    <tr><td><p>数据库</p></td><td><p>D1 / Postgres / MongoDB ...</p></td></tr>
    <tr><td><p>对象存储</p></td><td><p>R2 / S3 / 自建</p></td></tr>
  </tbody>
</table>

<h2>🎯 用户视角 / 关键场景</h2>
<p>列 2-3 个典型用户故事。</p>

<h2>🔐 鉴权模型</h2>
<p>谁能看 / 谁能改 / 团队 vs 个人 / token / OAuth ...</p>

<h2>📜 版本节点</h2>
<table>
  <thead><tr>
    <th background-color="light-gray"><p>版本</p></th>
    <th background-color="light-gray"><p>主题</p></th>
  </tr></thead>
  <tbody>
    <tr><td><p>vX.Y.Z</p></td><td><p>...</p></td></tr>
  </tbody>
</table>

<h2>🌐 跟其它项目的关系</h2>
<ul>
  <li>跟 X 互补 / 替代 / 上下游</li>
</ul>
```

## 然后回索引页加一行

在「🌐 已沉淀产品」表里：

```markdown
| [**产品名**](wiki-url) | vX.Y.Z | 🟢 active | 一句话用途 |
```
