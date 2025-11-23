///| 分块处理工具

///|
/// 使用 lambda 表达式折叠数组（辅助函数）
fn[T, U] fold(arr : Array[T], init : U, f : (U, T) -> U) -> U {
  let mut acc = init
  for i = 0; i < arr.length(); i = i + 1 {
    acc = f(acc, arr[i])
  }
  acc
}

///|
/// 将字符串分割成固定大小的块
pub fn chunk_string(data : String, chunk_size : Int) -> Array[String] {
  if chunk_size <= 0 {
    return []
  }
  let result = []
  let len = data.length()
  let mut i = 0
  while i < len {
    let end = if i + chunk_size < len { i + chunk_size } else { len }
    let mut s = ""
    for j = i; j < end; j = j + 1 {
      s = s + data[j].to_string()
    }
    result.push(s) |> ignore
    i = i + chunk_size
  }
  result
}

///|
/// 将整数数组分割成固定大小的块
pub fn chunk_ints(data : Array[Int], chunk_size : Int) -> Array[Array[Int]] {
  if chunk_size <= 0 {
    return []
  }
  let result = []
  let len = data.length()
  let mut i = 0
  while i < len {
    let end = if i + chunk_size < len { i + chunk_size } else { len }
    let chunk = []
    for j = i; j < end; j = j + 1 {
      chunk.push(data[j]) |> ignore
    }
    result.push(chunk) |> ignore
    i = i + chunk_size
  }
  result
}

///|
/// 合并字符串块
pub fn merge_chunks(chunks : Array[String]) -> String {
  fold(chunks, "", fn(acc, chunk) { acc + chunk })
}

///|
/// 合并整数数组块
pub fn merge_int_chunks(chunks : Array[Array[Int]]) -> Array[Int] {
  fold(chunks, [], fn(acc, chunk) {
    fold(chunk, acc, fn(arr, x) { [..arr, x] })
  })
}

///|
/// 对每个块应用函数并合并结果
pub fn[T, U] map_chunks(chunks : Array[T], mapper : (T) -> U) -> Array[U] {
  let result = []
  for i = 0; i < chunks.length(); i = i + 1 {
    result.push(mapper(chunks[i])) |> ignore
  }
  result
}

///|
/// 并行处理块（简化版本，实际需要并发支持）
/// TODO: 实现真正的并行处理
pub fn[T, U] process_chunks_parallel(
  chunks : Array[T],
  processor : (T) -> U,
) -> Array[U] {
  // 简化实现：顺序处理
  // 实际应用中需要并发/并行支持
  map_chunks(chunks, processor)
}
