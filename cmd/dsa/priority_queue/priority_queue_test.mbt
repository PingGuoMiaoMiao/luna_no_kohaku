///|
/// PriorityQueue 测试
test "priority_queue_basic" {
  let mut pq = PriorityQueue::new()
  assert_eq(pq.is_empty(), true)
  pq = pq.push(5)
  pq = pq.push(2)
  pq = pq.push(8)
  pq = pq.push(1)
  pq = pq.push(3)
  assert_eq(pq.size(), 5)
  assert_eq(pq.peek(), Some(1))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(1))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(2))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(3))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(5))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(8))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, None)
}

///|
test "priority_queue_order" {
  let mut pq = PriorityQueue::new()
  // 乱序插入
  pq = pq.push(10)
  pq = pq.push(5)
  pq = pq.push(15)
  pq = pq.push(3)
  pq = pq.push(7)
  pq = pq.push(12)

  // 应该按升序弹出
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(3))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(5))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(7))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(10))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(12))
  let (p, v) = pq.pop()
  pq = p
  assert_eq(v, Some(15))
}

///|
test "priority_queue_clear" {
  let mut pq = PriorityQueue::new()
  for i = 0; i < 10; i = i + 1 {
    pq = pq.push(10 - i)
  }
  pq = pq.clear()
  assert_eq(pq.size(), 0)
  assert_eq(pq.is_empty(), true)
}
