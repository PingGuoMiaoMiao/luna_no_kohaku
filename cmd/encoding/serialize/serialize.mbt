///| 序列化和反序列化工具

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
/// 将整数数组序列化为字符串
pub fn serialize_ints(data : Array[Int]) -> String {
  if data.length() == 0 {
    return ""
  }
  fold(data, "", fn(acc, x) {
    if acc.length() == 0 {
      x.to_string()
    } else {
      acc + "," + x.to_string()
    }
  })
}

///| 将字符串反序列化为整数数组

///|
/// TODO: 实现完整的整数反序列化（支持多位数、负数等）
/// 注意：简化实现，假设每个整数用单个字符表示
pub fn deserialize_ints(data : String) -> Array[Int] {
  if data.length() == 0 {
    return []
  }
  let result = []
  let mut current = ""
  for i = 0; i < data.length(); i = i + 1 {
    let ch = data[i]
    if ch == ',' {
      if current.length() > 0 {
        // 简化：使用第一个字符的字符码
        result.push(current[0]) |> ignore
        current = ""
      }
    } else {
      current = current + ch.to_string()
    }
  }
  if current.length() > 0 {
    result.push(current[0]) |> ignore
  }
  result
}

///|
/// 将字符串数组序列化
pub fn serialize_strings(data : Array[String]) -> String {
  if data.length() == 0 {
    return ""
  }
  fold(data, "", fn(acc, x) {
    if acc.length() == 0 {
      x
    } else {
      acc + "|" + x
    }
  })
}

///|
/// 将字符串反序列化为字符串数组
pub fn deserialize_strings(data : String) -> Array[String] {
  if data.length() == 0 {
    return []
  }
  let result = []
  let mut current = ""
  for i = 0; i < data.length(); i = i + 1 {
    let ch = data[i]
    if ch == '|' {
      if current.length() > 0 {
        result.push(current) |> ignore
        current = ""
      }
    } else {
      current = current + ch.to_string()
    }
  }
  if current.length() > 0 {
    result.push(current) |> ignore
  }
  result
}

///|
/// 将布尔数组序列化为位字符串
/// 使用 lambda 表达式优化
pub fn serialize_bools(data : Array[Bool]) -> String {
  // 使用 fold 和 lambda 表达式
  fold(data, "", fn(acc, x) { acc + (if x { "1" } else { "0" }) })
}

///|
/// 将位字符串反序列化为布尔数组
pub fn deserialize_bools(data : String) -> Array[Bool] {
  let result = []
  for i = 0; i < data.length(); i = i + 1 {
    result.push(data[i] == '1') |> ignore
  }
  result
}

///|
/// 简单的 JSON 风格序列化（仅支持基本类型）
pub fn serialize_json(data : Array[(String, String)]) -> String {
  let json_content = fold(data, "", fn(acc, pair) {
    let (key, value) = pair
    let entry = "\"" + key + "\":\"" + value + "\""
    if acc.length() == 0 {
      entry
    } else {
      acc + "," + entry
    }
  })
  "{" + json_content + "}"
}
