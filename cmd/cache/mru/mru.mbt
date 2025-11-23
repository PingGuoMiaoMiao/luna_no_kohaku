///| MRU (Most Recently Used) 缓存实现

///|

///|
/// 最近使用的元素最先被淘汰（与 LRU 相反）

///|
/// 工具函数
fn[T] update_array(arr : Array[T], index : Int, value : T) -> Array[T] {
  let result = []
  for i = 0; i < arr.length(); i = i + 1 {
    result.push(if i == index { value } else { arr[i] }) |> ignore
  }
  result
}

///|
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
fn[T] append(arr : Array[T], value : T) -> Array[T] {
  [..arr, value]
}

///|
pub struct MRUCache[K, V] {
  capacity : Int
  data : Array[(K, V)]
  access_order : Array[Int] // 访问顺序，值越大表示越最近访问
  len : Int
  next_order : Int
}

///|
/// 创建新的 MRU 缓存
pub fn[K, V] MRUCache::new(capacity : Int) -> MRUCache[K, V] {
  MRUCache::{ capacity, data: [], access_order: [], len: 0, next_order: 0 }
}

///|
/// 获取值
pub fn[K : Compare, V] MRUCache::get(
  self : MRUCache[K, V],
  key : K,
) -> (MRUCache[K, V], V?) {
  // 优化：从后往前查找（最近访问的元素更可能在后面）
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
    // 更新访问顺序（标记为最近使用）（优化：使用工具函数）
    let new_order = update_array(self.access_order, found_idx, self.next_order)
    let new_cache = MRUCache::{
      capacity: self.capacity,
      data: self.data,
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
pub fn[K : Compare, V] MRUCache::put(
  self : MRUCache[K, V],
  key : K,
  value : V,
) -> MRUCache[K, V] {
  // 检查是否已存在
  let mut exists = false
  let mut exists_idx = -1
  for i = 0; i < self.data.length(); i = i + 1 {
    let (k, _) = self.data[i]
    if k.compare(key) == 0 {
      exists = true
      exists_idx = i
      break
    }
  }
  if exists {
    // 更新现有值并更新访问顺序（标记为最近使用）（优化：使用工具函数）
    let new_data = update_array(self.data, exists_idx, (key, value))
    let new_order = update_array(self.access_order, exists_idx, self.next_order)
    MRUCache::{
      capacity: self.capacity,
      data: new_data,
      access_order: new_order,
      len: self.len,
      next_order: self.next_order + 1,
    }
    // 不存在，需要插入
  } else if self.len >= self.capacity {
    // 容量已满，找到最近使用的元素（access_order 最大的）
    let mut max_order = -1
    let mut max_idx = 0
    for i = 0; i < self.access_order.length(); i = i + 1 {
      if self.access_order[i] > max_order {
        max_order = self.access_order[i]
        max_idx = i
      }
    }

    // 移除最近使用的元素，添加新元素（优化：使用工具函数）
    let new_data = append(remove_at(self.data, max_idx), (key, value))
    let new_order = append(
      remove_at(self.access_order, max_idx),
      self.next_order,
    )
    MRUCache::{
      capacity: self.capacity,
      data: new_data,
      access_order: new_order,
      len: self.capacity,
      next_order: self.next_order + 1,
    }
  } else {
    // 容量未满，直接添加（优化：使用工具函数）
    let new_data = append(self.data, (key, value))
    let new_order = append(self.access_order, self.next_order)
    MRUCache::{
      capacity: self.capacity,
      data: new_data,
      access_order: new_order,
      len: self.len + 1,
      next_order: self.next_order + 1,
    }
  }
}

///|
/// 检查是否包含键
/// 优化：从后往前查找
pub fn[K : Compare, V] MRUCache::contains_key(
  self : MRUCache[K, V],
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
pub fn[K, V] MRUCache::size(self : MRUCache[K, V]) -> Int {
  self.len
}

///|
/// 获取容量
pub fn[K, V] MRUCache::capacity(self : MRUCache[K, V]) -> Int {
  self.capacity
}

///|
/// 清空缓存
pub fn[K, V] MRUCache::clear(_self : MRUCache[K, V]) -> MRUCache[K, V] {
  MRUCache::{
    capacity: _self.capacity,
    data: [],
    access_order: [],
    len: 0,
    next_order: 0,
  }
}
