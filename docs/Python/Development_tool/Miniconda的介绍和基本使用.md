# Miniconda的介绍和基本使用
conda：是一种通用包管理系统，旨在构建和管理任何语言和任何类型的软件。举个例子：包管理与pip的使用类似，环境管理则允许用户方便地安装不同版本的python并可以快速切换。

- 进入网址[Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- 安装/卸载[Conda](https://conda.io/projects/conda/en/latest/user-guide/install/linux.html)
- 然后保存更改，运行 source ~/.bashrc 
- 查看conda版本  conda -V

# 虚拟环境
```python
- 查看虚拟环境  conda info --envs/e

- 创建虚拟环境   conda create -n name python=3.6

- 激活Py2虚拟环境 conda activate py2

- 退出 conda deactivate 

- conda env export > environment.yml：导出环境配置

- conda env create -f environment.yml：创建一样的环境

- conda remove -n env_name --all：删除虚拟环境

- 查看所有虚拟环境  conda env list

- 指定虚拟环境，查看已安装的包  conda list -n envname

```

# 包管理
## conda和pip区别
conda作为包管理工具和pip类似，但是还有区别：
- 某些包不能通过conda安装，只能通过pip安装
- anaconda python conda都被conda视为package,和普通安装包管理方式相同
## 常用命令
```python
- 查看当前激活环境中的已安装包，如果希望查询指定环境中已安装包，则在command命令后加上-n 环境名，其他命令类似

    conda list 
 
- 查找package信息
 
    conda search  numpy
 
- 查看某安装包是否已安装
 
   conda list | grep 包名（支持正则）
 
- 指定环境，安装/更新/删除指定的包 

   conda install/update/remove -n envname package==1.0.0

- 清理（conda瘦身）
    （1）通过conda clean -p来删除一些没用的包，这个命令会检查哪些包没有在包缓存中被硬依赖到其他地方，并删除它们。
    （2）通过conda clean -t可以将删除conda保存下来的tar包。
        conda clean -p      	//删除没有用的包
        conda clean -t      	//删除tar包
        conda clean -y --all 	//删除所有的安装包及cache

- 复制/重命名/删除env环境
    conda是没有重命名环境的功能的, 要实现这个基本需求, 只能通过愚蠢的克隆-删除的过程。
    切记不要直接mv移动环境的文件夹来重命名, 会导致一系列无法想象的错误的发生!

- 克隆oldname环境为newname环境

    conda create --name newname --clone oldname 

- 彻底删除旧环境

    conda remove --name oldname --all      
```

# 安装Miniconda后 vscode 找不到包

1. 确定vscode有安装python拓展
2. 打开设置 在搜索框输入"python.analysis.extraPaths"
3. 通过 python3 -m site 查看包 添加到配置

# 创建环境失败
大概率因为网络原因, 添加镜像源就好了。
```
# 清华镜像  
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/  
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/  
conda config --set show_channel_urls yes
```



