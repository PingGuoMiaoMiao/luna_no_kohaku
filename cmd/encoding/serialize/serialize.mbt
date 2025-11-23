///| 序列化和反序列化工具

///|
/// 将整数数组序列化为字符串
pub fn serialize_ints(data : Array[Int]) -> String {
  let mut result = ""
  for i = 0; i < data.length(); i = i + 1 {
    if i > 0 {
      result = result + ","
    }
    result = result + data[i].to_string()
  }
  result
}

///| 将字符串反序列化为整数数组

///|
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
  let mut result = ""
  for i = 0; i < data.length(); i = i + 1 {
    if i > 0 {
      result = result + "|"
    }
    result = result + data[i]
  }
  result
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
pub fn serialize_bools(data : Array[Bool]) -> String {
  let mut result = ""
  for i = 0; i < data.length(); i = i + 1 {
    if data[i] {
      result = result + "1"
    } else {
      result = result + "0"
    }
  }
  result
}

///|
/// 将位字符串反序列化为布尔数组
pub fn deserialize_bools(data : String) -> Array[Bool] {
  let result = []
  for i = 0; i < data.length(); i = i + 1 {
    let ch = data[i]
    result.push(ch == '1') |> ignore
  }
  result
}

///|
/// 简单的 JSON 风格序列化（仅支持基本类型）
pub fn serialize_json(data : Array[(String, String)]) -> String {
  let mut result = "{"
  let mut first = true
  for i = 0; i < data.length(); i = i + 1 {
    let (key, value) = data[i]
    if !first {
      result = result + ","
    }
    result = result + "\"" + key + "\":\"" + value + "\""
    first = false
  }
  result = result + "}"
  result
}
