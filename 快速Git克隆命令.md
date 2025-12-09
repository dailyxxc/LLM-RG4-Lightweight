# 快速 Git Clone 命令

## ✅ 可以使用 Git Clone！

您的命令可以执行：
```bash
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

---

## ⚠️ 重要：需要 Git LFS

**必须先安装 Git LFS**，否则大模型文件无法正确下载。

---

## 🚀 完整执行步骤

### 步骤1：安装 Git LFS（如果未安装）

```bash
conda install -c conda-forge git-lfs -y
git lfs install
```

### 步骤2：准备目录

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 如果目录已存在但为空，可以删除后重新克隆
# 或者直接进入目录后 git clone
```

### 步骤3：克隆模型

**方式1：如果目录不存在或想重新克隆**
```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR/hf
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

**方式2：如果目录已存在（先删除空目录）**
```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR/hf
rm -rf Tiny-Vicuna-1B  # 删除空目录
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

---

## 📋 一键执行命令

### 完整命令（包含 Git LFS 安装）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 安装 Git LFS（如果需要）
if ! command -v git-lfs &> /dev/null; then
    echo "正在安装 Git LFS..."
    conda install -c conda-forge git-lfs -y
    git lfs install
fi

# 准备目录
mkdir -p ./hf
cd ./hf

# 删除空目录（如果存在）
rm -rf Tiny-Vicuna-1B

# 克隆模型
git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B
```

---

## ✅ 验证结果

克隆完成后检查：

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 检查文件
ls -lh ./hf/Tiny-Vicuna-1B/

# 检查模型权重文件大小（应该很大，约2GB）
ls -lh ./hf/Tiny-Vicuna-1B/*.bin ./hf/Tiny-Vicuna-1B/*.safetensors 2>/dev/null
```

如果模型权重文件只有几KB，说明 Git LFS 没有正确工作，需要重新安装和初始化。

---

## 🎯 如果网络有问题

如果 git clone 也遇到网络问题，可以使用符号链接方案（最快）：

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
# 选择 2（创建符号链接）
```

---

## 📚 详细文档

- [使用Git克隆模型的完整指南.md](./使用Git克隆模型的完整指南.md)
- [使用Git克隆模型的说明.md](./使用Git克隆模型的说明.md)













