///|
/// 分块处理测试
test "chunk_string" {
  let data = "hello world"
  let chunks = chunk_string(data, 3)
  assert_eq(chunks.length() > 0, true)
}

///|
test "chunk_ints" {
  let data = [1, 2, 3, 4, 5, 6]
  let chunks = chunk_ints(data, 2)
  assert_eq(chunks.length(), 3)
}

///|
test "merge_chunks" {
  let chunks = ["hello", " world"]
  let merged = merge_chunks(chunks)
  assert_eq(merged.length() > 0, true)
}
