#!/bin/bash

# 脚本保存路径
#SCRIPT_PATH="$HOME/Network3.sh"

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi


# 主菜单函数
function main_menu() {
    while true; do
        clear
        echo "退出脚本，请按键盘Ctrl+C退出即可"
        echo "请选择要执行的操作:"
        echo "1) 安装并启动节点"
        echo "2) 升级并启动节点"
        echo "3) 获取私钥"
        echo "4) 停止节点"
        echo "0) 退出"
        echo -n "选择一个选项 [0-4]: "
        read OPTION

        case $OPTION in
        1) install_and_start_node ;;
        2) upgrade_and_start_node ;;
        3) get_private_key ;;
        4) stop_node ;;
        0) exit 0 ;;
        *) echo "无效选项，请重新输入。" ;;
        esac

        echo "按任意键返回主菜单..."
        read -n 1
    done
}

# 安装并启动节点函数
install_and_start_node() {
    # 更新系统包列表
    apt update

    # 安装所需的软件包
    apt install -y wget curl make clang pkg-config libssl-dev build-essential jq lz4 gcc unzip snapd
    apt-get install -y net-tools

    # 下载、解压并清理文件
    echo "下载并解压节点软件包..."
    wget https://network3.io/ubuntu-node-v2.1.1.tar.gz
    tar -xvf ./ubuntu-node-v2.1.1.tar.gz
    #rm -rf ./ubuntu-node-v2.1.1.tar.gz

    # 检查目录是否存在
    if [ ! -d "ubuntu-node" ]; then
        echo "目录 ubuntu-node 不存在，请检查下载和解压是否成功。"
        exit 1
    fi

    # 提示并进入目录
    echo "进入 ubuntu-node 目录..."
    cd ubuntu-node


    # 启动节点
    echo "启动节点..."
    bash manager.sh up

    echo "脚本执行完毕。"
    echo "按任意键返回主菜单..."
    read -n 1
    main_menu
}

# 获取私钥函数
get_private_key() {
    echo "获取私钥..."
    cd ubuntu-node
    bash manager.sh key
    echo "按任意键返回主菜单..."
    read -n 1
    main_menu
}

# 停止节点函数
stop_node() {
    echo "停止节点..."
    cd ubuntu-node
    bash manager.sh down
    echo "节点已停止。"
    echo "按任意键返回主菜单..."
    read -n 1
    main_menu
}

# 升级脚本函数
upgrade_and_start_node() {
  # 更新系统包列表
  apt update

  # 先停止原先的程序
  echo "停止节点..."
  cd ubuntu-node
  bash manager.sh down
  echo "节点已停止。"

  echo "删除旧节点..."
  cd ..
  rm -rf ubuntu-node*

  # 下载、解压并清理文件
  echo "下载并解压节点软件包..."
  wget https://network3.io/ubuntu-node-v2.1.1.tar.gz
  tar -xvf ./ubuntu-node-v2.1.1.tar.gz
  #rm -rf ./ubuntu-node-v2.1.1.tar.gz

  # 检查目录是否存在
  if [ ! -d "ubuntu-node" ]; then
      echo "目录 ubuntu-node 不存在，请检查下载和解压是否成功。"
      exit 1
  fi

  # 提示并进入目录
  echo "进入 ubuntu-node 目录..."
  cd ubuntu-node


  # 启动节点
  echo "启动节点..."
  bash manager.sh up

  echo "脚本执行完毕。"
  echo "按任意键返回主菜单..."
  read -n 1
  main_menu
}


# 调用主菜单函数，开始执行主菜单逻辑
main_menu
