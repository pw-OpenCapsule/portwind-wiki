# Template: 技术分享 子节点

> 父节点：**🎤 技术分享** · 历史分享归档 + 待分享 backlog

## 标题约定

```
主题名（YYYY-MM-DD）
```

可选前缀：
- `[外部精选]` 外部会议 / 文章 / 视频合集
- `[handout]` 配套分享材料

## 模板

```xml
<title>主题名（YYYY-MM-DD）</title>

<p>分享人 · 时长 · 分类</p>

<h2>📋 大纲</h2>
<ol>
  <li>第 1 段（X min）</li>
  <li>第 2 段（X min）</li>
</ol>

<hr/>

<h2>正文 / 分章节展开</h2>

<!-- 主要内容。可以放 slides 截图 / 录屏链接 / 代码 demo / 引用源 -->

<hr/>

<h2>📚 参考资料</h2>
<ul>
  <li><a type="url-preview" href="...">资料 1</a></li>
</ul>

<hr/>

<h2>🎤 Q&A（分享后追加）</h2>
<p>分享会场答疑整理。</p>

<p>分享人：xxx · 日期：YYYY-MM-DD</p>
```

## 写分享文档的纪律（很重要）

避免 AI 味，**人话优先**：

- ❌ 「干货最多」「黄金 pattern」「核心理念」「能力光谱」 → 删
- ❌ 「实测省 30%+ token」这种没出处的数字 → 改成「我自己感觉明显降低」
- ❌ 5 条带走的结论 → 删，分享不该派结论
- ❌ 每段一个 emoji + callout 框 → 砍 80%
- ❌ Part 1/2/3 编号 → 改成自然 h2 标题
- ✅ 个人化 hedging（「我自己的习惯」「我用得最多」）
- ✅ 项目里的真实例子直接放正文，不用 callout 包

## 然后回到「技术分享」索引页加一行

在归档表加：

```markdown
| [标题](wiki-url) | 分享人 | YYYY-MM-DD | 分类 |
```

## 草稿期建议

新分享文档先在私人空间（草稿箱）写，定稿后 `lark-cli wiki +move` 搬回团队空间「技术分享」节点。详见 [drafts-workflow.md](../drafts-workflow.md)。
