///|
/// FIFO 缓存测试
test "fifo_basic" {
  let mut cache = FIFOCache::new(3)
  assert_eq(cache.size(), 0)
  assert_eq(cache.capacity(), 3)
  cache = cache.put(1, "a")
  cache = cache.put(2, "b")
  cache = cache.put(3, "c")
  assert_eq(cache.size(), 3)
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, Some("a"))

  // 插入新元素，应该淘汰最旧的（1）
  cache = cache.put(4, "d")
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, None) // 1 已被淘汰
  let (c, v) = cache.get(2)
  cache = c
  assert_eq(v, Some("b")) // 2 还在
}

///|
test "fifo_update_existing" {
  let mut cache = FIFOCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.put(2, "b")
  cache = cache.put(1, "a_updated")
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, Some("a_updated"))
  assert_eq(cache.size(), 2) // 大小不变
}

///|
test "fifo_clear" {
  let mut cache = FIFOCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.put(2, "b")
  cache = cache.clear()
  assert_eq(cache.size(), 0)
}
