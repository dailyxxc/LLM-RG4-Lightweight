#!/bin/bash
# 快速检查 Transformers 库是否已正确修改

echo "=========================================="
echo "Transformers 库修改检查"
echo "=========================================="
echo ""

# 查找 transformers 库路径
TRANSFORMERS_PATH=$(python3 -c "import transformers; import os; print(os.path.dirname(transformers.__file__))" 2>/dev/null)

if [ -z "$TRANSFORMERS_PATH" ]; then
    echo "❌ 错误: 无法找到 transformers 库"
    echo "请确保已安装 transformers: pip install transformers"
    exit 1
fi

echo "✓ Transformers 库路径: $TRANSFORMERS_PATH"
echo ""

LLAMA_FILE="${TRANSFORMERS_PATH}/models/llama/modeling_llama.py"

if [ ! -f "$LLAMA_FILE" ]; then
    echo "❌ 错误: 找不到文件 $LLAMA_FILE"
    exit 1
fi

echo "✓ 目标文件: $LLAMA_FILE"
echo ""

# 检查是否已修改
echo "检查修改状态..."
echo ""

if grep -q "loss_fct.*CrossEntropyLoss.*reduction='none'" "$LLAMA_FILE"; then
    echo "✅ 代码已经正确修改！"
    echo ""
    echo "已修改的行："
    grep -n "reduction='none'" "$LLAMA_FILE"
    echo ""
    echo "=========================================="
    echo "结论：无需任何操作，可以直接开始训练！"
    echo "=========================================="
    exit 0
else
    echo "⚠️ 代码尚未修改"
    echo ""
    echo "需要修改的行："
    grep -n "loss_fct.*CrossEntropyLoss()" "$LLAMA_FILE" | grep -v "reduction"
    echo ""
    echo "请参考: docs/Transformers手动修改步骤指南.md"
    exit 1
fi
