from PIL import Image
import sys
import os

def convert_image(image_path, output_path, max_dim=64):
    try:
        if not os.path.exists(image_path):
            print(f"Error: 找不到文件 {image_path}")
            return

        img = Image.open(image_path)
        img = img.convert('RGB')
        
        # 缩小图片，方便终端显示和编译
        ratio = min(max_dim / img.width, max_dim / img.height)
        if ratio < 1:
            new_size = (int(img.width * ratio), int(img.height * ratio))
            img = img.resize(new_size)
            print(f"缩小到 {new_size[0]}x{new_size[1]} (最大尺寸: {max_dim})")
        else:
            print(f"图片尺寸: {img.width}x{img.height} (不需要缩小)")
        
        width, height = img.size
        pixels = list(img.getdata())
        
        with open(output_path, 'w') as f:
            f.write('// 从 ' + os.path.basename(image_path) + ' 生成的图片数据\n')
            f.write('fn get_parsed_image() -> Image {\n')
            f.write(f'  let width = {width}\n')
            f.write(f'  let height = {height}\n')
            f.write('  let pixels = [\n')
            
            for r, g, b in pixels:
                f.write(f'    RgbaColor::{{ r: {r}, g: {g}, b: {b} }},\n')
                
            f.write('  ]\n')
            f.write('  Image::{ pixels, width, height }\n')
            f.write('}\n')
            
        print(f"转换完成: {image_path} -> {output_path}")
        
    except ImportError:
        print("Error: 需要安装 Pillow，运行: pip install Pillow")
    except Exception as e:
        print(f"转换出错: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("用法: python3 convert_image.py <输入图片> <输出文件> [最大尺寸]")
        print("  最大尺寸默认 64")
    else:
        max_dim = 64
        if len(sys.argv) >= 4:
            try:
                max_dim = int(sys.argv[3])
            except ValueError:
                print(f"警告: 无效的尺寸 '{sys.argv[3]}'，用默认值 64")
        convert_image(sys.argv[1], sys.argv[2], max_dim)

