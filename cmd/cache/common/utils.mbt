///| 缓存工具函数

///| 更新数组中的单个元素（工具函数）

///|
/// 用于减少数组复制操作
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
