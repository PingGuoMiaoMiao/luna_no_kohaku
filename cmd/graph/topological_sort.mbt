///| 拓扑排序算法（用于有向无环图 DAG）

///|
/// 拓扑排序结果
pub struct TopologicalSortResult {
  order : Array[Int]
  has_cycle : Bool
}

///|
/// 使用 DFS 方法进行拓扑排序
pub fn topological_sort(graph : Graph) -> TopologicalSortResult {
  let vertices = graph.vertex_count()
  let visited = init_array(vertices, false)
  let in_stack = init_array(vertices, false)
  let order : Array[Int] = []
  let (final_order, has_cycle) = dfs_topological(
    graph, visited, in_stack, order,
  )

  // 反转顺序（DFS 完成时间从大到小）
  let reversed_order = {
    let arr = []
    for i = final_order.length() - 1; i >= 0; i = i - 1 {
      arr.push(final_order[i]) |> ignore
    }
    arr
  }
  TopologicalSortResult::{ order: reversed_order, has_cycle }
}

///|
/// DFS 拓扑排序主函数
fn dfs_topological(
  graph : Graph,
  visited : Array[Bool],
  in_stack : Array[Bool],
  order : Array[Int],
) -> (Array[Int], Bool) {
  let vertices = graph.vertex_count()
  let mut new_visited = visited
  let mut new_in_stack = in_stack
  let mut new_order = order
  let mut has_cycle = false
  for i = 0; i < vertices; i = i + 1 {
    if !new_visited[i] {
      let (v, s, o, cycle) = dfs_visit_topological(
        graph, i, new_visited, new_in_stack, new_order,
      )
      new_visited = v
      new_in_stack = s
      new_order = o
      if cycle {
        has_cycle = true
      }
    }
  }
  (new_order, has_cycle)
}

///|
/// DFS 访问单个节点
fn dfs_visit_topological(
  graph : Graph,
  vertex : Int,
  visited : Array[Bool],
  in_stack : Array[Bool],
  order : Array[Int],
) -> (Array[Bool], Array[Bool], Array[Int], Bool) {
  if in_stack[vertex] {
    return (visited, in_stack, order, true)
  }
  if visited[vertex] {
    return (visited, in_stack, order, false)
  }
  let mut new_visited = visited
  let mut new_in_stack = in_stack
  let mut new_order = order
  new_visited[vertex] = true
  new_in_stack[vertex] = true
  let edges = graph.get_edges(vertex)
  let mut has_cycle = false
  for i = 0; i < edges.length(); i = i + 1 {
    let edge = edges[i]
    let to = edge.to
    let (v, s, o, cycle) = dfs_visit_topological(
      graph, to, new_visited, new_in_stack, new_order,
    )
    new_visited = v
    new_in_stack = s
    new_order = o
    if cycle {
      has_cycle = true
    }
  }
  new_in_stack[vertex] = false
  new_order = [..new_order, vertex]
  (new_visited, new_in_stack, new_order, has_cycle)
}

///|
/// Kahn 算法：基于入度的拓扑排序
pub fn topological_sort_kahn(graph : Graph) -> TopologicalSortResult {
  let vertices = graph.vertex_count()
  let in_degree = init_array(vertices, 0)

  // 计算每个顶点的入度
  for i = 0; i < vertices; i = i + 1 {
    let edges = graph.get_edges(i)
    for j = 0; j < edges.length(); j = j + 1 {
      let edge = edges[j]
      in_degree[edge.to] = in_degree[edge.to] + 1
    }
  }

  // 找到所有入度为 0 的顶点
  let queue = {
    let q = []
    for i = 0; i < vertices; i = i + 1 {
      if in_degree[i] == 0 {
        q.push(i) |> ignore
      }
    }
    q
  }
  let order = []
  let (final_order, _) = kahn_process(graph, queue, in_degree, order)
  TopologicalSortResult::{
    order: final_order,
    has_cycle: final_order.length() != vertices,
  }
}

///|
/// Kahn 算法主循环
fn kahn_process(
  graph : Graph,
  queue : Array[Int],
  in_degree : Array[Int],
  order : Array[Int],
) -> (Array[Int], Bool) {
  if queue.length() == 0 {
    return (order, false)
  }
  let current = queue[0]
  let new_queue = {
    let q = []
    for i = 1; i < queue.length(); i = i + 1 {
      q.push(queue[i]) |> ignore
    }
    q
  }
  let new_order = [..order, current]
  let edges = graph.get_edges(current)
  let (updated_queue, new_in_degree) = kahn_update_degrees(
    edges, new_queue, in_degree,
  )
  kahn_process(graph, updated_queue, new_in_degree, new_order)
}

///|
/// 更新邻居节点的入度
fn kahn_update_degrees(
  edges : Array[Edge],
  queue : Array[Int],
  in_degree : Array[Int],
) -> (Array[Int], Array[Int]) {
  if edges.length() == 0 {
    return (queue, in_degree)
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
  let new_degree = in_degree[to] - 1
  let new_in_degree = update_array(in_degree, to, new_degree)
  let new_queue = if new_degree == 0 { [..queue, to] } else { queue }
  kahn_update_degrees(remaining_edges, new_queue, new_in_degree)
}
