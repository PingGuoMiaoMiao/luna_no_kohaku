///| Base64 编码和解码

///|
/// Base64 字符表
const BASE64_CHARS : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

///|
/// 查找 Base64 字符的索引
fn find_base64_char(ch : Int) -> Int {
  for i = 0; i < BASE64_CHARS.length(); i = i + 1 {
    if BASE64_CHARS[i] == ch {
      return i
    }
  }
  -1
}

///|
/// Base64 编码：将字符串编码为 Base64
pub fn encode(data : String) -> String {
  let mut result = ""
  let len = data.length()
  let mut i = 0
  while i < len {
    // 读取 3 个字符（24 位）
    let byte1 = if i < len { data[i] } else { 0 }
    let byte2 = if i + 1 < len { data[i + 1] } else { 0 }
    let byte3 = if i + 2 < len { data[i + 2] } else { 0 }

    // 组合为 24 位
    let combined = (byte1 << 16) | (byte2 << 8) | byte3

    // 提取 4 个 6 位值
    let enc1 = (combined >> 18) & 63
    let enc2 = (combined >> 12) & 63
    let enc3 = (combined >> 6) & 63
    let enc4 = combined & 63
    result = result + BASE64_CHARS[enc1].to_string()
    result = result + BASE64_CHARS[enc2].to_string()
    if i + 1 < len {
      result = result + BASE64_CHARS[enc3].to_string()
    } else {
      result = result + "="
    }
    if i + 2 < len {
      result = result + BASE64_CHARS[enc4].to_string()
    } else {
      result = result + "="
    }
    i = i + 3
  }
  result
}

///|
/// Base64 解码：将 Base64 字符串解码
pub fn decode(encoded : String) -> String {
  let mut result = ""
  let len = encoded.length()
  let mut i = 0

  // 构建反向查找表（简化实现：直接查找）
  // 注意：这里使用线性查找，实际应用中可以使用预计算的查找表
  while i < len {
    if encoded[i] == '=' {
      break
    }
    let enc1 = if i < len { find_base64_char(encoded[i]) } else { 0 }
    let enc2 = if i + 1 < len { find_base64_char(encoded[i + 1]) } else { 0 }
    let enc3 = if i + 2 < len && encoded[i + 2] != '=' {
      find_base64_char(encoded[i + 2])
    } else {
      0
    }
    let enc4 = if i + 3 < len && encoded[i + 3] != '=' {
      find_base64_char(encoded[i + 3])
    } else {
      0
    }
    let combined = (enc1 << 18) | (enc2 << 12) | (enc3 << 6) | enc4
    let byte1 = (combined >> 16) & 255
    let byte2 = (combined >> 8) & 255
    let byte3 = combined & 255
    result = result + byte1.to_string()
    if i + 2 < len && encoded[i + 2] != '=' {
      result = result + byte2.to_string()
    }
    if i + 3 < len && encoded[i + 3] != '=' {
      result = result + byte3.to_string()
    }
    i = i + 4
  }
  result
}
