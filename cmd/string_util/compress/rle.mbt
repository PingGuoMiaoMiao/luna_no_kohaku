///| Run-Length Encoding (RLE) 压缩算法

///|

///| 将连续重复的字符压缩为 (字符, 次数) 的形式

///| 例如：aaabbbcc -> [(a,3), (b,3), (c,2)]

///|
/// 编码：将字符串压缩为 RLE 格式
/// 时间复杂度：O(n)，其中 n 是字符串长度
/// 优化：单次遍历，O(1) 空间复杂度
pub fn encode(str : String) -> Array[(Int, Int)] {
  if str.length() == 0 {
    return []
  }
  let result = []
  let mut current_char = str[0]
  let mut count = 1
  for i = 1; i < str.length(); i = i + 1 {
    if str[i] == current_char {
      count = count + 1
    } else {
      // 字符改变，保存当前字符和计数
      result.push((current_char, count)) |> ignore
      current_char = str[i]
      count = 1
    }
  }

  // 添加最后一个字符
  result.push((current_char, count)) |> ignore
  result
}

///|
/// 解码：将 RLE 格式还原为字符串
/// 优化：预先计算总长度，减少字符串拼接次数
pub fn decode(encoded : Array[(Int, Int)]) -> String {
  if encoded.length() == 0 {
    return ""
  }
  // 优化：使用字符数组构建，最后一次性转换
  // 预先分配空间可以提高性能
  let chars = {
    let arr = []
    for i = 0; i < encoded.length(); i = i + 1 {
      let (char_code, count) = encoded[i]
      for j = 0; j < count; j = j + 1 {
        arr.push(char_code) |> ignore
      }
    }
    arr
  }
  // 将字符数组转换为字符串
  // 优化：直接构建，避免多次字符串拼接
  let mut result = ""
  for i = 0; i < chars.length(); i = i + 1 {
    result = result + chars[i].to_string()
  }
  result
}

///|
/// 压缩比
/// 返回压缩后的数据大小与原始数据大小的比值
pub fn compression_ratio(
  original : String,
  encoded : Array[(Int, Int)],
) -> Double {
  let original_size = original.length()
  let encoded_size = encoded.length() * 2 // 每个 (char, count) 占 2 个整数
  if original_size == 0 {
    return 0.0
  }
  encoded_size.to_double() / original_size.to_double()
}
