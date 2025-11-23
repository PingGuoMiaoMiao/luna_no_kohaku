///|
/// Base64 编码测试
test "encode_basic" {
  let data = "hello"
  let encoded = encode(data)
  assert_eq(encoded.length() > 0, true)
}
