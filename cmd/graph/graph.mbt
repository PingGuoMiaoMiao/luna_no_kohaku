///| 图数据结构实现

///|

///| 提供图的邻接表表示和基本操作

///|
/// 图的边（带权重）
pub struct Edge {
  from : Int
  to : Int
  weight : Double
}

///|
/// 创建边
pub fn Edge::new(from : Int, to : Int, weight : Double) -> Edge {
  Edge::{ from, to, weight }
}

///|
/// 创建无权重边（默认权重为 1.0）
pub fn Edge::new_unweighted(from : Int, to : Int) -> Edge {
  Edge::{ from, to, weight: 1.0 }
}

///|
/// 图的邻接表表示
pub struct Graph {
  vertices : Int
  edges : Array[Array[Edge]]
}

///|
/// 创建包含 n 个顶点的空图
pub fn Graph::new(vertices : Int) -> Graph {
  let edges = {
    let arr = []
    for i = 0; i < vertices; i = i + 1 {
      arr.push([]) |> ignore
    }
    arr
  }
  Graph::{ vertices, edges }
}

///|
/// 添加有向边
pub fn Graph::add_edge(
  self : Graph,
  from : Int,
  to : Int,
  weight : Double,
) -> Graph {
  if from < 0 || from >= self.vertices || to < 0 || to >= self.vertices {
    return self
  }
  let new_edges = {
    let arr = []
    for i = 0; i < self.edges.length(); i = i + 1 {
      if i == from {
        arr.push([..self.edges[i], Edge::new(from, to, weight)]) |> ignore
      } else {
        arr.push(self.edges[i]) |> ignore
      }
    }
    arr
  }
  Graph::{ vertices: self.vertices, edges: new_edges }
}

///|
/// 添加无向边（双向）
pub fn Graph::add_undirected_edge(
  self : Graph,
  from : Int,
  to : Int,
  weight : Double,
) -> Graph {
  let g1 = Graph::add_edge(self, from, to, weight)
  Graph::add_edge(g1, to, from, weight)
}

///|
/// 添加无权重边（权重为 1.0）
pub fn Graph::add_edge_unweighted(self : Graph, from : Int, to : Int) -> Graph {
  Graph::add_edge(self, from, to, 1.0)
}

///|
/// 获取顶点数量
pub fn Graph::vertex_count(self : Graph) -> Int {
  self.vertices
}

///|
/// 获取顶点的所有邻接边
pub fn Graph::get_edges(self : Graph, vertex : Int) -> Array[Edge] {
  if vertex < 0 || vertex >= self.vertices {
    return []
  }
  self.edges[vertex]
}

///|
/// 初始化数组（工具函数）
fn[T] init_array(size : Int, value : T) -> Array[T] {
  let arr = []
  for i = 0; i < size; i = i + 1 {
    arr.push(value) |> ignore
  }
  arr
}

///|
/// 更新数组中的单个元素（工具函数）
fn[T] update_array(arr : Array[T], index : Int, value : T) -> Array[T] {
  let result = []
  for i = 0; i < arr.length(); i = i + 1 {
    if i == index {
      result.push(value) |> ignore
    } else {
      result.push(arr[i]) |> ignore
    }
  }
  result
}
