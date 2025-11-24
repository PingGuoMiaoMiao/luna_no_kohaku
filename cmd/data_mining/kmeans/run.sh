#!/bin/bash
# K-Means 聚类程序运行脚本
# 用法: ./run.sh [选项]
#
# 选项:
#   -k, --clusters N        颜色聚类数量 (默认: 5)
#   -m, --max_iter N        最大迭代次数 (默认: 30)
#   -t, --threshold N      收敛阈值 (默认: 1.0)
#   -s, --seed N            随机种子 (默认: 12345)
#   -z, --size N            图像最大尺寸（像素，默认: 64）
#   -v, --verbose           显示详细信息
#   -h, --help              显示帮助信息

# 默认参数
K=5
MAX_ITER=30
THRESHOLD=1.0
SEED=12345
IMAGE_SIZE=64
VERBOSE=false

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -k|--clusters)
            K="$2"
            shift 2
            ;;
        -m|--max_iter)
            MAX_ITER="$2"
            shift 2
            ;;
        -t|--threshold)
            THRESHOLD="$2"
            shift 2
            ;;
        -s|--seed)
            SEED="$2"
            shift 2
            ;;
        -z|--size)
            IMAGE_SIZE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "K-Means 颜色聚类程序"
            echo ""
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  -k, --clusters N        颜色聚类数量 (默认: 5)"
            echo "  -m, --max_iter N        最大迭代次数 (默认: 30)"
            echo "  -t, --threshold N      收敛阈值 (默认: 1.0)"
            echo "  -s, --seed N            随机种子 (默认: 12345)"
            echo "  -z, --size N            图像最大尺寸（像素，默认: 64）"
            echo "  -v, --verbose           显示详细信息"
            echo "  -h, --help              显示帮助信息"
            echo ""
            echo "示例:"
            echo "  $0 -k 8 -v              # 使用 8 种颜色，显示详细信息"
            echo "  $0 -k 3 -m 50           # 使用 3 种颜色，最大迭代 50 次"
            echo "  $0 -k 5 -z 32           # 使用 5 种颜色，图像大小限制为 32x32"
            echo "  $0 -k 10 -z 128 -v      # 使用 10 种颜色，图像大小 128x128，显示详细信息"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            echo "使用 -h 或 --help 查看帮助信息"
            exit 1
            ;;
    esac
done

# 获取脚本所在目录和项目根目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
KMEANS_DIR="$SCRIPT_DIR"

# 切换到脚本所在目录进行图像转换
cd "$KMEANS_DIR"

# 检查图像文件是否存在
IMAGE_FILE="images/G0gK2OobkAAQOCw.jpeg"
TARGET_IMAGE="src/main/target_image.mbt"

# 如果图像文件存在，根据参数重新转换图像
if [ -f "$IMAGE_FILE" ]; then
    if [ "$VERBOSE" = true ]; then
        echo "正在转换图像，最大尺寸: ${IMAGE_SIZE}x${IMAGE_SIZE}..."
    fi
    python3 convert_image.py "$IMAGE_FILE" "$TARGET_IMAGE" "$IMAGE_SIZE"
    if [ $? -ne 0 ]; then
        echo "警告: 图像转换失败，将使用现有的图像数据（如果存在）"
    fi
else
    if [ "$VERBOSE" = true ]; then
        echo "图像文件不存在: $IMAGE_FILE，将使用现有的图像数据（如果存在）"
    fi
fi

# 生成参数配置文件
cat > src/main/params.mbt <<EOF
///| 运行时参数配置（由 run.sh 自动生成）
///| 不要手动编辑此文件

pub fn get_k() -> Int { $K }
pub fn get_max_iter() -> Int { $MAX_ITER }
pub fn get_threshold() -> Double { $THRESHOLD }
pub fn get_seed() -> Int { $SEED }
pub fn get_verbose() -> Bool { $VERBOSE }
EOF

# 切换到项目根目录运行 MoonBit 程序
cd "$PROJECT_ROOT"
moon run cmd/data_mining/kmeans/src/main
