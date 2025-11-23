///|
/// 位运算测试
test "test_bit" {
  let value = 5
  assert_eq(test_bit(value, 0), true)
  assert_eq(test_bit(value, 1), false)
  assert_eq(test_bit(value, 2), true)
}

///|
test "set_bit" {
  let value = 0
  let result = set_bit(value, 0)
  assert_eq(result, 1)
}

///|
test "clear_bit" {
  let value = 5
  let result = clear_bit(value, 0)
  assert_eq(result, 4)
}

///|
test "to_binary_string" {
  let value = 5
  let binary = to_binary_string(value)
  assert_eq(binary.length() > 0, true)
}
