///| K-Means 聚类算法主程序
///|
///| 演示 K-Means 算法的使用
///|
///| 使用 run.sh 脚本运行程序并传递参数：
///|   ./run.sh -k 8 -v              # 使用 8 种颜色，显示详细信息
///|   ./run.sh -k 3 -m 50           # 使用 3 种颜色，最大迭代 50 次
///|   ./run.sh -k 5 -z 32           # 使用 5 种颜色，图像大小限制为 32x32
///|   ./run.sh -k 10 -z 128 -v      # 使用 10 种颜色，图像大小 128x128，显示详细信息

/// 主函数
fn main {
  // 从参数配置文件读取参数（由 run.sh 自动生成）
  // 如果 params.mbt 不存在，使用默认值
  let k = get_k()
  let max_iter = get_max_iter()
  let threshold = get_threshold()
  let seed = get_seed()
  let verbose = get_verbose()
  let input_path = ""

  if verbose {
    println("=== K-Means 颜色聚类 ===")
    println("聚类数量 K: " + k.to_string())
    println("最大迭代次数: " + max_iter.to_string())
    println("收敛阈值: " + threshold.to_string())
    println("随机种子: " + seed.to_string())
  }

  // 自动检测是否加载了转换后的图像数据
  // 如果用户指定了输入路径，我们只是打印提示（因为实际加载是通过预编译完成的）
  // 但如果目标文件存在，我们直接使用转换后的 get_parsed_image
  let image = if input_path != "" {
    println("注意: 目前通过预处理加载图像，输入路径参数仅作参考。")
    println("正在使用预转换的图像数据...")
    get_parsed_image()
  } else {
    // 默认使用预转换的图像，如果用户没有指定，我们也优先使用刚才转换的图像
    // 因为用户意图是"parse this"
    get_parsed_image()
  }
  
  if verbose {
    println(
      "图像大小: " +
      image.width.to_string() +
      " x " +
      image.height.to_string(),
    )
    println("")
  }

  // 运行 K-Means 算法
  println("开始运行 K-Means 算法...")
  let centroids = Image::kmeans(image, k, max_iter, threshold, seed)

  // 输出结果
  println("")
  println("提取的主颜色（质心）:")
  for i = 0; i < centroids.length(); i = i + 1 {
    let color = centroids[i]
    println(
      "  颜色 " +
      (i + 1).to_string() +
      ": RGB(" +
      color.r.to_string() +
      ", " +
      color.g.to_string() +
      ", " +
      color.b.to_string() +
      ")",
    )
  }

  // 运行带压缩的版本
  println("")
  println("运行带压缩的 K-Means...")
  let (_compressed, compressed_centroids) = Image::kmeans_with_compression(
    image, k, max_iter, threshold, seed,
  )
  
  if verbose {
    println("压缩完成")
    println("压缩后的图像尺寸: " + _compressed.width.to_string() + "x" + _compressed.height.to_string())
  }

  // 打印压缩后的图像
  println("")
  print_image_terminal(_compressed)
  
  // 简单的 ANSI 颜色输出展示
  println("")
  println("主颜色预览:")
  for i = 0; i < compressed_centroids.length(); i = i + 1 {
    let c = compressed_centroids[i]
    // ANSI escape code for background color: \x1b[48;2;R;G;Bm
    let ansi_color = "\u001b[48;2;" + c.r.to_string() + ";" + c.g.to_string() + ";" + c.b.to_string() + "m"
    println(ansi_color + "    " + "\u001b[0m " + "RGB(" + c.r.to_string() + ", " + c.g.to_string() + ", " + c.b.to_string() + ")")
  }

  println("")
  println("完成！")
}

///|
/// 在终端打印图像预览
fn print_image_terminal(image: Image) -> Unit {
  println("压缩图像预览 (" + image.width.to_string() + "x" + image.height.to_string() + "):")
  for y = 0; y < image.height; y = y + 1 {
    let mut line = ""
    for x = 0; x < image.width; x = x + 1 {
      let idx = y * image.width + x
      if idx < image.pixels.length() {
        let pixel = image.pixels[idx]
        // ANSI background color: \u001b[48;2;R;G;Bm
        // 使用两个空格表示一个像素点
        let ansi = "\u001b[48;2;" + pixel.r.to_string() + ";" + pixel.g.to_string() + ";" + pixel.b.to_string() + "m  \u001b[0m"
        line = line + ansi
      }
    }
    println(line)
  }
}

///|
/// 获取测试图像 (保留作为备用，但不再默认使用)
fn get_test_image() -> Image {
  let pixels = [
    RgbaColor::{ r: 255, g: 0, b: 0 },
    RgbaColor::{ r: 250, g: 5, b: 5 },
    RgbaColor::{ r: 245, g: 10, b: 10 },
    RgbaColor::{ r: 0, g: 255, b: 0 },
    RgbaColor::{ r: 5, g: 250, b: 5 },
    RgbaColor::{ r: 10, g: 245, b: 10 },
    RgbaColor::{ r: 0, g: 0, b: 255 },
    RgbaColor::{ r: 5, g: 5, b: 250 },
    RgbaColor::{ r: 10, g: 10, b: 245 },
    RgbaColor::{ r: 255, g: 255, b: 0 },
    RgbaColor::{ r: 250, g: 250, b: 5 },
    RgbaColor::{ r: 245, g: 245, b: 10 },
  ]
  Image::{ pixels, width: 4, height: 3 }
}
