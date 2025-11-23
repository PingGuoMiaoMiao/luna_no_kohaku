///|
/// 序列化测试
test "serialize_ints" {
  let data = [1, 2, 3]
  let serialized = serialize_ints(data)
  assert_eq(serialized.length() > 0, true)
}

///|
test "serialize_strings" {
  let data = ["hello", "world"]
  let serialized = serialize_strings(data)
  assert_eq(serialized.length() > 0, true)
}

///|
test "serialize_bools" {
  let data = [true, false, true]
  let serialized = serialize_bools(data)
  assert_eq(serialized.length() > 0, true)
}
