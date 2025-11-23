# 📖 使用示例文档

本文档提供了各个模块的详细使用示例，帮助你快速上手！

## 📊 数据结构 (dsa)

### 链表 (LinkedList)

```moonbit
// 创建链表
let list = LinkedList::new()

// 添加元素
let list1 = LinkedList::push(list, 1)
let list2 = LinkedList::push(list1, 2)
let list3 = LinkedList::push(list2, 3)

// 查看顶部元素
let top = LinkedList::peek(list3)  // Some(3)

// 移除顶部元素
let (list4, value) = LinkedList::pop(list3)  // value = Some(3)

// 获取长度
let len = LinkedList::length(list4)  // 2

// 检查是否为空
let empty = LinkedList::is_empty(list4)  // false
```

### 队列 (Queue)

```moonbit
// 创建容量为 10 的队列
let queue = Queue::new(10)

// 入队
let q1 = Queue::enqueue(queue, "first")
let q2 = Queue::enqueue(q1, "second")
let q3 = Queue::enqueue(q2, "third")

// 出队
let (q4, item1) = Queue::dequeue(q3)  // item1 = Some("first")
let (q5, item2) = Queue::dequeue(q4)  // item2 = Some("second")

// 查看队首元素（不移除）
let front = Queue::peek(q5)  // Some("third")

// 获取大小
let size = Queue::size(q5)  // 1
```

### 栈 (Stack)

```moonbit
// 创建栈
let stack = Stack::new()

// 入栈
let s1 = Stack::push(stack, 10)
let s2 = Stack::push(s1, 20)
let s3 = Stack::push(s2, 30)

// 出栈
let (s4, value) = Stack::pop(s3)  // value = Some(30)

// 查看栈顶（不移除）
let top = Stack::peek(s4)  // Some(20)
```

### 二叉搜索树 (BST)

```moonbit
// 创建 BST
let bst = BST::new()

// 插入元素
let bst1 = BST::insert(bst, 5)
let bst2 = BST::insert(bst1, 3)
let bst3 = BST::insert(bst2, 7)
let bst4 = BST::insert(bst3, 1)

// 查找元素
let found = BST::search(bst4, 3)  // true
let not_found = BST::search(bst4, 10)  // false

// 获取排序后的数组
let sorted = BST::to_array(bst4)  // [1, 3, 5, 7]
```

## 💾 缓存算法 (cache)

### LRU 缓存

```moonbit
// 创建容量为 3 的 LRU 缓存
let cache = LRU::new(3)

// 添加键值对
let c1 = LRU::put(cache, "key1", "value1")
let c2 = LRU::put(c1, "key2", "value2")
let c3 = LRU::put(c2, "key3", "value3")

// 获取值
let (c4, val1) = LRU::get(c3, "key1")  // val1 = Some("value1")

// 添加新元素（会淘汰最久未使用的 key2）
let c5 = LRU::put(c4, "key4", "value4")

// 检查 key2 是否还在
let exists = LRU::contains_key(c5, "key2")  // false
let (c6, val2) = LRU::get(c5, "key2")  // val2 = None
```

### FIFO 缓存

```moonbit
// 创建 FIFO 缓存
let cache = FIFO::new(3)

// 添加元素
let c1 = FIFO::put(cache, "a", 1)
let c2 = FIFO::put(c1, "b", 2)
let c3 = FIFO::put(c2, "c", 3)

// 添加新元素（会淘汰最先进入的 "a"）
let c4 = FIFO::put(c3, "d", 4)

let (c5, val_a) = FIFO::get(c4, "a")  // val_a = None（已被淘汰）
let (c6, val_b) = FIFO::get(c5, "b")  // val_b = Some(2)
```

### LFU 缓存

```moonbit
// 创建 LFU 缓存
let cache = LFU::new(3)

// 添加元素
let c1 = LFU::put(cache, "a", 1)
let c2 = LFU::put(c1, "b", 2)

// 多次访问 "a" 增加其频率
let (c3, _) = LFU::get(c2, "a")
let (c4, _) = LFU::get(c3, "a")

// 添加新元素（会淘汰频率最低的 "b"）
let c5 = LFU::put(c4, "c", 3)
let c6 = LFU::put(c5, "d", 4)

let (c7, val_b) = LFU::get(c6, "b")  // val_b = None（已被淘汰）
```

## 🔤 字符串工具 (string_util)

### 基础操作

```moonbit
// 分割字符串
let parts = split("hello,world,test", ",")  // ["hello", "world", "test"]

// 连接字符串
let joined = join(["hello", "world"], " ")  // "hello world"

// 子字符串
let sub = substring("hello world", 0, 5)  // "hello"

// 替换
let replaced = replace("hello world", "world", "moonbit")  // "hello moonbit"
```

### 字符串匹配

```moonbit
// KMP 算法查找所有匹配位置
let text = "ababcababc"
let pattern = "ab"
let positions = kmp_find_all(text, pattern)  // [0, 2, 5, 7]

// 查找第一个匹配位置
let first = kmp_find_first(text, pattern)  // Some(0)

// 检查是否包含
let contains = kmp_contains(text, pattern)  // true

// Rabin-Karp 算法
let rk_positions = rabin_karp_find_all(text, pattern)  // [0, 2, 5, 7]
```

### 字典树 (Trie)

```moonbit
// 创建字典树
let trie = Trie::new()

// 插入单词
let t1 = Trie::insert(trie, "hello")
let t2 = Trie::insert(t1, "world")
let t3 = Trie::insert(t2, "help")
let t4 = Trie::insert(t3, "hero")

// 查找单词
let found1 = Trie::search(t4, "hello")  // true
let found2 = Trie::search(t4, "help")  // true
let found3 = Trie::search(t4, "hero")  // true
let found4 = Trie::search(t4, "he")  // false（不是完整单词）

// 自动补全
let suggestions = Trie::autocomplete(t4, "he")  // ["hello", "help", "hero"]
```

### 压缩算法 (RLE)

```moonbit
// 编码
let data = "aaabbbcc"
let encoded = encode(data)  // [(97, 3), (98, 3), (99, 2)]

// 解码
let decoded = decode(encoded)  // "aaabbbcc"
```

## 🕸️ 图算法 (graph)

### 创建图

```moonbit
// 创建包含 5 个顶点的图
let graph = Graph::new(5)

// 添加有向边
let g1 = Graph::add_edge(graph, 0, 1, 2.0)  // 从 0 到 1，权重 2.0
let g2 = Graph::add_edge(g1, 0, 2, 3.0)
let g3 = Graph::add_edge(g2, 1, 3, 1.0)
let g4 = Graph::add_edge(g3, 2, 3, 4.0)

// 添加无向边
let g5 = Graph::add_undirected_edge(g4, 3, 4, 5.0)

// 添加无权重边（默认权重 1.0）
let g6 = Graph::add_edge_unweighted(g5, 4, 0)
```

### BFS（广度优先搜索）

```moonbit
// 执行 BFS
let result = bfs(g6, 0)

// 查看访问过的节点
let visited = result.visited  // [true, true, true, true, true]

// 查看距离
let distance = result.distance  // [0, 1, 1, 2, 3]

// 查看父节点
let parent = result.parent  // [None, Some(0), Some(0), Some(1), Some(3)]
```

### DFS（深度优先搜索）

```moonbit
// 执行 DFS
let result = dfs(g6, 0)

// 查看发现时间
let discovery = result.discovery_time  // [0, 1, 4, 2, 3]

// 查看完成时间
let finish = result.finish_time  // [7, 6, 5, 3, 4]
```

### Dijkstra 最短路径

```moonbit
// 计算从顶点 0 到所有顶点的最短路径
let result = dijkstra(g6, 0)

// 查看距离
let distances = result.distance  // [0.0, 2.0, 3.0, 3.0, 8.0]

// 查看可达性
let reachable = result.reachable  // [true, true, true, true, true]

// 获取从 0 到 4 的路径
let path = get_shortest_path(result, 0, 4)  // [0, 1, 3, 4]
```

### 最小生成树 (MST)

```moonbit
// 使用 Kruskal 算法
let mst_result = kruskal(g6)
let edges = mst_result.edges
let total_weight = mst_result.total_weight

// 使用 Prim 算法（从顶点 0 开始）
let prim_result = prim(g6, 0)
```

### 拓扑排序

```moonbit
// 创建有向无环图
let dag = Graph::new(5)
let d1 = Graph::add_edge(dag, 0, 1, 1.0)
let d2 = Graph::add_edge(d1, 0, 2, 1.0)
let d3 = Graph::add_edge(d2, 1, 3, 1.0)
let d4 = Graph::add_edge(d3, 2, 3, 1.0)
let d5 = Graph::add_edge(d4, 3, 4, 1.0)

// DFS 方法
let result1 = topological_sort(d5)
let order1 = result1.order  // [0, 2, 1, 3, 4] 或类似
let has_cycle1 = result1.has_cycle  // false

// Kahn 算法
let result2 = topological_sort_kahn(d5)
let order2 = result2.order  // [0, 1, 2, 3, 4] 或类似
```

### A* 搜索

```moonbit
// 定义启发式函数（这里使用零启发式，相当于 Dijkstra）
fn my_heuristic(vertex : Int) -> Double {
  // 实际应用中应该根据图的特性实现
  // 例如：欧几里得距离、曼哈顿距离等
  0.0
}

// 执行 A* 搜索
let result = astar(g6, 0, 4, my_heuristic)

if result.found {
  let path = result.path  // [0, 1, 3, 4]
  let cost = result.cost  // 8.0
} else {
  // 未找到路径
}
```

## 🔐 编码与压缩 (encoding)

### 哈夫曼编码

```moonbit
// 压缩数据
let data = "hello"
let (encoded, tree) = compress(data)

// 解压数据
let decoded = decompress(encoded, tree)  // "hello"

// 手动构建编码表
let frequencies = count_frequencies(data)
let huffman_tree = build_huffman_tree(frequencies)
let codes = generate_codes(huffman_tree)
let encoded_manual = encode(data, codes)
```

### Base64 编码

```moonbit
// 编码
let data = "hello"
let encoded = encode(data)  // "aGVsbG8="

// 解码
let decoded = decode(encoded)  // "hello"
```

### CRC32 校验

```moonbit
// 计算 CRC32
let data = "hello"
let crc = crc32(data)  // 计算校验和

// 转换为十六进制
let hex = crc32_to_hex(crc)  // "3610a686"

// 计算字节数组的 CRC32
let bytes = [104, 101, 108, 108, 111]
let crc_bytes = crc32_bytes(bytes)
```

### 哈希函数

```moonbit
// MD5（简化实现）
let data = "hello"
let md5_hash = md5(data)  // "5d41402abc4b2a76b9719d911017c592"

// SHA1（简化实现）
let sha1_hash = sha1(data)  // "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"

// 简单哈希
let simple = simple_hash(data)  // 99162322

// FNV-1a 哈希
let fnv = fnv1a_hash(data)  // 1335831723
```

### 位运算

```moonbit
// 设置位
let value = 0
let set = set_bit(value, 0)  // 1

// 清除位
let cleared = clear_bit(5, 0)  // 4

// 切换位
let toggled = toggle_bit(5, 1)  // 7

// 测试位
let is_set = test_bit(5, 0)  // true
let is_not_set = test_bit(5, 1)  // false

// 转换为二进制字符串
let binary = to_binary_string(5)  // "101"

// 从二进制字符串转换
let from_binary = from_binary_string("101")  // 5
```

### 序列化

```moonbit
// 序列化整数数组
let ints = [1, 2, 3, 4, 5]
let serialized = serialize_ints(ints)  // "1,2,3,4,5"

// 反序列化
let deserialized = deserialize_ints(serialized)  // [1, 2, 3, 4, 5]

// 序列化字符串数组
let strings = ["hello", "world"]
let serialized_str = serialize_strings(strings)  // "hello|world"

// 序列化布尔数组
let bools = [true, false, true]
let serialized_bool = serialize_bools(bools)  // "101"
```

### 分块处理

```moonbit
// 字符串分块
let data = "hello world"
let chunks = chunk_string(data, 3)  // ["hel", "lo ", "wor", "ld"]

// 整数数组分块
let numbers = [1, 2, 3, 4, 5, 6, 7]
let int_chunks = chunk_ints(numbers, 3)  // [[1, 2, 3], [4, 5, 6], [7]]

// 合并块
let merged = merge_chunks(chunks)  // "hello world"

// 对每个块应用函数
let doubled = map_chunks(int_chunks, fn(chunk) {
  // 将每个块中的数字翻倍
  let result = []
  for i = 0; i < chunk.length(); i = i + 1 {
    result.push(chunk[i] * 2) |> ignore
  }
  result
})
```

## 💡 最佳实践

1. **缓存容量选择**：根据实际使用场景选择合适的缓存容量，太小会导致频繁淘汰，太大会浪费内存。

2. **图算法选择**：
   - 对于无权图，使用 BFS 或 DFS
   - 对于有权图，使用 Dijkstra 或 A*
   - 对于需要拓扑顺序的场景，使用拓扑排序

3. **字符串匹配**：
   - 短模式：使用暴力匹配
   - 长模式：使用 KMP 或 Rabin-Karp
   - 需要多次匹配：使用 KMP（预处理一次）

4. **性能优化**：
   - 对于频繁操作的数据结构，考虑预分配容量
   - 使用合适的缓存策略（LRU、LFU 等）
   - 避免不必要的数组复制

## 🐛 常见问题

**Q: 为什么缓存算法的查找是 O(n)？**

A: 由于 MoonBit 缺少内置的 Map 数据结构，当前实现使用数组模拟。对于小容量缓存（< 100），性能可接受。如果需要更高性能，可以考虑使用自定义的 HashMap。

**Q: 哈希函数为什么是简化实现？**

A: MD5 和 SHA1 的完整实现非常复杂，需要大量的位运算和常量。简化版本仅用于演示和学习，生产环境应使用标准库或经过验证的实现。

**Q: 如何选择合适的缓存策略？**

A:
- **LRU**：适合访问模式有明显时间局部性的场景
- **LFU**：适合某些元素被频繁访问的场景
- **FIFO**：适合简单的队列式缓存
- **ARC**：适合访问模式复杂的场景

---

希望这些示例能帮助你更好地使用这个库！如果有问题，欢迎提交 Issue。

