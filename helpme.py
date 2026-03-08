#!/usr/bin/env python3

import requests
import json
from typing import Optional
import sys

import os
os.environ['ALL_PROXY'] = ''
os.environ['HTTP_PROXY'] = ''
os.environ['HTTPS_PROXY'] = ''

# Ollama API 端点
OLLAMA_API = "http://localhost:11434/api/generate"

MODEL = "llama3.2:latest"

def call_ollama(prompt: str) -> Optional[str]:
    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False # 不流式输出，一次性返回
    }
    
    response = requests.post(OLLAMA_API, json=payload)
    if response.status_code == 200:
        result = response.json()
        return result.get("response", "")
    else:
        print(f"Error calling Ollama API: ", response.status_code, response.text)
        return None

def build_prompt(user_input: str) -> str:
    system_prompt = """
        你是一个shell命令助手。用户会用自然语言描述需求，你必须严格按照以下格式返回。
        重要：必须包含"命令："和"解释："两行，不能省略！
        输出格式：
        命令：<shell 命令>
        解释：<工具名/关键参数/含义，用 | 分隔，不超过 50 字，复杂命令可适当延长>

        示例：
        用户：找出大于 10MB 的文件
        你：
        命令：find . -type f -size +10M
        解释：find 查找工具 | -type f 只找文件 | -size +10M 大于 10MB

        用户：统计每行第一个字段的和
        你：
        命令：awk '{sum+=$1} END {print sum}'
        解释：awk 文本处理 | $1 第一列 | sum 累加 | END 最后输出

        用户：解压 tar.gz 文件
        你：
        命令：tar -xzf file.tar.gz
        解释：tar 归档工具 | -x 解压 | -z gzip 格式 | -f 指定文件
    """
    
    full_prompt = system_prompt + "\n用户：" + user_input + "\n你："
    return full_prompt

def main():
    if len(sys.argv) < 2:
        print("用法: helpme <自然语言描述>")
        print("示例: helpme '找出大于 10MB 的文件'")
        sys.exit(1)
        
    user_input = "".join(sys.argv[1:])
    prompt = build_prompt(user_input)
    
    # print(f"🔍 解析需求: {prompt}")
    
    # 调用 Ollama API
    print("⏳ 正在生成命令...")
    result = call_ollama(prompt)

    # 输出结果
    if result:
        print(result)
    else:
        print("❌ 生成失败，请重试")
        sys.exit(1)
    

if __name__ == "__main__":
    main()
    