#!/bin/bash
# 下载 Tiny-Vicuna-1B 模型的脚本

set -e

cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 尝试激活 llm_rg4 conda 环境（如果存在）
if [ -f "/home/user8/miniconda3/etc/profile.d/conda.sh" ]; then
    source /home/user8/miniconda3/etc/profile.d/conda.sh
    if conda env list | grep -q "llm_rg4"; then
        conda activate llm_rg4 2>/dev/null || true
    fi
fi

MODEL_DIR="./hf/Tiny-Vicuna-1B"

echo "=========================================="
echo "Tiny-Vicuna-1B 模型下载脚本"
echo "=========================================="
echo ""

# 检查是否已存在
if [ -d "$MODEL_DIR" ] && [ "$(ls -A $MODEL_DIR 2>/dev/null)" ]; then
    echo "⚠️  警告: 模型目录已存在且不为空: $MODEL_DIR"
    echo ""
    echo "目录内容："
    ls -lh "$MODEL_DIR" | head -5
    echo ""
    read -p "是否继续下载（将覆盖现有文件）? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "下载已取消"
        exit 0
    fi
fi

# 创建目录
mkdir -p "$MODEL_DIR"

echo "请选择下载方式："
echo "1. 从 Hugging Face 下载 Tiny-Vicuna-1B（需要模型ID）"
echo "2. 创建符号链接到现有的 TinyLlama-1.1B 模型（快速，但需要确认兼容性）"
echo ""
read -p "请选择 (1/2): " choice

case $choice in
    1)
        echo ""
        echo "请输入 Hugging Face 上的模型ID"
        echo "示例: PhengXuan/Tiny-Vicuna-1B 或其他正确的模型ID"
        read -p "模型ID: " MODEL_ID
        
        if [ -z "$MODEL_ID" ]; then
            echo "错误: 未输入模型ID"
            exit 1
        fi
        
        echo ""
        echo "开始下载模型: $MODEL_ID"
        echo "目标目录: $MODEL_DIR"
        echo ""
        
        # 检查是否安装了 huggingface_hub
        HF_CLI_CMD=""
        if command -v huggingface-cli &> /dev/null; then
            HF_CLI_CMD="huggingface-cli"
        elif python -c "import huggingface_hub" 2>/dev/null; then
            # 使用 Python 模块方式
            HF_CLI_CMD="python -m huggingface_hub.commands.huggingface_cli"
        else
            echo "⚠️  未找到 huggingface-cli 和 huggingface_hub，尝试安装..."
            pip install huggingface_hub
            if command -v huggingface-cli &> /dev/null; then
                HF_CLI_CMD="huggingface-cli"
            elif python -c "import huggingface_hub" 2>/dev/null; then
                HF_CLI_CMD="python -m huggingface_hub.commands.huggingface_cli"
            else
                echo "❌ 安装失败，请手动安装: pip install huggingface_hub"
                exit 1
            fi
        fi
        
        echo "使用命令: $HF_CLI_CMD"
        echo ""
        
        # 尝试使用命令行工具下载
        if [ -n "$HF_CLI_CMD" ]; then
            $HF_CLI_CMD download "$MODEL_ID" \
                --local-dir "$MODEL_DIR" \
                --local-dir-use-symlinks False
            
            if [ $? -eq 0 ]; then
                echo ""
                echo "✅ 下载完成！"
            else
                echo ""
                echo "⚠️  命令行下载失败，尝试使用 Python 方式..."
                # 使用 Python 脚本作为备选方案
                python3 << EOF
from huggingface_hub import snapshot_download
import os

model_id = "$MODEL_ID"
local_dir = "$MODEL_DIR"

print(f"使用 Python 方式下载 {model_id}...")
try:
    snapshot_download(
        repo_id=model_id,
        local_dir=local_dir,
        local_dir_use_symlinks=False
    )
    print("✅ 下载完成！")
except Exception as e:
    print(f"❌ 下载失败: {e}")
    exit(1)
EOF
                if [ $? -ne 0 ]; then
                    echo ""
                    echo "❌ 下载失败，请检查："
                    echo "  1. 模型ID是否正确: $MODEL_ID"
                    echo "  2. 网络连接是否正常"
                    echo "  3. 是否需要登录 Hugging Face: huggingface-cli login"
                    echo "  4. 磁盘空间是否足够（需要 2-3GB）"
                    exit 1
                fi
            fi
        fi
        ;;
    2)
        SOURCE_MODEL="/mnt/nvme_disk/user8_data/model_weights/TinyLlama-1.1B-Chat-v1.0"
        
        if [ ! -d "$SOURCE_MODEL" ]; then
            echo "错误: 找不到源模型目录: $SOURCE_MODEL"
            exit 1
        fi
        
        echo ""
        echo "源模型位置: $SOURCE_MODEL"
        echo "将创建符号链接到: $MODEL_DIR"
        echo ""
        echo "⚠️  注意: TinyLlama 和 Tiny-Vicuna 可能不完全兼容"
        echo "如果训练时出现错误，请下载真正的 Tiny-Vicuna-1B 模型"
        echo ""
        read -p "是否继续? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "操作已取消"
            exit 0
        fi
        
        # 如果目标已存在，先删除
        if [ -e "$MODEL_DIR" ]; then
            rm -rf "$MODEL_DIR"
        fi
        
        # 创建符号链接
        ln -s "$SOURCE_MODEL" "$MODEL_DIR"
        
        echo "✅ 符号链接创建成功！"
        ;;
    *)
        echo "错误: 无效的选择"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "验证下载/链接结果"
echo "=========================================="
echo ""

if [ -L "$MODEL_DIR" ]; then
    echo "✓ 这是一个符号链接"
    echo "链接目标: $(readlink -f $MODEL_DIR)"
elif [ -d "$MODEL_DIR" ]; then
    echo "✓ 这是一个目录"
fi

echo ""
echo "目录内容："
ls -lh "$MODEL_DIR" | head -10

echo ""
echo "检查关键文件："
for file in config.json tokenizer.json tokenizer.model pytorch_model.bin model.safetensors; do
    if [ -f "$MODEL_DIR/$file" ] || [ -L "$MODEL_DIR/$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (未找到)"
    fi
done

echo ""
echo "=========================================="
echo "完成！"
echo "=========================================="
echo ""
echo "模型位置: $MODEL_DIR"
echo ""
echo "下一步："
echo "1. 验证训练脚本中的路径是否正确: ./hf/Tiny-Vicuna-1B"
echo "2. 进行小规模测试运行"
echo "3. 开始正式训练"



