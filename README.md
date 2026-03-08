# helpme - Shell 自然语言命令助手

**创建日期：** 2026-03-06  
**最后更新：** 2026-03-06  
**状态：** 🟡 立项阶段

---

## 项目目标

在 bash/shell 中实现 `helpme <自然语言描述>` 命令，自动将用户需求转换为 Linux 命令。

**示例：**
```bash
helpme 找出当前目录下大于 10MB 的文件
# 输出：find . -type f -size +10M

helpme 查看端口 8080 被哪个进程占用
# 输出：lsof -i :8080 或 netstat -tlnp | grep 8080
```

---

## 技术选型

| 组件 | 选择 | 原因 |
|------|------|------|
| AI 引擎 | Ollama (本地) | 隐私好、免费、快速 |
| 推荐模型 | qwen2.5:7b | 中文支持好、轻量 |
| 集成方式 | Shell 函数 + Python 脚本 | 灵活、易调试 |
| 安全机制 | 危险命令二次确认 | 防止误执行 rm/dd 等 |

---

## 开发进度

### ✅ 已完成
- [x] 项目立项（2026-03-06）
- [ ] 环境检测
- [ ] 核心脚本开发
- [ ] Shell 集成
- [ ] 安全确认机制
- [ ] 测试验证

### ⏳ 下一步
1. 执行环境检测（检查 Ollama 是否安装）
2. 如未安装，安装 Ollama 并下载模型
3. 创建 `helpme.py` 核心脚本

---

## 目录结构

```
helpme-shell-assistant/
├── README.md              # 本文件
├── helpme.py              # 核心脚本（待创建）
├── helpme.sh              # Shell 集成脚本（待创建）
├── test/                  # 测试用例（待创建）
│   └── test_cases.md
└── docs/                  # 文档（待创建）
    └── design.md
```

---

## 技术架构

```
用户输入 (bash)
    ↓
helpme 别名/函数
    ↓
helpme.py (Python 脚本)
    ↓
Ollama API (本地 AI)
    ↓
命令建议 → 用户确认 → 执行
```

---

## 安全考虑

**危险命令检测：**
- `rm -rf`、`dd`、`mkfs`、`chmod 777` 等
- 检测到危险命令时，强制二次确认
- 输出：`⚠️ 此命令会删除文件，确认执行？(y/N)`

---

## 相关文件

- 项目位置：`/home/Documents/GPTProjects/工具/helpme-shell-assistant/`
- 归档位置：同项目目录（自包含）

---

## 参考资料

- Ollama 官方文档：https://ollama.com/
- Qwen2.5 模型：https://ollama.com/library/qwen2.5
