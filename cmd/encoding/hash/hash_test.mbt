///|
/// 哈希函数测试
test "simple_hash" {
  let data = "hello"
  let hash = simple_hash(data)
  assert_eq(hash != 0, true)
}

///|
test "fnv1a_hash" {
  let data = "hello"
  let hash = fnv1a_hash(data)
  assert_eq(hash != 0, true)
}

///|
test "md5" {
  let data = "hello"
  let hash = md5(data)
  assert_eq(hash.length() > 0, true)
}

///|
test "sha1" {
  let data = "hello"
  let hash = sha1(data)
  assert_eq(hash.length() > 0, true)
}
