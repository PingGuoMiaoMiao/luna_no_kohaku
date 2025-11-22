///|
/// ARC 缓存测试
test "arc_basic" {
  let mut cache = ARCCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.put(2, "b")
  cache = cache.put(3, "c")

  // 访问 1，使其从 t1 移到 t2
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, Some("a"))

  // 插入新元素
  cache = cache.put(4, "d")
  let (c, v) = cache.get(4)
  cache = c
  assert_eq(v, Some("d"))
}

///|
test "arc_clear" {
  let mut cache = ARCCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.clear()
  assert_eq(cache.size(), 0)
}
