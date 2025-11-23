///| 缓存工具函数

///|
/// 使用 lambda 表达式映射数组
/// 将数组中的每个元素通过函数 f 转换为新元素
pub fn[T, U] map(arr : Array[T], f : (T) -> U) -> Array[U] {
  let result = []
  for i = 0; i < arr.length(); i = i + 1 {
    result.push(f(arr[i])) |> ignore
  }
  result
}

///|
/// 使用 lambda 表达式过滤数组
/// 保留满足条件 pred 的元素
pub fn[T] filter(arr : Array[T], pred : (T) -> Bool) -> Array[T] {
  let result = []
  for i = 0; i < arr.length(); i = i + 1 {
    if pred(arr[i]) {
      result.push(arr[i]) |> ignore
    }
  }
  result
}

///|
/// 使用 lambda 表达式折叠数组（从左到右）
/// 将数组元素通过函数 f 累积为单个值
pub fn[T, U] fold(arr : Array[T], init : U, f : (U, T) -> U) -> U {
  let mut acc = init
  for i = 0; i < arr.length(); i = i + 1 {
    acc = f(acc, arr[i])
  }
  acc
}

///|
/// 使用 lambda 表达式查找元素索引
/// 返回第一个满足条件 pred 的元素的索引，如果不存在返回 -1
pub fn[T] find_index(arr : Array[T], pred : (T) -> Bool) -> Int {
  for i = 0; i < arr.length(); i = i + 1 {
    if pred(arr[i]) {
      return i
    }
  }
  -1
}

///|
/// 使用 lambda 表达式检查是否存在满足条件的元素
pub fn[T] exists(arr : Array[T], pred : (T) -> Bool) -> Bool {
  find_index(arr, pred) >= 0
}

///|
/// 更新数组中的单个元素（工具函数）
pub fn[T] update_array(arr : Array[T], index : Int, value : T) -> Array[T] {
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
/// 移除数组中指定索引的元素
pub fn[T] remove_at(arr : Array[T], index : Int) -> Array[T] {
  let result = []
  for i = 0; i < arr.length(); i = i + 1 {
    if i != index {
      result.push(arr[i]) |> ignore
    }
  }
  result
}

///|
/// 在数组末尾添加元素
pub fn[T] append(arr : Array[T], value : T) -> Array[T] {
  [..arr, value]
}
