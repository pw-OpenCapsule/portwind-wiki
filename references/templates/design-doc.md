# Template: 架构 & 调研 子节点（design doc / 选型 / ADR）

> 父节点：**📐 架构 & 调研**

## 什么时候写

- 动手前：要做的改动 ≥ 1 周工作量、要触发别人 review → 先写 design doc
- 选型时：在 X 和 Y 之间纠结 / 做了 POC → 写选型对比
- 事后：重构动了核心、为什么这么动需要后人知道 → 补一个 ADR

## status 字段（必填）

- `idea / 待验证` — 占位条目，触发背景 + 一句话假设 + 待回答问题
- `draft` — 在写
- `under review` — 找人挑刺中
- `decided` — 已拍板，按本文档实施
- `superseded by <link>` — 被新文档替代

占位条目不是垃圾条目 —— 让下一个人知道「这里有个悬而未决的问题」。

## 模板（5 段 RFC）

```xml
<title>主题（建议 ≤ 30 字）</title>

<callout emoji="🌱" background-color="light-yellow" border-color="yellow">
  <p><b>status: idea / draft / under review / decided</b></p>
  <p>作者：xxx · 创建：YYYY-MM-DD · 最近更新：YYYY-MM-DD</p>
</callout>

<h2>1. 背景</h2>
<p>问题是什么？现在为什么不够用？谁受影响？（3-5 句）</p>

<h2>2. 备选方案</h2>
<ul>
  <li><b>方案 A：xxx</b> —— 一句话描述</li>
  <li><b>方案 B：xxx</b> —— 一句话描述</li>
  <li><b>方案 C：xxx</b>（可选）</li>
</ul>

<h2>3. 权衡</h2>
<table>
  <colgroup><col width="160"/><col width="180"/><col width="180"/></colgroup>
  <thead><tr>
    <th background-color="light-gray"><p>维度</p></th>
    <th background-color="light-gray"><p>方案 A</p></th>
    <th background-color="light-gray"><p>方案 B</p></th>
  </tr></thead>
  <tbody>
    <tr><td><p>性能</p></td><td><p>...</p></td><td><p>...</p></td></tr>
    <tr><td><p>复杂度</p></td><td><p>...</p></td><td><p>...</p></td></tr>
    <tr><td><p>维护成本</p></td><td><p>...</p></td><td><p>...</p></td></tr>
    <tr><td><p>迁移成本</p></td><td><p>...</p></td><td><p>...</p></td></tr>
  </tbody>
</table>

<h2>4. 决策</h2>
<p>选了哪个 + 一句话理由。</p>

<h2>5. 待解决 / 已知未知</h2>
<p>这个决策的未知 / 需要后续验证的点。没有也写一句「无」。</p>

<h2>🔗 相关</h2>
<ul>
  <li>对应工具页：<a href="...">Skill 沉淀 / X</a></li>
  <li>触发本文档的群聊：<a href="...">飞书群 X，YYYY-MM-DD</a></li>
</ul>
```

## idea 占位的简化版（status=idea 用这个）

只填 3 段：

```xml
<h2>📍 触发背景</h2>
<blockquote><p>来自 xxx 在 yyy 群（YYYY-MM-DD）：「<原话>」</p></blockquote>

<h2>💡 一句话假设</h2>
<p>...</p>

<h2>❓ 待回答</h2>
<ul>
  <li>问题 1</li>
  <li>问题 2</li>
</ul>
```
