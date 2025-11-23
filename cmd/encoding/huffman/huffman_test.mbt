///|
/// 哈夫曼编码测试
test "count_frequencies" {
  let data = "hello"
  let frequencies = count_frequencies(data)
  assert_eq(frequencies.length() > 0, true)
}

///|
test "build_huffman_tree" {
  let frequencies = [
    CharFreq::new(104, 1),
    CharFreq::new(101, 1),
    CharFreq::new(108, 2),
  ]
  let tree = build_huffman_tree(frequencies)
  match tree {
    Some(_) => assert_eq(true, true)
    None => assert_eq(false, true)
  }
}
