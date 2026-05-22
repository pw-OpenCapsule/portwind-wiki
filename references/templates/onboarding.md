# Template: 团队入门 子节点

> 父节点：**🚀 团队入门** · 新人第一周该看的东西

## 维护人

每个团队入门文档**必须有 1-2 个老员工兼任维护**。半年外没复检的内容自动加「可能过期」标签。

## 不要写的

- ❌ 业务知识（口传 + design doc 即可，不进 onboarding）
- ❌ 详细 API 文档（让新人自己查代码）
- ❌ 个人偏好（除非全团队共识）

## 模板

```xml
<title>新人第 X 周：xxx（适用人）</title>

<callout emoji="🚀" background-color="light-blue" border-color="blue">
  <p>适用人：<b>后端 / 前端 / 全栈</b>（按场景选）</p>
  <p>预计耗时：约 X 小时</p>
  <p>维护人：@xxx</p>
</callout>

<h2>1. 这是什么 / 适用人</h2>
<p>一句话定位，哪类新人按这一份。</p>

<h2>2. 先做（必做，按顺序）</h2>
<ol>
  <li><b>装基础工具链</b>
    <pre lang="bash"><code>brew install xxx</code></pre>
    验证：<code>xxx --version</code> 输出 vY.Z
  </li>
  <li><b>登录企业系统</b><br/>从 IT 拿邀请，进 Lark workspace + 1Password vault</li>
  <li><b>clone 主仓库 + 跑起来</b>
    <pre lang="bash"><code>cd ~/code &amp;&amp; git clone ...
cd ... &amp;&amp; pnpm install &amp;&amp; pnpm dev</code></pre>
    验证：http://localhost:3000 打开
  </li>
</ol>

<h2>3. 再做（按需）</h2>
<ul>
  <li>装 Claude Code + portwind-wiki skill（团队 wiki 沉淀）</li>
  <li>装 claude-statusbar 看 rate-limit 用量</li>
  <li>装 wrangler-accounts 多 Cloudflare 账号管理</li>
  <li>配公司 VPN</li>
</ul>

<h2>4. 卡住找谁</h2>
<table>
  <colgroup><col width="180"/><col width="180"/><col width="300"/></colgroup>
  <thead><tr>
    <th background-color="light-gray"><p>领域</p></th>
    <th background-color="light-gray"><p>找谁</p></th>
    <th background-color="light-gray"><p>怎么找</p></th>
  </tr></thead>
  <tbody>
    <tr><td><p>账号 / 权限</p></td><td><p>@IT</p></td><td><p>飞书 @ TA</p></td></tr>
    <tr><td><p>本地跑不起来</p></td><td><p>onboarding mentor @xxx</p></td><td><p>飞书</p></td></tr>
    <tr><td><p>架构 / 业务</p></td><td><p>对应模块 owner（GitHub CODEOWNERS）</p></td><td><p>PR / 飞书</p></td></tr>
  </tbody>
</table>

<h2>5. 半年回看</h2>
<p>上次更新：YYYY-MM-DD · 下次复检：YYYY-MM-DD（6 月后）</p>
```

## 写 onboarding 的纪律

- **每条「先做」都要有验证步骤**（不只命令，得告诉新人「跑通的样子」）
- **「找谁」必须是具体姓名**，不要写「问团队」
- **半年没复检 = 加 `[可能过期 YYYY-MM]` 前缀**，提醒读者别照搬
