///|
/// Deque 测试
test "deque_basic" {
  let mut deque = Deque::new()
  assert_eq(deque.is_empty(), true)
  deque = deque.push_back(1)
  deque = deque.push_back(2)
  deque = deque.push_front(0)
  assert_eq(deque.size(), 3)
  assert_eq(deque.front(), Some(0))
  assert_eq(deque.back(), Some(2))
  let (d, v) = deque.pop_front()
  deque = d
  assert_eq(v, Some(0))
  let (d, v) = deque.pop_back()
  deque = d
  assert_eq(v, Some(2))
  let (d, v) = deque.pop_front()
  deque = d
  assert_eq(v, Some(1))
  let (d, v) = deque.pop_front()
  deque = d
  assert_eq(v, None)
}

///|
test "deque_both_ends" {
  let mut deque = Deque::new()
  deque = deque.push_front(1)
  deque = deque.push_back(2)
  deque = deque.push_front(0)
  deque = deque.push_back(3)
  let (d, v) = deque.pop_front()
  deque = d
  assert_eq(v, Some(0))
  let (d, v) = deque.pop_back()
  deque = d
  assert_eq(v, Some(3))
  let (d, v) = deque.pop_front()
  deque = d
  assert_eq(v, Some(1))
  let (d, v) = deque.pop_back()
  deque = d
  assert_eq(v, Some(2))
}

///|
test "deque_clear" {
  let mut deque = Deque::new()
  for i = 0; i < 10; i = i + 1 {
    if i % 2 == 0 {
      deque = deque.push_front(i)
    } else {
      deque = deque.push_back(i)
    }
  }
  deque = deque.clear()
  assert_eq(deque.size(), 0)
  assert_eq(deque.is_empty(), true)
}
