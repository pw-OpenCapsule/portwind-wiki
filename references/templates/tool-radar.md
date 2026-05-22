# Template: 工具雷达 子节点

> 父节点：**📌 工具雷达** · 团队发现的**外部**工具（不是自研）

## 跟 Skill 沉淀 的区别

| | Skill 沉淀 | 工具雷达 |
|---|---|---|
| 谁做的 | 团队自研 | 外部别人做的 |
| 维护 | 我们负责 | 跟着原作者节奏 |
| 时效性 | 长期 | 6 月复查一次 |

## 标题约定

直接用工具名。`cmux` / `chops.md` / `markitdown`。

## 必填字段

每条工具雷达条目**必须带 2 个时间字段**：

- `discovered_at`：发现日期（YYYY-MM）
- `review_at`：建议复查日期（默认 6 月后）

## 模板

```xml
<title>工具名</title>

<callout emoji="🔧" background-color="light-blue" border-color="blue">
  <p>一句话定位（≤ 50 字）。</p>
</callout>

<h2>1. 是什么</h2>
<ul>
  <li>仓库 / 主页：<a type="url-preview" href="...">user/repo 或 site</a></li>
  <li>类型：CLI / browser extension / web app / library / ...</li>
</ul>

<h2>2. 我们为什么关注</h2>
<ul>
  <li>解决了 X 痛点 / 跟现有方案 Y 的区别</li>
  <li>对我们工作流的潜在价值</li>
  <li>（如有）当前局限 / 风险</li>
</ul>

<h2>3. 怎么试 / 用</h2>
<pre lang="bash"><code># 装 + 一个能跑通的 demo（3-5 行内）
xxx install
xxx --help</code></pre>

<h2>4. 来源 + 复查</h2>
<ul>
  <li>来源：via &lt;群名&gt;，YYYY-MM</li>
  <li>review_at: YYYY-MM</li>
</ul>
```

## 不要的反例

- ❌ Claude 产品页（claude.ai/design）—— 产品页不是工具
- ❌ 课程链接 / 书 —— 个人学习资源，不是团队工具
- ❌ 听过但没试过的工具 —— 雷达条目意味着「至少有 1 人用过」

## 季度自清流程

每季度 30 分钟，老员工兼任：

1. 看 `review_at` 已过 → 真还用吗？
   - 还用 → 顺手 +6 月
   - 不用 → 加 `[archived YYYY-MM]` 前缀，不删
2. 链接 404 → 加 `[archived]`
3. 跟现有 Skill / Plugin 重了 → 合并到那个节点 + 本条转「指向 X」

## 然后回索引页加一行

在「📡 当前雷达」表里：

```markdown
| [**工具名**](wiki-url) | 一句话 | 2026-MM | 2026-MM |
```

四列：工具 / 一句话 / 发现于 / 复查日期。
