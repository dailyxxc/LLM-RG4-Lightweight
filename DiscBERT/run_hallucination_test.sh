#!/bin/bash
# DiscBERT 幻觉检测脚本
# 用于测试模型生成的报告中的输入无关幻觉（hallucination）

# 设置路径
cd "$(dirname "$0")"
cd ..

# 配置参数（使用绝对路径，避免路径问题）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PREDICT_CSV="${PROJECT_ROOT}/DiscBERT/sn_predictions.csv"
DISCBERT_MODEL="${PROJECT_ROOT}/DiscBERT/discbert.pth"
BERT_MODEL="${PROJECT_ROOT}/hf/bert-base-uncased"
OUTPUT_DIR="${PROJECT_ROOT}/DiscBERT/hall_results"
GPU_ID=1

# 创建输出目录
mkdir -p ${OUTPUT_DIR}

# 固定使用 GPU1
export CUDA_VISIBLE_DEVICES=${GPU_ID}

echo "=========================================="
echo "DiscBERT 幻觉检测"
echo "=========================================="
echo "预测文件: ${PREDICT_CSV}"
echo "DiscBERT 模型: ${DISCBERT_MODEL}"
echo "BERT 模型: ${BERT_MODEL}"
echo "输出目录: ${OUTPUT_DIR}"
echo "GPU: ${GPU_ID}"
echo "=========================================="

# 运行 DiscBERT
cd ${PROJECT_ROOT}/DiscBERT
python train.py \
    --predict \
    --predictroad ${PREDICT_CSV} \
    --delta_file ${DISCBERT_MODEL} \
    --BertModel ${BERT_MODEL} \
    --savedmodel_path ${OUTPUT_DIR} \
    --batch_size 16 \
    --test_batch_size 16 \
    --num_workers 8 \
    --devices 1 \
    --accelerator gpu \
    --precision bf16-mixed \
    2>&1 | tee ${OUTPUT_DIR}/discbert_log.txt

echo "=========================================="
echo "检测完成！结果保存在: ${OUTPUT_DIR}"
echo "=========================================="

