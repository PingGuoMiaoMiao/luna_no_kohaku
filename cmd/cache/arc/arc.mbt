///| ARC (Adaptive Replacement Cache) 缓存实现

///|

///|
/// 自适应替换缓存，结合 LRU 和 LFU 的优点

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
fn[T] remove_first(arr : Array[T]) -> Array[T] {
  let result = []
  for i = 1; i < arr.length(); i = i + 1 {
    result.push(arr[i]) |> ignore
  }
  result
}

///|
pub struct ARCCache[K, V] {
  capacity : Int
  t1 : Array[(K, V)] // LRU 列表（最近访问的）
  t2 : Array[(K, V)] // LRU 列表（频繁访问的）
  b1 : Array[K] // 被淘汰的键（来自 t1）
  b2 : Array[K] // 被淘汰的键（来自 t2）
  t1_order : Array[Int]
  t2_order : Array[Int]
  p : Int // 目标大小，用于调整 t1 和 t2 的大小
  next_order : Int
}

///|
/// 创建新的 ARC 缓存
pub fn[K, V] ARCCache::new(capacity : Int) -> ARCCache[K, V] {
  ARCCache::{
    capacity,
    t1: [],
    t2: [],
    b1: [],
    b2: [],
    t1_order: [],
    t2_order: [],
    p: 0,
    next_order: 0,
  }
}

///|
/// 获取值
pub fn[K : Compare, V] ARCCache::get(
  self : ARCCache[K, V],
  key : K,
) -> (ARCCache[K, V], V?) {
  // 优化：从后往前查找（最近访问的元素更可能在后面）
  let mut found_value = None
  let mut found_in_t1 = false
  let mut found_idx = -1
  for i = self.t1.length() - 1; i >= 0; i = i - 1 {
    let (k, v) = self.t1[i]
    if k.compare(key) == 0 {
      found_value = Some(v)
      found_in_t1 = true
      found_idx = i
      break
    }
  }

  // 在 t2 中查找（从后往前）
  if !found_in_t1 {
    for i = self.t2.length() - 1; i >= 0; i = i - 1 {
      let (k, v) = self.t2[i]
      if k.compare(key) == 0 {
        found_value = Some(v)
        found_idx = i
        break
      }
    }
  }
  match found_value {
    Some(_) =>
      if found_in_t1 {
        // 从 t1 移到 t2（提升为频繁访问）（优化：使用工具函数）
        let (k, v) = self.t1[found_idx]
        let new_t1 = remove_at(self.t1, found_idx)
        let new_t1_order = remove_at(self.t1_order, found_idx)
        let new_t2 = append(self.t2, (k, v))
        let new_t2_order = append(self.t2_order, self.next_order)

        // 调整 p
        let delta = if self.b1.length() >= self.b2.length() {
          1
        } else if self.b1.length() > 0 {
          self.b2.length() / self.b1.length()
        } else {
          1
        }
        let new_p = if self.p + delta > self.capacity {
          self.capacity
        } else {
          self.p + delta
        }
        let new_cache = ARCCache::{
          capacity: self.capacity,
          t1: new_t1,
          t2: new_t2,
          b1: self.b1,
          b2: self.b2,
          t1_order: new_t1_order,
          t2_order: new_t2_order,
          p: new_p,
          next_order: self.next_order + 1,
        }
        (new_cache, found_value)
      } else {
        // 在 t2 中，更新访问顺序（优化：使用工具函数）
        let new_t2 = self.t2
        let new_t2_order = update_array(
          self.t2_order,
          found_idx,
          self.next_order,
        )
        let new_cache = ARCCache::{
          capacity: self.capacity,
          t1: self.t1,
          t2: new_t2,
          b1: self.b1,
          b2: self.b2,
          t1_order: self.t1_order,
          t2_order: new_t2_order,
          p: self.p,
          next_order: self.next_order + 1,
        }
        (new_cache, found_value)
      }
    None => (self, None)
  }
}

///|
/// 插入或更新值
pub fn[K : Compare, V] ARCCache::put(
  self : ARCCache[K, V],
  key : K,
  value : V,
) -> ARCCache[K, V] {
  // 优化：从后往前查找（最近淘汰的元素更可能在后面）
  let mut in_b1 = false
  let mut in_b2 = false
  for i = self.b1.length() - 1; i >= 0; i = i - 1 {
    if self.b1[i].compare(key) == 0 {
      in_b1 = true
      break
    }
  }
  for i = self.b2.length() - 1; i >= 0; i = i - 1 {
    if self.b2[i].compare(key) == 0 {
      in_b2 = true
      break
    }
  }
  if in_b1 {
    // 在 b1 中，调整 p，然后添加到 t2
    let delta = if self.b1.length() >= self.b2.length() {
      1
    } else {
      self.b2.length() /
      (if self.b1.length() > 0 { self.b1.length() } else { 1 })
    }
    let new_p = if self.p + delta > self.capacity {
      self.capacity
    } else {
      self.p + delta
    }

    // 从 b1 移除（优化：使用工具函数）
    let new_b1 = {
      let result = []
      for i = 0; i < self.b1.length(); i = i + 1 {
        if self.b1[i].compare(key) != 0 {
          result.push(self.b1[i]) |> ignore
        }
      }
      result
    }

    // 添加到 t2（优化：使用工具函数）
    let new_t2 = append(self.t2, (key, value))
    let new_t2_order = append(self.t2_order, self.next_order)

    // 如果 t2 超过容量，移除最旧的（优化：使用工具函数）
    let (final_t2, final_t2_order) = if new_t2.length() > self.capacity {
      (remove_first(new_t2), remove_first(new_t2_order))
    } else {
      (new_t2, new_t2_order)
    }
    ARCCache::{
      capacity: self.capacity,
      t1: self.t1,
      t2: final_t2,
      b1: new_b1,
      b2: self.b2,
      t1_order: self.t1_order,
      t2_order: final_t2_order,
      p: new_p,
      next_order: self.next_order + 1,
    }
  } else if in_b2 {
    // 在 b2 中，调整 p，然后添加到 t2
    let delta = if self.b2.length() >= self.b1.length() {
      1
    } else {
      self.b1.length() /
      (if self.b2.length() > 0 { self.b2.length() } else { 1 })
    }
    let new_p = if self.p - delta < 0 { 0 } else { self.p - delta }

    // 从 b2 移除
    let new_b2 = {
      let temp = []
      for i = 0; i < self.b2.length(); i = i + 1 {
        if self.b2[i].compare(key) != 0 {
          temp.push(self.b2[i]) |> ignore
        }
      }
      temp
    }

    // 添加到 t2
    let new_t2 = [..self.t2, (key, value)]
    let new_t2_order = [..self.t2_order, self.next_order]

    // 如果 t2 超过容量，移除最旧的
    let (final_t2, final_t2_order) = if new_t2.length() > self.capacity {
      let t = {
        let temp = []
        for i = 1; i < new_t2.length(); i = i + 1 {
          temp.push(new_t2[i]) |> ignore
        }
        temp
      }
      let o = {
        let temp = []
        for i = 1; i < new_t2_order.length(); i = i + 1 {
          temp.push(new_t2_order[i]) |> ignore
        }
        temp
      }
      (t, o)
    } else {
      (new_t2, new_t2_order)
    }
    ARCCache::{
      capacity: self.capacity,
      t1: self.t1,
      t2: final_t2,
      b1: self.b1,
      b2: new_b2,
      t1_order: self.t1_order,
      t2_order: final_t2_order,
      p: new_p,
      next_order: self.next_order + 1,
    }
  } else {
    // 不在 b1 或 b2 中，添加到 t1
    let total_size = self.t1.length() + self.t2.length()
    if total_size >= self.capacity {
      if self.t1.length() >= self.p {
        // 从 t1 移除最旧的
        let removed_key = if self.t1.length() > 0 {
          Some(self.t1[0].0)
        } else {
          None
        }
        // 优化：使用工具函数
        let new_t1 = if self.t1.length() > 0 {
          append(remove_first(self.t1), (key, value))
        } else {
          append(self.t1, (key, value))
        }
        let new_t1_order = if self.t1_order.length() > 0 {
          append(remove_first(self.t1_order), self.next_order)
        } else {
          append(self.t1_order, self.next_order)
        }

        // 将移除的键添加到 b1（优化：使用工具函数）
        let new_b1 = match removed_key {
          Some(k) => append(self.b1, k)
          None => self.b1
        }
        ARCCache::{
          capacity: self.capacity,
          t1: new_t1,
          t2: self.t2,
          b1: new_b1,
          b2: self.b2,
          t1_order: new_t1_order,
          t2_order: self.t2_order,
          p: self.p,
          next_order: self.next_order + 1,
        }
      } else {
        // 从 t2 移除最旧的
        let removed_key = if self.t2.length() > 0 {
          Some(self.t2[0].0)
        } else {
          None
        }
        // 优化：使用工具函数
        let new_t2 = if self.t2.length() > 0 {
          remove_first(self.t2)
        } else {
          self.t2
        }
        let new_t2_order = if self.t2_order.length() > 0 {
          remove_first(self.t2_order)
        } else {
          self.t2_order
        }

        // 添加到 t1（优化：使用工具函数）
        let new_t1 = append(self.t1, (key, value))
        let new_t1_order = append(self.t1_order, self.next_order)

        // 将移除的键添加到 b2（优化：使用工具函数）
        let new_b2 = match removed_key {
          Some(k) => append(self.b2, k)
          None => self.b2
        }
        ARCCache::{
          capacity: self.capacity,
          t1: new_t1,
          t2: new_t2,
          b1: self.b1,
          b2: new_b2,
          t1_order: new_t1_order,
          t2_order: new_t2_order,
          p: self.p,
          next_order: self.next_order + 1,
        }
      }
    } else {
      // 容量未满，直接添加到 t1（优化：使用工具函数）
      let new_t1 = append(self.t1, (key, value))
      let new_t1_order = append(self.t1_order, self.next_order)
      ARCCache::{
        capacity: self.capacity,
        t1: new_t1,
        t2: self.t2,
        b1: self.b1,
        b2: self.b2,
        t1_order: new_t1_order,
        t2_order: self.t2_order,
        p: self.p,
        next_order: self.next_order + 1,
      }
    }
  }
}

///|
/// 检查是否包含键
/// 优化：从后往前查找
pub fn[K : Compare, V] ARCCache::contains_key(
  self : ARCCache[K, V],
  key : K,
) -> Bool {
  for i = self.t1.length() - 1; i >= 0; i = i - 1 {
    let (k, _) = self.t1[i]
    if k.compare(key) == 0 {
      return true
    }
  }
  for i = self.t2.length() - 1; i >= 0; i = i - 1 {
    let (k, _) = self.t2[i]
    if k.compare(key) == 0 {
      return true
    }
  }
  false
}

///|
/// 获取当前大小
pub fn[K, V] ARCCache::size(self : ARCCache[K, V]) -> Int {
  self.t1.length() + self.t2.length()
}

///|
/// 获取容量
pub fn[K, V] ARCCache::capacity(self : ARCCache[K, V]) -> Int {
  self.capacity
}

///|
/// 清空缓存
pub fn[K, V] ARCCache::clear(_self : ARCCache[K, V]) -> ARCCache[K, V] {
  ARCCache::{
    capacity: _self.capacity,
    t1: [],
    t2: [],
    b1: [],
    b2: [],
    t1_order: [],
    t2_order: [],
    p: 0,
    next_order: 0,
  }
}
