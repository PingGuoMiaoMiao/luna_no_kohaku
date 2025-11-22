///|
/// LFU 缓存测试
test "lfu_basic" {
  let mut cache = LFUCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.put(2, "b")
  cache = cache.put(3, "c")

  // 多次访问 1，增加其频率
  let (c, _) = cache.get(1)
  cache = c
  let (c, _) = cache.get(1)
  cache = c

  // 访问 2 一次
  let (c, _) = cache.get(2)
  cache = c

  // 插入新元素，应该淘汰频率最低的（3，从未被访问）
  cache = cache.put(4, "d")
  let (c, v) = cache.get(3)
  cache = c
  assert_eq(v, None) // 3 已被淘汰
  let (c, v) = cache.get(1)
  cache = c
  assert_eq(v, Some("a")) // 1 还在（频率最高）
}

///|
test "lfu_clear" {
  let mut cache = LFUCache::new(3)
  cache = cache.put(1, "a")
  cache = cache.clear()
  assert_eq(cache.size(), 0)
}
