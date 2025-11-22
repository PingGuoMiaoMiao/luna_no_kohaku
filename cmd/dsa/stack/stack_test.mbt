///|
/// Stack 测试
test "stack_basic" {
  let mut stack = Stack::new()
  assert_eq(stack.is_empty(), true)
  assert_eq(stack.size(), 0)
  stack = stack.push(1)
  stack = stack.push(2)
  stack = stack.push(3)
  assert_eq(stack.is_empty(), false)
  assert_eq(stack.size(), 3)
  assert_eq(stack.peek(), Some(3))
  let (s, v) = stack.pop()
  stack = s
  assert_eq(v, Some(3))
  let (s, v) = stack.pop()
  stack = s
  assert_eq(v, Some(2))
  let (s, v) = stack.pop()
  stack = s
  assert_eq(v, Some(1))
  let (s, v) = stack.pop()
  stack = s
  assert_eq(v, None)
  assert_eq(stack.is_empty(), true)
}

///|
test "stack_small_object_optimization" {
  let mut stack = Stack::new()
  // 测试小对象优化
  for i = 0; i < STACK_SO_SIZE; i = i + 1 {
    stack = stack.push(i)
  }
  assert_eq(stack.use_small, true)
  assert_eq(stack.size(), STACK_SO_SIZE)

  // 超过小对象阈值，应该切换到大缓冲区
  stack = stack.push(STACK_SO_SIZE)
  assert_eq(stack.use_small, false)
  assert_eq(stack.size(), STACK_SO_SIZE + 1)
}

///|
test "stack_no_shrink_on_pop" {
  let mut stack = Stack::new()
  // 填充超过小对象阈值
  for i = 0; i < 20; i = i + 1 {
    stack = stack.push(i)
  }
  let cap_before = stack.capacity()

  // 弹出一些元素
  for i = 0; i < 10; i = i + 1 {
    let (s, _) = stack.pop()
    stack = s
  }

  // 容量不应该减少
  assert_eq(stack.capacity(), cap_before)
}

///|
test "stack_clear" {
  let mut stack = Stack::new()
  for i = 0; i < 10; i = i + 1 {
    stack = stack.push(i)
  }
  assert_eq(stack.size(), 10)
  stack = stack.clear()
  assert_eq(stack.size(), 0)
  assert_eq(stack.is_empty(), true)
}
