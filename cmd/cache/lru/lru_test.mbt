///|
/// LRU 缓存测试
test "lru_basic" {
  let mut cache = LRUCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.put(2, "b")
  cache = cache.put(3, "c")

  // 访问 1，使其成为最近使用的
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, Some("a"))

  // 插入新元素，应该淘汰最久未使用的（2）
  cache = cache.put(4, "d")
  let (c, v) = cache.get(2)
  cache = c
  assert_eq(v, None) // 2 已被淘汰
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, Some("a")) // 1 还在（因为刚访问过）
}

///|
test "lru_update_existing" {
  let mut cache = LRUCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.put(2, "b")
  cache = cache.put(1, "a_updated")
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, Some("a_updated"))
}

///|
test "lru_clear" {
  let mut cache = LRUCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.clear()
  assert_eq(cache.size(), 0)
}
