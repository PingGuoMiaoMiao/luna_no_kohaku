///| A* 启发式搜索算法

///|
/// A* 节点
priv struct AStarNode {
  vertex : Int
  f_cost : Double
}

///|
/// 创建 A* 节点
fn AStarNode::new(vertex : Int, f_cost : Double) -> AStarNode {
  AStarNode::{ vertex, f_cost }
}

///|
/// A* 搜索结果
pub struct AStarResult {
  path : Array[Int]
  cost : Double
  found : Bool
}

///| A* 算法：使用启发式函数寻找最短路径

///|
/// heuristic: 估计从顶点到终点的距离
pub fn astar(
  graph : Graph,
  start : Int,
  goal : Int,
  heuristic : (Int) -> Double,
) -> AStarResult {
  let vertices = graph.vertex_count()
  if start < 0 || start >= vertices || goal < 0 || goal >= vertices {
    return AStarResult::{ path: [], cost: 0.0, found: false }
  }
  if start == goal {
    return AStarResult::{ path: [start], cost: 0.0, found: true }
  }
  let open_set = {
    let arr = []
    arr.push(AStarNode::new(start, heuristic(start))) |> ignore
    arr
  }
  let closed_set = init_array(vertices, false)
  let came_from = init_array(vertices, None)
  let g_score = init_array(vertices, 1.0e10)
  let initial_g_score = update_array(g_score, start, 0.0)
  let (final_path, final_cost, found) = astar_search(
    graph, goal, open_set, closed_set, came_from, initial_g_score, heuristic,
  )
  AStarResult::{ path: final_path, cost: final_cost, found }
}

///|
/// A* 搜索主循环
fn astar_search(
  graph : Graph,
  goal : Int,
  open_set : Array[AStarNode],
  closed_set : Array[Bool],
  came_from : Array[Int?],
  g_score : Array[Double],
  heuristic : (Int) -> Double,
) -> (Array[Int], Double, Bool) {
  if open_set.length() == 0 {
    return ([], 0.0, false)
  }
  // 找到 f_cost 最小的节点
  let mut min_idx = 0
  let mut min_f = open_set[0].f_cost
  for i = 1; i < open_set.length(); i = i + 1 {
    if open_set[i].f_cost < min_f {
      min_f = open_set[i].f_cost
      min_idx = i
    }
  }
  let current = open_set[min_idx]
  let new_open_set = {
    let arr = []
    for i = 0; i < open_set.length(); i = i + 1 {
      if i != min_idx {
        arr.push(open_set[i]) |> ignore
      }
    }
    arr
  }
  if current.vertex == goal {
    // 找到目标，重建路径
    let path = []
    let (final_path, _) = reconstruct_path(came_from, goal, path)
    let reversed_path = {
      let arr = []
      for i = final_path.length() - 1; i >= 0; i = i - 1 {
        arr.push(final_path[i]) |> ignore
      }
      arr
    }
    return (reversed_path, g_score[goal], true)
  }
  let new_closed_set = update_array(closed_set, current.vertex, true)
  let edges = graph.get_edges(current.vertex)
  let (final_open_set, final_came_from, final_g_score) = astar_update_neighbors(
    edges,
    current.vertex,
    new_open_set,
    came_from,
    g_score,
    new_closed_set,
    heuristic,
  )
  astar_search(
    graph, goal, final_open_set, new_closed_set, final_came_from, final_g_score,
    heuristic,
  )
}

///|
/// 更新邻居节点
fn astar_update_neighbors(
  edges : Array[Edge],
  current : Int,
  open_set : Array[AStarNode],
  came_from : Array[Int?],
  g_score : Array[Double],
  closed_set : Array[Bool],
  heuristic : (Int) -> Double,
) -> (Array[AStarNode], Array[Int?], Array[Double]) {
  if edges.length() == 0 {
    return (open_set, came_from, g_score)
  }
  let edge = edges[0]
  let remaining_edges = {
    let arr = []
    for i = 1; i < edges.length(); i = i + 1 {
      arr.push(edges[i]) |> ignore
    }
    arr
  }
  let neighbor = edge.to
  let (updated_open_set, updated_came_from, updated_g_score) = if closed_set[neighbor] {
    (open_set, came_from, g_score)
  } else {
    let tentative_g = g_score[current] + edge.weight
    if tentative_g < g_score[neighbor] {
      let new_came_from = update_array(came_from, neighbor, Some(current))
      let new_g_score = update_array(g_score, neighbor, tentative_g)
      let h = heuristic(neighbor)
      let neighbor_node = AStarNode::new(neighbor, tentative_g + h)
      // 检查是否已在开放列表中
      let mut found = false
      for j = 0; j < open_set.length(); j = j + 1 {
        if open_set[j].vertex == neighbor {
          found = true
          break
        }
      }
      let new_open_set = if found {
        open_set
      } else {
        [..open_set, neighbor_node]
      }
      (new_open_set, new_came_from, new_g_score)
    } else {
      (open_set, came_from, g_score)
    }
  }
  astar_update_neighbors(
    remaining_edges, current, updated_open_set, updated_came_from, updated_g_score,
    closed_set, heuristic,
  )
}

///|
/// 重建路径
fn reconstruct_path(
  came_from : Array[Int?],
  current : Int,
  path : Array[Int],
) -> (Array[Int], Int) {
  let new_path = [..path, current]
  match came_from[current] {
    Some(parent) => reconstruct_path(came_from, parent, new_path)
    None => (new_path, current)
  }
}

///| 零启发式函数（相当于 Dijkstra）

///|
/// TODO: 根据实际场景实现合适的启发式函数（曼哈顿距离、欧几里得距离等）
pub fn zero_heuristic(_vertex : Int) -> Double {
  0.0
}
