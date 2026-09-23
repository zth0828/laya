#!/usr/bin/env bash
# ==============================================================================
# Laya System 1 决策引擎 - 终端直显前台启动脚本
# (按 Ctrl + C 即可随时停止，实时输出访问日志与决策结果)
# ==============================================================================

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

export LAYA_HOST="0.0.0.0"
export LAYA_PORT="18899"
export LAYA_MODELS_DIR="$DIR/models"
export LAYA_PRELOAD="1"
export NO_PROXY="localhost,127.0.0.1"
export no_proxy="localhost,127.0.0.1"
export PYTHONPATH="$DIR:$PYTHONPATH"

# 检查端口是否被占用，如有占用提示清理
PORT_PID=$(lsof -ti :$LAYA_PORT 2>/dev/null || true)
if [ -n "$PORT_PID" ]; then
    echo "[!] 提示: 端口 $LAYA_PORT 当前已被进程 $PORT_PID 占用，正在尝试清理..."
    kill -9 $PORT_PID 2>/dev/null || true
    sleep 1
fi

# 获取本机局域网 IP
LAN_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "127.0.0.1")

echo "=================================================================="
echo "🚀 正在启动 Laya 决策引擎服务 (前台实时日志模式)..."
echo "📂 本地权重目录: $LAYA_MODELS_DIR"
echo "🌐 本地接口地址: http://127.0.0.1:$LAYA_PORT"
echo "📡 局域网访问点: http://$LAN_IP:$LAYA_PORT"
echo "💡 提示: 所有请求与决策耗时将在此实时显示，按 [Ctrl + C] 即可停止服务。"
echo "=================================================================="

# 捕捉 Ctrl + C 信号，优雅退出
trap 'echo -e "\n🛑 正在停止 Laya 服务..."; exit 0' SIGINT SIGTERM

# 前台启动，日志直显终端
python3 -m laya.serve
