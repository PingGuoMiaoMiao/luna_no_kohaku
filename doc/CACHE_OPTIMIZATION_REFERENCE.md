# 缓存算法优化参考 - 基于 SakuraTears 的实现方式

参考文章：[缓存淘汰算法（LFU、LRU、FIFO、ARC、MRU）](https://www.sakuratears.top/blog/%E7%BC%93%E5%AD%98%E6%B7%98%E6%B1%B0%E7%AE%97%E6%B3%95%EF%BC%88LFU%E3%80%81LRU%E3%80%81FIFO%E3%80%81ARC%E3%80%81MRU%EF%BC%89.html)

## 📊 实现方式对比

### 网页中的实现方式（Java）

#### FIFO 方案一：LinkedList + HashMap
```java
private LinkedList<K> linkedList;  // 维护顺序（先进先出）
private Map<K,V> hashMap;          // O(1) 查找

public V get(K key) {
    return hashMap.get(key);  // O(1)
}

public void set(K key, V value) {
    V v = hashMap.get(key);
    if(v == null){
        hashMap.put(key,value);
        linkedList.add(key);  // 添加到链表尾
    }else{
        hashMap.put(key,value);  // 只更新值
    }
    if(linkedList.size() > capacity){
        K k = linkedList.poll();  // 删除头部
        hashMap.remove(k);
    }
}
```

**关键特点**：
- ✅ **分离关注点**：HashMap 负责 O(1) 查找，LinkedList 负责维护顺序
- ✅ **查找复杂度**：O(1) 平均情况
- ✅ **内存占用**：较高（需要两个数据结构）

#### LRU：双向链表 + HashMap
```java
// 使用双向链表维护访问顺序
// HashMap 存储键值对，实现 O(1) 查找
```

**关键特点**：
- ✅ **双向链表**：可以快速移动节点到头部/尾部
- ✅ **HashMap**：O(1) 查找节点位置
- ✅ **更新操作**：O(1) 时间复杂度

---

### 我们当前的实现方式（MoonBit）

#### FIFO 当前实现
```moonbit
pub struct FIFOCache[K, V] {
  capacity : Int
  data : Array[(K, V)]  // 键值对数组
  len : Int
}

// 查找：O(n) 线性搜索
pub fn get(self : FIFOCache[K, V], key : K) -> (FIFOCache[K, V], V?) {
  for i = self.data.length() - 1; i >= 0; i = i - 1 {
    let (k, v) = self.data[i]
    if k.compare(key) == 0 {
      return (self, Some(v))
    }
  }
  (self, None)
}
```

**当前特点**：
- ❌ **查找复杂度**：O(n) 线性搜索
- ❌ **数组复制**：每次更新都需要复制整个数组
- ✅ **内存占用**：较低（只有一个数组）

---

## 🎯 优化方案

### 方案一：实现简单哈希表（推荐）

由于 MoonBit 可能没有内置 `Map`，我们需要实现一个简单的哈希表。

#### 1. 创建哈希表模块

```moonbit
// cmd/cache/common/hash_map.mbt
///| 简单的哈希表实现
///| 使用开放寻址法处理冲突

pub struct HashMap[K, V] {
  buckets : Array[(K, V)?]  // 桶数组
  size : Int
  capacity : Int
}

///| 哈希函数（简化版）
fn[K : Compare] hash(key : K, capacity : Int) -> Int {
  // 使用 key 的字符串表示计算哈希值
  // 注意：这是一个简化实现，实际应该使用更好的哈希函数
  let key_str = key.to_string()  // 假设有 to_string 方法
  let mut hash = 0
  for i = 0; i < key_str.length(); i = i + 1 {
    hash = (hash * 31 + key_str[i]) % capacity
  }
  hash
}

///| 查找键的索引
fn[K : Compare, V] HashMap::find_index(
  self : HashMap[K, V],
  key : K,
) -> Int {
  let mut idx = hash(key, self.capacity)
  let mut attempts = 0
  while attempts < self.capacity {
    match self.buckets[idx] {
      Some((k, _)) =>
        if k.compare(key) == 0 {
          return idx
        } else {
          idx = (idx + 1) % self.capacity
          attempts = attempts + 1
        }
      None => return -1
    }
  }
  -1
}

///| 获取值（O(1) 平均情况）
pub fn[K : Compare, V] HashMap::get(
  self : HashMap[K, V],
  key : K,
) -> (HashMap[K, V], V?) {
  let idx = HashMap::find_index(self, key)
  if idx >= 0 {
    match self.buckets[idx] {
      Some((_, v)) => (self, Some(v))
      None => (self, None)
    }
  } else {
    (self, None)
  }
}
```

#### 2. 优化后的 FIFO 实现

```moonbit
pub struct FIFOCache[K, V] {
  capacity : Int
  hash_map : HashMap[K, V]      // O(1) 查找
  order_list : Array[K]          // 维护顺序（先进先出）
  len : Int
}

pub fn[K : Compare, V] FIFOCache::get(
  self : FIFOCache[K, V],
  key : K,
) -> (FIFOCache[K, V], V?) {
  // O(1) 查找
  let (new_map, value) = HashMap::get(self.hash_map, key)
  (FIFOCache::{
    capacity: self.capacity,
    hash_map: new_map,
    order_list: self.order_list,
    len: self.len,
  }, value)
}

pub fn[K : Compare, V] FIFOCache::put(
  self : FIFOCache[K, V],
  key : K,
  value : V,
) -> FIFOCache[K, V] {
  // O(1) 检查是否存在
  let (new_map, existing) = HashMap::get(self.hash_map, key)
  match existing {
    Some(_) => {
      // 已存在，只更新值（不改变顺序）
      let updated_map = HashMap::put(new_map, key, value)
      FIFOCache::{
        capacity: self.capacity,
        hash_map: updated_map,
        order_list: self.order_list,
        len: self.len,
      }
    }
    None => {
      // 不存在，需要添加
      let updated_map = HashMap::put(new_map, key, value)
      let new_order = [..self.order_list, key]
      let (final_map, final_order) = if new_order.length() > self.capacity {
        // 移除最旧的元素
        let oldest_key = new_order[0]
        let (removed_map, _) = HashMap::remove(updated_map, oldest_key)
        let trimmed_order = {
          let arr = []
          for i = 1; i < new_order.length(); i = i + 1 {
            arr.push(new_order[i]) |> ignore
          }
          arr
        }
        (removed_map, trimmed_order)
      } else {
        (updated_map, new_order)
      }
      FIFOCache::{
        capacity: self.capacity,
        hash_map: final_map,
        order_list: final_order,
        len: final_order.length(),
      }
    }
  }
}
```

**性能提升**：
- 查找：O(n) → O(1) 平均情况
- 插入：O(n) → O(1) 平均情况
- 内存：增加约 50%（需要额外的哈希表）

---

### 方案二：键到索引的映射（简化版）

如果实现完整哈希表太复杂，可以使用数组 + 线性搜索，但添加键到索引的缓存。

```moonbit
pub struct FIFOCache[K, V] {
  capacity : Int
  data : Array[(K, V)]
  key_to_idx : Array[(K, Int)]  // 键到索引的映射（缓存）
  len : Int
}

///| 查找键的索引（带缓存）
fn[K : Compare, V] FIFOCache::find_index(
  self : FIFOCache[K, V],
  key : K,
) -> Int {
  // 先检查缓存
  for i = 0; i < self.key_to_idx.length(); i = i + 1 {
    let (k, idx) = self.key_to_idx[i]
    if k.compare(key) == 0 {
      // 验证索引是否仍然有效
      if idx < self.data.length() {
        let (k2, _) = self.data[idx]
        if k2.compare(key) == 0 {
          return idx
        }
      }
    }
  }
  // 缓存未命中，线性搜索
  for i = self.data.length() - 1; i >= 0; i = i - 1 {
    let (k, _) = self.data[i]
    if k.compare(key) == 0 {
      return i
    }
  }
  -1
}
```

**性能提升**：
- 查找：O(n) → O(k) 其中 k 是缓存大小（通常 k << n）
- 实现简单，不需要完整哈希表

---

### 方案三：使用 MoonBit 内置 Map（如果可用）

如果 MoonBit 标准库提供了 `Map` 类型，直接使用：

```moonbit
pub struct FIFOCache[K, V] {
  capacity : Int
  map : Map[K, V]        // 使用内置 Map
  order_list : Array[K]   // 维护顺序
  len : Int
}

pub fn[K : Compare, V] FIFOCache::get(
  self : FIFOCache[K, V],
  key : K,
) -> (FIFOCache[K, V], V?) {
  // O(1) 查找
  let (new_map, value) = Map::get(self.map, key)
  (FIFOCache::{
    capacity: self.capacity,
    map: new_map,
    order_list: self.order_list,
    len: self.len,
  }, value)
}
```

---

## 🔄 LRU 优化方案

参考网页中的实现，LRU 应该使用双向链表 + HashMap。

### 当前实现的问题

```moonbit
// 当前：每次更新 access_order 都需要复制整个数组
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

### 优化后的结构

```moonbit
pub struct LRUCache[K, V] {
  capacity : Int
  hash_map : HashMap[K, (V, Int)]  // 值 + 访问顺序
  order_list : Array[K]            // 按访问顺序排列的键
  next_order : Int
  len : Int
}

///| 更新访问顺序（优化版）
fn[K : Compare, V] LRUCache::update_order(
  self : LRUCache[K, V],
  key : K,
) -> LRUCache[K, V] {
  // 从 order_list 中移除 key（如果存在）
  let filtered_order = {
    let arr = []
    for i = 0; i < self.order_list.length(); i = i + 1 {
      let k = self.order_list[i]
      if k.compare(key) != 0 {
        arr.push(k) |> ignore
      }
    }
    arr
  }
  // 添加到末尾（最近使用）
  let new_order = [..filtered_order, key]
  LRUCache::{
    capacity: self.capacity,
    hash_map: self.hash_map,
    order_list: new_order,
    next_order: self.next_order + 1,
    len: self.len,
  }
}
```

**性能提升**：
- 查找：O(n) → O(1)（使用 HashMap）
- 更新顺序：O(n) → O(n)（仍需遍历，但可以优化）

---

## 📈 性能对比表

| 操作 | 当前实现 | 优化后（HashMap） | 提升倍数 |
|------|----------|------------------|----------|
| FIFO::get | O(n) | O(1) | 10-100x |
| FIFO::put | O(n) | O(1) | 10-100x |
| LRU::get | O(n) | O(1) | 10-100x |
| LRU::put | O(n) | O(1) | 10-100x |
| LFU::get | O(n) | O(1) | 10-100x |
| LFU::put | O(n) | O(1) | 10-100x |

**注意**：提升倍数取决于缓存容量。容量越大，提升越明显。

---

## 🚀 实施建议

### 第一阶段：实现简单哈希表
1. 创建 `cmd/cache/common/hash_map.mbt`
2. 实现基本的 `get`、`put`、`remove` 方法
3. 使用开放寻址法处理冲突

### 第二阶段：优化 FIFO
1. 重构 `FIFOCache` 使用 `HashMap`
2. 保持 `Array[K]` 维护顺序
3. 测试性能提升

### 第三阶段：优化 LRU/LFU/MRU
1. 应用相同的优化策略
2. 优化顺序更新逻辑
3. 减少数组复制

### 第四阶段：优化 ARC
1. ARC 算法最复杂，需要仔细设计
2. 四个列表（T1, T2, B1, B2）都需要优化
3. 自适应参数 p 的计算也需要优化

---

## ⚠️ 注意事项

1. **MoonBit 限制**：
   - 不可变性：所有更新都需要返回新结构
   - 可能没有内置 Map：需要自己实现
   - 函数式风格：避免可变状态

2. **哈希函数**：
   - 需要为不同类型 K 实现合适的哈希函数
   - 考虑使用 `Compare` trait 来生成哈希值

3. **冲突处理**：
   - 开放寻址法：简单但可能性能下降
   - 链式法：需要链表支持

4. **测试**：
   - 优化后需要完整测试
   - 性能基准测试验证提升

---

## 📚 参考资源

- [SakuraTears 的缓存淘汰算法文章](https://www.sakuratears.top/blog/%E7%BC%93%E5%AD%98%E6%B7%98%E6%B1%B0%E7%AE%97%E6%B3%95%EF%BC%88LFU%E3%80%81LRU%E3%80%81FIFO%E3%80%81ARC%E3%80%81MRU%EF%BC%89.html)
- MoonBit 官方文档
- 哈希表实现原理

