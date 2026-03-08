# helpme.py - 开发进度

**创建日期：** 2026-03-06  
**最后更新：** 2026-03-08 11:08  
**目标：** 实现 `helpme <自然语言>` → Linux 命令 + 简短解释  
**关联脚本：** `helpme.py`（已完成）  
**模型选择：** llama3.2:latest（3B，速度快，适合简单命令生成）

---

## 当前进度

✅ **步骤 0：项目立项**（2026-03-06 18:07）
- README.md 已创建
- 技术选型确认（本地 Ollama + llama3.2:latest）
- 项目目录已建立

✅ **步骤 1：环境检测**（2026-03-07 11:58）
- Ollama 已安装（v0.15.1，通过 snap）
- 主机名：DESKTOP-TJNUFS5（家里电脑）

✅ **步骤 2：下载模型**（2026-03-07 14:08 完成）
- 模型：qwen2.5:7b（4.7GB）✅ 已完成
- 备用模型：llama3.2:latest（2GB）✅ 已完成
- **最终选择：llama3.2:latest**（3B 参数，速度快，适合简单命令生成）

✅ **步骤 3：创建核心脚本 helpme.py**（2026-03-08 11:05 完成）
- ✅ 模型测试完成（llama3.2:3b 表现良好）
- ✅ 创建基础骨架
- ✅ 实现 Ollama API 调用（call_ollama 函数）
- ✅ 实现提示词构建（build_prompt 函数）
- ✅ 实现命令行参数解析（sys.argv）
- ✅ 测试运行（命令 + 解释格式完美）
- 输出示例：
  ```
  ⏳ 正在生成命令...
  命令：find . -type f -size +10M
  解释：find 查找工具 | -type f 只找文件 | -size +10M 大于 10MB
  ```

⏳ **步骤 4：Shell 集成**（进行中）
- ⏳ 创建 helpme 函数/别名
- ⏳ 添加到 .bashrc
- ⏸️ 测试新命令

⏸️ **步骤 5：安全确认机制**（可选）
- 危险命令检测（rm、sudo 等）
- 二次确认交互

⏸️ **步骤 6：测试验证**（待开始）
- 编写测试用例
- 实际场景测试

---

## 下一步（任务清单）

**步骤 4：Shell 集成**
```bash
# 1. 打开 .bashrc
nano ~/.bashrc

# 2. 添加到文件末尾：
helpme() {
    python3 /mnt/e/Documents/GPTProjects/工具/helpme-shell-assistant/helpme.py "$@"
}

# 3. 重新加载配置
source ~/.bashrc

# 4. 测试新命令
helpme "找出大于 10MB 的文件"
```

---

## 遇到的问题

| 日期 | 问题 | 解决方案 |
|------|------|---------|
| 2026-03-08 | `import Optional` 错误 | 改成 `from typing import Optional` |
| 2026-03-08 | `MODEL` 变量未定义 | 检查发现是删除了全局定义 |
| 2026-03-08 | `"".join()` 参数无空格 | 改成 `" ".join()` |
| 2026-03-08 | 提示词示例乱码 | `$1` 变成 `+78 lines`，手动修复 |
| 2026-03-08 | AI 不遵守输出格式 | 模型能力有限，接受当前输出 |
| 2026-03-08 | 调试代码打印 prompt | 删除调试输出 |

---

## 已完成的代码

### helpme.py（最终版本）

```python
#!/usr/bin/env python3
"""
helpme - Shell 自然语言命令助手
用法：helpme <自然语言描述>
示例：helpme 找出当前目录下大于 10MB 的文件
"""

import requests
import json
from typing import Optional
import sys

# Ollama API 端点
OLLAMA_API = "http://localhost:11434/api/generate"
MODEL = "llama3.2:latest"

def call_ollama(prompt: str) -> Optional[str]:
    """调用 Ollama API 生成命令"""
    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False
    }
    response = requests.post(OLLAMA_API, json=payload)
    if response.status_code == 200:
        result = response.json()
        return result.get("response", "")
    else:
        print(f"Error calling Ollama API: ", response.status_code, response.text)
        return None

def build_prompt(user_input: str) -> str:
    """构建给 Ollama 的提示词"""
    system_prompt = """
你是一个 shell 命令助手。用户会用自然语言描述需求，你只需要返回对应的 shell 命令 + 简短解释。
输出格式：
命令：<shell 命令>
解释：<工具名/关键参数/含义，用 | 分隔，不超过 50 字，复杂命令可适当延长>

示例：
用户：找出大于 10MB 的文件
你：
命令：find . -type f -size +10M
解释：find 查找工具 | -type f 只找文件 | -size +10M 大于 10MB
"""
    full_prompt = system_prompt + "\n用户：" + user_input + "\n你："
    return full_prompt

def main():
    if len(sys.argv) < 2:
        print("用法：helpme <自然语言描述>")
        print("示例：helpme '找出大于 10MB 的文件'")
        sys.exit(1)
    
    user_input = " ".join(sys.argv[1:])
    prompt = build_prompt(user_input)
    
    print("⏳ 正在生成命令...")
    result = call_ollama(prompt)
    
    if result:
        print(result)
    else:
        print("❌ 生成失败，请重试")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

---

## 会话记录

**2026-03-08 09:51 - 2026-03-08 11:08**
- 用户提出需求：helpme 和幽灵文本是否值得做
- AI 分析：helpme 值得做（终端命令生成），幽灵文本不建议（用 Cursor 免费版）
- 确认 helpme 需求：生成命令 + 解释，用户手敲，达成熟练
- 选择方案 A：简单版（1 天完成）
- 步骤 3.1：添加 Ollama API 调用（import requests）
- 步骤 3.2：实现 call_ollama 函数
- 用户提问：`python3 -m` 是什么意思
- 用户提问：为什么 `response.json()`
- 用户提问：什么是包装器
- 步骤 3.3：实现 build_prompt 函数
- 用户提问：解释不超过 40 字合理么
- AI 反思：改成 50 字，复杂命令可延长
- 步骤 3.4：修改 main() 函数
- 用户提问：`" ".join(sys.argv[1:])` 是什么意思
- 测试运行：修复 `import Optional` 错误
- 测试运行：修复 `MODEL` 未定义
- 测试运行：修复 `"".join()` 空格问题
- 测试运行：修复提示词乱码
- 测试运行：删除调试输出
- ✅ 最终测试成功：命令 + 解释格式完美
- ✅ AI 已更新进度文件（2026-03-08 11:08）
- 当前：步骤 4 Shell 集成（等待用户执行）

---

## 违规记录

**2026-03-07 12:12**
- 类型：未更新进度文件
- 原因：用户提醒后才更新
- 补救：已更新 helpme.py.progress.md
- 归档：memory/2026-03-07.md

**2026-03-08 10:07**
- 类型：未优先使用 MCP 工具
- 原因：AI 没有用 MCP WebSearch，直接尝试 web_search
- 补救：已用 MCP 重新搜索
- 规则修改：BOOTSTRAP.md/MEMORY.md/HEARTBEAT.md 已更新
- 归档：memory/2026-03-08.md

**2026-03-08 11:08**
- 类型：AI 推卸责任（让用户维护进度文件）
- 原因：AI 让用户手动删除重写进度文件
- 补救：AI 立即用 write 工具更新
- 归档：本文件（见上）
