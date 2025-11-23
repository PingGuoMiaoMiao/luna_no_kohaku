///| 分块处理工具

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
    let chunk = {
      let mut s = ""
      for j = i; j < end; j = j + 1 {
        s = s + data[j].to_string()
      }
      s
    }
    result.push(chunk) |> ignore
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
    let chunk = {
      let arr = []
      for j = i; j < end; j = j + 1 {
        arr.push(data[j]) |> ignore
      }
      arr
    }
    result.push(chunk) |> ignore
    i = i + chunk_size
  }
  result
}

///|
/// 合并字符串块
pub fn merge_chunks(chunks : Array[String]) -> String {
  let mut result = ""
  for i = 0; i < chunks.length(); i = i + 1 {
    result = result + chunks[i]
  }
  result
}

///|
/// 合并整数数组块
pub fn merge_int_chunks(chunks : Array[Array[Int]]) -> Array[Int] {
  let result = []
  for i = 0; i < chunks.length(); i = i + 1 {
    let chunk = chunks[i]
    for j = 0; j < chunk.length(); j = j + 1 {
      result.push(chunk[j]) |> ignore
    }
  }
  result
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
pub fn[T, U] process_chunks_parallel(
  chunks : Array[T],
  processor : (T) -> U,
) -> Array[U] {
  // 简化实现：顺序处理
  // 实际应用中需要并发/并行支持
  map_chunks(chunks, processor)
}
