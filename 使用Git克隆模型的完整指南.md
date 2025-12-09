# 使用 Git Clone 下载 Tiny-Vicuna-1B 完整指南

## ✅ 可以使用 Git Clone！

您的想法很好！`git clone` 是一个很好的备选方案，有时候比 `huggingface-cli` 更稳定。

---

## ⚠️ 重要前提：需要 Git LFS

### 为什么需要 Git LFS？

Hugging Face 上的大模型文件（如模型权重，通常几GB）使用 **Git LFS**（Large File Storage）存储。

- **没有 Git LFS**：只会下载小文件（如 config.json），大文件只会下载指针，不是实际模型
- **有 Git LFS**：可以正常下载所有文件，包括大模型权重

### 检查 Git LFS 是否安装

```bash
git lfs version
```

如果显示 "command not found"，需要安装。

---

## 🚀 完整执行步骤

### 步骤1：安装 Git LFS（如果需要）

```bash
# 方法1：使用 conda 安装（推荐）
conda install -c conda-forge git-lfs

# 或者方法2：使用系统包管理器
# Ubuntu/Debian:
sudo apt-get install git-lfs

# 安装后初始化
git lfs install
```

### 步骤2：克隆模型

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 创建目录（如果不存在）
mkdir -p ./hf

# 进入目录
cd ./hf

# 克隆模型
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

### 步骤3：验证下载结果

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 检查目录
ls -lh ./hf/Tiny-Vicuna-1B/

# 检查模型权重文件大小（应该很大，约2GB）
ls -lh ./hf/Tiny-Vicuna-1B/*.bin ./hf/Tiny-Vicuna-1B/*.safetensors 2>/dev/null
```

如果模型权重文件只有几KB，说明 Git LFS 没有正确工作。

---

## 📋 一键执行命令

### 完整命令序列（包含 Git LFS 安装）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 1. 检查并安装 Git LFS（如果需要）
if ! command -v git-lfs &> /dev/null; then
    echo "安装 Git LFS..."
    conda install -c conda-forge git-lfs -y
    git lfs install
fi

# 2. 创建目录
mkdir -p ./hf

# 3. 克隆模型
cd ./hf
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B

# 4. 验证
cd Tiny-Vicuna-1B
ls -lh
```

### 简化命令（如果 Git LFS 已安装）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR/hf && \
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

---

## 🔍 验证模型是否正确下载

下载完成后，检查关键文件：

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 检查目录结构
ls -lh ./hf/Tiny-Vicuna-1B/

# 应该看到：
# - config.json （小文件，几KB）
# - pytorch_model.bin 或 model.safetensors （大文件，约2GB）✅
# - tokenizer.json 或其他 tokenizer 文件
# - 其他配置文件

# 检查模型权重文件大小
ls -lh ./hf/Tiny-Vicuna-1B/*.bin ./hf/Tiny-Vicuna-1B/*.safetensors 2>/dev/null

# 如果文件大小只有几KB，说明 Git LFS 没有正确下载
```

---

## ⚠️ 常见问题

### 问题1：Git LFS 未安装

**症状**：模型权重文件只有几KB

**解决**：
```bash
conda install -c conda-forge git-lfs
git lfs install
# 然后重新克隆或拉取 LFS 文件
cd ./hf/Tiny-Vicuna-1B
git lfs pull
```

### 问题2：网络连接问题

**症状**：克隆过程中断或很慢

**解决**：
- 检查网络连接
- 可能需要配置代理
- 或使用符号链接方案（选项2）

### 问题3：模型不存在

**症状**：`fatal: repository not found`

**解决**：
- 检查模型ID是否正确
- 访问 https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B 验证
- 如果不存在，使用符号链接方案

---

## 🎯 Git Clone vs 其他方案

| 方案 | 优点 | 缺点 |
|------|------|------|
| **Git Clone** | ✅ 稳定，支持断点续传<br>✅ 可以查看版本历史 | ⚠️ 需要 Git LFS<br>⚠️ 受网络影响 |
| **Hugging Face CLI** | ✅ 自动处理 LFS<br>✅ 简单易用 | ❌ 网络问题（当前） |
| **符号链接** | ✅ 最快<br>✅ 无需网络<br>✅ 节省空间 | ⚠️ 需要确认兼容性 |

---

## 💡 推荐执行流程

### 如果 Git LFS 已安装或可以安装

```bash
# 1. 安装 Git LFS（如果需要）
conda install -c conda-forge git-lfs -y
git lfs install

# 2. 克隆模型
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR/hf
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

### 如果网络有问题或想快速开始

```bash
# 使用符号链接（推荐）
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
# 选择 2
```

---

## ✅ 总结

**可以使用 Git Clone！**

**执行命令**：
```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR/hf && \
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

**重要提醒**：
- ⚠️ 需要先安装 Git LFS（如果未安装）
- ✅ Git 已安装
- ✅ 命令可以执行

---

## 📚 相关文档

- [使用Git克隆模型的说明.md](./使用Git克隆模型的说明.md)
- [网络错误解决方案.md](./网络错误解决方案.md)













