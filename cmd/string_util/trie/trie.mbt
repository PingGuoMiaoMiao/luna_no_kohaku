///| Trie（前缀树）实现

///|

///| 用于高效存储和查找字符串集合

///| 支持前缀查找和自动补全

///|
/// Trie 节点
pub struct TrieNode {
  children : Array[TrieNode?]
  is_end : Bool // 标记是否为单词结尾
  count : Int // 以该节点为结尾的单词数量
}

///|
/// 创建新的 Trie 节点
fn TrieNode::new() -> TrieNode {
  TrieNode::{
    children: {
      let arr = []
      for i = 0; i < 256; i = i + 1 {
        arr.push(None) |> ignore
      }
      arr
    },
    is_end: false,
    count: 0,
  }
}

///|
/// Trie 树
pub struct Trie {
  root : TrieNode
  size : Int // 存储的单词数量
}

///|
/// 创建新的空 Trie
pub fn Trie::new() -> Trie {
  Trie::{ root: TrieNode::new(), size: 0 }
}

///|
/// 插入单词
pub fn Trie::insert(self : Trie, word : String) -> Trie {
  if word.length() == 0 {
    return self
  }
  let mut current = self.root
  for i = 0; i < word.length(); i = i + 1 {
    let char_code = word[i]
    let idx = char_code % 256

    // 检查子节点是否存在
    let child = current.children[idx]
    match child {
      Some(node) =>
        // 子节点存在，继续向下
        current = node
      None => {
        // 子节点不存在，创建新节点
        let new_node = TrieNode::new()
        // 更新 children 数组
        let new_children = {
          let arr = []
          for j = 0; j < current.children.length(); j = j + 1 {
            if j == idx {
              arr.push(Some(new_node)) |> ignore
            } else {
              arr.push(current.children[j]) |> ignore
            }
          }
          arr
        }
        current = TrieNode::{
          children: new_children,
          is_end: current.is_end,
          count: current.count,
        }
      }
    }
  }

  // 标记单词结尾
  if !current.is_end {
    current = TrieNode::{
      children: current.children,
      is_end: true,
      count: current.count + 1,
    }
  }
  Trie::{ root: current, size: self.size + 1 }
}

///|
/// 搜索单词
pub fn Trie::search(self : Trie, word : String) -> Bool {
  if word.length() == 0 {
    return false
  }
  let mut current = self.root
  for i = 0; i < word.length(); i = i + 1 {
    let char_code = word[i]
    let idx = char_code % 256
    match current.children[idx] {
      Some(node) => current = node
      None => return false
    }
  }
  current.is_end
}

///|
/// 检查是否存在以 prefix 为前缀的单词
pub fn Trie::starts_with(self : Trie, prefix : String) -> Bool {
  if prefix.length() == 0 {
    return true
  }
  let mut current = self.root
  for i = 0; i < prefix.length(); i = i + 1 {
    let char_code = prefix[i]
    let idx = char_code % 256
    match current.children[idx] {
      Some(node) => current = node
      None => return false
    }
  }
  true
}

///|
/// 查找所有以 prefix 为前缀的单词（前缀查找）
pub fn Trie::find_prefix(self : Trie, prefix : String) -> Array[String] {
  if prefix.length() == 0 {
    return []
  }

  // 先找到 prefix 对应的节点
  let mut current = self.root
  for i = 0; i < prefix.length(); i = i + 1 {
    let char_code = prefix[i]
    let idx = char_code % 256
    match current.children[idx] {
      Some(node) => current = node
      None => return []
    }
  }

  // 从该节点开始 DFS 遍历
  let result = []
  let final_result = Trie::dfs_collect(current, prefix, result)
  final_result
}

///|
/// DFS 遍历收集所有单词
fn Trie::dfs_collect(
  node : TrieNode,
  prefix : String,
  result : Array[String],
) -> Array[String] {
  let mut new_result = result

  // 如果当前节点是单词结尾，添加到结果
  if node.is_end {
    new_result = [..new_result, prefix]
  }

  // 遍历所有子节点
  for i = 0; i < node.children.length(); i = i + 1 {
    match node.children[i] {
      Some(child) => {
        // TODO: 修复字符转换逻辑（索引转字符）
        // 注意：这里简化处理，实际应该将索引转换为字符
        // 由于 MoonBit 的限制，这里使用索引的字符串表示
        let char_str = i.to_string()
        let new_prefix = prefix + char_str
        new_result = Trie::dfs_collect(child, new_prefix, new_result)
      }
      None => ignore(())
    }
  }
  new_result
}

///|
/// 自动补全
/// 返回以 prefix 为前缀的所有单词（限制数量）
pub fn Trie::autocomplete(
  self : Trie,
  prefix : String,
  limit : Int,
) -> Array[String] {
  let all = Trie::find_prefix(self, prefix)
  if all.length() <= limit {
    return all
  }
  let result = []
  for i = 0; i < limit; i = i + 1 {
    result.push(all[i]) |> ignore
  }
  result
}

///|
/// 获取 Trie 中存储的单词数量
pub fn Trie::size(self : Trie) -> Int {
  self.size
}

///|
/// 检查 Trie 是否为空
pub fn Trie::is_empty(self : Trie) -> Bool {
  self.size == 0
}

///|
/// 清空 Trie
pub fn Trie::clear(_self : Trie) -> Trie {
  Trie::new()
}
