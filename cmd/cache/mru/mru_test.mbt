///|
/// MRU 缓存测试
test "mru_basic" {
  let mut cache = MRUCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.put(2, "b")
  cache = cache.put(3, "c")

  // 访问 1，使其成为最近使用的
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, Some("a"))

  // 插入新元素，应该淘汰最近使用的（1）
  cache = cache.put(4, "d")
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, None) // 1 已被淘汰（因为最近使用）
  let (c, v) = cache.get(2)
  cache = c
  assert_eq(v, Some("b")) // 2 还在
}

///|
test "mru_clear" {
  let mut cache = MRUCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.clear()
  assert_eq(cache.size(), 0)
}
