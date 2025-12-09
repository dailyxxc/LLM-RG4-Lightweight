# 使用 Python snapshot_download 下载模型

## ✅ 按照图片中的方法

您可以使用 Python 的 `snapshot_download` 方法来下载模型，这是 Hugging Face 官方推荐的方法。

---

## 🚀 快速执行

### 方式1：使用我创建的 Python 脚本（推荐）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 确保在 llm_rg4 环境中
conda activate llm_rg4

# 运行 Python 脚本
python scripts/download_tiny_vicuna_python.py
```

### 方式2：直接在 Python 中执行

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 确保在 llm_rg4 环境中
conda activate llm_rg4

# 启动 Python 并执行
python3 << EOF
from huggingface_hub import snapshot_download
import os

# 模型ID
repo_id = "Jiayi-Pan/Tiny-Vicuna-1B"

# 保存目录
save_dir = "./hf/Tiny-Vicuna-1B"

# 创建保存目录
os.makedirs(save_dir, exist_ok=True)

print("开始下载模型...")
snapshot_download(
    repo_id=repo_id,
    local_dir=save_dir,
    local_dir_use_symlinks=False
)
print("✅ 下载完成！")
EOF
```

### 方式3：交互式 Python

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
conda activate llm_rg4
python3
```

然后在 Python 中执行：

```python
from huggingface_hub import snapshot_download
import os

repo_id = "Jiayi-Pan/Tiny-Vicuna-1B"
save_dir = "./hf/Tiny-Vicuna-1B"

os.makedirs(save_dir, exist_ok=True)

snapshot_download(
    repo_id=repo_id,
    local_dir=save_dir,
    local_dir_use_symlinks=False
)
```

---

## 📋 完整代码（按照图片中的方法）

```python
# 安装库（如果未安装）
# pip install huggingface_hub

from huggingface_hub import snapshot_download
import os

# 创建保存模型目录
save_dir = "./hf/Tiny-Vicuna-1B"
os.makedirs(save_dir, exist_ok=True)

# save_dir是模型保存到本地的目录
# repo_id是模型在huggingface中的id
repo_id = "Jiayi-Pan/Tiny-Vicuna-1B"

# 下载模型
snapshot_download(
    repo_id=repo_id,
    local_dir=save_dir,
    local_dir_use_symlinks=False  # 不使用符号链接，直接复制文件
)
```

---

## ✅ 验证下载结果

下载完成后检查：

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 检查文件
ls -lh ./hf/Tiny-Vicuna-1B/

# 检查模型权重文件大小（应该很大，约2GB）
ls -lh ./hf/Tiny-Vicuna-1B/*.bin ./hf/Tiny-Vicuna-1B/*.safetensors 2>/dev/null
```

---

## 🎯 推荐执行命令

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
conda activate llm_rg4
python scripts/download_tiny_vicuna_python.py
```

---

## ⚠️ 注意事项

1. **确保在正确的环境中**：
   - 需要激活 `llm_rg4` conda 环境
   - 确保 `huggingface_hub` 已安装

2. **网络连接**：
   - 如果网络有问题，可能仍然会失败
   - 如果失败，可以考虑使用符号链接方案（选项2）

3. **磁盘空间**：
   - 确保有足够的磁盘空间（约2-3GB）

---

## 📚 相关文档

- [网络错误解决方案.md](./网络错误解决方案.md)
- [使用Git克隆模型的完整指南.md](./使用Git克隆模型的完整指南.md)













