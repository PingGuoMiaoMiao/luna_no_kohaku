///| BFS 和 DFS 遍历算法

///|
/// BFS 遍历结果
pub struct BFSResult {
  visited : Array[Bool]
  distance : Array[Int]
  parent : Array[Int?]
}

///|
/// DFS 遍历结果
pub struct DFSResult {
  visited : Array[Bool]
  discovery_time : Array[Int]
  finish_time : Array[Int]
  parent : Array[Int?]
}

///|
/// 广度优先搜索
pub fn bfs(graph : Graph, start : Int) -> BFSResult {
  let vertices = graph.vertex_count()
  if start < 0 || start >= vertices {
    return BFSResult::{ visited: [], distance: [], parent: [] }
  }
  let visited = init_array(vertices, false)
  let distance = init_array(vertices, -1)
  let parent = init_array(vertices, None)
  let visited = update_array(visited, start, true)
  let distance = update_array(distance, start, 0)
  let queue = [start]
  let (final_visited, final_distance, final_parent, _) = bfs_visit(
    graph, queue, visited, distance, parent,
  )
  BFSResult::{
    visited: final_visited,
    distance: final_distance,
    parent: final_parent,
  }
}

///|
/// BFS 主循环
fn bfs_visit(
  graph : Graph,
  queue : Array[Int],
  visited : Array[Bool],
  distance : Array[Int],
  parent : Array[Int?],
) -> (Array[Bool], Array[Int], Array[Int?], Array[Int]) {
  if queue.length() == 0 {
    return (visited, distance, parent, queue)
  }
  let current = queue[0]
  let new_queue = {
    let q = []
    for i = 1; i < queue.length(); i = i + 1 {
      q.push(queue[i]) |> ignore
    }
    q
  }
  let edges = graph.get_edges(current)
  let (updated_visited, updated_distance, updated_parent, updated_queue) = bfs_process_edges(
    edges, current, visited, distance, parent, new_queue,
  )
  bfs_visit(
    graph, updated_queue, updated_visited, updated_distance, updated_parent,
  )
}

///|
/// 处理当前节点的所有边
fn bfs_process_edges(
  edges : Array[Edge],
  current : Int,
  visited : Array[Bool],
  distance : Array[Int],
  parent : Array[Int?],
  queue : Array[Int],
) -> (Array[Bool], Array[Int], Array[Int?], Array[Int]) {
  if edges.length() == 0 {
    return (visited, distance, parent, queue)
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
  let (new_visited, new_distance, new_parent, new_queue) = if !visited[to] {
    let v = update_array(visited, to, true)
    let d = update_array(distance, to, distance[current] + 1)
    let p = update_array(parent, to, Some(current))
    let q = [..queue, to]
    (v, d, p, q)
  } else {
    (visited, distance, parent, queue)
  }
  bfs_process_edges(
    remaining_edges, current, new_visited, new_distance, new_parent, new_queue,
  )
}

///|
/// 深度优先搜索
pub fn dfs(graph : Graph, start : Int) -> DFSResult {
  let vertices = graph.vertex_count()
  if start < 0 || start >= vertices {
    return DFSResult::{
      visited: [],
      discovery_time: [],
      finish_time: [],
      parent: [],
    }
  }
  let visited = init_array(vertices, false)
  let discovery_time = init_array(vertices, -1)
  let finish_time = init_array(vertices, -1)
  let parent = init_array(vertices, None)
  let (final_visited, final_discovery, final_finish, final_parent, _) = dfs_visit(
    graph, start, visited, discovery_time, finish_time, parent, 0,
  )
  DFSResult::{
    visited: final_visited,
    discovery_time: final_discovery,
    finish_time: final_finish,
    parent: final_parent,
  }
}

///|
/// DFS 递归访问节点
fn dfs_visit(
  graph : Graph,
  vertex : Int,
  visited : Array[Bool],
  discovery_time : Array[Int],
  finish_time : Array[Int],
  parent : Array[Int?],
  time : Int,
) -> (Array[Bool], Array[Int], Array[Int], Array[Int?], Int) {
  if visited[vertex] {
    return (visited, discovery_time, finish_time, parent, time)
  }
  let new_visited = update_array(visited, vertex, true)
  let new_discovery = update_array(discovery_time, vertex, time)
  let new_time = time + 1
  let edges = graph.get_edges(vertex)
  let (final_visited, final_discovery, final_finish, final_parent, final_time) = dfs_process_edges(
    graph, edges, vertex, new_visited, new_discovery, finish_time, parent, new_time,
  )
  let new_finish = update_array(final_finish, vertex, final_time)
  (final_visited, final_discovery, new_finish, final_parent, final_time + 1)
}

///|
/// 处理 DFS 中的边
fn dfs_process_edges(
  graph : Graph,
  edges : Array[Edge],
  vertex : Int,
  visited : Array[Bool],
  discovery_time : Array[Int],
  finish_time : Array[Int],
  parent : Array[Int?],
  time : Int,
) -> (Array[Bool], Array[Int], Array[Int], Array[Int?], Int) {
  if edges.length() == 0 {
    return (visited, discovery_time, finish_time, parent, time)
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
  let (new_visited, new_discovery, new_finish, new_parent, new_time) = if !visited[to] {
    let new_p = update_array(parent, to, Some(vertex))
    let (v, d, f, p, t) = dfs_visit(
      graph, to, visited, discovery_time, finish_time, new_p, time,
    )
    (v, d, f, p, t)
  } else {
    (visited, discovery_time, finish_time, parent, time)
  }
  dfs_process_edges(
    graph, remaining_edges, vertex, new_visited, new_discovery, new_finish, new_parent,
    new_time,
  )
}

///|
/// 遍历所有连通分量的 DFS
pub fn dfs_all(graph : Graph) -> DFSResult {
  let vertices = graph.vertex_count()
  let visited = init_array(vertices, false)
  let discovery_time = init_array(vertices, -1)
  let finish_time = init_array(vertices, -1)
  let parent = init_array(vertices, None)
  let (final_visited, final_discovery, final_finish, final_parent, _) = dfs_all_visit(
    graph, 0, visited, discovery_time, finish_time, parent, 0,
  )
  DFSResult::{
    visited: final_visited,
    discovery_time: final_discovery,
    finish_time: final_finish,
    parent: final_parent,
  }
}

///|
/// 遍历所有顶点的 DFS 辅助函数
fn dfs_all_visit(
  graph : Graph,
  current_vertex : Int,
  visited : Array[Bool],
  discovery_time : Array[Int],
  finish_time : Array[Int],
  parent : Array[Int?],
  time : Int,
) -> (Array[Bool], Array[Int], Array[Int], Array[Int?], Int) {
  let vertices = graph.vertex_count()
  if current_vertex >= vertices {
    return (visited, discovery_time, finish_time, parent, time)
  }
  let (new_visited, new_discovery, new_finish, new_parent, new_time) = if !visited[current_vertex] {
    let (v, d, f, p, t) = dfs_visit(
      graph, current_vertex, visited, discovery_time, finish_time, parent, time,
    )
    (v, d, f, p, t)
  } else {
    (visited, discovery_time, finish_time, parent, time)
  }
  dfs_all_visit(
    graph,
    current_vertex + 1,
    new_visited,
    new_discovery,
    new_finish,
    new_parent,
    new_time,
  )
}

///|
/// 随机深度优先搜索（通过打乱边的顺序实现随机性）
pub fn random_dfs(graph : Graph, start : Int) -> DFSResult {
  let vertices = graph.vertex_count()
  if start < 0 || start >= vertices {
    return DFSResult::{
      visited: [],
      discovery_time: [],
      finish_time: [],
      parent: [],
    }
  }
  let visited = init_array(vertices, false)
  let discovery_time = init_array(vertices, -1)
  let finish_time = init_array(vertices, -1)
  let parent = init_array(vertices, None)
  let (final_visited, final_discovery, final_finish, final_parent, _) = random_dfs_visit(
    graph, start, visited, discovery_time, finish_time, parent, 0,
  )
  DFSResult::{
    visited: final_visited,
    discovery_time: final_discovery,
    finish_time: final_finish,
    parent: final_parent,
  }
}

///|
/// 随机 DFS 递归访问
fn random_dfs_visit(
  graph : Graph,
  vertex : Int,
  visited : Array[Bool],
  discovery_time : Array[Int],
  finish_time : Array[Int],
  parent : Array[Int?],
  time : Int,
) -> (Array[Bool], Array[Int], Array[Int], Array[Int?], Int) {
  if visited[vertex] {
    return (visited, discovery_time, finish_time, parent, time)
  }
  let new_visited = update_array(visited, vertex, true)
  let new_discovery = update_array(discovery_time, vertex, time)
  let new_time = time + 1
  let edges = graph.get_edges(vertex)
  let shuffled_edges = shuffle_edges(edges, vertex)
  let (final_visited, final_discovery, final_finish, final_parent, final_time) = random_dfs_process_edges(
    graph, shuffled_edges, vertex, new_visited, new_discovery, finish_time, parent,
    new_time,
  )
  let new_finish = update_array(final_finish, vertex, final_time)
  (final_visited, final_discovery, new_finish, final_parent, final_time + 1)
}

///|
/// 打乱边的顺序（使用顶点索引作为随机种子）
fn shuffle_edges(edges : Array[Edge], seed : Int) -> Array[Edge] {
  let len = edges.length()
  if len <= 1 {
    return edges
  }
  let result = [..edges]
  for i = 0; i < len; i = i + 1 {
    let j = (i + seed + i * 7) % len
    let temp = result[i]
    result[i] = result[j]
    result[j] = temp
  }
  result
}

///|
/// 处理随机 DFS 中的边
fn random_dfs_process_edges(
  graph : Graph,
  edges : Array[Edge],
  vertex : Int,
  visited : Array[Bool],
  discovery_time : Array[Int],
  finish_time : Array[Int],
  parent : Array[Int?],
  time : Int,
) -> (Array[Bool], Array[Int], Array[Int], Array[Int?], Int) {
  if edges.length() == 0 {
    return (visited, discovery_time, finish_time, parent, time)
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
  let (new_visited, new_discovery, new_finish, new_parent, new_time) = if !visited[to] {
    let new_p = update_array(parent, to, Some(vertex))
    let (v, d, f, p, t) = random_dfs_visit(
      graph, to, visited, discovery_time, finish_time, new_p, time,
    )
    (v, d, f, p, t)
  } else {
    (visited, discovery_time, finish_time, parent, time)
  }
  random_dfs_process_edges(
    graph, remaining_edges, vertex, new_visited, new_discovery, new_finish, new_parent,
    new_time,
  )
}
