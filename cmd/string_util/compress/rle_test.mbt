///|
/// RLE 压缩测试
test "rle_encode_basic" {
  let result = encode("aaabbbcc")
  assert_eq(result.length(), 3)
  assert_eq(result[0].0, 'a'.to_int())
  assert_eq(result[0].1, 3)
}

///|
test "rle_decode_basic" {
  let encoded = [(97, 3), (98, 2), (99, 1)]
  let result = decode(encoded)
  assert_eq(result, "aaabbc")
}

///|
test "rle_roundtrip" {
  let original = "aaabbbcc"
  let encoded = encode(original)
  let decoded = decode(encoded)
  assert_eq(decoded, original)
}
