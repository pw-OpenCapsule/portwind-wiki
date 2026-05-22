# Template: [复盘] 线上故障 RCA

> 父节点：**🩹 踩坑 & 复盘** · 标题前缀：`[复盘]`（强制）

## 什么算 [复盘]

线上影响用户的事故。P0 / P1 必写；P2 / P3 看影响面。

非线上、自己撞的小坑走 [pitfall.md](pitfall.md) 的 `[坑]` 模板。

## 模板

```xml
<title>[复盘] 一句话事件 — YYYY-MM-DD（P0/P1/P2/P3）</title>

<callout emoji="🚨" background-color="light-red" border-color="red">
  <p><b>严重级</b>：P0 / P1 / P2 / P3</p>
  <p><b>影响</b>：哪些用户 / 多少请求 / 持续多久 / 业务损失估算</p>
  <p><b>主备份</b>：主复盘 @xxx · 备复盘 @yyy</p>
</callout>

<h2>1. 一句话事件</h2>
<p>≤ 30 字，回答「发生了什么 + 多严重」。</p>

<h2>2. 影响面</h2>
<ul>
  <li>受影响用户：x 万 / x%</li>
  <li>受影响请求：x req / x% 失败率</li>
  <li>持续时长：从 X 时分 到 Y 时分</li>
  <li>业务损失估算：金额 / 单量 / SLA 计费等</li>
</ul>

<h2>3. 时间线（UTC）</h2>
<table>
  <colgroup><col width="180"/><col width="500"/></colgroup>
  <thead><tr>
    <th background-color="light-gray"><p>时间</p></th>
    <th background-color="light-gray"><p>事件</p></th>
  </tr></thead>
  <tbody>
    <tr><td><p>HH:MM</p></td><td><p>告警触发 / 上线 / 配置变更</p></td></tr>
    <tr><td><p>HH:MM</p></td><td><p>oncall 介入</p></td></tr>
    <tr><td><p>HH:MM</p></td><td><p>定位到根因</p></td></tr>
    <tr><td><p>HH:MM</p></td><td><p>缓解措施生效</p></td></tr>
    <tr><td><p>HH:MM</p></td><td><p>完全恢复</p></td></tr>
    <tr><td><p>+24h</p></td><td><p>复盘会</p></td></tr>
  </tbody>
</table>

<h2>4. 根因（5 Whys）</h2>
<p>连续问 5 次「为什么」逼到机制层面，不要停在「xxx 改错了」。</p>
<ol>
  <li>为什么挂？—— ...</li>
  <li>为什么 X 会发生？—— ...</li>
  <li>...</li>
  <li>...</li>
  <li>...</li>
</ol>

<h2>5. 偶然 vs 系统</h2>
<p>是巧合（特定时序 / 罕见输入）还是机制必然（设计漏洞 / 缺监控）？</p>

<h2>6. Action items</h2>
<table>
  <colgroup><col width="60"/><col width="380"/><col width="120"/><col width="120"/></colgroup>
  <thead><tr>
    <th background-color="light-gray"><p>#</p></th>
    <th background-color="light-gray"><p>动作</p></th>
    <th background-color="light-gray"><p>owner</p></th>
    <th background-color="light-gray"><p>due</p></th>
  </tr></thead>
  <tbody>
    <tr><td><p>1</p></td><td><p>具体动作（不要写「优化 X」，写「在 Y 文件加 Z 校验」）</p></td><td><p>@xxx</p></td><td><p>YYYY-MM-DD</p></td></tr>
  </tbody>
</table>

<h2>7. What went well</h2>
<p>响应快的、决策对的、监控起作用的部分。让团队学到「这个继续做」。</p>

<h2>🔗 关联</h2>
<ul>
  <li>触发 commit / PR / 变更单</li>
  <li>对应 design doc（如果是设计缺陷）</li>
  <li>相关 [坑] 条目</li>
</ul>
```

## 写复盘的纪律

- **不追责人，追机制**：「为什么这个错误能在 review 中漏过」比「谁 review 的」重要
- **AI 不要套话**：「加强测试」「提高警惕」这种没用，必须落到具体 action item + owner + due
- **6 周内 review action items**：开个跟踪表，过了 due 没做要打开问
