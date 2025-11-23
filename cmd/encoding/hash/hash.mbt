///| 哈希函数实现：MD5 和 SHA1

///|
/// MD5 哈希函数（简化实现）
/// TODO: 实现完整的 MD5 算法（RFC 1321）
pub fn md5(data : String) -> String {
  // MD5 的完整实现非常复杂，这里提供简化版本
  // 实际应用中应使用标准库或经过验证的实现
  let mut hash = 0
  let len = data.length()
  for i = 0; i < len; i = i + 1 {
    let ch = data[i]
    hash = (hash << 5) - hash + ch
    hash = hash & 0xFFFFFFFF
  }

  // 转换为十六进制字符串
  int_to_hex(hash)
}

///|
/// SHA1 哈希函数（简化实现）
/// TODO: 实现完整的 SHA1 算法（RFC 3174）
pub fn sha1(data : String) -> String {
  // SHA1 的完整实现非常复杂，这里提供简化版本
  // 实际应用中应使用标准库或经过验证的实现
  let mut h0 = 0x67452301
  let mut h1 = 0xEFCDAB89
  let mut h2 = 0x98BADCFE
  let mut h3 = 0x10325476
  let mut h4 = 0xC3D2E1F0
  let len = data.length()
  for i = 0; i < len; i = i + 1 {
    let ch = data[i]
    h0 = h0 + ch
    h1 = h1 ^ ch
    h2 = h2 + (ch << (i % 32))
    h3 = h3 ^ (ch << ((i + 1) % 32))
    h4 = h4 + (h0 ^ h1 ^ h2 ^ h3)
    h0 = h0 & 0xFFFFFFFF
    h1 = h1 & 0xFFFFFFFF
    h2 = h2 & 0xFFFFFFFF
    h3 = h3 & 0xFFFFFFFF
    h4 = h4 & 0xFFFFFFFF
  }
  int_to_hex(h0) +
  int_to_hex(h1) +
  int_to_hex(h2) +
  int_to_hex(h3) +
  int_to_hex(h4)
}

///|
/// 将整数转换为十六进制字符串
fn int_to_hex(value : Int) -> String {
  let hex_chars = "0123456789abcdef"
  let mut result = ""
  let mut v = value & 0xFFFFFFFF
  for j = 0; j < 8; j = j + 1 {
    result = hex_chars[v & 0xF].to_string() + result
    v = v >> 4
  }
  result
}

///|
/// 简单的哈希函数（用于哈希表等场景）
pub fn simple_hash(data : String) -> Int {
  let mut hash = 0
  let len = data.length()
  for i = 0; i < len; i = i + 1 {
    let ch = data[i]
    hash = (hash << 5) - hash + ch
    hash = hash & 0x7FFFFFFF
  }
  hash
}

///|
/// FNV-1a 哈希函数
pub fn fnv1a_hash(data : String) -> Int {
  let mut hash = 0x811C9DC5
  let len = data.length()
  for i = 0; i < len; i = i + 1 {
    let ch = data[i]
    hash = hash ^ ch
    hash = hash * 0x01000193
    hash = hash & 0xFFFFFFFF
  }
  hash
}
