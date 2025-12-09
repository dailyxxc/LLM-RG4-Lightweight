#!/bin/bash
# 模型代码修改自动化脚本
# 用于修改 CXR-BERT 和 Transformers 库的代码

set -e  # 遇到错误立即退出

echo "=========================================="
echo "模型代码修改自动化脚本"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="/mnt/nvme_disk/user8_data/BN5212-final-VLMR"
cd "$PROJECT_ROOT"

echo -e "${GREEN}[步骤 1/3] 修改 CXR-BERT 模型代码${NC}"
echo "----------------------------------------"

CXRBERT_FILE="./hf/BiomedVLP-CXR-BERT-specialized/modeling_cxrbert.py"
CXRBERT_SOURCE="../LLM-RG4/hf/BiomedVLP-CXR-BERT-specialized/modeling_cxrbert.py"

if [ ! -f "$CXRBERT_FILE" ]; then
    echo -e "${RED}错误: 找不到目标文件 $CXRBERT_FILE${NC}"
    exit 1
fi

# 检查源文件是否存在
if [ -f "$CXRBERT_SOURCE" ]; then
    echo "找到源文件: $CXRBERT_SOURCE"
    
    # 比较文件是否相同
    if diff -q "$CXRBERT_FILE" "$CXRBERT_SOURCE" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 文件已是最新版本，无需修改${NC}"
    else
        # 备份原文件
        if [ ! -f "${CXRBERT_FILE}.backup" ]; then
            cp "$CXRBERT_FILE" "${CXRBERT_FILE}.backup"
            echo "✓ 已备份原文件"
        fi
        
        # 复制新文件
        cp "$CXRBERT_SOURCE" "$CXRBERT_FILE"
        echo -e "${GREEN}✓ 已替换为项目提供的版本${NC}"
    fi
else
    echo -e "${YELLOW}警告: 源文件 $CXRBERT_SOURCE 不存在${NC}"
    echo "检查当前文件是否已包含必要的修改..."
    
    # 检查文件是否包含关键方法
    if grep -q "get_projected_text_embeddings" "$CXRBERT_FILE"; then
        echo -e "${GREEN}✓ 文件已包含必要的修改${NC}"
    else
        echo -e "${RED}错误: 文件缺少必要的修改${NC}"
        echo "请手动复制正确的 modeling_cxrbert.py 文件"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}[步骤 2/3] 修改 Transformers 库代码${NC}"
echo "----------------------------------------"

# 查找 transformers 库位置
echo "正在查找 transformers 库位置..."

TRANSFORMERS_PATH=$(python3 -c "import transformers; import os; print(os.path.dirname(transformers.__file__))" 2>/dev/null)

if [ -z "$TRANSFORMERS_PATH" ]; then
    echo -e "${RED}错误: 无法找到 transformers 库${NC}"
    echo "请确保已安装 transformers 库: pip install transformers"
    exit 1
fi

echo "找到 transformers 库: $TRANSFORMERS_PATH"

LLAMA_FILE="${TRANSFORMERS_PATH}/models/llama/modeling_llama.py"

if [ ! -f "$LLAMA_FILE" ]; then
    echo -e "${RED}错误: 找不到文件 $LLAMA_FILE${NC}"
    exit 1
fi

echo "目标文件: $LLAMA_FILE"

# 检查是否已经修改过
if grep -q "loss_fct = nn.CrossEntropyLoss(reduction='none')" "$LLAMA_FILE"; then
    echo -e "${GREEN}✓ 文件已包含修改，无需重复修改${NC}"
elif grep -q "loss_fct.*CrossEntropyLoss.*reduction='none'" "$LLAMA_FILE"; then
    echo -e "${GREEN}✓ 文件已包含修改（不同格式），无需重复修改${NC}"
else
    # 备份原文件
    if [ ! -f "${LLAMA_FILE}.backup" ]; then
        cp "$LLAMA_FILE" "${LLAMA_FILE}.backup"
        echo "✓ 已备份原文件到 ${LLAMA_FILE}.backup"
    else
        echo "✓ 备份文件已存在，跳过备份"
    fi
    
    # 查找需要修改的行
    echo "正在查找需要修改的代码行..."
    
    # 尝试多种可能的代码格式
    LINE_NUM=$(grep -n "loss_fct = CrossEntropyLoss()" "$LLAMA_FILE" 2>/dev/null | head -1 | cut -d: -f1)
    
    if [ -z "$LINE_NUM" ]; then
        LINE_NUM=$(grep -n "loss_fct = nn.CrossEntropyLoss()" "$LLAMA_FILE" 2>/dev/null | head -1 | cut -d: -f1)
    fi
    
    if [ -z "$LINE_NUM" ]; then
        # 尝试更宽泛的搜索
        LINE_NUM=$(grep -n -A2 -B2 "CrossEntropyLoss()" "$LLAMA_FILE" 2>/dev/null | grep "loss_fct" | head -1 | cut -d: -f1 || echo "")
    fi
    
    if [ -z "$LINE_NUM" ]; then
        echo -e "${RED}错误: 无法自动找到需要修改的代码行${NC}"
        echo ""
        echo "请手动查找并修改以下内容："
        echo "  查找: loss_fct = CrossEntropyLoss()"
        echo "  或:   loss_fct = nn.CrossEntropyLoss()"
        echo "  替换为: loss_fct = nn.CrossEntropyLoss(reduction='none')"
        echo ""
        echo "相关代码行（前5行和后5行）："
        grep -n -A5 -B5 "CrossEntropyLoss()" "$LLAMA_FILE" | head -20 || echo "未找到相关内容"
        exit 1
    fi
    
    echo "找到需要修改的行：第 $LINE_NUM 行"
    
    # 显示修改前的代码（前后各3行）
    echo ""
    echo "修改前的代码（第 $((LINE_NUM-3)) 到 $((LINE_NUM+3)) 行）："
    sed -n "$((LINE_NUM-3)),$((LINE_NUM+3))p" "$LLAMA_FILE" | cat -n
    
    # 执行替换
    sed -i "${LINE_NUM}s/.*CrossEntropyLoss()/    loss_fct = nn.CrossEntropyLoss(reduction='none')/" "$LLAMA_FILE"
    
    # 如果上面的替换失败，尝试更精确的替换
    if ! grep -q "reduction='none'" "$LLAMA_FILE"; then
        # 尝试保留原有缩进
        ORIGINAL_LINE=$(sed -n "${LINE_NUM}p" "$LLAMA_FILE")
        INDENT=$(echo "$ORIGINAL_LINE" | sed 's/[^ ].*//')
        sed -i "${LINE_NUM}s/.*/&${INDENT}loss_fct = nn.CrossEntropyLoss(reduction='none')/" "$LLAMA_FILE"
    fi
    
    # 验证修改
    if grep -q "reduction='none'" "$LLAMA_FILE"; then
        echo ""
        echo "修改后的代码（第 $((LINE_NUM-3)) 到 $((LINE_NUM+3)) 行）："
        sed -n "$((LINE_NUM-3)),$((LINE_NUM+3))p" "$LLAMA_FILE" | cat -n
        echo ""
        echo -e "${GREEN}✓ 修改成功${NC}"
    else
        echo -e "${RED}错误: 修改失败，请手动修改${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}[步骤 3/3] 验证修改${NC}"
echo "----------------------------------------"

# 验证 CXR-BERT
echo "验证 CXR-BERT 修改..."
if grep -q "get_projected_text_embeddings" "$CXRBERT_FILE"; then
    echo -e "${GREEN}✓ CXR-BERT 修改正确${NC}"
else
    echo -e "${RED}✗ CXR-BERT 修改可能有问题${NC}"
fi

# 验证 Transformers
echo "验证 Transformers 修改..."
if grep -q "reduction='none'" "$LLAMA_FILE"; then
    echo -e "${GREEN}✓ Transformers 修改正确${NC}"
else
    echo -e "${RED}✗ Transformers 修改可能有问题${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}修改完成！${NC}"
echo "=========================================="
echo ""
echo "修改摘要："
echo "  1. CXR-BERT: $CXRBERT_FILE"
echo "  2. Transformers: $LLAMA_FILE"
echo ""
echo "备份文件位置："
if [ -f "${CXRBERT_FILE}.backup" ]; then
    echo "  - ${CXRBERT_FILE}.backup"
fi
if [ -f "${LLAMA_FILE}.backup" ]; then
    echo "  - ${LLAMA_FILE}.backup"
fi
echo ""
echo "如果遇到问题，可以使用备份文件恢复："
echo "  cp ${CXRBERT_FILE}.backup ${CXRBERT_FILE}"
echo "  cp ${LLAMA_FILE}.backup ${LLAMA_FILE}"

