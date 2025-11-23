///| FIFO (First In First Out) 缓存实现

///|

///|
/// 使用队列实现，最先进入的元素最先被淘汰

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
/// 工具函数：移除数组中第一个元素
fn[T] remove_first(arr : Array[T]) -> Array[T] {
  let result = []
  for i = 1; i < arr.length(); i = i + 1 {
    result.push(arr[i]) |> ignore
  }
  result
}

///|
/// 工具函数：在数组末尾添加元素
fn[T] append(arr : Array[T], value : T) -> Array[T] {
  [..arr, value]
}

///|
pub struct FIFOCache[K, V] {
  capacity : Int
  data : Array[(K, V)]
  len : Int
}

///|
/// 创建新的 FIFO 缓存
/// 参数 capacity 必须 > 0，否则行为未定义
pub fn[K, V] FIFOCache::new(capacity : Int) -> FIFOCache[K, V] {
  FIFOCache::{ capacity, data: [], len: 0 }
}

///|
/// 获取值
/// 时间复杂度：O(n)，其中 n 是缓存大小
/// 对于小容量缓存（< 100），性能可接受
pub fn[K : Compare, V] FIFOCache::get(
  self : FIFOCache[K, V],
  key : K,
) -> (FIFOCache[K, V], V?) {
  // 优化：从后往前查找（新插入的元素更可能在后面）
  let mut found_value = None
  for i = self.data.length() - 1; i >= 0; i = i - 1 {
    let (k, v) = self.data[i]
    if k.compare(key) == 0 {
      found_value = Some(v)
      break
    }
  }
  (self, found_value)
}

///|
/// 插入或更新值
/// 优化：先检查是否存在，避免不必要的数组复制
pub fn[K : Compare, V] FIFOCache::put(
  self : FIFOCache[K, V],
  key : K,
  value : V,
) -> FIFOCache[K, V] {
  // 优化：先快速检查是否存在（从后往前，新元素更可能在后面）
  let mut exists_idx = -1
  for i = self.data.length() - 1; i >= 0; i = i - 1 {
    let (k, _) = self.data[i]
    if k.compare(key) == 0 {
      exists_idx = i
      break
    }
  }
  if exists_idx >= 0 {
    // 已存在，只更新值，保持位置（FIFO 不改变顺序）（优化：使用工具函数）
    let new_data = update_array(self.data, exists_idx, (key, value))
    FIFOCache::{ capacity: self.capacity, data: new_data, len: self.len }
  } else if self.len >= self.capacity {
    // 容量已满，移除最旧的元素（第一个），添加新元素（优化：使用工具函数）
    let updated_data = append(remove_first(self.data), (key, value))
    FIFOCache::{
      capacity: self.capacity,
      data: updated_data,
      len: self.capacity,
    }
  } else {
    // 容量未满，直接添加（优化：使用工具函数）
    FIFOCache::{
      capacity: self.capacity,
      data: append(self.data, (key, value)),
      len: self.len + 1,
    }
  }
}

///|
/// 检查是否包含键
/// 优化：从后往前查找
pub fn[K : Compare, V] FIFOCache::contains_key(
  self : FIFOCache[K, V],
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
pub fn[K, V] FIFOCache::size(self : FIFOCache[K, V]) -> Int {
  self.len
}

///|
/// 获取容量
pub fn[K, V] FIFOCache::capacity(self : FIFOCache[K, V]) -> Int {
  self.capacity
}

///|
/// 清空缓存
pub fn[K, V] FIFOCache::clear(_self : FIFOCache[K, V]) -> FIFOCache[K, V] {
  FIFOCache::{ capacity: _self.capacity, data: [], len: 0 }
}
