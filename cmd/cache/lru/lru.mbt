///| LRU (Least Recently Used) 缓存实现

///|

///|
/// 最近最少使用的元素最先被淘汰
pub struct LRUCache[K, V] {
  capacity : Int
  data : Array[(K, V)]
  access_order : Array[Int] // 访问顺序，值越大表示越最近访问
  len : Int
  next_order : Int // 下一个访问顺序号
}

///|
/// 创建新的 LRU 缓存
pub fn[K, V] LRUCache::new(capacity : Int) -> LRUCache[K, V] {
  LRUCache::{ capacity, data: [], access_order: [], len: 0, next_order: 0 }
}

///|
/// 获取值
pub fn[K : Compare, V] LRUCache::get(
  self : LRUCache[K, V],
  key : K,
) -> (LRUCache[K, V], V?) {
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
    // 更新访问顺序
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
    let new_cache = LRUCache::{
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
pub fn[K : Compare, V] LRUCache::put(
  self : LRUCache[K, V],
  key : K,
  value : V,
) -> LRUCache[K, V] {
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
    // 更新现有值并更新访问顺序
    let new_data = {
      let temp = []
      for i = 0; i < self.data.length(); i = i + 1 {
        if i == exists_idx {
          temp.push((key, value)) |> ignore
        } else {
          let (k, v) = self.data[i]
          temp.push((k, v)) |> ignore
        }
      }
      temp
    }
    let new_order = {
      let temp = []
      for i = 0; i < self.access_order.length(); i = i + 1 {
        if i == exists_idx {
          temp.push(self.next_order) |> ignore
        } else {
          temp.push(self.access_order[i]) |> ignore
        }
      }
      temp
    }
    LRUCache::{
      capacity: self.capacity,
      data: new_data,
      access_order: new_order,
      len: self.len,
      next_order: self.next_order + 1,
    }
    // 不存在，需要插入
  } else if self.len >= self.capacity {
    // 容量已满，找到最久未使用的元素（access_order 最小的）
    let mut min_order = self.next_order
    let mut min_idx = 0
    for i = 0; i < self.access_order.length(); i = i + 1 {
      if self.access_order[i] < min_order {
        min_order = self.access_order[i]
        min_idx = i
      }
    }

    // 移除最久未使用的元素，添加新元素
    let new_data = {
      let temp = []
      for i = 0; i < self.data.length(); i = i + 1 {
        if i != min_idx {
          temp.push(self.data[i]) |> ignore
        }
      }
      temp.push((key, value)) |> ignore
      temp
    }
    let new_order = {
      let temp = []
      for i = 0; i < self.access_order.length(); i = i + 1 {
        if i != min_idx {
          temp.push(self.access_order[i]) |> ignore
        }
      }
      temp.push(self.next_order) |> ignore
      temp
    }
    LRUCache::{
      capacity: self.capacity,
      data: new_data,
      access_order: new_order,
      len: self.capacity,
      next_order: self.next_order + 1,
    }
  } else {
    // 容量未满，直接添加
    let new_data = [..self.data, (key, value)]
    let new_order = [..self.access_order, self.next_order]
    LRUCache::{
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
pub fn[K : Compare, V] LRUCache::contains_key(
  self : LRUCache[K, V],
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
pub fn[K, V] LRUCache::size(self : LRUCache[K, V]) -> Int {
  self.len
}

///|
/// 获取容量
pub fn[K, V] LRUCache::capacity(self : LRUCache[K, V]) -> Int {
  self.capacity
}

///|
/// 清空缓存
pub fn[K, V] LRUCache::clear(_self : LRUCache[K, V]) -> LRUCache[K, V] {
  LRUCache::{
    capacity: _self.capacity,
    data: [],
    access_order: [],
    len: 0,
    next_order: 0,
  }
}
