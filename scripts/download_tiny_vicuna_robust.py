#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
改进的 Tiny-Vicuna-1B 模型下载脚本
支持镜像、重试机制和更好的错误处理
"""

import os
import sys
from huggingface_hub import snapshot_download

# 模型ID
repo_id = "Jiayi-Pan/Tiny-Vicuna-1B"

# 保存目录
save_dir = "./hf/Tiny-Vicuna-1B"

# 创建保存目录
os.makedirs(save_dir, exist_ok=True)

print("=" * 60)
print("Tiny-Vicuna-1B 模型下载脚本（改进版）")
print("=" * 60)
print(f"模型ID: {repo_id}")
print(f"保存目录: {save_dir}")
print("")

# 检查环境变量，看是否设置了镜像
hf_endpoint = os.environ.get("HF_ENDPOINT", "https://huggingface.co")
if hf_endpoint != "https://huggingface.co":
    print(f"⚠️  使用镜像站点: {hf_endpoint}")
    print("")

print("开始下载模型...")
print("（如果下载失败，请尝试设置镜像：export HF_ENDPOINT=https://hf-mirror.com）")
print("")

try:
    # 下载模型
    # local_dir_use_symlinks=False 表示不使用符号链接，直接复制文件
    snapshot_download(
        repo_id=repo_id,
        local_dir=save_dir,
        local_dir_use_symlinks=False,
        resume_download=True  # 支持断点续传
    )
    
    print("")
    print("=" * 60)
    print("✅ 下载完成！")
    print("=" * 60)
    print(f"模型已保存到: {os.path.abspath(save_dir)}")
    print("")
    print("验证下载的文件：")
    if os.path.exists(save_dir):
        files = os.listdir(save_dir)
        total_size = 0
        for file in files[:15]:  # 显示前15个文件
            file_path = os.path.join(save_dir, file)
            if os.path.isfile(file_path):
                size = os.path.getsize(file_path)
                total_size += size
                size_mb = size / (1024 * 1024)
                if size_mb > 1:
                    print(f"  ✓ {file} ({size_mb:.2f} MB)")
                else:
                    size_kb = size / 1024
                    print(f"  ✓ {file} ({size_kb:.2f} KB)")
            else:
                print(f"  ✓ {file}/ (目录)")
        
        total_gb = total_size / (1024 * 1024 * 1024)
        print(f"\n总大小: {total_gb:.2f} GB")
    
except KeyboardInterrupt:
    print("\n\n下载被用户中断")
    sys.exit(1)
    
except Exception as e:
    print("")
    print("=" * 60)
    print("❌ 下载失败")
    print("=" * 60)
    print(f"错误类型: {type(e).__name__}")
    print(f"错误信息: {e}")
    print("")
    print("=" * 60)
    print("解决方案")
    print("=" * 60)
    print("")
    print("方案1：使用镜像站点（如果在国内，推荐）")
    print("  export HF_ENDPOINT=https://hf-mirror.com")
    print("  python scripts/download_tiny_vicuna_robust.py")
    print("")
    print("方案2：使用 Git Clone")
    print("  cd ./hf")
    print("  git clone https://huggingface.co/Jiayi-Pan/Tiny-Vicuna-1B")
    print("")
    print("方案3：使用符号链接（最快，无需网络）")
    print("  bash scripts/download_tiny_vicuna.sh")
    print("  选择 2（创建符号链接到 TinyLlama-1.1B）")
    print("")
    print("方案4：配置代理（如果网络需要代理）")
    print("  export HTTP_PROXY=http://proxy.example.com:8080")
    print("  export HTTPS_PROXY=http://proxy.example.com:8080")
    print("  python scripts/download_tiny_vicuna_robust.py")
    print("")
    
    sys.exit(1)

