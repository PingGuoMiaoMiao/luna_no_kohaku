# 🌙 Luna No Kohaku

> 一个用 MoonBit 实现的算法与数据结构库，从基础到进阶，应有尽有！

## ✨ 项目简介

这是一个用 **MoonBit** 语言实现的算法与数据结构库，包含了常用的数据结构、缓存算法、字符串工具、图算法和编码压缩等模块。无论是学习算法、准备面试，还是在实际项目中使用，这里都能找到你需要的！

## 🚀 项目特色

- 📦 **模块化设计**：每个模块独立，按需使用
- 🎯 **功能完整**：从基础数据结构到高级算法，一应俱全
- 🧪 **测试覆盖**：每个模块都有对应的测试用例
- 📚 **代码清晰**：注释详细，易于理解和学习
- ⚡ **性能优化**：针对 MoonBit 特性进行了优化

## 📁 项目结构

```
luna_no_kohaku/
├── cmd/
│   ├── dsa/              # 数据结构
│   │   ├── linked_list/  # 链表
│   │   ├── bst/          # 二叉搜索树
│   │   ├── queue/        # 队列
│   │   ├── stack/        # 栈
│   │   ├── deque/        # 双端队列
│   │   └── priority_queue/ # 优先队列
│   │
│   ├── cache/            # 缓存算法
│   │   ├── fifo/         # 先进先出
│   │   ├── lru/          # 最近最少使用
│   │   ├── lfu/          # 最不经常使用
│   │   ├── arc/          # 自适应替换缓存
│   │   └── mru/          # 最近最多使用
│   │
│   ├── string_util/      # 字符串工具
│   │   ├── basic/        # 基础操作（split, join, replace等）
│   │   ├── match/        # 字符串匹配（KMP, Rabin-Karp等）
│   │   ├── trie/         # 字典树
│   │   └── compress/     # 压缩算法（RLE）
│   │
│   ├── graph/            # 图算法
│   │   ├── bfs_dfs.mbt   # 广度/深度优先搜索
│   │   ├── dijkstra.mbt  # 最短路径
│   │   ├── mst.mbt       # 最小生成树
│   │   ├── topological_sort.mbt # 拓扑排序
│   │   └── astar.mbt     # A* 搜索
│   │
│   └── encoding/         # 编码与压缩
│       ├── huffman/      # 哈夫曼编码
│       ├── bit/          # 位运算
│       ├── base64/       # Base64 编码
│       ├── crc/          # CRC32 校验
│       ├── hash/         # 哈希函数（MD5/SHA1）
│       ├── serialize/    # 序列化
│       └── chunk/        # 分块处理
│
└── doc/                  # 文档
    ├── OPTIMIZATION_SUGGESTIONS.md
    ├── CACHE_APPLICATIONS.md
    └── ...
```

## 🎯 已实现的功能

### 📊 数据结构 (dsa)
- ✅ **链表** (LinkedList)：支持插入、删除、查找
- ✅ **二叉搜索树** (BST)：支持插入、删除、查找、排序
- ✅ **队列** (Queue)：FIFO 队列
- ✅ **栈** (Stack)：LIFO 栈
- ✅ **双端队列** (Deque)：支持两端操作
- ✅ **优先队列** (PriorityQueue)：基于堆实现

### 💾 缓存算法 (cache)
- ✅ **FIFO**：先进先出策略
- ✅ **LRU**：最近最少使用策略
- ✅ **LFU**：最不经常使用策略
- ✅ **ARC**：自适应替换缓存
- ✅ **MRU**：最近最多使用策略

### 🔤 字符串工具 (string_util)
- ✅ **基础操作**：split, join, substring, replace
- ✅ **字符串匹配**：暴力匹配、KMP、Rabin-Karp
- ✅ **字典树** (Trie)：支持插入、查找、自动补全
- ✅ **压缩算法**：Run-Length Encoding (RLE)

### 🕸️ 图算法 (graph)
- ✅ **BFS/DFS**：广度/深度优先搜索
- ✅ **Dijkstra**：单源最短路径
- ✅ **MST**：最小生成树（Kruskal、Prim）
- ✅ **拓扑排序**：DFS 和 Kahn 算法
- ✅ **A* 搜索**：启发式搜索
- ✅ **随机 DFS**：随机深度优先搜索

### 🔐 编码与压缩 (encoding)
- ✅ **哈夫曼编码**：最优前缀编码
- ✅ **位运算**：完整的位操作工具集
- ✅ **Base64**：Base64 编码/解码
- ✅ **CRC32**：循环冗余校验
- ✅ **哈希函数**：MD5、SHA1、FNV-1a
- ✅ **序列化**：整数、字符串、布尔数组序列化
- ✅ **分块处理**：数据分块和合并

## 💡 使用示例

### 数据结构示例

```moonbit
// 使用链表
let list = LinkedList::new()
let list1 = LinkedList::push(list, 1)
let list2 = LinkedList::push(list1, 2)
let value = LinkedList::peek(list2)  // Some(2)

// 使用队列
let queue = Queue::new(10)
let q1 = Queue::enqueue(queue, "hello")
let q2 = Queue::enqueue(q1, "world")
let (q3, item) = Queue::dequeue(q2)  // item = Some("hello")
```

### 缓存算法示例

```moonbit
// 使用 LRU 缓存
let cache = LRU::new(3)
let c1 = LRU::put(cache, "key1", "value1")
let c2 = LRU::put(c1, "key2", "value2")
let (c3, value) = LRU::get(c2, "key1")  // Some("value1")
```

### 图算法示例

```moonbit
// 创建图并执行 BFS
let graph = Graph::new(5)
let g1 = Graph::add_edge(graph, 0, 1, 1.0)
let g2 = Graph::add_edge(g1, 0, 2, 1.0)
let result = bfs(g2, 0)
// result.visited 包含访问过的节点
// result.distance 包含距离信息
```

### 字符串工具示例

```moonbit
// 字符串匹配
let text = "hello world"
let pattern = "world"
let positions = kmp_find_all(text, pattern)  // [6]

// Trie 自动补全
let trie = Trie::new()
let t1 = Trie::insert(trie, "hello")
let t2 = Trie::insert(t1, "world")
let suggestions = Trie::autocomplete(t2, "he")  // ["hello"]
```

### 编码压缩示例

```moonbit
// 哈夫曼编码
let data = "hello"
let (encoded, tree) = compress(data)
let decoded = decompress(encoded, tree)  // "hello"

// Base64 编码
let encoded = encode("hello")  // "aGVsbG8="
let decoded = decode(encoded)  // "hello"

// CRC32 校验
let crc = crc32("hello")  // 计算校验和
let hex = crc32_to_hex(crc)  // 转换为十六进制
```

## ⚡ 运行测试

```bash
# 运行所有测试
moon test

# 运行特定模块的测试
moon test cmd/dsa
moon test cmd/cache
moon test cmd/graph
moon test cmd/encoding

# 检查代码
moon check

# 格式化代码
moon fmt

# 更新接口文件
moon info
```

## 🎨 优点

1. **功能全面**：涵盖了常用的算法和数据结构
2. **模块化设计**：每个模块独立，易于维护和扩展
3. **代码清晰**：注释详细，适合学习和参考
4. **测试完整**：每个模块都有对应的测试用例
5. **性能优化**：
   - 针对 MoonBit 特性进行了优化
   - 缓存算法使用工具函数减少数组复制
   - 查找操作从后往前遍历（利用局部性）
6. **易于使用**：API 设计简洁，上手快
7. **文档完善**：提供详细的使用示例和最佳实践

## ⚠️ 缺点与限制

1. **MoonBit 语言限制**：
   - 由于 MoonBit 的函数式特性，某些算法实现可能不如命令式语言直观
   - 缺少内置的 Map/Set 等数据结构，部分实现使用了数组模拟
   - **已优化**：通过提取工具函数（`update_array`, `remove_at`, `append`）减少了数组复制操作

2. **性能考虑**：
   - ~~某些操作（如数组复制）可能影响性能~~ **已优化**：缓存算法已使用工具函数优化数组操作
   - 缓存算法使用线性搜索，对于大容量缓存（> 100）可能较慢
   - **优化建议**：对于大容量缓存，可以考虑使用自定义 HashMap（已实现，位于 `cmd/cache/common/hash_map.mbt`）

3. **功能简化**：
   - MD5/SHA1 等哈希函数是简化实现，不适合生产环境（仅用于学习和演示）
   - 某些算法（如 A*）的启发式函数需要根据实际场景实现

4. **文档**：
   - ~~部分高级功能的使用示例可能不够详细~~ **已优化**：已添加详细的使用示例文档（`doc/USAGE_EXAMPLES.md`）

## 🔧 依赖要求

- MoonBit 编译器（最新版本）
- 支持 MoonBit 的开发环境

## 📝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本项目
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

## 📄 许可证

本项目采用 Apache-2.0 许可证。

## 🙏 致谢

感谢 MoonBit 团队提供了这么好的语言和工具！

---

**Made with ❤️ and MoonBit**

> 如果你觉得这个项目有用，给个 ⭐ 吧！你的支持是我继续前进的动力 💪
