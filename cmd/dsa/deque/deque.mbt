///| Deque（双端队列）实现

///|
/// 使用优化的数组实现，减少数组复制
/// 使用 front 索引避免每次 pop_front 都复制整个数组
pub struct Deque[T] {
  buffer : Array[T]
  front : Int // 队首索引（用于避免数组复制）
  len : Int // 当前元素数量
}

///|
/// 创建新的空双端队列
pub fn[T] Deque::new() -> Deque[T] {
  Deque::{ buffer: [], front: 0, len: 0 }
}

///|
/// 内部函数：压缩缓冲区（当 front 索引过大时）
fn[T] Deque::compact(self : Deque[T]) -> Deque[T] {
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
  Deque::{ buffer: new_buffer, front: 0, len: self.len }
}

///|
/// 在队首插入
pub fn[T] Deque::push_front(self : Deque[T], value : T) -> Deque[T] {
  // 如果 front 为 0，需要创建新数组
  if self.front == 0 {
    Deque::{ buffer: [value, ..self.buffer], front: 0, len: self.len + 1 }
  } else {
    // front > 0，可以在 front-1 位置插入
    let new_buffer = {
      let buf = []
      for i = 0; i < self.front - 1; i = i + 1 {
        buf.push(self.buffer[i]) |> ignore
      }
      buf.push(value) |> ignore
      for i = self.front - 1; i < self.buffer.length(); i = i + 1 {
        buf.push(self.buffer[i]) |> ignore
      }
      buf
    }
    Deque::{ buffer: new_buffer, front: self.front - 1, len: self.len + 1 }
  }
}

///|
/// 在队尾插入
pub fn[T] Deque::push_back(self : Deque[T], value : T) -> Deque[T] {
  // 如果 front 索引过大，先压缩
  let deque = if self.front > 0 && self.front * 2 > self.buffer.length() {
    Deque::compact(self)
  } else {
    self
  }
  Deque::{
    buffer: [..deque.buffer, value],
    front: deque.front,
    len: deque.len + 1,
  }
}

///|
/// 从队首弹出
pub fn[T] Deque::pop_front(self : Deque[T]) -> (Deque[T], T?) {
  if self.len == 0 {
    return (self, None)
  }
  let result = Some(self.buffer[self.front])
  // 只更新 front 索引，不复制数组
  let new_deque = Deque::{
    buffer: self.buffer,
    front: self.front + 1,
    len: self.len - 1,
  }
  (new_deque, result)
}

///|
/// 从队尾弹出
pub fn[T] Deque::pop_back(self : Deque[T]) -> (Deque[T], T?) {
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
  let new_deque = Deque::{ buffer: new_buffer, front: 0, len: self.len - 1 }
  (new_deque, result)
}

///|
/// 查看队首元素
pub fn[T] Deque::front(self : Deque[T]) -> T? {
  if self.len == 0 {
    return None
  }
  Some(self.buffer[self.front])
}

///|
/// 查看队尾元素
pub fn[T] Deque::back(self : Deque[T]) -> T? {
  if self.len == 0 {
    return None
  }
  let last_idx = self.buffer.length() - 1
  Some(self.buffer[last_idx])
}

///|
/// 检查是否为空
pub fn[T] Deque::is_empty(self : Deque[T]) -> Bool {
  self.len == 0
}

///|
/// 获取大小
pub fn[T] Deque::size(self : Deque[T]) -> Int {
  self.len
}

///|
/// 清空
pub fn[T] Deque::clear(_self : Deque[T]) -> Deque[T] {
  Deque::{ buffer: [], front: 0, len: 0 }
}
