///| PriorityQueue（优先队列/堆）实现

///|
/// 使用数组实现最小堆
/// 堆是一个完全二叉树，存储在数组中
/// 对于索引 i，左子节点在 2*i+1，右子节点在 2*i+2，父节点在 (i-1)/2
pub struct PriorityQueue[T] {
  heap : Array[T]
  len : Int
}

///|
/// 创建新的空优先队列
pub fn[T] PriorityQueue::new() -> PriorityQueue[T] {
  PriorityQueue::{ heap: [], len: 0 }
}

///|
/// 内部函数：上浮操作（sift up），维护堆性质
fn[T : Compare] PriorityQueue::sift_up(heap : Array[T], idx : Int) -> Array[T] {
  if idx == 0 {
    return heap
  }
  let parent_idx = (idx - 1) / 2
  if heap[idx].compare(heap[parent_idx]) < 0 {
    // 交换当前节点和父节点
    let new_heap = {
      let buf = []
      for i = 0; i < heap.length(); i = i + 1 {
        if i == idx {
          buf.push(heap[parent_idx]) |> ignore
        } else if i == parent_idx {
          buf.push(heap[idx]) |> ignore
        } else {
          buf.push(heap[i]) |> ignore
        }
      }
      buf
    }
    PriorityQueue::sift_up(new_heap, parent_idx)
  } else {
    heap
  }
}

///|
/// 内部函数：下沉操作（sift down），维护堆性质
fn[T : Compare] PriorityQueue::sift_down(
  heap : Array[T],
  idx : Int,
  len : Int,
) -> Array[T] {
  let left_idx = 2 * idx + 1
  let right_idx = 2 * idx + 2
  let mut smallest = idx

  // 找到当前节点、左子节点、右子节点中的最小值
  if left_idx < len && heap[left_idx].compare(heap[smallest]) < 0 {
    smallest = left_idx
  }
  if right_idx < len && heap[right_idx].compare(heap[smallest]) < 0 {
    smallest = right_idx
  }
  if smallest != idx {
    // 交换当前节点和最小子节点
    let new_heap = {
      let buf = []
      for i = 0; i < heap.length(); i = i + 1 {
        if i == idx {
          buf.push(heap[smallest]) |> ignore
        } else if i == smallest {
          buf.push(heap[idx]) |> ignore
        } else {
          buf.push(heap[i]) |> ignore
        }
      }
      buf
    }
    PriorityQueue::sift_down(new_heap, smallest, len)
  } else {
    heap
  }
}

///|
/// 插入元素
/// 时间复杂度：O(log n)
pub fn[T : Compare] PriorityQueue::push(
  self : PriorityQueue[T],
  value : T,
) -> PriorityQueue[T] {
  // 添加到末尾
  let new_heap = [..self.heap, value]
  // 上浮操作，维护堆性质
  let final_heap = PriorityQueue::sift_up(new_heap, self.len)
  PriorityQueue::{ heap: final_heap, len: self.len + 1 }
}

///|
/// 弹出最小元素
/// 时间复杂度：O(log n)
pub fn[T : Compare] PriorityQueue::pop(
  self : PriorityQueue[T],
) -> (PriorityQueue[T], T?) {
  if self.len == 0 {
    return (self, None)
  }
  let result = Some(self.heap[0])
  if self.len == 1 {
    return (PriorityQueue::{ heap: [], len: 0 }, result)
  }

  // 将最后一个元素移到根节点
  let last_val = self.heap[self.len - 1]
  let new_heap = {
    let buf = []
    buf.push(last_val) |> ignore
    for i = 1; i < self.len - 1; i = i + 1 {
      buf.push(self.heap[i]) |> ignore
    }
    buf
  }

  // 下沉操作，维护堆性质
  let final_heap = PriorityQueue::sift_down(new_heap, 0, self.len - 1)
  let new_queue = PriorityQueue::{ heap: final_heap, len: self.len - 1 }
  (new_queue, result)
}

///|
/// 查看最小元素
/// 时间复杂度：O(1)
pub fn[T] PriorityQueue::peek(self : PriorityQueue[T]) -> T? {
  if self.len == 0 {
    return None
  }
  Some(self.heap[0])
}

///|
/// 检查是否为空
pub fn[T] PriorityQueue::is_empty(self : PriorityQueue[T]) -> Bool {
  self.len == 0
}

///|
/// 获取大小
pub fn[T] PriorityQueue::size(self : PriorityQueue[T]) -> Int {
  self.len
}

///|
/// 清空
pub fn[T] PriorityQueue::clear(_self : PriorityQueue[T]) -> PriorityQueue[T] {
  PriorityQueue::{ heap: [], len: 0 }
}
