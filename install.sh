#!/bin/bash

# 禁用代理（localhost 不应该走代理）
unset ALL_PROXY HTTP_PROXY HTTPS_PROXY NO_PROXY

set -e # 出错即停

echo "🔧 helpme 自动安装脚本"
echo "======================"

HOSTNAME=$(hostname)
echo "📡 当前主机名: $HOSTNAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📂 脚本目录: $SCRIPT_DIR"

if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 未安装，请先安装 Python 3"
    echo "请执行: sudo apt update && sudo apt install python3 python3-pip -y"
    exit 1
fi

echo "✅ Python 3 已安装 $(python3 --version)"

# 3. 检测并安装依赖
echo "📦 检查依赖..."
if ! python3 -c "import requests" &> /dev/null; then
    echo "⏳ 安装 requests 库..."
    pip3 install requests --user
fi
echo "✅ requests 已安装"

# 4. 检测 Ollama
if ! command -v ollama &> /dev/null; then
    echo "⚠️  Ollama 未安装"
    echo "请执行：curl -fsSL https://ollama.com/install.sh | sh"
    echo "然后重新运行此脚本"
    exit 1
fi
echo "✅ Ollama: $(ollama --version)"

# 5. 检测 Ollama 服务
if ! curl -s http://localhost:11434/api/version &> /dev/null; then
    echo "⚠️  Ollama 服务未运行"
    echo "请执行：ollama serve"
    echo "（新开终端运行，然后重新运行此脚本）"
    exit 1
fi
echo "✅ Ollama 服务运行中"

# 6. 检测模型
MODEL="llama3.2:latest"
echo "📥 检查模型：$MODEL"
if ! ollama list | grep -q "$MODEL"; then
    echo "⏳ 下载模型（约 2GB，首次需要几分钟）..."
    ollama pull $MODEL
fi
echo "✅ 模型已就绪"

# 7. 配置 .bashrc
echo "🔧 配置 .bashrc..."
BASH_FUNC="
# helpme - Shell 命令助手（自动添加）
helpme() {
    python3 $SCRIPT_DIR/helpme.py \"\$@\"
}
"

if ! grep -q "helpme()" ~/.bashrc; then
    echo "$BASH_FUNC" >> ~/.bashrc
    echo "✅ 已添加到 ~/.bashrc"
else
    echo "✅ helpme 已在 ~/.bashrc 中"
fi

# 8. 测试运行
echo "🧪 测试运行..."
source ~/.bashrc
python3 "$SCRIPT_DIR/helpme.py" "测试"

echo ""
echo "🎉 安装完成！"
echo "用法：helpme <自然语言描述>"
echo "示例：helpme 找出大于 10MB 的文件"

eval "$(tail -10 ~/.bashrc | grep -A5 'helpme()')"

echo ""
echo "✅ helpme 已加载到当前终端！"
echo "   新终端会自动加载，无需 source"