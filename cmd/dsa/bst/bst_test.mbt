///|
/// BST 测试
test "bst_basic" {
  let mut bst = BST::new()
  assert_eq(bst.is_empty(), true)
  bst = bst.insert(5)
  bst = bst.insert(3)
  bst = bst.insert(7)
  bst = bst.insert(1)
  bst = bst.insert(4)
  assert_eq(bst.size(), 5)
  assert_eq(bst.search(5), true)
  assert_eq(bst.search(3), true)
  assert_eq(bst.search(10), false)
  assert_eq(bst.min(), Some(1))
  assert_eq(bst.max(), Some(7))
}

///|
test "bst_traversal" {
  let mut bst = BST::new()
  bst = bst.insert(4)
  bst = bst.insert(2)
  bst = bst.insert(6)
  bst = bst.insert(1)
  bst = bst.insert(3)
  bst = bst.insert(5)
  bst = bst.insert(7)

  // 中序遍历应该是有序的
  let inorder = bst.inorder()
  inspect(inorder, content="[1, 2, 3, 4, 5, 6, 7]")
}

///|
test "bst_clear" {
  let mut bst = BST::new()
  for i = 0; i < 10; i = i + 1 {
    bst = bst.insert(i)
  }
  bst = bst.clear()
  assert_eq(bst.size(), 0)
  assert_eq(bst.is_empty(), true)
}
