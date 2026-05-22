# Bootstrap：新团队首次搭 wiki

让 agent 跟着这个文档一步步建出 7 父节点 + Homepage。

## 前置

- 飞书 wiki 空间已建好（或用现成的）
- `lark-cli auth login --recommend` 已完成
- 当前用户对该 wiki 空间有 owner / admin 权限

## 步骤

### 1. 拿 space_id

```bash
lark-cli wiki +space-list --as user --page-size 50
```

从列表里找到目标空间，记下 `space_id`。

### 2. 建 7 个父节点

按这个顺序建（影响侧栏排列）：

```bash
SPACE=<你的 space_id>

for name in "Skill 沉淀" "产品沉淀" "架构 & 调研" "踩坑 & 复盘" "团队入门" "工具雷达" "技术分享"; do
  lark-cli wiki +node-create --space-id $SPACE \
    --title "$name" --obj-type docx --node-type origin --as user
done
```

记下每个返回的 `node_token` 和 `obj_token`（后面要用）。

### 3. 填每个父节点的索引页

每个父节点是个 docx，需要填索引内容。模板在 [templates/](templates/) 下，但**索引页本身**用下面这些骨架（agent 按模板填）：

#### Skill 沉淀 索引页

```xml
<title>Skill 沉淀</title>

<callout emoji="🛠️" background-color="light-blue" border-color="blue">
  <p>本目录沉淀团队的 <b>AI agent skill / CLI 工具 / 编辑器 plugin</b> 类项目 —— 装上即用、面向单人开发体验。</p>
  <p><b>路由规则</b>：使用层文档（怎么装、怎么用）属于本节点；设计 / 选型讨论去 <a href="<架构调研 url>">架构 &amp; 调研</a>；使用中撞到的坑去 <a href="<踩坑 url>">踩坑 &amp; 复盘</a>。</p>
</callout>

<h2>📦 已沉淀项目（0 个）</h2>
<!-- 4 列表格：名字 / 版本 / 状态 / 用途。新增项目时在这加行。-->

<h2>🆕 加新项目的约定</h2>
<p>新沉淀一个 skill 项目时：</p>
<ol>
  <li>在本节点下建子文档（命名 = repo 名）</li>
  <li>填一份概览：用途、安装、关键命令、跟其他项目的关系（模板见 portwind-wiki skill）</li>
  <li>有 GitHub Releases → 加自动同步 workflow（参考 portwind-wiki/references/release-automation.md）</li>
  <li>回到本索引页加一行进表格</li>
</ol>

<p>跟 agent 说：「把 /path/to/repo 沉淀进 Skill 沉淀」即可。</p>
```

其他 6 个索引页骨架类似，每个对应一个 template，agent 照着写。

### 4. 改 Homepage

Homepage 已经存在（飞书空间默认有）。需要把默认的英文 placeholder 换成中文导航。骨架：

```xml
<title>团队知识库</title>

<callout emoji="📚" background-color="light-blue" border-color="blue">
  <p><b>这里沉淀团队的技术资产 —— 工具、产品、设计、踩坑、入门、分享。</b></p>
  <p>一句话规矩：<b>有可复用价值的就写下来</b>。模板都备好，复制粘贴改就行。</p>
</callout>

<h2>🧭 导航</h2>
<table>
  <colgroup><col width="160"/><col width="380"/><col width="180"/></colgroup>
  <thead><tr>
    <th background-color="light-gray"><p>分类</p></th>
    <th background-color="light-gray"><p>放什么</p></th>
    <th background-color="light-gray"><p>最适合的提问</p></th>
  </tr></thead>
  <tbody>
    <!-- 7 行，每个父节点一行 -->
  </tbody>
</table>

<h2>🎯 沉淀什么 / 不沉淀什么</h2>
<grid>
  <column width-ratio="0.5">
    <callout emoji="✅" background-color="light-green" border-color="green">
      <p><b>沉淀</b></p>
      <p>• 跑了 1 次还想再用的</p>
      <p>• 撞过的坑（哪怕一句话）</p>
      <p>• 反复被问的</p>
      <p>• 设计 / 选型决策</p>
    </callout>
  </column>
  <column width-ratio="0.5">
    <callout emoji="❌" background-color="light-red" border-color="red">
      <p><b>不沉淀</b></p>
      <p>• 个人学习笔记</p>
      <p>• 会议纪要（飞书妙记有）</p>
      <p>• 一次性脚本</p>
      <p>• 业务知识大杂烩</p>
    </callout>
  </column>
</grid>

<h2>📋 维护约定</h2>
<ul>
  <li>不删，只归档</li>
  <li>模板必填段卡住未完成条目</li>
  <li>cross-link 设计文档 ↔ 工具页</li>
  <li>季度自清，30 分钟</li>
</ul>
```

### 5. 给同事发群通告

短，不介绍内容，只给链接：

```
团队 wiki 搭好了

<wiki Homepage URL>

经验、踩坑、好工具都可以往里扔，自己以后也好找
```

## 完整 setup 大约花多久

熟练的 agent：3-5 分钟（含等 API 响应）。

第一次手动跑：15-20 分钟。

## 跟 portwind-wiki skill 的关系

本 bootstrap 用的所有结构 / 路由 / 模板都来自本 skill 的其他 reference。装了 portwind-wiki skill 之后，跟 agent 说「按 portwind-wiki 搭一个团队 wiki」，它会自动跑这个流程。
