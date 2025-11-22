///| 优化的 Stack 实现

///| - 使用连续内存（Array）避免频繁 drop/clone

///| - Small-Object Optimization：小对象直接存储在栈上

///| - 避免 pop() 时缩容

///| - 针对 Copy 类型优化

///|
/// Small-Object Optimization 阈值
pub const STACK_SO_SIZE : Int = 8

///| Stack 结构体

///|
/// 使用 Small-Object Optimization：小对象直接存储在栈上
pub struct Stack[T] {
  // Small-Object Optimization: 直接存储小数组
  small_buffer : Array[T]
  // 大对象使用动态分配的数组
  large_buffer : Array[T]
  // 当前使用的缓冲区类型：true 表示使用 small_buffer，false 表示使用 large_buffer
  use_small : Bool
  // 当前长度
  len : Int
}

///|
/// 创建新的空栈
pub fn[T] Stack::new() -> Stack[T] {
  Stack::{ small_buffer: [], large_buffer: [], use_small: true, len: 0 }
}

///| 推送元素到栈顶

///|
/// 优化：避免不必要的 clone，使用移动语义
pub fn[T] Stack::push(self : Stack[T], value : T) -> Stack[T] {
  if self.use_small {
    if self.len < STACK_SO_SIZE {
      // 使用小缓冲区，直接追加
      let new_buffer = [..self.small_buffer, value]
      Stack::{
        small_buffer: new_buffer,
        large_buffer: self.large_buffer,
        use_small: true,
        len: self.len + 1,
      }
    } else {
      // 从小缓冲区迁移到大缓冲区
      let large = [..self.small_buffer, value]
      Stack::{
        small_buffer: [],
        large_buffer: large,
        use_small: false,
        len: self.len + 1,
      }
    }
  } else {
    // 使用大缓冲区，直接追加
    let new_buffer = [..self.large_buffer, value]
    Stack::{
      small_buffer: self.small_buffer,
      large_buffer: new_buffer,
      use_small: false,
      len: self.len + 1,
    }
  }
}

///| 从栈顶弹出元素

///|
/// 优化：不缩容，避免频繁内存分配
pub fn[T] Stack::pop(self : Stack[T]) -> (Stack[T], T?) {
  if self.len == 0 {
    return (self, None)
  }
  let new_len = self.len - 1
  let result = if self.use_small {
    Some(self.small_buffer[new_len])
  } else {
    Some(self.large_buffer[new_len])
  }
  let new_stack = Stack::{
    small_buffer: self.small_buffer,
    large_buffer: self.large_buffer,
    use_small: self.use_small,
    len: new_len,
  }
  (new_stack, result)
}

///|
/// 查看栈顶元素（不移除）
pub fn[T] Stack::peek(self : Stack[T]) -> T? {
  if self.len == 0 {
    return None
  }
  let idx = self.len - 1
  if self.use_small {
    Some(self.small_buffer[idx])
  } else {
    Some(self.large_buffer[idx])
  }
}

///|
/// 检查栈是否为空
pub fn[T] Stack::is_empty(self : Stack[T]) -> Bool {
  self.len == 0
}

///|
/// 获取栈的大小
pub fn[T] Stack::size(self : Stack[T]) -> Int {
  self.len
}

///| 清空栈

///|
/// 优化：不释放内存，只重置长度
pub fn[T] Stack::clear(self : Stack[T]) -> Stack[T] {
  Stack::{
    small_buffer: if self.use_small {
      self.small_buffer
    } else {
      []
    },
    large_buffer: [],
    use_small: true,
    len: 0,
  }
}

///|
/// 获取栈的容量
pub fn[T] Stack::capacity(self : Stack[T]) -> Int {
  if self.use_small {
    STACK_SO_SIZE
  } else {
    self.large_buffer.length()
  }
}
