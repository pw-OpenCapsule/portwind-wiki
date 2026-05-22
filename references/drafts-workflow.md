# 草稿工作流：私人空间 → 团队空间

新分享 / 长文档 / 大改动写到一半的，**不直接进团队空间**。先在私人 wiki 写，定稿再搬。

## 为什么

- 草稿状态团队看到容易误解（「这就是结论？」「我点进来怎么没写完？」）
- 写一半改方向不想留个公开版本里的尴尬历史
- 避免给团队首页归档表加链接、然后等定稿才补内容

## 一次性 setup：建私人草稿空间

```bash
lark-cli wiki +space-create \
  --name "<你的名字> 的草稿箱" \
  --description "私人草稿，分享前在这里写" \
  --as user
```

返回结果里记下 `space_id`，比如 `7642292358005493272`。

`visibility: private` —— 只有你能看（含管理员）。

## 写草稿

正常在草稿空间下建节点 + 写内容（用 `lark-cli wiki +node-create` 和 `docs +update`），跟在团队空间一样。

## 定稿搬到团队空间

```bash
lark-cli wiki +move \
  --node-token <草稿节点 token> \
  --source-space-id <草稿空间 id> \
  --target-space-id <团队空间 id> \
  --target-parent-token <团队空间目标父节点 token> \
  --as user
```

例子（搬到团队空间的「技术分享」父节点下）：

```bash
lark-cli wiki +move \
  --node-token VhMJwlx82iqo5okajjAjGfZmpAd \
  --source-space-id 7642292358005493272 \
  --target-space-id 7642234757744496151 \
  --target-parent-token RwtAw0NwIiMs7AkiRZnjQY8FpAd \
  --as user
```

搬完之后：
1. 文档 URL **不变**（wiki node token 是稳定的）
2. 权限自动跟着新父节点（团队空间 = 团队成员可见）
3. 草稿空间里那条节点消失

## 然后别忘了

更新对应父节点的索引页表格，加一行指向新文档。否则别人在团队空间根页找不到入口。

## 失败模式

| 现象 | 原因 / 解法 |
|---|---|
| `wiki +move` 报权限 | 缺 `wiki:node:move` scope → `lark-cli auth login --scope "wiki:node:move"` |
| 搬完原 URL 打不开 | 浏览器缓存，强刷或换浏览器试 |
| 搬完发现忘改某段 | 直接在团队空间继续 `docs +update`，跟新位置无关 |

## 反过来：从团队空间搬回草稿

如果你公开了一份草稿但想撤回继续改：

```bash
# 把 source 和 target 互换
lark-cli wiki +move \
  --node-token <节点 token> \
  --source-space-id <团队空间 id> \
  --target-space-id <草稿空间 id> \
  --as user
# 不传 --target-parent-token = 搬到草稿空间根
```

然后从团队索引页删掉那行链接（避免别人点 404）。

## 不要做的

- ❌ 不要在团队空间「权限设置」里把单文档设私有 —— 飞书 wiki 节点权限继承空间，单独设置容易踩坑。直接搬空间更干净。
- ❌ 不要用复制粘贴方式「搬」内容 —— 历史 / 评论 / 链接全丢，`wiki +move` 是原子操作。
