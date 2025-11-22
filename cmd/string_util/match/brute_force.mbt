///| 暴力匹配算法（Brute Force）

///|

///| 时间复杂度：O(n*m)，其中 n 是文本长度，m 是模式长度

///| 空间复杂度：O(1)

///|
/// 在文本中查找模式的所有出现位置
/// 返回所有匹配位置的数组
pub fn brute_force_find_all(text : String, pattern : String) -> Array[Int] {
  if pattern.length() == 0 {
    return []
  }
  if pattern.length() > text.length() {
    return []
  }
  let result = []
  let n = text.length()
  let m = pattern.length()
  for i = 0; i <= n - m; i = i + 1 {
    let mut match_found = true
    for j = 0; j < m; j = j + 1 {
      if text[i + j] != pattern[j] {
        match_found = false
        break
      }
    }
    if match_found {
      result.push(i) |> ignore
    }
  }
  result
}

///|
/// 在文本中查找模式的第一个出现位置
/// 返回匹配位置，如果未找到返回 -1
pub fn brute_force_find_first(text : String, pattern : String) -> Int {
  if pattern.length() == 0 {
    return 0
  }
  if pattern.length() > text.length() {
    return -1
  }
  let n = text.length()
  let m = pattern.length()
  for i = 0; i <= n - m; i = i + 1 {
    let mut match_found = true
    for j = 0; j < m; j = j + 1 {
      if text[i + j] != pattern[j] {
        match_found = false
        break
      }
    }
    if match_found {
      return i
    }
  }
  -1
}

///|
/// 检查文本是否包含模式
pub fn brute_force_contains(text : String, pattern : String) -> Bool {
  brute_force_find_first(text, pattern) >= 0
}
