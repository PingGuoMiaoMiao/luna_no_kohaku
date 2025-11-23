///|
/// 图算法测试
test "graph_basic" {
  let g = Graph::new(5)
  let g1 = g.add_edge_unweighted(0, 1)
  let g2 = g1.add_edge_unweighted(1, 2)
  let g3 = g2.add_edge_unweighted(2, 3)
  assert_eq(g3.vertex_count(), 5)
}

///|
test "bfs_basic" {
  let g = Graph::new(4)
  let g1 = g.add_edge_unweighted(0, 1)
  let g2 = g1.add_edge_unweighted(0, 2)
  let g3 = g2.add_edge_unweighted(1, 3)
  let result = bfs(g3, 0)
  assert_eq(result.visited[0], true)
  assert_eq(result.distance[0], 0)
}

///|
test "dfs_basic" {
  let g = Graph::new(4)
  let g1 = g.add_edge_unweighted(0, 1)
  let g2 = g1.add_edge_unweighted(1, 2)
  let result = dfs(g2, 0)
  assert_eq(result.visited[0], true)
}
