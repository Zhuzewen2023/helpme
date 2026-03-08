# helpme 🤖

> 别再 Google "find 命令参数" 了，直接问！

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ollama](https://img.shields.io/badge/Ollama-llama3.2-blue)](https://ollama.com)

## 🤔 你是不是也这样？

```bash
# 想找大于 10MB 的文件，但不记得 find 参数...
find . -size ??? -type ???

# 最后 Google："find 大于 10MB 文件 命令"
# 点开第 3 个链接
# 复制粘贴
# 执行
# 忘了参数啥意思
```

**现在可以这样：**

```bash
helpme 找出大于 10MB 的文件

# 输出：
⏳ 正在生成命令...
命令：find . -type f -size +10M
解释：find 查找工具 | -type f 只找文件 | -size +10M 大于 10MB
```

**✨ 命令有了，参数也懂了，下次就会了！**

---

## 🚀 快速开始

### 1 分钟安装

```bash
# 1. 确保 Ollama 已安装（没装？https://ollama.com）
ollama --version

# 2. 下载模型（首次约 2GB）
ollama pull llama3.2:latest

# 3. 克隆并安装
git clone git@github.com:Zhuzewen2023/helpme.git
cd helpme
./install.sh

# 4. 开始用！
helpme 找出大于 10MB 的文件
```

### 如果 install.sh 失败...

```bash
# 手动安装（3 步）
pip3 install requests --user
echo 'helpme() { python3 $(pwd)/helpme.py "$@"; }' >> ~/.bashrc
source ~/.bashrc
```

---

## 💬 使用示例

### 文件操作
```bash
helpme 找出大于 10MB 的文件
helpme 找出最近修改的文件
helpme 统计当前目录有多少文件
```

### 文本处理
```bash
helpme 统计每行第一个字段的和
helpme 找出包含 "error" 的行
helpme 把文件里的 tab 换成空格
```

### 网络相关
```bash
helpme 检查 80 端口是否开放
helpme 下载这个 URL 的文件
helpme 测试网站能不能访问
```

### 系统信息
```bash
helpme 查看内存使用
helpme 查看磁盘空间
helpme 找出最占 CPU 的进程
```

---

## 🎯 输出说明

```bash
$ helpme 解压 tar.gz 文件

⏳ 正在生成命令...
命令：tar -xzf file.tar.gz
解释：tar 归档工具 | -x 解压 | -z gzip 格式 | -f 指定文件
```

| 部分 | 说明 |
|------|------|
| `⏳` | 正在生成（1-3 秒） |
| `命令：` | 可以直接复制执行 |
| `解释：` | 参数含义，用 `|` 分隔 |

---

## 🔧 配置

### 换个模型

编辑 `helpme.py`：
```python
MODEL = "qwen2.5:7b"  # 更大更聪明，但更慢
```

### 远程 Ollama 服务

编辑 `helpme.py`：
```python
OLLAMA_API = "http://your-server:11434/api/generate"
```

### 修改解释长度

编辑 `helpme.py` 里的 `build_prompt()` 函数。

---

## 🛠️ 开发

### 项目结构
```
helpme/
├── helpme.py           # 核心脚本（100 行）
├── install.sh          # 自动安装脚本
├── README.md           # 你在看的这个
├── .gitignore          # Git 忽略文件
└── helpme.py.progress.md  # 开发进度日志
```

### 贡献
1. Fork 本项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

---

## 📝 开发日志

- **2026-03-08** v1.0 发布 🎉
  - 核心功能完成
  - 自动安装脚本
  - 命令 + 解释输出

---

## 🤝 感谢

- [Ollama](https://ollama.com) - 本地 AI 模型运行
- [llama3.2](https://ollama.com/library/llama3.2) - 快速轻量的模型

---

## 📄 许可证

MIT License - 随便用，别告我，记得署名 😄

---

## ⭐ 如果好用，给个 Star！

```bash
# 在 GitHub 页面右上角点 Star ⭐
# 不用花钱，对我很重要！
```

---

## 🙏 常见问题

**Q: 为什么这么慢？**  
A: 首次运行要加载模型（约 5 秒），之后 1-3 秒。

**Q: 命令能直接执行吗？**  
A: 可以！但危险命令（如 rm）请先确认。

**Q: 需要联网吗？**  
A: 不需要！Ollama 本地运行，隐私安全。

**Q: 能自定义提示词吗？**  
A: 可以！编辑 `helpme.py` 里的 `build_prompt()` 函数。

**Q: 报错 "Connection refused"**  
A: 执行 `ollama serve` 启动服务。

**Q: 代理问题连不上**  
A: 执行 `unset ALL_PROXY HTTP_PROXY HTTPS_PROXY`
