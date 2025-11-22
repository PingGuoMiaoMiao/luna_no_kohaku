///|
/// Trie 测试
test "trie_basic" {
  let mut trie = Trie::new()
  assert_eq(trie.is_empty(), true)
  trie = trie.insert("hello")
  trie = trie.insert("world")
  assert_eq(trie.size(), 2)
  assert_eq(trie.search("hello"), true)
  assert_eq(trie.search("world"), true)
  assert_eq(trie.search("hell"), false)
}

///|
test "trie_prefix" {
  let mut trie = Trie::new()
  trie = trie.insert("hello")
  trie = trie.insert("hell")
  trie = trie.insert("help")
  assert_eq(trie.starts_with("hel"), true)
  assert_eq(trie.starts_with("abc"), false)
}

///|
test "trie_autocomplete" {
  let mut trie = Trie::new()
  trie = trie.insert("hello")
  trie = trie.insert("hell")
  trie = trie.insert("help")
  let result = trie.autocomplete("hel", 10)
  assert_eq(result.length(), 3)
}
