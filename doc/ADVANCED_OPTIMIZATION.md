# 高级优化方案

本文档列出了当前算法实现的进一步优化建议，按优先级和影响程度分类。

## 🔴 高优先级优化（性能影响大）

### 1. 字符串操作：减少字符串拼接开销

**问题**：`split`、`substring`、`replace`、`rle.decode` 等函数中仍使用字符串拼接 `s = s + char.to_string()`，每次拼接都会创建新字符串，时间复杂度为 O(n²)。

**当前实现**：
```moonbit
// basic.mbt - split 函数
let mut s = ""
for k = start; k < i; k = k + 1 {
  s = s + str[k].to_string()  // O(n²) 复杂度
}
```

**优化方案**：
- 使用字符数组（`Array[Int]`）构建，最后一次性转换为字符串
- 时间复杂度从 O(n²) 降低到 O(n)
- 空间复杂度：O(n)

**预期性能提升**：对于长字符串（>1000 字符），性能提升 10-100 倍

**影响范围**：
- `cmd/string_util/basic/basic.mbt`: `split`, `substring`, `replace`
- `cmd/string_util/compress/rle.mbt`: `decode`

---

### 2. BST 排序算法优化

**问题**：当前使用冒泡排序 O(n²)，每次 `insert` 都需要 O(n log n) 或 O(n²) 时间。

**当前实现**：
```moonbit
// bst.mbt - sort_array 函数
// 冒泡排序 O(n²)
for i = 0; i < len - 1; i = i + 1 {
  for j = 0; j < len - i - 1; j = j + 1 {
    if result[j + 1].compare(result[j]) < 0 {
      // 交换
    }
  }
}
```

**优化方案**：
- 实现快速排序或归并排序，时间复杂度 O(n log n)
- 对于小数组（< 10），可以使用插入排序
- 对于已排序数组，使用二分插入，时间复杂度 O(log n)

**预期性能提升**：
- 小数组（< 10）：提升 2-3 倍
- 大数组（> 100）：提升 10-100 倍

**影响范围**：
- `cmd/dsa/bst/bst.mbt`: `sort_array` 函数

---

### 3. 缓存算法：使用哈希表优化查找

**问题**：所有缓存算法（FIFO, LRU, LFU, ARC, MRU）使用线性搜索 O(n) 查找键。

**当前实现**：
```moonbit
// 从后往前查找，但仍然是 O(n)
for i = self.data.length() - 1; i >= 0; i = i - 1 {
  let (k, v) = self.data[i]
  if k.compare(key) == 0 {
    // 找到
  }
}
```

**优化方案**：
- 实现简单的哈希表（使用数组 + 哈希函数）
- 或者使用 MoonBit 的 `Map` 类型（如果可用）
- 维护键到索引的映射：`Map[K, Int]` 或 `Array[(K, Int)]`
- 查找复杂度从 O(n) 降低到 O(1)（平均情况）

**预期性能提升**：
- 小容量缓存（< 10）：提升不明显
- 中等容量（10-100）：提升 5-10 倍
- 大容量（> 100）：提升 10-100 倍

**影响范围**：
- `cmd/cache/fifo/fifo.mbt`
- `cmd/cache/lru/lru.mbt`
- `cmd/cache/lfu/lfu.mbt`
- `cmd/cache/arc/arc.mbt`
- `cmd/cache/mru/mru.mbt`

**注意**：由于 MoonBit 可能没有内置 `Map`，需要实现简单的哈希表或使用其他数据结构。

---

## 🟡 中优先级优化（性能影响中等）

### 4. Trie 字符转换优化

**问题**：`dfs_collect` 函数中使用 `i.to_string()` 将索引转换为字符串，这不是正确的字符转换方式。

**当前实现**：
```moonbit
// trie.mbt - dfs_collect 函数
let char_str = i.to_string()  // 错误：将索引转为字符串，不是字符
let new_prefix = prefix + char_str
```

**优化方案**：
- 存储字符码到索引的映射关系
- 在插入时记录字符码，在遍历时使用字符码构建字符串
- 或者使用字符码数组，最后一次性转换为字符串

**预期性能提升**：修复逻辑错误，确保功能正确性

**影响范围**：
- `cmd/string_util/trie/trie.mbt`: `dfs_collect` 函数

---

### 5. 字符串匹配算法：Boyer-Moore 算法

**问题**：当前只有暴力匹配、KMP 和 Rabin-Karp。对于某些场景，Boyer-Moore 算法可能更高效。

**优化方案**：
- 实现 Boyer-Moore 算法（从右到左匹配，跳过不匹配的字符）
- 平均时间复杂度：O(n/m)，最坏情况 O(n*m)
- 对于长模式串，性能优于 KMP

**预期性能提升**：
- 长文本 + 长模式：提升 2-5 倍
- 短模式：提升不明显

**影响范围**：
- 新增：`cmd/string_util/match/boyer_moore.mbt`

---

### 6. 缓存算法：减少数组复制

**问题**：更新 `access_order` 或 `frequencies` 时需要复制整个数组。

**当前实现**：
```moonbit
// 每次更新都需要复制整个数组
let new_order = {
  let temp = []
  for i = 0; i < self.access_order.length(); i = i + 1 {
    if i == found_idx {
      temp.push(self.next_order) |> ignore
    } else {
      temp.push(self.access_order[i]) |> ignore
    }
  }
  temp
}
```

**优化方案**：
- 使用可变数组（如果 MoonBit 支持）
- 或者使用索引映射，避免复制整个数组
- 延迟更新，批量处理多个更新

**预期性能提升**：
- 小容量缓存：提升 2-3 倍
- 大容量缓存：提升 5-10 倍

**影响范围**：
- `cmd/cache/lru/lru.mbt`
- `cmd/cache/lfu/lfu.mbt`
- `cmd/cache/arc/arc.mbt`
- `cmd/cache/mru/mru.mbt`

---

## 🟢 低优先级优化（性能影响小或代码质量）

### 7. 字符串操作：使用字符串切片（如果支持）

**问题**：`substring` 函数手动构建字符串，如果 MoonBit 支持字符串切片，可以直接使用。

**优化方案**：
- 检查 MoonBit 是否支持 `str[start:end]` 语法
- 如果支持，直接使用切片，避免手动构建

**预期性能提升**：提升 2-5 倍（如果支持原生切片）

**影响范围**：
- `cmd/string_util/basic/basic.mbt`: `substring` 函数

---

### 8. 代码重复：提取公共函数

**问题**：多个缓存算法有相似的查找和更新逻辑。

**优化方案**：
- 提取公共的查找函数
- 提取公共的数组更新函数
- 创建缓存基类或 trait（如果 MoonBit 支持）

**预期性能提升**：代码可维护性提升，性能影响小

**影响范围**：
- `cmd/cache/*/*.mbt`

---

### 9. 内存优化：预分配数组大小

**问题**：某些函数中，数组大小可以预先计算，但当前是动态增长。

**优化方案**：
- 在 `split` 函数中，可以预先估计结果数组大小
- 在 `rle.decode` 中，可以预先计算总字符数
- 使用预分配数组，减少重新分配次数

**预期性能提升**：提升 10-20%

**影响范围**：
- `cmd/string_util/basic/basic.mbt`: `split`
- `cmd/string_util/compress/rle.mbt`: `decode`

---

### 10. 边界检查和错误处理

**问题**：某些函数缺少边界检查或错误处理。

**优化方案**：
- 添加更完善的边界检查
- 使用 `Result` 类型处理错误（如果 MoonBit 支持）
- 添加文档说明边界情况

**预期性能提升**：代码质量提升，性能影响小

**影响范围**：
- 所有文件

---

## 📊 优化优先级总结

| 优先级 | 优化项 | 预期性能提升 | 实现难度 | 影响范围 |
|--------|--------|--------------|----------|----------|
| 🔴 高 | 字符串拼接优化 | 10-100x | 低 | 4 个文件 |
| 🔴 高 | BST 排序优化 | 10-100x | 中 | 1 个文件 |
| 🔴 高 | 缓存哈希表优化 | 10-100x | 高 | 5 个文件 |
| 🟡 中 | Trie 字符转换 | 修复错误 | 中 | 1 个文件 |
| 🟡 中 | Boyer-Moore 算法 | 2-5x | 中 | 新增文件 |
| 🟡 中 | 减少数组复制 | 2-10x | 中 | 5 个文件 |
| 🟢 低 | 字符串切片 | 2-5x | 低 | 1 个文件 |
| 🟢 低 | 代码重复提取 | 可维护性 | 低 | 多个文件 |
| 🟢 低 | 预分配数组 | 10-20% | 低 | 2 个文件 |
| 🟢 低 | 错误处理 | 代码质量 | 低 | 所有文件 |

---

## 🚀 实施建议

### 第一阶段（立即实施）
1. **字符串拼接优化**：影响最大，实现简单
2. **BST 排序优化**：影响大，实现中等

### 第二阶段（短期实施）
3. **Trie 字符转换修复**：修复逻辑错误
4. **减少数组复制**：提升缓存性能

### 第三阶段（长期实施）
5. **缓存哈希表优化**：需要实现哈希表，复杂度高
6. **Boyer-Moore 算法**：新增功能
7. **其他低优先级优化**：代码质量提升

---

## 📝 注意事项

1. **MoonBit 限制**：某些优化可能受 MoonBit 语言特性限制（如不可变性、缺少内置 Map 等）
2. **测试覆盖**：优化后需要运行完整测试，确保功能正确性
3. **性能测试**：建议添加性能基准测试，验证优化效果
4. **向后兼容**：优化不应改变公共 API

---

## 🔍 性能测试建议

建议添加性能基准测试，测量优化前后的性能差异：

```moonbit
// 示例：字符串拼接性能测试
pub fn benchmark_split() {
  let long_str = "a" * 10000  // 假设支持字符串重复
  let start = time.now()
  let result = split(long_str, "a")
  let end = time.now()
  inspect(end - start)  // 记录执行时间
}
```

---

## 📚 参考资料

- MoonBit 官方文档：https://docs.moonbitlang.com
- 算法优化技巧
- 字符串处理最佳实践

