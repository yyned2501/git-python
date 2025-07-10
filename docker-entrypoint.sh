#!/bin/bash

gitpull() {
    echo "拉取仓库"
    git reset --hard origin/"$GIT_BRANCH"
    git pull origin "$GIT_BRANCH"
}

if [ -n "$GIT_REMOTE" ]; then
    if [ -z "$GIT_BRANCH" ]; then
        echo "GIT_BRANCH 未设置，使用默认值 master"
        GIT_BRANCH="master"
    fi
    # 检查是否是一个 Git 仓库
    if [ ! -d ".git" ]; then
        echo "初始化git"
        git config --global --add safe.directory /app
        git init
        git remote add origin "$GIT_REMOTE"
        git fetch origin >/dev/null
    fi
    echo "尝试更新git仓库"
    gitpull
fi
if [ -f "packages.txt" ]; then
    echo "安装apt依赖"
    apt-get update >/dev/null
    xargs -a packages.txt apt-get update && apt-get install -y --no-install-recommends >/dev/null 2>&1
fi
echo "更新pip"
pip install pip -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com --upgrade >/dev/null 2>&1
echo "安装supervisor"
pip install supervisor -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com --upgrade >/dev/null 2>&1

if [ -f "requirements.txt" ]; then
    echo "安装requirements.txt"
    pip install -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com --upgrade >/dev/null 2>&1
fi

echo "启动 supervisord"
supervisord -c supervisord.conf -n
