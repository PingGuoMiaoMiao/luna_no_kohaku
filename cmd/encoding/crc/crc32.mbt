///| CRC32 校验和计算

///|
/// 计算 CRC32 查找表中的单个值
fn crc32_table_value(i : Int) -> Int {
  let polynomial = 0xEDB88320
  let mut crc = i
  for j = 0; j < 8; j = j + 1 {
    if (crc & 1) != 0 {
      crc = (crc >> 1) ^ polynomial
    } else {
      crc = crc >> 1
    }
  }
  crc
}

///|
/// 计算字符串的 CRC32 校验和
pub fn crc32(data : String) -> Int {
  let mut crc = 0xFFFFFFFF
  let len = data.length()
  for i = 0; i < len; i = i + 1 {
    let byte = data[i] & 0xFF
    let index = (crc ^ byte) & 0xFF
    crc = (crc >> 8) ^ crc32_table_value(index)
  }
  crc ^ 0xFFFFFFFF
}

///|
/// 计算字节数组的 CRC32
pub fn crc32_bytes(data : Array[Int]) -> Int {
  let mut crc = 0xFFFFFFFF
  for i = 0; i < data.length(); i = i + 1 {
    let byte = data[i] & 0xFF
    let index = (crc ^ byte) & 0xFF
    crc = (crc >> 8) ^ crc32_table_value(index)
  }
  crc ^ 0xFFFFFFFF
}

///|
/// 将 CRC32 值转换为十六进制字符串
pub fn crc32_to_hex(crc : Int) -> String {
  let hex_chars = "0123456789abcdef"
  let mut result = ""
  let mut value = crc & 0xFFFFFFFF
  for j = 0; j < 8; j = j + 1 {
    let digit = value & 0xF
    result = hex_chars[digit].to_string() + result
    value = value >> 4
  }
  result
}
