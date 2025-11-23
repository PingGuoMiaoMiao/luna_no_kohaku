///| Dijkstra 最短路径算法

///|
/// 最短路径结果
pub struct ShortestPathResult {
  distance : Array[Double]
  parent : Array[Int?]
  reachable : Array[Bool]
}

///|
/// Dijkstra 算法：计算从起点到所有顶点的最短路径
pub fn dijkstra(graph : Graph, start : Int) -> ShortestPathResult {
  let vertices = graph.vertex_count()
  if start < 0 || start >= vertices {
    return ShortestPathResult::{ distance: [], parent: [], reachable: [] }
  }
  let distance = init_array(vertices, 1.0e10)
  let parent = init_array(vertices, None)
  let visited = init_array(vertices, false)
  let distance = update_array(distance, start, 0.0)
  let (final_distance, final_parent, final_visited) = dijkstra_iterate(
    graph, distance, parent, visited, vertices,
  )
  ShortestPathResult::{
    distance: final_distance,
    parent: final_parent,
    reachable: final_visited,
  }
}

///|
/// Dijkstra 主循环
fn dijkstra_iterate(
  graph : Graph,
  distance : Array[Double],
  parent : Array[Int?],
  visited : Array[Bool],
  remaining : Int,
) -> (Array[Double], Array[Int?], Array[Bool]) {
  if remaining == 0 {
    return (distance, parent, visited)
  }
  let vertices = graph.vertex_count()
  let mut min_dist = 1.0e10
  let mut min_vertex = -1
  for i = 0; i < vertices; i = i + 1 {
    if !visited[i] && distance[i] < min_dist {
      min_dist = distance[i]
      min_vertex = i
    }
  }
  if min_vertex < 0 {
    return (distance, parent, visited)
  }
  let new_visited = update_array(visited, min_vertex, true)
  let edges = graph.get_edges(min_vertex)
  let (new_distance, new_parent) = relax_edges(
    edges, min_vertex, distance, parent,
  )
  dijkstra_iterate(graph, new_distance, new_parent, new_visited, remaining - 1)
}

///|
/// 松弛边：更新通过当前节点到达邻居的距离
fn relax_edges(
  edges : Array[Edge],
  from : Int,
  distance : Array[Double],
  parent : Array[Int?],
) -> (Array[Double], Array[Int?]) {
  if edges.length() == 0 {
    return (distance, parent)
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
  let new_dist = distance[from] + edge.weight
  let (new_distance, new_parent) = if new_dist < distance[to] {
    let d = update_array(distance, to, new_dist)
    let p = update_array(parent, to, Some(from))
    (d, p)
  } else {
    (distance, parent)
  }
  relax_edges(remaining_edges, from, new_distance, new_parent)
}

///|
/// 获取从起点到终点的最短路径
pub fn get_shortest_path(
  result : ShortestPathResult,
  _start : Int,
  end : Int,
) -> Array[Int] {
  if !result.reachable[end] {
    return []
  }
  let path = []
  let (final_path, _) = build_path(result.parent, end, path)

  // 反转路径
  let reversed_path = {
    let arr = []
    for i = final_path.length() - 1; i >= 0; i = i - 1 {
      arr.push(final_path[i]) |> ignore
    }
    arr
  }
  reversed_path
}

///|
/// 根据父节点数组构建路径
fn build_path(
  parent : Array[Int?],
  current : Int,
  path : Array[Int],
) -> (Array[Int], Int) {
  let new_path = [..path, current]
  match parent[current] {
    Some(p) => build_path(parent, p, new_path)
    None => (new_path, current)
  }
}
