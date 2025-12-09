# Tiny-Vicuna-1B 下载和配置指南

## 📋 当前状态

您的 `hf/` 目录中缺少 `Tiny-Vicuna-1B` 模型，训练脚本中指定的是：
```bash
vicuna_model="./hf/Tiny-Vicuna-1B"
```

---

## 🎯 解决方案

您有两个选择：

### 方案A：下载真正的 Tiny-Vicuna-1B（推荐）

从 Hugging Face 下载 Tiny-Vicuna-1B 模型到项目目录。

### 方案B：使用现有的 TinyLlama-1.1B（快速方案）

您已经有 `TinyLlama-1.1B-Chat-v1.0` 模型，如果兼容可以直接使用。

---

## 方案A：下载 Tiny-Vicuna-1B

### 步骤1：找到正确的 Hugging Face 模型

Tiny-Vicuna-1B 在 Hugging Face 上的主要仓库：
- **推荐**：`PhengXuan/Tiny-Vicuna-1B` 或类似的仓库
- 搜索关键词：`Tiny-Vicuna-1B` 或 `tiny-vicuna-1b`

### 步骤2：使用 huggingface-cli 下载

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 确保已安装 huggingface_hub
pip install huggingface_hub

# 创建目标目录
mkdir -p ./hf/Tiny-Vicuna-1B

# 下载模型（需要替换为实际的模型ID）
# 方式1：使用 huggingface-cli
huggingface-cli download PhengXuan/Tiny-Vicuna-1B --local-dir ./hf/Tiny-Vicuna-1B

# 或者方式2：使用 Python 脚本下载
```

### 步骤3：使用 Python 脚本下载（推荐）

创建一个下载脚本：

```python
# download_tiny_vicuna.py
from huggingface_hub import snapshot_download

model_id = "PhengXuan/Tiny-Vicuna-1B"  # 或实际的模型ID
local_dir = "./hf/Tiny-Vicuna-1B"

print(f"正在下载 {model_id} 到 {local_dir}...")
snapshot_download(
    repo_id=model_id,
    local_dir=local_dir,
    local_dir_use_symlinks=False
)
print("下载完成！")
```

运行脚本：
```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
python download_tiny_vicuna.py
```

### 步骤4：验证下载

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
ls -lh ./hf/Tiny-Vicuna-1B/
```

应该看到：
- `config.json`
- `pytorch_model.bin` 或 `model.safetensors`
- `tokenizer.json` 或 `tokenizer.model`
- 其他相关文件

---

## 方案B：使用现有的 TinyLlama-1.1B（快速方案）

如果您已经有 `TinyLlama-1.1B-Chat-v1.0` 模型，并且确认可以使用，可以创建符号链接：

### 步骤1：确认现有模型位置

```bash
# 检查模型是否存在
ls -lh /mnt/nvme_disk/user8_data/model_weights/TinyLlama-1.1B-Chat-v1.0/
```

### 步骤2：创建符号链接（推荐，节省空间）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
mkdir -p ./hf

# 创建符号链接
ln -s /mnt/nvme_disk/user8_data/model_weights/TinyLlama-1.1B-Chat-v1.0 \
      ./hf/Tiny-Vicuna-1B

# 验证链接
ls -lh ./hf/Tiny-Vicuna-1B
```

### 步骤3：验证模型兼容性

**注意**：TinyLlama 和 Tiny-Vicuna 虽然都是 1B 模型，但可能不完全兼容。需要确认：
- Embedding 维度是否相同（通常是 2048）
- Tokenizer 是否兼容
- 模型架构是否匹配

如果模型不兼容，训练时可能会报错。

---

## 🔍 如何确定正确的模型ID

### 方法1：在 Hugging Face 网站上搜索

1. 访问 https://huggingface.co/models
2. 搜索 "Tiny-Vicuna-1B" 或 "tiny-vicuna"
3. 找到合适的模型仓库

### 方法2：检查项目中是否有说明

查看 README 或文档中是否有模型下载链接。

### 方法3：使用 huggingface-cli 搜索

```bash
huggingface-cli scan-cache
# 或者
huggingface-cli list --filter tiny-vicuna
```

---

## 📝 完整的下载脚本

我为您创建一个完整的下载脚本：

```bash
#!/bin/bash
# download_tiny_vicuna.sh - 下载 Tiny-Vicuna-1B 模型

cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

MODEL_DIR="./hf/Tiny-Vicuna-1B"

# 检查是否已存在
if [ -d "$MODEL_DIR" ] && [ "$(ls -A $MODEL_DIR)" ]; then
    echo "模型目录已存在且不为空: $MODEL_DIR"
    echo "如果希望重新下载，请先删除该目录"
    exit 0
fi

# 创建目录
mkdir -p "$MODEL_DIR"

# 模型ID（需要替换为实际的模型ID）
MODEL_ID="PhengXuan/Tiny-Vicuna-1B"  # 示例，需要确认实际ID

echo "开始下载模型: $MODEL_ID"
echo "目标目录: $MODEL_DIR"
echo ""

# 使用 huggingface-cli 下载
huggingface-cli download "$MODEL_ID" \
    --local-dir "$MODEL_DIR" \
    --local-dir-use-symlinks False

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 下载完成！"
    echo ""
    echo "验证下载的文件："
    ls -lh "$MODEL_DIR" | head -10
else
    echo ""
    echo "❌ 下载失败，请检查："
    echo "  1. 模型ID是否正确"
    echo "  2. 网络连接是否正常"
    echo "  3. 是否有足够的磁盘空间"
    exit 1
fi
```

---

## ⚠️ 注意事项

### 1. 磁盘空间

Tiny-Vicuna-1B 模型大约需要 **2-3GB** 磁盘空间。确保有足够的空间。

### 2. 下载时间

根据网络速度，下载可能需要 **10-30分钟**。

### 3. 模型兼容性

如果使用 TinyLlama 替代 Tiny-Vicuna，需要确认：
- ✅ Embedding 维度相同（通常都是 2048）
- ✅ Tokenizer 兼容
- ⚠️ 可能需要测试运行确认

### 4. Hugging Face 认证

某些模型可能需要 Hugging Face 账号认证：
```bash
huggingface-cli login
```

---

## ✅ 验证配置

下载完成后，验证模型配置：

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 检查文件是否存在
ls -lh ./hf/Tiny-Vicuna-1B/

# 检查配置文件
cat ./hf/Tiny-Vicuna-1B/config.json | grep -E "hidden_size|vocab_size"

# 检查是否有模型权重文件
ls -lh ./hf/Tiny-Vicuna-1B/*.bin ./hf/Tiny-Vicuna-1B/*.safetensors 2>/dev/null
```

---

## 🎯 下一步

完成模型下载后：

1. ✅ 验证模型文件完整性
2. ✅ 检查训练脚本中的路径是否正确
3. ✅ 进行小规模测试运行
4. ✅ 开始正式训练

参考：[下一步操作指南](./下一步操作指南.md)

---

## 📚 相关文档

- [模型文件检查结果](./模型文件检查结果.md)
- [下一步操作指南](./下一步操作指南.md)

---

## 🔗 有用的链接

- Hugging Face 模型库：https://huggingface.co/models
- Hugging Face CLI 文档：https://huggingface.co/docs/huggingface_hub/quick-start

---

## 💡 快速参考

**如果模型下载遇到问题，可以尝试：**

1. **使用镜像站点**（如果在中国）
2. **分步下载**：先下载配置文件，再下载权重文件
3. **使用 git lfs**：某些模型使用 git lfs 存储















