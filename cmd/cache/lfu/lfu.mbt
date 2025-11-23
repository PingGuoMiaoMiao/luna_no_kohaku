///| LFU (Least Frequently Used) 缓存实现

///|

///|
/// 使用频率最低的元素最先被淘汰

///|
/// 工具函数：更新数组中的单个元素
fn[T] update_array(arr : Array[T], index : Int, value : T) -> Array[T] {
  let result = []
  for i = 0; i < arr.length(); i = i + 1 {
    if i == index {
      result.push(value) |> ignore
    } else {
      result.push(arr[i]) |> ignore
    }
  }
  result
}

///|
/// 工具函数：移除数组中指定索引的元素
fn[T] remove_at(arr : Array[T], index : Int) -> Array[T] {
  let result = []
  for i = 0; i < arr.length(); i = i + 1 {
    if i != index {
      result.push(arr[i]) |> ignore
    }
  }
  result
}

///|
/// 工具函数：在数组末尾添加元素
fn[T] append(arr : Array[T], value : T) -> Array[T] {
  [..arr, value]
}

///|
pub struct LFUCache[K, V] {
  capacity : Int
  data : Array[(K, V)]
  frequencies : Array[Int] // 每个键的访问频率
  access_order : Array[Int] // 访问顺序，用于处理频率相同的情况
  len : Int
  next_order : Int
}

///|
/// 创建新的 LFU 缓存
pub fn[K, V] LFUCache::new(capacity : Int) -> LFUCache[K, V] {
  LFUCache::{
    capacity,
    data: [],
    frequencies: [],
    access_order: [],
    len: 0,
    next_order: 0,
  }
}

///|
/// 获取值
pub fn[K : Compare, V] LFUCache::get(
  self : LFUCache[K, V],
  key : K,
) -> (LFUCache[K, V], V?) {
  // 优化：从后往前查找
  let mut found_value = None
  let mut found_idx = -1
  for i = self.data.length() - 1; i >= 0; i = i - 1 {
    let (k, v) = self.data[i]
    if k.compare(key) == 0 {
      found_value = Some(v)
      found_idx = i
      break
    }
  }
  if found_idx >= 0 {
    // 增加频率并更新访问顺序（优化：使用工具函数）
    let new_freq = update_array(
      self.frequencies,
      found_idx,
      self.frequencies[found_idx] + 1,
    )
    let new_order = update_array(self.access_order, found_idx, self.next_order)
    let new_cache = LFUCache::{
      capacity: self.capacity,
      data: self.data,
      frequencies: new_freq,
      access_order: new_order,
      len: self.len,
      next_order: self.next_order + 1,
    }
    (new_cache, found_value)
  } else {
    (self, None)
  }
}

///|
/// 插入或更新值
pub fn[K : Compare, V] LFUCache::put(
  self : LFUCache[K, V],
  key : K,
  value : V,
) -> LFUCache[K, V] {
  // 优化：从后往前查找
  let mut exists = false
  let mut exists_idx = -1
  for i = self.data.length() - 1; i >= 0; i = i - 1 {
    let (k, _) = self.data[i]
    if k.compare(key) == 0 {
      exists = true
      exists_idx = i
      break
    }
  }
  if exists {
    // 更新现有值并增加频率（优化：使用工具函数）
    let new_data = update_array(self.data, exists_idx, (key, value))
    let new_freq = update_array(
      self.frequencies,
      exists_idx,
      self.frequencies[exists_idx] + 1,
    )
    let new_order = update_array(self.access_order, exists_idx, self.next_order)
    LFUCache::{
      capacity: self.capacity,
      data: new_data,
      frequencies: new_freq,
      access_order: new_order,
      len: self.len,
      next_order: self.next_order + 1,
    }
    // 不存在，需要插入
  } else if self.len >= self.capacity {
    // 容量已满，找到频率最低的元素（频率相同则选最久未使用的）
    let mut min_freq = self.next_order
    let mut min_order = self.next_order
    let mut min_idx = 0
    for i = 0; i < self.frequencies.length(); i = i + 1 {
      if self.frequencies[i] < min_freq ||
        (self.frequencies[i] == min_freq && self.access_order[i] < min_order) {
        min_freq = self.frequencies[i]
        min_order = self.access_order[i]
        min_idx = i
      }
    }

    // 移除频率最低的元素，添加新元素（优化：使用工具函数）
    let new_data = append(remove_at(self.data, min_idx), (key, value))
    let new_freq = append(remove_at(self.frequencies, min_idx), 1)
    let new_order = append(
      remove_at(self.access_order, min_idx),
      self.next_order,
    )
    LFUCache::{
      capacity: self.capacity,
      data: new_data,
      frequencies: new_freq,
      access_order: new_order,
      len: self.capacity,
      next_order: self.next_order + 1,
    }
  } else {
    // 容量未满，直接添加（优化：使用工具函数）
    let new_data = append(self.data, (key, value))
    let new_freq = append(self.frequencies, 1)
    let new_order = append(self.access_order, self.next_order)
    LFUCache::{
      capacity: self.capacity,
      data: new_data,
      frequencies: new_freq,
      access_order: new_order,
      len: self.len + 1,
      next_order: self.next_order + 1,
    }
  }
}

///|
/// 检查是否包含键
/// 优化：从后往前查找
pub fn[K : Compare, V] LFUCache::contains_key(
  self : LFUCache[K, V],
  key : K,
) -> Bool {
  for i = self.data.length() - 1; i >= 0; i = i - 1 {
    let (k, _) = self.data[i]
    if k.compare(key) == 0 {
      return true
    }
  }
  false
}

///|
/// 获取当前大小
pub fn[K, V] LFUCache::size(self : LFUCache[K, V]) -> Int {
  self.len
}

///|
/// 获取容量
pub fn[K, V] LFUCache::capacity(self : LFUCache[K, V]) -> Int {
  self.capacity
}

///|
/// 清空缓存
pub fn[K, V] LFUCache::clear(_self : LFUCache[K, V]) -> LFUCache[K, V] {
  LFUCache::{
    capacity: _self.capacity,
    data: [],
    frequencies: [],
    access_order: [],
    len: 0,
    next_order: 0,
  }
}
