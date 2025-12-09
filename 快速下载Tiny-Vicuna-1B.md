# 快速下载 Tiny-Vicuna-1B 模型

## 🚀 一键执行命令

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR && bash scripts/download_tiny_vicuna.sh
```

---

## 📋 执行步骤说明

### 步骤1：运行脚本

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
```

### 步骤2：选择下载方式

脚本会显示两个选项：

```
请选择下载方式：
1. 从 Hugging Face 下载 Tiny-Vicuna-1B（需要模型ID）
2. 创建符号链接到现有的 TinyLlama-1.1B 模型（快速，但需要确认兼容性）

请选择 (1/2):
```

---

## 🎯 推荐方案

### ⚡ 快速测试方案（推荐先试这个）

如果您想快速开始，选择 **选项2**（创建符号链接）：

```bash
bash scripts/download_tiny_vicuna.sh
# 输入：2
# 确认：y
```

**优点**：
- 几秒钟完成
- 使用您已有的 TinyLlama-1.1B 模型
- 节省磁盘空间

**注意**：如果训练时出现兼容性问题，再下载真正的 Tiny-Vicuna-1B。

---

### 🔧 完整方案（推荐用于正式训练）

如果需要真正的 Tiny-Vicuna-1B 模型，选择 **选项1**：

```bash
bash scripts/download_tiny_vicuna.sh
# 输入：1
# 输入模型ID（例如：PhengXuan/Tiny-Vicuna-1B）
```

**需要的准备工作**：
- 确认正确的模型ID（在 Hugging Face 上搜索）
- 稳定的网络连接
- 2-3GB 磁盘空间
- 约 10-30 分钟下载时间

---

## ✅ 验证结果

下载/配置完成后，验证：

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
ls -lh ./hf/Tiny-Vicuna-1B/
```

应该看到模型文件（config.json、模型权重文件等）。

---

## 📝 完整命令示例

### 方式1：使用符号链接（快速）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
# 选择 2，然后确认
```

### 方式2：下载真正的模型

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
# 选择 1，输入模型ID（需要先确认）
```

---

## 🔍 如何找到模型ID

访问 Hugging Face 网站搜索：https://huggingface.co/models
- 搜索关键词：`Tiny-Vicuna-1B` 或 `tiny-vicuna`
- 找到合适的模型仓库
- 复制仓库名称作为模型ID

---

## 📚 详细文档

更多详细信息请参考：
- [下载Tiny-Vicuna-1B执行指南](./docs/下载Tiny-Vicuna-1B执行指南.md)
- [Tiny-Vicuna-1B下载和配置指南](./docs/Tiny-Vicuna-1B下载和配置指南.md)













