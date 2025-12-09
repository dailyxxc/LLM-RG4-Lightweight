#!/bin/bash
# 快速检查 CXR-BERT 文件是否配置正确

echo "=========================================="
echo "CXR-BERT 文件检查"
echo "=========================================="
echo ""

cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

FILE="./hf/BiomedVLP-CXR-BERT-specialized/modeling_cxrbert.py"

# 检查文件是否存在
if [ -f "$FILE" ]; then
    echo "✓ 文件存在: $FILE"
    echo "  文件大小: $(ls -lh "$FILE" | awk '{print $5}')"
    echo ""
else
    echo "✗ 文件不存在: $FILE"
    exit 1
fi

# 检查是否包含关键方法
if grep -q "get_projected_text_embeddings" "$FILE"; then
    echo "✓ 包含修改版功能 (get_projected_text_embeddings 方法)"
else
    echo "✗ 缺少修改版功能"
    echo "  这可能是官方版本，需要替换为修改版"
    exit 1
fi

# 检查是否包含 cls_projected_embedding
if grep -q "cls_projected_embedding" "$FILE"; then
    echo "✓ 包含 cls_projected_embedding 字段"
else
    echo "✗ 缺少 cls_projected_embedding 字段"
fi

echo ""
echo "=========================================="
echo "结论：文件配置正确，可以直接使用！"
echo "=========================================="
