#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
使用 Python snapshot_download 下载 Tiny-Vicuna-1B 模型
按照 Hugging Face 官方推荐的方法
"""

import os
from huggingface_hub import snapshot_download

# 模型ID
repo_id = "Jiayi-Pan/Tiny-Vicuna-1B"

# 保存目录
save_dir = "./hf/Tiny-Vicuna-1B"

# 创建保存目录
os.makedirs(save_dir, exist_ok=True)

print("=" * 50)
print("开始下载 Tiny-Vicuna-1B 模型")
print("=" * 50)
print(f"模型ID: {repo_id}")
print(f"保存目录: {save_dir}")
print("")

try:
    # 下载模型
    # local_dir_use_symlinks=False 表示不使用符号链接，直接复制文件
    snapshot_download(
        repo_id=repo_id,
        local_dir=save_dir,
        local_dir_use_symlinks=False
    )
    
    print("")
    print("=" * 50)
    print("✅ 下载完成！")
    print("=" * 50)
    print(f"模型已保存到: {os.path.abspath(save_dir)}")
    print("")
    print("验证下载的文件：")
    if os.path.exists(save_dir):
        files = os.listdir(save_dir)
        for file in files[:10]:  # 显示前10个文件
            file_path = os.path.join(save_dir, file)
            if os.path.isfile(file_path):
                size = os.path.getsize(file_path)
                size_mb = size / (1024 * 1024)
                print(f"  ✓ {file} ({size_mb:.2f} MB)")
            else:
                print(f"  ✓ {file}/ (目录)")
    
except Exception as e:
    print("")
    print("=" * 50)
    print("❌ 下载失败")
    print("=" * 50)
    print(f"错误信息: {e}")
    print("")
    print("可能的原因：")
    print("  1. 网络连接问题")
    print("  2. 模型ID不正确")
    print("  3. 需要登录 Hugging Face (使用: huggingface-cli login)")
    print("  4. 磁盘空间不足")
    exit(1)

