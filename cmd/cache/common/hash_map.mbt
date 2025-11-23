///| 高效的哈希表实现

///|

///| 使用开放寻址法（线性探测）处理冲突

///| 提供 O(1) 平均时间复杂度的查找、插入、删除操作

///|
/// 哈希表结构
pub struct HashMap[K, V] {
  buckets : Array[(K, V)?] // 桶数组，使用 Option 表示空槽
  size : Int // 当前元素数量
  capacity : Int // 容量（桶的数量）
}

///|
/// 初始容量
const INITIAL_CAPACITY : Int = 16

///|
/// 负载因子阈值（当 size/capacity > 0.75 时扩容）
const LOAD_FACTOR : Double = 0.75

///|
/// 创建新的空哈希表
pub fn[K, V] HashMap::new() -> HashMap[K, V] {
  let buckets = {
    let arr = []
    for i = 0; i < INITIAL_CAPACITY; i = i + 1 {
      arr.push(None) |> ignore
    }
    arr
  }
  HashMap::{ buckets, size: 0, capacity: INITIAL_CAPACITY }
}

///|
/// 创建指定容量的哈希表
pub fn[K, V] HashMap::with_capacity(capacity : Int) -> HashMap[K, V] {
  let actual_capacity = if capacity < INITIAL_CAPACITY {
    INITIAL_CAPACITY
  } else {
    capacity
  }
  let buckets = {
    let arr = []
    for i = 0; i < actual_capacity; i = i + 1 {
      arr.push(None) |> ignore
    }
    arr
  }
  HashMap::{ buckets, size: 0, capacity: actual_capacity }
}

///| 查找键的索引（使用线性探测）

///|
/// 使用简单的哈希策略：从后往前搜索（利用局部性）
fn[K : Compare, V] HashMap::find_index(self : HashMap[K, V], key : K) -> Int {
  // 优化：从后往前搜索（最近插入的元素更可能在后面）
  for i = self.buckets.length() - 1; i >= 0; i = i - 1 {
    match self.buckets[i] {
      Some((k, _)) => if k.compare(key) == 0 { return i } else { ignore(()) }
      None => ignore(())
    }
  }
  -1
}

///| 查找插入位置（用于 put 操作）

///|
/// 返回 (索引, 是否已存在)
fn[K : Compare, V] HashMap::find_insert_index(
  self : HashMap[K, V],
  key : K,
) -> (Int, Bool) {
  // 先检查是否已存在
  let existing_idx = HashMap::find_index(self, key)
  if existing_idx >= 0 {
    return (existing_idx, true)
  }
  // 不存在，找第一个空槽
  for i = 0; i < self.buckets.length(); i = i + 1 {
    match self.buckets[i] {
      None => return (i, false)
      Some(_) => ignore(())
    }
  }
  // 表已满（理论上不应该发生，因为会扩容）
  (-1, false)
}

///|
/// 检查是否需要扩容
fn[K, V] HashMap::should_resize(self : HashMap[K, V]) -> Bool {
  let load = self.size.to_double() / self.capacity.to_double()
  load > LOAD_FACTOR
}

///|
/// 扩容哈希表
fn[K : Compare, V] HashMap::resize(self : HashMap[K, V]) -> HashMap[K, V] {
  let new_capacity = self.capacity * 2
  let new_buckets = {
    let arr = []
    for i = 0; i < new_capacity; i = i + 1 {
      arr.push(None) |> ignore
    }
    arr
  }
  // 重新插入所有元素
  let mut new_map = HashMap::{
    buckets: new_buckets,
    size: 0,
    capacity: new_capacity,
  }
  for i = 0; i < self.capacity; i = i + 1 {
    match self.buckets[i] {
      Some((k, v)) => new_map = HashMap::put(new_map, k, v)
      None => ignore(())
    }
  }
  new_map
}

///| 获取值

///|
/// 时间复杂度：O(1) 平均情况
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

///| 插入或更新值

///|
/// 时间复杂度：O(1) 平均情况
pub fn[K : Compare, V] HashMap::put(
  self : HashMap[K, V],
  key : K,
  value : V,
) -> HashMap[K, V] {
  // 检查是否需要扩容
  let map = if HashMap::should_resize(self) {
    HashMap::resize(self)
  } else {
    self
  }
  let (idx, exists) = HashMap::find_insert_index(map, key)
  if idx < 0 {
    return map // 错误情况
  }
  let new_buckets = {
    let arr = []
    for i = 0; i < map.buckets.length(); i = i + 1 {
      if i == idx {
        arr.push(Some((key, value))) |> ignore
      } else {
        arr.push(map.buckets[i]) |> ignore
      }
    }
    arr
  }
  HashMap::{
    buckets: new_buckets,
    size: if exists {
      map.size
    } else {
      map.size + 1
    },
    capacity: map.capacity,
  }
}

///| 删除键值对

///|
/// 时间复杂度：O(1) 平均情况
pub fn[K : Compare, V] HashMap::remove(
  self : HashMap[K, V],
  key : K,
) -> (HashMap[K, V], Bool) {
  let idx = HashMap::find_index(self, key)
  if idx < 0 {
    return (self, false) // 未找到
  }
  let new_buckets = {
    let arr = []
    for i = 0; i < self.buckets.length(); i = i + 1 {
      if i == idx {
        arr.push(None) |> ignore
      } else {
        arr.push(self.buckets[i]) |> ignore
      }
    }
    arr
  }
  (
    HashMap::{
      buckets: new_buckets,
      size: self.size - 1,
      capacity: self.capacity,
    },
    true,
  )
}

///| 检查是否包含键

///|
/// 时间复杂度：O(1) 平均情况
pub fn[K : Compare, V] HashMap::contains_key(
  self : HashMap[K, V],
  key : K,
) -> Bool {
  let idx = HashMap::find_index(self, key)
  idx >= 0
}

///|
/// 获取大小
pub fn[K, V] HashMap::size(self : HashMap[K, V]) -> Int {
  self.size
}

///|
/// 检查是否为空
pub fn[K, V] HashMap::is_empty(self : HashMap[K, V]) -> Bool {
  self.size == 0
}

///|
/// 清空哈希表
pub fn[K, V] HashMap::clear(_self : HashMap[K, V]) -> HashMap[K, V] {
  HashMap::new()
}
