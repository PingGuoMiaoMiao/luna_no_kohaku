///| 基础字符串操作

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
/// 包含 split, join, substring, replace 等常用操作

///|
/// 分割字符串
/// 将字符串按分隔符分割成数组
/// 时间复杂度：O(n*m)，其中 n 是字符串长度，m 是分隔符长度
/// 优化：减少中间数组分配，直接构建字符串
pub fn split(str : String, delimiter : String) -> Array[String] {
  if delimiter.length() == 0 {
    // 如果分隔符为空，返回每个字符
    let result = []
    for i = 0; i < str.length(); i = i + 1 {
      let char_str = str[i].to_string()
      result.push(char_str) |> ignore
    }
    return result
  }
  // 边界检查：如果字符串为空
  if str.length() == 0 {
    return [""]
  }
  let result = []
  let mut start = 0
  let mut i = 0
  while i < str.length() {
    // 检查是否匹配分隔符
    let mut match_found = true
    if i + delimiter.length() > str.length() {
      match_found = false
    } else {
      for j = 0; j < delimiter.length(); j = j + 1 {
        if str[i + j] != delimiter[j] {
          match_found = false
          break
        }
      }
    }
    if match_found {
      // 找到分隔符，添加子字符串
      if i > start {
        // 优化：直接构建字符串，避免中间数组
        let substr = {
          let mut s = ""
          for k = start; k < i; k = k + 1 {
            s = s + str[k].to_string()
          }
          s
        }
        result.push(substr) |> ignore
      }
      start = i + delimiter.length()
      i = start
    } else {
      i = i + 1
    }
  }

  // 添加最后一部分
  if start < str.length() {
    // 优化：直接构建字符串，避免中间数组
    let substr = {
      let mut s = ""
      for k = start; k < str.length(); k = k + 1 {
        s = s + str[k].to_string()
      }
      s
    }
    result.push(substr) |> ignore
  } else if start == str.length() {
    // 如果字符串以分隔符结尾，添加空字符串
    result.push("") |> ignore
  }
  result
}

///|
/// 连接字符串数组
/// 使用指定的分隔符连接字符串数组
/// 时间复杂度：O(n)，其中 n 是所有字符串的总长度
pub fn join(strings : Array[String], delimiter : String) -> String {
  if strings.length() == 0 {
    return ""
  }
  if strings.length() == 1 {
    return strings[0]
  }
  fold(strings, "", fn(acc, str) {
    if acc.length() == 0 {
      str
    } else {
      acc + delimiter + str
    }
  })
}

///|
/// 获取子字符串
/// 从 start 位置开始，到 end 位置（不包含）的子字符串
pub fn substring(str : String, start : Int, end : Int) -> String {
  if start < 0 || end > str.length() || start >= end {
    return ""
  }
  let mut result = ""
  for i = start; i < end; i = i + 1 {
    result = result + str[i].to_string()
  }
  result
}

///|
/// 替换字符串
/// 将字符串中所有出现的 old_str 替换为 new_str
/// 时间复杂度：O(n*m)，其中 n 是字符串长度，m 是 old_str 长度
/// 优化：使用字符数组构建，最后一次性转换
pub fn replace(str : String, old_str : String, new_str : String) -> String {
  if old_str.length() == 0 {
    return str
  }
  // 边界检查：如果字符串为空
  if str.length() == 0 {
    return str
  }
  let result = []
  let mut i = 0
  while i < str.length() {
    // 检查是否匹配 old_str
    let mut match_found = true
    if i + old_str.length() > str.length() {
      match_found = false
    } else {
      for j = 0; j < old_str.length(); j = j + 1 {
        if str[i + j] != old_str[j] {
          match_found = false
          break
        }
      }
    }
    if match_found {
      // 找到匹配，添加 new_str
      for k = 0; k < new_str.length(); k = k + 1 {
        result.push(new_str[k]) |> ignore
      }
      i = i + old_str.length()
    } else {
      // 不匹配，添加当前字符
      result.push(str[i]) |> ignore
      i = i + 1
    }
  }

  // 优化：直接构建字符串，避免中间数组
  // 注意：result 已经是字符数组，直接转换
  let mut result_str = ""
  for i = 0; i < result.length(); i = i + 1 {
    result_str = result_str + result[i].to_string()
  }
  result_str
}
