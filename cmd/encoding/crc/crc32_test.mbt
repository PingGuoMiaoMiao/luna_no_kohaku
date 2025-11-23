///|
/// CRC32 测试
test "crc32_basic" {
  let data = "hello"
  let crc = crc32(data)
  assert_eq(crc != 0, true)
}

///|
test "crc32_bytes" {
  let data = [104, 101, 108, 108, 111]
  let crc = crc32_bytes(data)
  assert_eq(crc != 0, true)
}
