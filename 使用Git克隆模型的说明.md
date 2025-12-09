# 使用 Git Clone 下载 Tiny-Vicuna-1B 模型

## ✅ 可以使用 Git Clone

您可以使用 `git clone` 命令下载模型，这是一个很好的备选方案！

---

## 📋 前提条件

### 1. 检查 Git 是否安装

```bash
git --version
```

### 2. 检查 Git LFS 是否安装（重要！）

Hugging Face 上的大模型文件通常使用 **Git LFS**（Large File Storage）存储，所以需要安装 `git-lfs`：

```bash
# 检查是否已安装
git lfs version

# 如果未安装，安装方法：
# Ubuntu/Debian:
sudo apt-get install git-lfs

# 或者使用 conda:
conda install -c conda-forge git-lfs
```

### 3. 初始化 Git LFS

如果安装后第一次使用，需要初始化：

```bash
git lfs install
```

---

## 🚀 执行步骤

### 方法1：直接克隆到目标目录

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 创建目录
mkdir -p ./hf

# 克隆模型（直接到目标目录）
cd ./hf
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B

# 验证
cd Tiny-Vicuna-1B
ls -lh
```

### 方法2：克隆后移动到目标位置

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 克隆到临时位置
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B ./hf/Tiny-Vicuna-1B

# 验证
ls -lh ./hf/Tiny-Vicuna-1B/
```

---

## ⚠️ 注意事项

### 1. Git LFS 必须安装

如果模型使用 Git LFS，但没有安装 `git-lfs`：
- 小文件（如 config.json）会正常下载
- 大文件（如模型权重）只会下载指针文件，不是实际模型
- 结果：模型无法使用

### 2. 网络问题仍然存在

如果网络连接有问题：
- `git clone` 也可能失败
- 但如果它能工作，通常比 huggingface-cli 更稳定

### 3. 下载时间

- Git LFS 下载大文件时可能需要较长时间
- 确保网络连接稳定

---

## 🔍 验证克隆结果

克隆完成后，检查文件：

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 检查目录
ls -lh ./hf/Tiny-Vicuna-1B/

# 应该看到：
# - config.json
# - pytorch_model.bin 或 model.safetensors（大文件，约2GB）
# - tokenizer.json 或其他 tokenizer 文件
# - 其他配置文件

# 检查模型权重文件大小（应该很大，约2GB）
ls -lh ./hf/Tiny-Vicuna-1B/*.bin ./hf/Tiny-Vicuna-1B/*.safetensors 2>/dev/null
```

如果文件大小只有几KB，说明 Git LFS 没有正确下载大文件。

---

## 🛠️ 完整的命令序列

```bash
# 1. 确保在项目目录
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 2. 检查并安装 git-lfs（如果需要）
git lfs version || (echo "需要安装 git-lfs" && conda install -c conda-forge git-lfs)
git lfs install

# 3. 创建目录
mkdir -p ./hf

# 4. 克隆模型
cd ./hf
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B

# 或者直接克隆到目标位置：
# git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B ./hf/Tiny-Vicuna-1B

# 5. 验证结果
cd Tiny-Vicuna-1B
ls -lh
```

---

## 🆚 Git Clone vs Hugging Face CLI

| 特性 | Git Clone | Hugging Face CLI |
|------|-----------|------------------|
| 网络稳定性 | ⚠️ 受网络影响 | ⚠️ 受网络影响 |
| Git LFS 支持 | ✅ 需要安装 git-lfs | ✅ 自动处理 |
| 下载速度 | ⚡ 可能更快 | 正常 |
| 断点续传 | ✅ 支持 | ✅ 支持 |
| 错误恢复 | ✅ 可以重新运行 | ✅ 可以重新运行 |

---

## 🎯 推荐方案

### 如果网络连接正常

**方案1：使用 Git Clone（推荐）**
```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR/hf
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

**方案2：使用符号链接（最快）**
```bash
# 如果网络有问题，直接用符号链接
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
# 选择 2
```

---

## ✅ 快速执行命令

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR && \
mkdir -p ./hf && \
cd ./hf && \
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

---

## 📚 相关文档

- [网络错误解决方案.md](./网络错误解决方案.md)
- [下载错误分析和解决方案.md](./docs/下载错误分析和解决方案.md)













