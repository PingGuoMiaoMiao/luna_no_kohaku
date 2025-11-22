///| KMP (Knuth-Morris-Pratt) 算法

///|

///| 使用前缀函数（部分匹配表）优化字符串匹配

///| 时间复杂度：O(n + m)，其中 n 是文本长度，m 是模式长度

///| 空间复杂度：O(m)

///|
/// 计算前缀函数（部分匹配表）
/// 返回每个位置的最长相等前后缀长度
/// 优化：使用优化的 KMP 前缀函数计算
fn kmp_compute_prefix(pattern : String) -> Array[Int] {
  let m = pattern.length()
  let prefix = {
    let arr = []
    for i = 0; i < m; i = i + 1 {
      arr.push(0) |> ignore
    }
    arr
  }
  let mut len = 0
  let mut i = 1
  while i < m {
    if pattern[i] == pattern[len] {
      len = len + 1
      prefix[i] = len
      i = i + 1
    } else if len != 0 {
      len = prefix[len - 1]
    } else {
      prefix[i] = 0
      i = i + 1
    }
  }
  prefix
}

///|
/// 在文本中查找模式的所有出现位置
/// 优化：使用 KMP 算法，避免重复比较
pub fn kmp_find_all(text : String, pattern : String) -> Array[Int] {
  if pattern.length() == 0 {
    return []
  }
  if pattern.length() > text.length() {
    return []
  }
  // 边界检查：如果文本为空
  if text.length() == 0 {
    return []
  }
  let result = []
  let n = text.length()
  let m = pattern.length()
  let prefix = kmp_compute_prefix(pattern)
  let mut i = 0 // 文本索引
  let mut j = 0 // 模式索引
  while i < n {
    if text[i] == pattern[j] {
      i = i + 1
      j = j + 1
    }
    if j == m {
      // 找到匹配
      result.push(i - j) |> ignore
      j = prefix[j - 1]
    } else if i < n && text[i] != pattern[j] {
      // 不匹配，使用前缀函数跳过
      if j != 0 {
        j = prefix[j - 1]
      } else {
        i = i + 1
      }
    }
    // 优化：当 j == 0 且不匹配时，i 已经递增，避免重复检查
  }
  result
}

///|
/// 在文本中查找模式的第一个出现位置
/// 优化：找到第一个匹配后立即返回
pub fn kmp_find_first(text : String, pattern : String) -> Int {
  if pattern.length() == 0 {
    return 0
  }
  if pattern.length() > text.length() {
    return -1
  }
  // 边界检查：如果文本为空
  if text.length() == 0 {
    return -1
  }
  let n = text.length()
  let m = pattern.length()
  let prefix = kmp_compute_prefix(pattern)
  let mut i = 0 // 文本索引
  let mut j = 0 // 模式索引
  while i < n {
    if text[i] == pattern[j] {
      i = i + 1
      j = j + 1
    }
    if j == m {
      // 找到匹配
      return i - j
    } else if i < n && text[i] != pattern[j] {
      // 不匹配，使用前缀函数跳过
      if j != 0 {
        j = prefix[j - 1]
      } else {
        i = i + 1
      }
    }
  }
  -1
}

///|
/// 检查文本是否包含模式
pub fn kmp_contains(text : String, pattern : String) -> Bool {
  kmp_find_first(text, pattern) >= 0
}
