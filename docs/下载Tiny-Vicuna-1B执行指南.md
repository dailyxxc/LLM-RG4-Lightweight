# 下载 Tiny-Vicuna-1B 执行指南

## 📋 快速执行命令

### 方式1：直接执行脚本（交互式）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
```

或者使用完整路径：

```bash
bash /mnt/nvme_disk/user8_data/BN5212-final-VLMR/scripts/download_tiny_vicuna.sh
```

---

## 🎯 两种下载方案

脚本会提示您选择：

### 方案1：从 Hugging Face 下载 Tiny-Vicuna-1B

**优点**：
- ✅ 使用真正的 Tiny-Vicuna-1B 模型
- ✅ 与训练脚本完全匹配
- ✅ 避免兼容性问题

**缺点**：
- ⏱️ 需要下载时间（约 2-3GB，10-30分钟）
- 🌐 需要稳定的网络连接

**需要的模型ID示例**（需要确认正确的ID）：
- `PhengXuan/Tiny-Vicuna-1B`
- 或其他在 Hugging Face 上的 Tiny-Vicuna-1B 仓库

**执行步骤**：
1. 运行脚本：`bash scripts/download_tiny_vicuna.sh`
2. 选择 `1`（从 Hugging Face 下载）
3. 输入模型ID（例如：`PhengXuan/Tiny-Vicuna-1B`）
4. 等待下载完成

---

### 方案2：创建符号链接到现有的 TinyLlama-1.1B（快速方案）

**优点**：
- ⚡ 快速（几秒钟完成）
- 💾 节省磁盘空间（不重复存储）
- ✅ 您已经有这个模型

**缺点**：
- ⚠️ 可能存在兼容性问题（TinyLlama vs Tiny-Vicuna）
- 🔧 如果训练报错，可能需要下载真正的 Tiny-Vicuna-1B

**执行步骤**：
1. 运行脚本：`bash scripts/download_tiny_vicuna.sh`
2. 选择 `2`（创建符号链接）
3. 确认操作
4. 完成！

---

## 🚀 推荐执行流程

### 如果您想快速开始测试（推荐先试这个）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
# 选择 2（快速符号链接）
```

然后运行一个小规模测试，如果训练正常，说明兼容；如果有问题，再下载真正的 Tiny-Vicuna-1B。

### 如果您想要完整匹配（推荐用于正式训练）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR
bash scripts/download_tiny_vicuna.sh
# 选择 1（下载真正的模型）
# 输入模型ID（需要先确认正确的ID）
```

---

## 🔍 如何找到正确的模型ID

### 方法1：在 Hugging Face 网站搜索

1. 访问 https://huggingface.co/models
2. 搜索关键词：`Tiny-Vicuna-1B` 或 `tiny-vicuna-1b`
3. 找到合适的模型仓库，复制仓库名称

### 方法2：查看模型文档

检查项目中是否有 README 或其他文档提到模型下载链接。

### 方法3：直接使用已知的模型ID

常见的可能模型ID：
- `PhengXuan/Tiny-Vicuna-1B`
- `jphme/Tiny-Vicuna-1B`
- 或类似的仓库

**注意**：如果模型ID不正确，下载会失败，您可以尝试其他ID。

---

## ✅ 验证下载结果

下载完成后，验证模型文件：

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 检查目录是否存在
ls -lh ./hf/Tiny-Vicuna-1B/

# 检查关键文件
ls -lh ./hf/Tiny-Vicuna-1B/config.json
ls -lh ./hf/Tiny-Vicuna-1B/*.bin ./hf/Tiny-Vicuna-1B/*.safetensors 2>/dev/null
ls -lh ./hf/Tiny-Vicuna-1B/tokenizer.* 2>/dev/null
```

应该看到：
- ✅ `config.json` - 模型配置文件
- ✅ `pytorch_model.bin` 或 `model.safetensors` - 模型权重（约 2GB）
- ✅ `tokenizer.json` 或 `tokenizer.model` - 分词器文件

---

## 📝 完整示例

### 示例1：使用符号链接（快速）

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 执行脚本
bash scripts/download_tiny_vicuna.sh

# 交互提示：
# 请选择 (1/2): 2
# 是否继续? (y/N): y

# 验证
ls -lh ./hf/Tiny-Vicuna-1B/
```

### 示例2：从 Hugging Face 下载

```bash
cd /mnt/nvme_disk/user8_data/BN5212-final-VLMR

# 执行脚本
bash scripts/download_tiny_vicuna.sh

# 交互提示：
# 请选择 (1/2): 1
# 模型ID: PhengXuan/Tiny-Vicuna-1B

# 等待下载完成...

# 验证
ls -lh ./hf/Tiny-Vicuna-1B/
```

---

## ⚠️ 常见问题

### 1. 找不到 huggingface-cli

**问题**：脚本提示未找到 `huggingface-cli`

**解决**：
```bash
pip install huggingface_hub
```

### 2. 需要 Hugging Face 登录

**问题**：某些模型需要登录才能下载

**解决**：
```bash
huggingface-cli login
# 输入您的 Hugging Face token
```

### 3. 下载失败

**检查**：
- 模型ID是否正确
- 网络连接是否正常
- 磁盘空间是否足够（需要 2-3GB）

### 4. 符号链接后训练报错

**解决**：
- 尝试下载真正的 Tiny-Vicuna-1B 模型
- 或检查模型架构兼容性

---

## 🎯 下一步

模型下载/配置完成后：

1. ✅ 验证模型文件完整性
2. ✅ 检查训练脚本路径是否正确：`./hf/Tiny-Vicuna-1B`
3. ✅ 进行小规模测试运行
4. ✅ 开始正式训练

参考：[下一步操作指南](./下一步操作指南.md)

---

## 📚 相关文档

- [Tiny-Vicuna-1B下载和配置指南](./Tiny-Vicuna-1B下载和配置指南.md)
- [下一步操作指南](./下一步操作指南.md)













