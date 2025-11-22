///|
/// 匹配算法测试
test "brute_force_basic" {
  let result = brute_force_find_all("ababcab", "ab")
  assert_eq(result.length(), 3)
  assert_eq(result[0], 0)
  assert_eq(result[1], 2)
  assert_eq(result[2], 5)
}

///|
test "kmp_basic" {
  let result = kmp_find_all("ababcab", "ab")
  assert_eq(result.length(), 3)
}

///|
test "rabin_karp_basic" {
  let result = rabin_karp_find_all("ababcab", "ab")
  assert_eq(result.length(), 3)
}
