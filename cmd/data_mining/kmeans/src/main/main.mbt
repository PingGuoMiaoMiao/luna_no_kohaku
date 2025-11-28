// K-Means 颜色聚类，从图片里提取主色调
// 用 run.sh 运行，比如: ./run.sh -k 5 -v

fn main {
  // 从 run.sh 生成的 params.mbt 读参数
  let k = get_k()
  let max_iter = get_max_iter()
  let threshold = get_threshold()
  let seed = get_seed()
  let verbose = get_verbose()

  if verbose {
    println("=== K-Means 颜色聚类 ===")
    println("聚类数量 K: " + k.to_string())
    println("最大迭代次数: " + max_iter.to_string())
    println("收敛阈值: " + threshold.to_string())
    println("随机种子: " + seed.to_string())
  }

  // 直接用转换好的图片数据（convert_image.py 生成的）
  let image = get_parsed_image()
  
  if verbose {
    println(
      "图像大小: " +
      image.width.to_string() +
      " x " +
      image.height.to_string(),
    )
    println("")
  }

  println("开始运行 K-Means...")
  let centroids = Image::kmeans(image, k, max_iter, threshold, seed)

  println("")
  println("提取的主颜色:")
  for i = 0; i < centroids.length(); i = i + 1 {
    let c = centroids[i]
    println("  颜色 " + (i + 1).to_string() + ": RGB(" + c.r.to_string() + ", " + c.g.to_string() + ", " + c.b.to_string() + ")")
  }

  println("")
  println("生成压缩图片...")
  let (compressed_img, compressed_centroids) = Image::kmeans_with_compression(
    image, k, max_iter, threshold, seed,
  )
  
  if verbose {
    println("压缩完成，尺寸: " + compressed_img.width.to_string() + "x" + compressed_img.height.to_string())
  }

  println("")
  print_image_terminal(compressed_img)
  
  println("")
  println("主颜色预览:")
  for i = 0; i < compressed_centroids.length(); i = i + 1 {
    let c = compressed_centroids[i]
    // ANSI 颜色码
    let ansi = "\u001b[48;2;" + c.r.to_string() + ";" + c.g.to_string() + ";" + c.b.to_string() + "m"
    println(ansi + "    " + "\u001b[0m " + "RGB(" + c.r.to_string() + ", " + c.g.to_string() + ", " + c.b.to_string() + ")")
  }

  println("")
  println("完成！")
}

// 在终端打印彩色图片预览
fn print_image_terminal(image: Image) -> Unit {
  println("压缩图像预览 (" + image.width.to_string() + "x" + image.height.to_string() + "):")
  for y = 0; y < image.height; y = y + 1 {
    let mut line = ""
    for x = 0; x < image.width; x = x + 1 {
      let idx = y * image.width + x
      if idx < image.pixels.length() {
        let p = image.pixels[idx]
        // ANSI 背景色，两个空格当像素
        let ansi = "\u001b[48;2;" + p.r.to_string() + ";" + p.g.to_string() + ";" + p.b.to_string() + "m  \u001b[0m"
        line = line + ansi
      }
    }
    println(line)
  }
}

