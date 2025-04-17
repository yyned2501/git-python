#!/bin/bash

gitpull() {
	echo "拉取仓库"
    git reset --hard origin/"$GIT_BRANCH"
    git pull origin "$GIT_BRANCH"
}

echo "切换到/app"
cd /app

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

echo "更新pip"
pip install --upgrade pip -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com >/dev/null 2>&1
pip install supervisor -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com >/dev/null 2>&1

if [ -f "requirements.txt" ]; then
    echo "安装requirements.txt"
    pip install -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com --upgrade >/dev/null 2>&1
fi


supervisord -c supervisord.conf -n