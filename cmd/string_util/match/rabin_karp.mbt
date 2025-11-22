///| Rabin-Karp 算法（滚动哈希）

///|

///| 使用哈希函数进行字符串匹配

///| 时间复杂度：平均 O(n + m)，最坏 O(n*m)

///| 空间复杂度：O(1)

///|
/// 计算字符串的哈希值
/// 使用简单的多项式哈希
fn rabin_karp_hash(str : String, start : Int, end : Int) -> Int {
  let mut h = 0
  let base = 256
  let mod_val = 1000000007 // 大质数，避免溢出
  for i = start; i < end; i = i + 1 {
    // str[i] 返回 Int（字符的 Unicode 码点）
    h = (h * base + str[i]) % mod_val
  }
  h
}

///|
/// 计算滚动哈希
/// 从旧哈希值计算新哈希值
fn rabin_karp_roll_hash(
  old_hash : Int,
  old_char : Int, // 字符的 Unicode 码点
  new_char : Int, // 字符的 Unicode 码点
  pattern_len : Int,
) -> Int {
  let base = 256
  let mod_val = 1000000007
  let base_power = {
    let mut result = 1
    for i = 0; i < pattern_len - 1; i = i + 1 {
      result = result * base % mod_val
    }
    result
  }
  let mut new_hash = old_hash
  new_hash = (new_hash - old_char * base_power % mod_val + mod_val) % mod_val
  new_hash = (new_hash * base + new_char) % mod_val
  new_hash
}

///|
/// 在文本中查找模式的所有出现位置
pub fn rabin_karp_find_all(text : String, pattern : String) -> Array[Int] {
  if pattern.length() == 0 {
    return []
  }
  if pattern.length() > text.length() {
    return []
  }
  let result = []
  let n = text.length()
  let m = pattern.length()

  // 计算模式的哈希值
  let pattern_hash = rabin_karp_hash(pattern, 0, m)

  // 计算文本第一个窗口的哈希值
  let mut text_hash = rabin_karp_hash(text, 0, m)

  // 检查第一个窗口
  if text_hash == pattern_hash {
    // 哈希匹配，验证实际字符串
    let mut match_found = true
    for j = 0; j < m; j = j + 1 {
      if text[j] != pattern[j] {
        match_found = false
        break
      }
    }
    if match_found {
      result.push(0) |> ignore
    }
  }

  // 滚动窗口
  for i = 1; i <= n - m; i = i + 1 {
    // 使用滚动哈希更新
    text_hash = rabin_karp_roll_hash(text_hash, text[i - 1], text[i + m - 1], m)

    // 检查哈希匹配
    if text_hash == pattern_hash {
      // 哈希匹配，验证实际字符串（避免哈希冲突）
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
  }
  result
}

///|
/// 在文本中查找模式的第一个出现位置
pub fn rabin_karp_find_first(text : String, pattern : String) -> Int {
  if pattern.length() == 0 {
    return 0
  }
  if pattern.length() > text.length() {
    return -1
  }
  let n = text.length()
  let m = pattern.length()

  // 计算模式的哈希值
  let pattern_hash = rabin_karp_hash(pattern, 0, m)

  // 计算文本第一个窗口的哈希值
  let mut text_hash = rabin_karp_hash(text, 0, m)

  // 检查第一个窗口
  if text_hash == pattern_hash {
    // 哈希匹配，验证实际字符串
    let mut match_found = true
    for j = 0; j < m; j = j + 1 {
      if text[j] != pattern[j] {
        match_found = false
        break
      }
    }
    if match_found {
      return 0
    }
  }

  // 滚动窗口
  for i = 1; i <= n - m; i = i + 1 {
    // 使用滚动哈希更新
    text_hash = rabin_karp_roll_hash(text_hash, text[i - 1], text[i + m - 1], m)

    // 检查哈希匹配
    if text_hash == pattern_hash {
      // 哈希匹配，验证实际字符串
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
  }
  -1
}

///|
/// 检查文本是否包含模式
pub fn rabin_karp_contains(text : String, pattern : String) -> Bool {
  rabin_karp_find_first(text, pattern) >= 0
}
