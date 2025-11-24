from PIL import Image
import sys
import os

def convert_image(image_path, output_path, max_dim=64):
    try:
        if not os.path.exists(image_path):
            print(f"Error: File not found {image_path}")
            return

        img = Image.open(image_path)
        img = img.convert('RGB')
        
        # Resize for terminal display and performance
        # Default max_dim is 64 to ensure it fits in terminal and compiles quickly
        ratio = min(max_dim / img.width, max_dim / img.height)
        if ratio < 1:
            new_size = (int(img.width * ratio), int(img.height * ratio))
            img = img.resize(new_size)
            print(f"Resized image to {new_size[0]}x{new_size[1]} (max dimension: {max_dim})")
        else:
            print(f"Image size: {img.width}x{img.height} (no resize needed)")
        
        width, height = img.size
        pixels = list(img.getdata())
        
        with open(output_path, 'w') as f:
            f.write('///| Generated image data from ' + os.path.basename(image_path) + '\n')
            f.write('fn get_parsed_image() -> Image {\n')
            f.write(f'  let width = {width}\n')
            f.write(f'  let height = {height}\n')
            f.write('  let pixels = [\n')
            
            for r, g, b in pixels:
                f.write(f'    RgbaColor::{{ r: {r}, g: {g}, b: {b} }},\n')
                
            f.write('  ]\n')
            f.write('  Image::{ pixels, width, height }\n')
            f.write('}\n')
            
        print(f"Successfully converted {image_path} to {output_path}")
        
    except ImportError:
        print("Error: PIL (Pillow) module not found. Please install it with: pip install Pillow")
    except Exception as e:
        print(f"Error converting image: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 convert_image.py <input_image> <output_mbt> [max_dim]")
        print("  max_dim: Maximum dimension for resizing (default: 64)")
    else:
        max_dim = 64
        if len(sys.argv) >= 4:
            try:
                max_dim = int(sys.argv[3])
            except ValueError:
                print(f"Warning: Invalid max_dim '{sys.argv[3]}', using default 64")
        convert_image(sys.argv[1], sys.argv[2], max_dim)

