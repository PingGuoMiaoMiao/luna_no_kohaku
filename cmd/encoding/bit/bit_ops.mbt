///| 位运算和位压缩工具

///|
/// 设置指定位为 1
pub fn set_bit(value : Int, bit_pos : Int) -> Int {
  value | (1 << bit_pos)
}

///|
/// 清除指定位（设为 0）
pub fn clear_bit(value : Int, bit_pos : Int) -> Int {
  let mask = 1 << bit_pos
  value & (0xFFFFFFFF ^ mask)
}

///|
/// 切换指定位（0 变 1，1 变 0）
pub fn toggle_bit(value : Int, bit_pos : Int) -> Int {
  value ^ (1 << bit_pos)
}

///|
/// 检查指定位是否为 1
pub fn test_bit(value : Int, bit_pos : Int) -> Bool {
  (value & (1 << bit_pos)) != 0
}

///|
/// 获取指定位的值（0 或 1）
pub fn get_bit(value : Int, bit_pos : Int) -> Int {
  if test_bit(value, bit_pos) {
    1
  } else {
    0
  }
}

///|
/// 左移 n 位
pub fn shift_left(value : Int, n : Int) -> Int {
  value << n
}

///|
/// 右移 n 位（算术右移）
pub fn shift_right(value : Int, n : Int) -> Int {
  value >> n
}

///|
/// 无符号右移 n 位（逻辑右移）
pub fn shift_right_unsigned(value : Int, n : Int) -> Int {
  // MoonBit 中 >> 已经是逻辑右移
  value >> n
}

///|
/// 按位与
pub fn bit_and(a : Int, b : Int) -> Int {
  a & b
}

///|
/// 按位或
pub fn bit_or(a : Int, b : Int) -> Int {
  a | b
}

///|
/// 按位异或
pub fn bit_xor(a : Int, b : Int) -> Int {
  a ^ b
}

///|
/// 按位取反
pub fn bit_not(value : Int) -> Int {
  0xFFFFFFFF ^ value
}

///|
/// 计算 1 的个数（popcount）
pub fn popcount(value : Int) -> Int {
  let mut count = 0
  let mut v = value
  while v != 0 {
    if (v & 1) != 0 {
      count = count + 1
    }
    v = v >> 1
  }
  count
}

///|
/// 计算前导零的个数
pub fn leading_zeros(value : Int) -> Int {
  if value == 0 {
    return 32 // 假设 32 位整数
  }
  let mut count = 0
  let mut v = value
  while (v & 0x80000000) == 0 {
    count = count + 1
    v = v << 1
  }
  count
}

///|
/// 位压缩：将整数数组压缩为位字符串
pub fn compress_bits(data : Array[Int]) -> String {
  let mut result = ""
  for i = 0; i < data.length(); i = i + 1 {
    let value = data[i]
    for j = 0; j < 32; j = j + 1 {
      if test_bit(value, j) {
        result = result + "1"
      } else {
        result = result + "0"
      }
    }
  }
  result
}

///|
/// 位解压：将位字符串解压为整数数组
pub fn decompress_bits(bits : String) -> Array[Int] {
  let result = []
  let len = bits.length()
  let mut current_value = 0
  let mut bit_count = 0
  for i = 0; i < len; i = i + 1 {
    let bit_char = bits[i]
    let bit = if bit_char == '1' { 1 } else { 0 }
    if bit == 1 {
      current_value = set_bit(current_value, bit_count)
    }
    bit_count = bit_count + 1
    if bit_count >= 32 {
      result.push(current_value) |> ignore
      current_value = 0
      bit_count = 0
    }
  }
  if bit_count > 0 {
    result.push(current_value) |> ignore
  }
  result
}

///|
/// 将整数转换为二进制字符串
pub fn to_binary_string(value : Int) -> String {
  if value == 0 {
    return "0"
  }
  let mut result = ""
  let mut v = value
  while v > 0 {
    if (v & 1) != 0 {
      result = "1" + result
    } else {
      result = "0" + result
    }
    v = v >> 1
  }
  result
}

///|
/// 将二进制字符串转换为整数
pub fn from_binary_string(binary : String) -> Int {
  let mut result = 0
  let len = binary.length()
  for i = 0; i < len; i = i + 1 {
    let bit_char = binary[i]
    result = result << 1
    if bit_char == '1' {
      result = result | 1
    }
  }
  result
}
