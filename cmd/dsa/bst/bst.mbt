///| Binary Search Tree（二叉搜索树）实现

///|
/// 使用数组存储，简化实现
pub struct BST[T] {
  values : Array[T]
  len : Int
}

///|
/// 创建新的空 BST
pub fn[T] BST::new() -> BST[T] {
  BST::{ values: [], len: 0 }
}

///|
/// 插入元素
pub fn[T : Compare] BST::insert(self : BST[T], value : T) -> BST[T] {
  // 简化实现：如果不存在则插入并排序
  if !BST::search(self, value) {
    let new_values = [..self.values, value]
    let sorted = BST::sort_array(new_values)
    BST::{ values: sorted, len: self.len + 1 }
  } else {
    self
  }
}

///|
/// 搜索元素
pub fn[T : Compare] BST::search(self : BST[T], value : T) -> Bool {
  BST::binary_search(self.values, value, 0, self.values.length() - 1)
}

///|
/// 删除元素
/// 优化：删除后重新排序以保持 BST 性质
/// 优化：使用二分搜索找到元素位置（如果数组已排序）
pub fn[T : Compare] BST::remove(self : BST[T], value : T) -> (BST[T], Bool) {
  // 优化：如果数组已排序，使用二分搜索
  // 但为了简化，仍然使用线性搜索（因为 remove 后需要重新排序）
  let mut found_flag = false
  let new_values = {
    let buf = []
    for i = 0; i < self.values.length(); i = i + 1 {
      if self.values[i].compare(value) == 0 {
        found_flag = true
      } else {
        buf.push(self.values[i]) |> ignore
      }
    }
    buf
  }
  // 如果找到并删除，重新排序以保持 BST 性质
  let final_values = if found_flag {
    BST::sort_array(new_values)
  } else {
    new_values
  }
  let new_bst = BST::{
    values: final_values,
    len: if found_flag {
      self.len - 1
    } else {
      self.len
    },
  }
  (new_bst, found_flag)
}

///|
/// 检查是否为空
pub fn[T] BST::is_empty(self : BST[T]) -> Bool {
  self.len == 0
}

///|
/// 获取大小
pub fn[T] BST::size(self : BST[T]) -> Int {
  self.len
}

///|
/// 清空
pub fn[T] BST::clear(_self : BST[T]) -> BST[T] {
  BST::{ values: [], len: 0 }
}

///|
/// 获取最小值
/// 优化：如果数组已排序，直接返回第一个元素
pub fn[T : Compare] BST::min(self : BST[T]) -> T? {
  if self.len == 0 {
    return None
  }
  // 优化：由于 insert 后总是排序，第一个元素就是最小值
  // 但为了安全，仍然遍历查找（因为 remove 后可能未排序）
  let mut min_val = self.values[0]
  for i = 1; i < self.values.length(); i = i + 1 {
    if self.values[i].compare(min_val) < 0 {
      min_val = self.values[i]
    }
  }
  Some(min_val)
}

///|
/// 获取最大值
pub fn[T : Compare] BST::max(self : BST[T]) -> T? {
  if self.len == 0 {
    return None
  }
  let max_val = {
    let mut val = self.values[0]
    for i = 1; i < self.values.length(); i = i + 1 {
      if self.values[i].compare(val) > 0 {
        val = self.values[i]
      }
    }
    val
  }
  Some(max_val)
}

///|
/// 中序遍历（返回排序后的数组）
/// 优化：如果数组已排序，直接返回副本，否则排序
pub fn[T : Compare] BST::inorder(self : BST[T]) -> Array[T] {
  // 优化：由于 insert 后总是排序，可以直接返回副本
  // 但为了安全，仍然排序（因为 remove 后可能未排序，但我们已经修复了）
  let arr = {
    let temp = []
    for i = 0; i < self.values.length(); i = i + 1 {
      temp.push(self.values[i]) |> ignore
    }
    temp
  }
  BST::sort_array(arr)
}

///|
/// 前序遍历
pub fn[T] BST::preorder(self : BST[T]) -> Array[T] {
  self.values
}

///|
/// 后序遍历
pub fn[T] BST::postorder(self : BST[T]) -> Array[T] {
  let reversed = {
    let arr = []
    for i = self.values.length() - 1; i >= 0; i = i - 1 {
      arr.push(self.values[i]) |> ignore
    }
    arr
  }
  reversed
}

///|
/// 内部方法：二分搜索
fn[T : Compare] BST::binary_search(
  arr : Array[T],
  value : T,
  left : Int,
  right : Int,
) -> Bool {
  if left > right {
    return false
  }
  let mid = (left + right) / 2
  match value.compare(arr[mid]) {
    0 => true
    x =>
      if x < 0 {
        BST::binary_search(arr, value, left, mid - 1)
      } else {
        BST::binary_search(arr, value, mid + 1, right)
      }
  }
}

///|
/// 内部方法：排序数组（归并排序）
/// 优化：使用归并排序，时间复杂度 O(n log n)，适合函数式编程
/// 对于小数组（< 10），使用插入排序
fn[T : Compare] BST::sort_array(arr : Array[T]) -> Array[T] {
  let len = arr.length()
  if len <= 1 {
    return arr
  }
  // 对于小数组，使用插入排序
  if len < 10 {
    return BST::insertion_sort(arr)
  }
  // 对于大数组，使用归并排序
  BST::merge_sort(arr)
}

///|
/// 内部方法：插入排序（用于小数组）
fn[T : Compare] BST::insertion_sort(arr : Array[T]) -> Array[T] {
  let len = arr.length()
  if len <= 1 {
    return arr
  }
  let result = [..arr]
  for i = 1; i < len; i = i + 1 {
    let key = result[i]
    let mut j = i - 1
    while j >= 0 && result[j].compare(key) > 0 {
      result[j + 1] = result[j]
      j = j - 1
    }
    result[j + 1] = key
  }
  result
}

///|
/// 内部方法：归并排序
fn[T : Compare] BST::merge_sort(arr : Array[T]) -> Array[T] {
  let len = arr.length()
  if len <= 1 {
    return arr
  }
  let mid = len / 2
  let left = {
    let arr_left = []
    for i = 0; i < mid; i = i + 1 {
      arr_left.push(arr[i]) |> ignore
    }
    arr_left
  }
  let right = {
    let arr_right = []
    for i = mid; i < len; i = i + 1 {
      arr_right.push(arr[i]) |> ignore
    }
    arr_right
  }
  let sorted_left = BST::merge_sort(left)
  let sorted_right = BST::merge_sort(right)
  BST::merge(sorted_left, sorted_right)
}

///|
/// 内部方法：合并两个已排序数组
fn[T : Compare] BST::merge(left : Array[T], right : Array[T]) -> Array[T] {
  let result = []
  let mut i = 0
  let mut j = 0
  while i < left.length() && j < right.length() {
    if left[i].compare(right[j]) <= 0 {
      result.push(left[i]) |> ignore
      i = i + 1
    } else {
      result.push(right[j]) |> ignore
      j = j + 1
    }
  }
  while i < left.length() {
    result.push(left[i]) |> ignore
    i = i + 1
  }
  while j < right.length() {
    result.push(right[j]) |> ignore
    j = j + 1
  }
  result
}
