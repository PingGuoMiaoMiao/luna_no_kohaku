///| LFU (Least Frequently Used) 缓存实现

///|

///|
/// 使用频率最低的元素最先被淘汰
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
    // 增加频率并更新访问顺序
    let new_freq = {
      let temp = []
      for i = 0; i < self.frequencies.length(); i = i + 1 {
        if i == found_idx {
          temp.push(self.frequencies[i] + 1) |> ignore
        } else {
          temp.push(self.frequencies[i]) |> ignore
        }
      }
      temp
    }
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
    // 更新现有值并增加频率
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
    let new_freq = {
      let temp = []
      for i = 0; i < self.frequencies.length(); i = i + 1 {
        if i == exists_idx {
          temp.push(self.frequencies[i] + 1) |> ignore
        } else {
          temp.push(self.frequencies[i]) |> ignore
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

    // 移除频率最低的元素，添加新元素
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
    let new_freq = {
      let temp = []
      for i = 0; i < self.frequencies.length(); i = i + 1 {
        if i != min_idx {
          temp.push(self.frequencies[i]) |> ignore
        }
      }
      temp.push(1) |> ignore
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
    LFUCache::{
      capacity: self.capacity,
      data: new_data,
      frequencies: new_freq,
      access_order: new_order,
      len: self.capacity,
      next_order: self.next_order + 1,
    }
  } else {
    // 容量未满，直接添加
    let new_data = [..self.data, (key, value)]
    let new_freq = [..self.frequencies, 1]
    let new_order = [..self.access_order, self.next_order]
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
