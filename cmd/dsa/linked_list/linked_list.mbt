///| LinkedList（链表）实现

///|
/// 使用优化的数组实现，减少数组复制
/// 使用 front 索引避免频繁数组复制
pub struct LinkedList[T] {
  buffer : Array[T]
  front : Int // 头部索引（用于避免数组复制）
  len : Int
}

///|
/// 创建新的空链表
pub fn[T] LinkedList::new() -> LinkedList[T] {
  LinkedList::{ buffer: [], front: 0, len: 0 }
}

///|
/// 内部函数：压缩缓冲区（当 front 索引过大时）
fn[T] LinkedList::compact(self : LinkedList[T]) -> LinkedList[T] {
  if self.front == 0 {
    return self
  }
  // 压缩：从 front 开始复制剩余元素
  let new_buffer = {
    let buf = []
    for i = self.front; i < self.buffer.length(); i = i + 1 {
      buf.push(self.buffer[i]) |> ignore
    }
    buf
  }
  LinkedList::{ buffer: new_buffer, front: 0, len: self.len }
}

///|
/// 在头部插入
/// 优化：如果 front 为 0，需要创建新数组；否则可以在 front-1 位置插入
pub fn[T] LinkedList::push_front(
  self : LinkedList[T],
  value : T,
) -> LinkedList[T] {
  // 如果 front 索引过大，先压缩
  let list = if self.front > 0 && self.front * 2 > self.buffer.length() {
    LinkedList::compact(self)
  } else {
    self
  }
  // 如果 front 为 0，需要创建新数组
  if list.front == 0 {
    LinkedList::{ buffer: [value, ..list.buffer], front: 0, len: list.len + 1 }
  } else {
    // front > 0，可以在 front-1 位置插入（需要创建新数组）
    let new_buffer = {
      let buf = []
      for i = 0; i < list.front - 1; i = i + 1 {
        buf.push(list.buffer[i]) |> ignore
      }
      buf.push(value) |> ignore
      for i = list.front - 1; i < list.buffer.length(); i = i + 1 {
        buf.push(list.buffer[i]) |> ignore
      }
      buf
    }
    LinkedList::{ buffer: new_buffer, front: list.front - 1, len: list.len + 1 }
  }
}

///|
/// 在尾部插入
/// 优化：如果 front 索引过大，先压缩
pub fn[T] LinkedList::push_back(
  self : LinkedList[T],
  value : T,
) -> LinkedList[T] {
  // 如果 front 索引过大，先压缩
  let list = if self.front > 0 && self.front * 2 > self.buffer.length() {
    LinkedList::compact(self)
  } else {
    self
  }
  LinkedList::{
    buffer: [..list.buffer, value],
    front: list.front,
    len: list.len + 1,
  }
}

///|
/// 从头部弹出
/// 优化：只更新 front 索引，不复制数组
pub fn[T] LinkedList::pop_front(self : LinkedList[T]) -> (LinkedList[T], T?) {
  if self.len == 0 {
    return (self, None)
  }
  let result = Some(self.buffer[self.front])
  // 只更新 front 索引，不复制数组
  let new_list = LinkedList::{
    buffer: self.buffer,
    front: self.front + 1,
    len: self.len - 1,
  }
  (new_list, result)
}

///|
/// 从尾部弹出
pub fn[T] LinkedList::pop_back(self : LinkedList[T]) -> (LinkedList[T], T?) {
  if self.len == 0 {
    return (self, None)
  }
  let last_idx = self.buffer.length() - 1
  let result = Some(self.buffer[last_idx])
  // 创建新数组，去掉最后一个元素（从 front 到 last_idx-1）
  let new_buffer = {
    let buf = []
    for i = self.front; i < last_idx; i = i + 1 {
      buf.push(self.buffer[i]) |> ignore
    }
    buf
  }
  let new_list = LinkedList::{ buffer: new_buffer, front: 0, len: self.len - 1 }
  (new_list, result)
}

///|
/// 查看头部元素
pub fn[T] LinkedList::front(self : LinkedList[T]) -> T? {
  if self.len == 0 {
    return None
  }
  Some(self.buffer[self.front])
}

///|
/// 查看尾部元素
pub fn[T] LinkedList::back(self : LinkedList[T]) -> T? {
  if self.len == 0 {
    return None
  }
  let last_idx = self.buffer.length() - 1
  Some(self.buffer[last_idx])
}

///|
/// 检查是否为空
pub fn[T] LinkedList::is_empty(self : LinkedList[T]) -> Bool {
  self.len == 0
}

///|
/// 获取大小
pub fn[T] LinkedList::size(self : LinkedList[T]) -> Int {
  self.len
}

///|
/// 清空
pub fn[T] LinkedList::clear(_self : LinkedList[T]) -> LinkedList[T] {
  LinkedList::{ buffer: [], front: 0, len: 0 }
}

///|
/// 在指定位置插入
pub fn[T] LinkedList::insert_at(
  self : LinkedList[T],
  index : Int,
  value : T,
) -> LinkedList[T]? {
  if index < 0 || index > self.len {
    return None
  }
  if index == 0 {
    return Some(self.push_front(value))
  }
  if index == self.len {
    return Some(self.push_back(value))
  }

  // 在中间插入（需要考虑 front 索引）
  let actual_idx = self.front + index
  let new_buffer = {
    let buf = []
    for i = self.front; i < actual_idx; i = i + 1 {
      buf.push(self.buffer[i]) |> ignore
    }
    buf.push(value) |> ignore
    for i = actual_idx; i < self.buffer.length(); i = i + 1 {
      buf.push(self.buffer[i]) |> ignore
    }
    buf
  }
  Some(LinkedList::{ buffer: new_buffer, front: self.front, len: self.len + 1 })
}

///|
/// 删除指定位置的元素
pub fn[T] LinkedList::remove_at(
  self : LinkedList[T],
  index : Int,
) -> (LinkedList[T], T?) {
  if index < 0 || index >= self.len {
    return (self, None)
  }
  if index == 0 {
    return self.pop_front()
  }
  if index == self.len - 1 {
    return self.pop_back()
  }

  // 删除中间元素（需要考虑 front 索引）
  let actual_idx = self.front + index
  let result = Some(self.buffer[actual_idx])
  let new_buffer = {
    let buf = []
    for i = self.front; i < actual_idx; i = i + 1 {
      buf.push(self.buffer[i]) |> ignore
    }
    for i = actual_idx + 1; i < self.buffer.length(); i = i + 1 {
      buf.push(self.buffer[i]) |> ignore
    }
    buf
  }
  let new_list = LinkedList::{
    buffer: new_buffer,
    front: self.front,
    len: self.len - 1,
  }
  (new_list, result)
}

///|
/// 获取指定位置的元素
pub fn[T] LinkedList::get(self : LinkedList[T], index : Int) -> T? {
  if index < 0 || index >= self.len {
    return None
  }
  Some(self.buffer[self.front + index])
}
