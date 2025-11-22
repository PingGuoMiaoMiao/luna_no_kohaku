///|
/// 基础字符串操作测试
test "split_basic" {
  let result = split("a,b,c", ",")
  assert_eq(result.length(), 3)
  assert_eq(result[0], "a")
  assert_eq(result[1], "b")
  assert_eq(result[2], "c")
}

///|
test "split_empty_delimiter" {
  let result = split("abc", "")
  assert_eq(result.length(), 3)
}

///|
test "join_basic" {
  let arr = ["a", "b", "c"]
  let result = join(arr, ",")
  assert_eq(result, "a,b,c")
}

///|
test "substring_basic" {
  let result = substring("hello", 1, 4)
  assert_eq(result, "ell")
}

///|
test "replace_basic" {
  let result = replace("hello world", "world", "moon")
  assert_eq(result, "hello moon")
}

///|
test "replace_multiple" {
  let result = replace("a b a b", "a", "x")
  assert_eq(result, "x b x b")
}
