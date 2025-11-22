///|
/// Queue 测试
test "queue_basic" {
  let mut queue = Queue::new()
  assert_eq(queue.is_empty(), true)
  queue = queue.enqueue(1)
  queue = queue.enqueue(2)
  queue = queue.enqueue(3)
  assert_eq(queue.size(), 3)
  assert_eq(queue.front(), Some(1))
  let (q, v) = queue.dequeue()
  queue = q
  assert_eq(v, Some(1))
  let (q, v) = queue.dequeue()
  queue = q
  assert_eq(v, Some(2))
  let (q, v) = queue.dequeue()
  queue = q
  assert_eq(v, Some(3))
  let (q, v) = queue.dequeue()
  queue = q
  assert_eq(v, None)
  assert_eq(queue.is_empty(), true)
}

///|
test "queue_fifo" {
  let mut queue = Queue::new()
  queue = queue.enqueue(1)
  queue = queue.enqueue(2)
  let (q, v) = queue.dequeue()
  queue = q
  assert_eq(v, Some(1))
  queue = queue.enqueue(3)
  let (q, v) = queue.dequeue()
  queue = q
  assert_eq(v, Some(2))
  let (q, v) = queue.dequeue()
  queue = q
  assert_eq(v, Some(3))
}

///|
test "queue_clear" {
  let mut queue = Queue::new()
  for i = 0; i < 10; i = i + 1 {
    queue = queue.enqueue(i)
  }
  queue = queue.clear()
  assert_eq(queue.size(), 0)
  assert_eq(queue.is_empty(), true)
}
