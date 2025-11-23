///| 最小生成树（MST）算法：Kruskal 和 Prim

///|
/// MST 结果
pub struct MSTResult {
  edges : Array[Edge]
  total_weight : Double
}

///|
/// 并查集（用于 Kruskal 算法）
priv struct UnionFind {
  parent : Array[Int]
  rank : Array[Int]
}

///|
/// 创建并查集
fn UnionFind::new(size : Int) -> UnionFind {
  let parent = {
    let arr = []
    for i = 0; i < size; i = i + 1 {
      arr.push(i) |> ignore
    }
    arr
  }
  let rank = init_array(size, 0)
  UnionFind::{ parent, rank }
}

///|
/// 查找根节点（带路径压缩）
fn UnionFind::find(self : UnionFind, x : Int) -> (UnionFind, Int) {
  if self.parent[x] != x {
    let (new_uf, root) = UnionFind::find(self, self.parent[x])
    let new_parent = update_array(new_uf.parent, x, root)
    (UnionFind::{ parent: new_parent, rank: new_uf.rank }, root)
  } else {
    (self, x)
  }
}

///|
/// 合并两个集合（按秩合并）
fn UnionFind::union(self : UnionFind, x : Int, y : Int) -> UnionFind {
  let (uf1, root_x) = UnionFind::find(self, x)
  let (uf2, root_y) = UnionFind::find(uf1, y)
  if root_x == root_y {
    return uf2
  }
  let new_parent = [..uf2.parent]
  let new_rank = [..uf2.rank]
  if uf2.rank[root_x] < uf2.rank[root_y] {
    new_parent[root_x] = root_y
  } else if uf2.rank[root_x] > uf2.rank[root_y] {
    new_parent[root_y] = root_x
  } else {
    new_parent[root_y] = root_x
    new_rank[root_x] = new_rank[root_x] + 1
  }
  UnionFind::{ parent: new_parent, rank: new_rank }
}

///|
/// Kruskal 算法：使用并查集实现
pub fn kruskal(graph : Graph) -> MSTResult {
  let vertices = graph.vertex_count()
  // 收集所有边
  let all_edges = []
  for i = 0; i < vertices; i = i + 1 {
    let edges = graph.get_edges(i)
    for j = 0; j < edges.length(); j = j + 1 {
      let edge = edges[j]
      // 只添加 from < to 的边（避免重复）
      if edge.from < edge.to {
        all_edges.push(edge) |> ignore
      }
    }
  }
  // 按权重排序
  let sorted_edges = sort_edges(all_edges)
  let uf = UnionFind::new(vertices)
  let mst_edges : Array[Edge] = []
  let total_weight = 0.0
  let (_, final_edges, final_weight) = kruskal_process(
    sorted_edges, uf, mst_edges, total_weight,
  )
  MSTResult::{ edges: final_edges, total_weight: final_weight }
}

///|
/// Kruskal 处理函数
fn kruskal_process(
  edges : Array[Edge],
  uf : UnionFind,
  mst_edges : Array[Edge],
  total_weight : Double,
) -> (UnionFind, Array[Edge], Double) {
  if edges.length() == 0 {
    return (uf, mst_edges, total_weight)
  }
  let edge = edges[0]
  let remaining_edges = {
    let arr = []
    for i = 1; i < edges.length(); i = i + 1 {
      arr.push(edges[i]) |> ignore
    }
    arr
  }
  let (new_uf, root_from) = UnionFind::find(uf, edge.from)
  let (final_uf, root_to) = UnionFind::find(new_uf, edge.to)
  if root_from != root_to {
    let merged_uf = UnionFind::union(final_uf, root_from, root_to)
    let new_mst = [..mst_edges, edge]
    let new_weight = total_weight + edge.weight
    kruskal_process(remaining_edges, merged_uf, new_mst, new_weight)
  } else {
    kruskal_process(remaining_edges, final_uf, mst_edges, total_weight)
  }
}

///|
/// 排序边（按权重）
fn sort_edges(edges : Array[Edge]) -> Array[Edge] {
  // 使用简单的冒泡排序
  let len = edges.length()
  if len <= 1 {
    return edges
  }
  let result = [..edges]
  for i = 0; i < len - 1; i = i + 1 {
    for j = 0; j < len - i - 1; j = j + 1 {
      if result[j + 1].weight < result[j].weight {
        let temp = result[j]
        result[j] = result[j + 1]
        result[j + 1] = temp
      }
    }
  }
  result
}

///|
/// Prim 算法：从任意起点开始构建 MST
pub fn prim(graph : Graph, start : Int) -> MSTResult {
  let vertices = graph.vertex_count()
  if start < 0 || start >= vertices {
    return MSTResult::{ edges: [], total_weight: 0.0 }
  }
  let in_mst = init_array(vertices, false)
  let min_weight = init_array(vertices, 1.0e10)
  let parent = init_array(vertices, -1)
  let initial_min_weight = update_array(min_weight, start, 0.0)
  let (_, _, final_parent) = prim_process(
    graph, in_mst, initial_min_weight, parent,
  )
  // 构建 MST 边
  let empty_edges : Array[Edge] = []
  let (mst_edges, total_weight) = build_mst_edges(
    graph, final_parent, vertices, empty_edges, 0.0,
  )
  MSTResult::{ edges: mst_edges, total_weight }
}

///|
/// 构建 MST 边
fn build_mst_edges(
  graph : Graph,
  parent : Array[Int],
  vertices : Int,
  edges : Array[Edge],
  weight : Double,
) -> (Array[Edge], Double) {
  if vertices == 0 {
    return (edges, weight)
  }
  let i = vertices - 1
  let (new_edges, new_weight) = if parent[i] >= 0 {
    let graph_edges = graph.get_edges(parent[i])
    let mut found_edge = None
    for j = 0; j < graph_edges.length(); j = j + 1 {
      let edge = graph_edges[j]
      if edge.to == i {
        found_edge = Some(edge)
        break
      }
    }
    match found_edge {
      Some(edge) => ([..edges, edge], weight + edge.weight)
      None => (edges, weight)
    }
  } else {
    (edges, weight)
  }
  build_mst_edges(graph, parent, vertices - 1, new_edges, new_weight)
}

///|
/// Prim 处理函数
fn prim_process(
  graph : Graph,
  in_mst : Array[Bool],
  min_weight : Array[Double],
  parent : Array[Int],
) -> (Array[Bool], Array[Double], Array[Int]) {
  let vertices = graph.vertex_count()
  prim_iterate(graph, in_mst, min_weight, parent, vertices, vertices)
}

///|
/// Prim 迭代函数
fn prim_iterate(
  graph : Graph,
  in_mst : Array[Bool],
  min_weight : Array[Double],
  parent : Array[Int],
  vertices : Int,
  remaining : Int,
) -> (Array[Bool], Array[Double], Array[Int]) {
  if remaining == 0 {
    return (in_mst, min_weight, parent)
  }
  let mut min_w = 1.0e10
  let mut min_v = -1
  for i = 0; i < vertices; i = i + 1 {
    if !in_mst[i] && min_weight[i] < min_w {
      min_w = min_weight[i]
      min_v = i
    }
  }
  if min_v < 0 {
    return (in_mst, min_weight, parent)
  }
  let new_in_mst = {
    let arr = []
    for i = 0; i < in_mst.length(); i = i + 1 {
      if i == min_v {
        arr.push(true) |> ignore
      } else {
        arr.push(in_mst[i]) |> ignore
      }
    }
    arr
  }
  let edges = graph.get_edges(min_v)
  let (new_min_weight, new_parent) = prim_update_neighbors(
    edges, min_v, new_in_mst, min_weight, parent,
  )
  prim_iterate(
    graph,
    new_in_mst,
    new_min_weight,
    new_parent,
    vertices,
    remaining - 1,
  )
}

///|
/// Prim 更新邻居
fn prim_update_neighbors(
  edges : Array[Edge],
  from : Int,
  in_mst : Array[Bool],
  min_weight : Array[Double],
  parent : Array[Int],
) -> (Array[Double], Array[Int]) {
  if edges.length() == 0 {
    return (min_weight, parent)
  }
  let edge = edges[0]
  let remaining_edges = {
    let arr = []
    for i = 1; i < edges.length(); i = i + 1 {
      arr.push(edges[i]) |> ignore
    }
    arr
  }
  let to = edge.to
  let (new_min_weight, new_parent) = if !in_mst[to] &&
    edge.weight < min_weight[to] {
    let w = {
      let arr = []
      for i = 0; i < min_weight.length(); i = i + 1 {
        if i == to {
          arr.push(edge.weight) |> ignore
        } else {
          arr.push(min_weight[i]) |> ignore
        }
      }
      arr
    }
    let p = {
      let arr = []
      for i = 0; i < parent.length(); i = i + 1 {
        if i == to {
          arr.push(from) |> ignore
        } else {
          arr.push(parent[i]) |> ignore
        }
      }
      arr
    }
    (w, p)
  } else {
    (min_weight, parent)
  }
  prim_update_neighbors(
    remaining_edges, from, in_mst, new_min_weight, new_parent,
  )
}
