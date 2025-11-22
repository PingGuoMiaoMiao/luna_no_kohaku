///| Queue（队列）实现

///|
/// 使用优化的数组实现，减少数组复制
/// 使用 front 索引避免每次 dequeue 都复制整个数组
pub struct Queue[T] {
  buffer : Array[T]
  front : Int // 队首索引（用于避免数组复制）
  len : Int // 当前元素数量
}

///|
/// 创建新的空队列
pub fn[T] Queue::new() -> Queue[T] {
  Queue::{ buffer: [], front: 0, len: 0 }
}

///|
/// 内部函数：压缩缓冲区（当 front 索引过大时）
fn[T] Queue::compact(self : Queue[T]) -> Queue[T] {
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
  Queue::{ buffer: new_buffer, front: 0, len: self.len }
}

///|
/// 入队
pub fn[T] Queue::enqueue(self : Queue[T], value : T) -> Queue[T] {
  // 如果 front 索引过大，先压缩
  let queue = if self.front > 0 && self.front * 2 > self.buffer.length() {
    Queue::compact(self)
  } else {
    self
  }
  Queue::{
    buffer: [..queue.buffer, value],
    front: queue.front,
    len: queue.len + 1,
  }
}

///|
/// 出队
pub fn[T] Queue::dequeue(self : Queue[T]) -> (Queue[T], T?) {
  if self.len == 0 {
    return (self, None)
  }
  let result = Some(self.buffer[self.front])
  // 只更新 front 索引，不复制数组
  let new_queue = Queue::{
    buffer: self.buffer,
    front: self.front + 1,
    len: self.len - 1,
  }
  (new_queue, result)
}

///|
/// 查看队首元素
pub fn[T] Queue::front(self : Queue[T]) -> T? {
  if self.len == 0 {
    return None
  }
  Some(self.buffer[self.front])
}

///|
/// 检查是否为空
pub fn[T] Queue::is_empty(self : Queue[T]) -> Bool {
  self.len == 0
}

///|
/// 获取队列大小
pub fn[T] Queue::size(self : Queue[T]) -> Int {
  self.len
}

///|
/// 清空队列
pub fn[T] Queue::clear(_self : Queue[T]) -> Queue[T] {
  Queue::{ buffer: [], front: 0, len: 0 }
}
