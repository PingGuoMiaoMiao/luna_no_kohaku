///| 哈夫曼树和最优前缀编码实现

///|
/// 哈夫曼树节点
pub struct HuffmanNode {
  char : Int? // 字符（叶子节点）或 None（内部节点）
  freq : Int // 频率
  left : HuffmanNode?
  right : HuffmanNode?
}

///|
/// 创建叶子节点
fn HuffmanNode::leaf(char : Int, freq : Int) -> HuffmanNode {
  HuffmanNode::{ char: Some(char), freq, left: None, right: None }
}

///|
/// 创建内部节点
fn HuffmanNode::internal(
  freq : Int,
  left : HuffmanNode,
  right : HuffmanNode,
) -> HuffmanNode {
  HuffmanNode::{ char: None, freq, left: Some(left), right: Some(right) }
}

///|
/// 字符频率统计
pub struct CharFreq {
  char : Int
  freq : Int
}

///|
/// 创建字符频率
pub fn CharFreq::new(char : Int, freq : Int) -> CharFreq {
  CharFreq::{ char, freq }
}

///|
/// 统计字符串中每个字符的频率
pub fn count_frequencies(data : String) -> Array[CharFreq] {
  let len = data.length()
  count_frequencies_rec(data, 0, len, [])
}

///|
/// 递归统计频率
fn count_frequencies_rec(
  data : String,
  index : Int,
  len : Int,
  freq_map : Array[CharFreq],
) -> Array[CharFreq] {
  if index >= len {
    return freq_map
  }
  let ch = data[index]
  let (new_map, found) = update_frequency(freq_map, ch, 0)
  let final_map = if found {
    new_map
  } else {
    [..new_map, CharFreq::new(ch, 1)]
  }
  count_frequencies_rec(data, index + 1, len, final_map)
}

///|
/// 更新频率映射
fn update_frequency(
  freq_map : Array[CharFreq],
  ch : Int,
  idx : Int,
) -> (Array[CharFreq], Bool) {
  if idx >= freq_map.length() {
    return (freq_map, false)
  }
  let cf = freq_map[idx]
  if cf.char == ch {
    // 使用 lambda 表达式更新频率映射
    let new_map = {
      let arr = []
      for i = 0; i < freq_map.length(); i = i + 1 {
        if i == idx {
          arr.push(CharFreq::new(ch, cf.freq + 1)) |> ignore
        } else {
          arr.push(freq_map[i]) |> ignore
        }
      }
      arr
    }
    (new_map, true)
  } else {
    let (rest_map, rest_found) = update_frequency(freq_map, ch, idx + 1)
    if rest_found {
      (rest_map, true)
    } else {
      (freq_map, false)
    }
  }
}

///|
/// 构建哈夫曼树
pub fn build_huffman_tree(frequencies : Array[CharFreq]) -> HuffmanNode? {
  if frequencies.length() == 0 {
    return None
  }
  if frequencies.length() == 1 {
    let cf = frequencies[0]
    return Some(HuffmanNode::leaf(cf.char, cf.freq))
  }

  // 使用 lambda 表达式创建初始节点列表
  let nodes = {
    let arr = []
    for i = 0; i < frequencies.length(); i = i + 1 {
      let cf = frequencies[i]
      arr.push(HuffmanNode::leaf(cf.char, cf.freq)) |> ignore
    }
    arr
  }

  // 构建哈夫曼树
  build_tree(nodes)
}

///|
/// 构建树的辅助函数
fn build_tree(nodes : Array[HuffmanNode]) -> HuffmanNode? {
  if nodes.length() == 0 {
    return None
  }
  if nodes.length() == 1 {
    return Some(nodes[0])
  }

  // 找到频率最小的两个节点
  let (min1_idx, min2_idx) = find_two_min(nodes, 0, 1, 0, 1)
  let node1 = nodes[min1_idx]
  let node2 = nodes[min2_idx]

  // 创建新内部节点
  let new_node = HuffmanNode::internal(node1.freq + node2.freq, node1, node2)

  // 使用 lambda 表达式移除已合并的节点，添加新节点
  let new_nodes = {
    let arr = []
    for i = 0; i < nodes.length(); i = i + 1 {
      if i != min1_idx && i != min2_idx {
        arr.push(nodes[i]) |> ignore
      }
    }
    arr.push(new_node) |> ignore
    arr
  }
  build_tree(new_nodes)
}

///|
/// 找到频率最小的两个节点索引
fn find_two_min(
  nodes : Array[HuffmanNode],
  idx1 : Int,
  idx2 : Int,
  min1 : Int,
  min2 : Int,
) -> (Int, Int) {
  if idx1 >= nodes.length() {
    return (min1, min2)
  }
  let current_freq = nodes[idx1].freq
  let min1_freq = nodes[min1].freq
  let min2_freq = nodes[min2].freq
  let (new_min1, new_min2) = if current_freq < min1_freq {
    (idx1, min1)
  } else if current_freq < min2_freq && idx1 != min1 {
    (min1, idx1)
  } else {
    (min1, min2)
  }
  find_two_min(nodes, idx1 + 1, idx2, new_min1, new_min2)
}

///|
/// 生成编码表（字符到编码的映射）
pub fn generate_codes(root : HuffmanNode?) -> Array[(Int, String)] {
  match root {
    Some(node) => {
      let codes = []
      generate_codes_rec(node, "", codes)
    }
    None => []
  }
}

///|
/// 递归生成编码
fn generate_codes_rec(
  node : HuffmanNode,
  prefix : String,
  codes : Array[(Int, String)],
) -> Array[(Int, String)] {
  match node.char {
    Some(ch) =>
      // 叶子节点
      [..codes, (ch, prefix)]
    None =>
      // 内部节点，递归处理左右子树
      match (node.left, node.right) {
        (Some(left), Some(right)) => {
          let codes_left = generate_codes_rec(left, prefix + "0", codes)
          generate_codes_rec(right, prefix + "1", codes_left)
        }
        _ => codes
      }
  }
}

///|
/// 使用编码表编码字符串
pub fn encode(data : String, codes : Array[(Int, String)]) -> String {
  let mut result = ""
  let len = data.length()
  for i = 0; i < len; i = i + 1 {
    let ch = data[i]
    let mut found = false
    for j = 0; j < codes.length(); j = j + 1 {
      let (code_char, code_str) = codes[j]
      if code_char == ch {
        result = result + code_str
        found = true
        break
      }
    }
    if !found {
      // 如果找不到编码，跳过该字符
      // 实际应用中应该处理错误情况
    }
  }
  result
}

///|
/// 使用哈夫曼树解码
pub fn decode(encoded : String, root : HuffmanNode?) -> String {
  match root {
    Some(node) => {
      let mut result = ""
      let mut current = Some(node)
      let len = encoded.length()
      for i = 0; i < len; i = i + 1 {
        let bit_char = encoded[i]
        let bit_is_zero = bit_char == '0'
        match current {
          Some(n) =>
            match n.char {
              Some(ch) => {
                // 到达叶子节点，输出字符并重置
                result = result + ch.to_string()
                current = Some(node)
                // 继续处理当前位
                match (node.left, node.right) {
                  (Some(left), Some(right)) =>
                    if bit_is_zero {
                      current = Some(left)
                    } else {
                      current = Some(right)
                    }
                  _ => ignore(())
                }
              }
              None =>
                // 内部节点，根据位选择左右子树
                match (n.left, n.right) {
                  (Some(left), Some(right)) =>
                    if bit_is_zero {
                      current = Some(left)
                    } else {
                      current = Some(right)
                    }
                  _ => current = None
                }
            }
          None => break
        }
      }

      // 处理最后一个字符
      match current {
        Some(n) =>
          match n.char {
            Some(ch) => result = result + ch.to_string()
            None => ignore(())
          }
        None => ignore(())
      }
      result
    }
    None => ""
  }
}

///|
/// 压缩：将字符串编码为二进制字符串
pub fn compress(data : String) -> (String, HuffmanNode?) {
  let frequencies = count_frequencies(data)
  let tree = build_huffman_tree(frequencies)
  let codes = generate_codes(tree)
  let encoded = encode(data, codes)
  (encoded, tree)
}

///|
/// 解压：将二进制字符串解码为原始字符串
pub fn decompress(encoded : String, tree : HuffmanNode?) -> String {
  decode(encoded, tree)
}
