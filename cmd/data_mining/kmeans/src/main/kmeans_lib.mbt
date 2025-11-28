// K-Means 实现，用来做颜色聚类

// RGB 颜色

///|
pub struct RgbaColor {
  r : Int
  g : Int
  b : Int
} derive(Show)

// 图片结构

///|
pub struct Image {
  pixels : Array[RgbaColor]
  width : Int
  height : Int
} derive(Show)

// 随机数生成器（LCG）

///|
priv struct RandomState {
  seed : Int
}

// 生成下一个随机数

///|
fn next_random(state : RandomState) -> (RandomState, Int) {
  // LCG 算法，参数随便选的
  let new_seed = (1103515245 * state.seed + 12345) & 0x7FFFFFFF
  (RandomState::{ seed: new_seed }, new_seed)
}

// 生成 [0, max) 的随机数

///|
fn random_int(state : RandomState, max : Int) -> (RandomState, Int) {
  let (new_state, rand_val) = next_random(state)
  (new_state, rand_val % max)
}

// 平方根（牛顿法，精度够用就行）

///|
fn sqrt(value : Double) -> Double {
  if value <= 0.0 {
    return 0.0
  }
  let mut x = value
  let mut prev = 0.0
  let mut i = 0
  while (x - prev).abs() > 0.0001 && i < 100 {
    prev = x
    x = (x + value / x) / 2.0
    i = i + 1
  }
  x
}

// 计算两个颜色的距离

///|
pub fn RgbaColor::calc_dist(self : RgbaColor, other : RgbaColor) -> Double {
  let dr = (self.r - other.r).to_double()
  let dg = (self.g - other.g).to_double()
  let db = (self.b - other.b).to_double()
  sqrt(dr * dr + dg * dg + db * db)
}

// 随机选 k 个像素当初始质心

///|
pub fn Image::init_centroids(
  self : Image,
  k : Int,
  seed : Int,
) -> Array[RgbaColor] {
  let total = self.width * self.height
  if total == 0 || k <= 0 {
    return []
  }
  let centroids = []
  let state = RandomState::{ seed, }
  let used_indices = []
  let (final_centroids, _, _) = init_centroids_iter(
    self, k, total, state, centroids, used_indices, 0,
  )
  final_centroids
}

// 初始化质心的辅助函数

///|
fn init_centroids_iter(
  image : Image,
  k : Int,
  total : Int,
  state : RandomState,
  centroids : Array[RgbaColor],
  used_indices : Array[Int],
  i : Int,
) -> (Array[RgbaColor], RandomState, Array[Int]) {
  if i >= k || i >= total {
    return (centroids, state, used_indices)
  }
  let (new_state, rand_idx) = random_int(state, total)
  let pixel = image.pixels[rand_idx]
  let new_centroids = [..centroids, pixel]
  let new_used_indices = [..used_indices, rand_idx]
  init_centroids_iter(
    image,
    k,
    total,
    new_state,
    new_centroids,
    new_used_indices,
    i + 1,
  )
}

// K-Means 主算法，返回 k 个质心

///|
pub fn Image::kmeans(
  self : Image,
  k : Int,
  max_iter : Int,
  threshold : Double,
  seed : Int,
) -> Array[RgbaColor] {
  let total = self.width * self.height
  if total == 0 || k <= 0 {
    return []
  }
  let mut centroids = Image::init_centroids(self, k, seed)
  if centroids.length() == 0 {
    return []
  }

  // 用来累加 RGB 和计数
  let mut sum_r = []
  let mut sum_g = []
  let mut sum_b = []
  let mut cluster_sizes = []
  let mut labels = []

  // 初始化数组
  for i = 0; i < k; i = i + 1 {
    sum_r.push(0) |> ignore
    sum_g.push(0) |> ignore
    sum_b.push(0) |> ignore
    cluster_sizes.push(0) |> ignore
  }
  for i = 0; i < total; i = i + 1 {
    labels.push(0) |> ignore
  }
  let mut iter = 0
  while iter < max_iter {
    // 清空累加器
    for i = 0; i < k; i = i + 1 {
      sum_r = update_array(sum_r, i, 0)
      sum_g = update_array(sum_g, i, 0)
      sum_b = update_array(sum_b, i, 0)
      cluster_sizes = update_array(cluster_sizes, i, 0)
    }

    // 分配每个像素到最近的质心
    let mut settled = true
    for i = 0; i < total; i = i + 1 {
      let p = self.pixels[i]
      let mut min_dist = 1.0e30
      let mut best = 0
      for c = 0; c < k; c = c + 1 {
        let dist = RgbaColor::calc_dist(p, centroids[c])
        if dist < min_dist {
          min_dist = dist
          best = c
        }
      }
      labels = update_array(labels, i, best)
      sum_r = update_array(sum_r, best, sum_r[best] + p.r)
      sum_g = update_array(sum_g, best, sum_g[best] + p.g)
      sum_b = update_array(sum_b, best, sum_b[best] + p.b)
      cluster_sizes = update_array(cluster_sizes, best, cluster_sizes[best] + 1)
    }

    // 更新质心（求平均）
    for c = 0; c < k; c = c + 1 {
      if cluster_sizes[c] == 0 {
        // 空簇，重新随机选一个
        let state = RandomState::{ seed: seed + iter * 1000 + c }
        let (_, rand_idx) = random_int(state, total)
        centroids = update_array(centroids, c, self.pixels[rand_idx])
        continue
      }
      let old = centroids[c]
      let new_r = sum_r[c] / cluster_sizes[c]
      let new_g = sum_g[c] / cluster_sizes[c]
      let new_b = sum_b[c] / cluster_sizes[c]
      let new_centroid = RgbaColor::{ r: new_r, g: new_g, b: new_b }
      centroids = update_array(centroids, c, new_centroid)
      if RgbaColor::calc_dist(old, new_centroid) > threshold {
        settled = false
      }
    }
    if settled {
      break
    }
    iter = iter + 1
  }
  centroids
}

// 更新数组元素（MoonBit 没有直接修改，只能重建）

///|
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

// 把每个像素替换成最近的质心颜色

///|
fn kmeans_assign_pixels(
  image : Image,
  centroids : Array[RgbaColor],
  total : Int,
  i : Int,
  compressed_pixels : Array[RgbaColor],
) -> Array[RgbaColor] {
  if i >= total {
    return compressed_pixels
  }
  let pixel = image.pixels[i]
  let mut min_dist = 1.0e30
  let mut best = 0
  for c = 0; c < centroids.length(); c = c + 1 {
    let dist = RgbaColor::calc_dist(pixel, centroids[c])
    if dist < min_dist {
      min_dist = dist
      best = c
    }
  }
  let new_pixels = [..compressed_pixels, centroids[best]]
  kmeans_assign_pixels(image, centroids, total, i + 1, new_pixels)
}

// K-Means + 生成压缩图片，返回 (压缩图片, 质心)

///|
pub fn Image::kmeans_with_compression(
  self : Image,
  k : Int,
  max_iter : Int,
  threshold : Double,
  seed : Int,
) -> (Image, Array[RgbaColor]) {
  let total = self.width * self.height
  if total == 0 || k <= 0 {
    return (Image::{ pixels: [], width: 0, height: 0 }, [])
  }
  let centroids = Image::kmeans(self, k, max_iter, threshold, seed)
  if centroids.length() == 0 {
    return (Image::{ pixels: [], width: 0, height: 0 }, [])
  }

  // 用质心颜色替换每个像素
  let compressed_pixels = kmeans_assign_pixels(self, centroids, total, 0, [])
  let compressed = Image::{
    pixels: compressed_pixels,
    width: self.width,
    height: self.height,
  }
  (compressed, centroids)
}
