///|
/// LinkedList 测试
test "linked_list_basic" {
  let mut list = LinkedList::new()
  assert_eq(list.is_empty(), true)
  list = list.push_back(1)
  list = list.push_back(2)
  list = list.push_front(0)
  assert_eq(list.size(), 3)
  assert_eq(list.front(), Some(0))
  assert_eq(list.back(), Some(2))
  let (l, v) = list.pop_front()
  list = l
  assert_eq(v, Some(0))
  let (l, v) = list.pop_back()
  list = l
  assert_eq(v, Some(2))
  let (l, v) = list.pop_front()
  list = l
  assert_eq(v, Some(1))
  let (l, v) = list.pop_front()
  list = l
  assert_eq(v, None)
}

///|
test "linked_list_get" {
  let mut list = LinkedList::new()
  list = list.push_back(1)
  list = list.push_back(2)
  list = list.push_back(3)
  assert_eq(list.get(0), Some(1))
  assert_eq(list.get(1), Some(2))
  assert_eq(list.get(2), Some(3))
  assert_eq(list.get(3), None)
}

///|
test "linked_list_insert_at" {
  let mut list = LinkedList::new()
  list = list.push_back(1)
  list = list.push_back(3)
  match list.insert_at(1, 2) {
    Some(l) => list = l
    None => ignore(())
  }
  assert_eq(list.get(0), Some(1))
  assert_eq(list.get(1), Some(2))
  assert_eq(list.get(2), Some(3))
}

///|
test "linked_list_clear" {
  let mut list = LinkedList::new()
  for i = 0; i < 10; i = i + 1 {
    list = list.push_back(i)
  }
  list = list.clear()
  assert_eq(list.size(), 0)
  assert_eq(list.is_empty(), true)
}
