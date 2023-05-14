## 引言


## 工具篇 

| 开发工具                  | 简介                                                                                                                                                                         |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Visual Studio Code        | <a href="https://code.visualstudio.com/">Visual Studio Code </a>（简称VS Code）是一款由微软开发且跨平台的免费集成开发环境。                                                  |
| VS Code 插件::clangd      | 分析 C++ 文件，实现 C++代码跳转                                                                                                                                              |
| VS Code 插件::Python      | VS Code 插件 用于分析 Python 文件，主要有 代码跳转，变量类型分析等。                                                                                                         |
| VS Code 插件::Live Server | 启动带有实时重载功能的本地开发服务，用于静态和动态页面。实现 在线预览 oneflow开发过程中 html 文档。                                                                               |
| Debug工具::pdb            | <a href="https://docs.python.org/zh-cn/3/library/pdb.html"> pdb </a> 模块定义了一个交互式源代码调试器，用于Python 程序                                                       |
| Debug工具::GDB            | <a href="https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/gdb.html"> GDB</a>: 一个由GNU开源组织发布的、UNIX/LINUX操作系统下的、基于命令行的、功能强大的程序调试工具。 |



### <a id="Visual Studio Code"> Visual Studio Code </a>

**官方链接**:  https://code.visualstudio.com/

**使用介绍**: <a href="https://code.visualstudio.com/"> Visual Studio Code </a>（简称VS Code）是一款由微软开发且跨平台的免费集成开发环境，~

**注意事项**: ~

### clangd

**官方链接**: https://github.com/clangd/clangd

**使用介绍**: 
<a href="https://www.ttlarva.com/master/remote_cpp_development/Clangd.html#clangd"> <font face="STCAIYUN" color=red size=5>配置 clangd 教程</font> </a>

**注意事项**: ~

###  Python

vscode 插件

![image](https://user-images.githubusercontent.com/118866310/226109290-e266422e-23a9-4c04-856b-cff5e96afcda.png)

**官方链接**: https://www.python.org/

**使用介绍**: 和一般的 VS Code插件一样，可以直接点击侧边活动栏的插件市场图标，搜索 <font face="STCAIYUN" color=red size=5> Python </font>
 进行安装。

安装之后，打开一个新的.py文件即可使用。

**注意事项**: 

1. 切换 Python 解释器： 
<font face="黑体" color=green size=5>Crtl+Shift + P</font> 搜索  `Python:select Interpreter`   配置默认的解释器。 以后每次打开VsCode，都会使用这个默认的解释器。good！
![image](https://user-images.githubusercontent.com/118866310/226109929-0a267ad2-4b99-4377-9ec4-f334f620e830.png)

2. VScode底部状态栏不见， 请如下图勾选 <font face="黑体" color=green size=5> Status Bar</font>

![image](https://user-images.githubusercontent.com/118866310/226110528-052f8c4d-1718-43b4-a967-2f2cc2c89647.png)


### Live Server 

![image](https://user-images.githubusercontent.com/118866310/226110766-2d2a5a18-6ec6-4b47-9788-c6847f737392.png)


**官方链接**：https://github.com/ritwickdey/vscode-live-server-plus-plus


**使用介绍**: 和一般的 VS Code插件一样，可以直接点击侧边活动栏的插件市场图标，搜索 <font face="STCAIYUN" color=green size=5> Live Server </font>
 进行安装。

**注意事项**： 

打开一个项目，然后单击状态栏中的  <font face="STCAIYUN" color=green size=5>  GO Live </font> 以打开/关闭服务。

![image](https://user-images.githubusercontent.com/118866310/226111054-5f0de69b-29eb-45fc-bbf0-a4f217c3ac36.png)


### pdb
<font face="黑体" color=green size=5>pdb --- Python 的调试器¶ </font>


**官方链接**：https://docs.python.org/zh-cn/3/library/pdb.html

**使用介绍**: https://docs.python.org/zh-cn/3/library/pdb.html

**注意事项**: ~ 


### GDB
> 这里介绍 OneFlow 中使用<font color=Blue> gdb  debug</font>

Cmake 时候使用 <font face="黑体" color=green size=5>-DCMAKE_BUILD_TYPE=Debug </font>


<details open>
<summary> oneflow Debug 方式编译示例</summary>

```shell
git clone git@github.com:Oneflow-Inc/oneflow.git && cd oneflow 

mkdir -p build && cd build

cmake .. -C ../cmake/caches/cn/cuda.cmake   -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda  \
   -DCUDNN_ROOT_DIR=/usr/local/cudnn -DCMAKE_GENERATOR=Ninja -DCMAKE_BUILD_TYPE=Debug \
   -DCMAKE_EXPORT_COMPILE_COMMANDS=1

ninja -j32
```
</details>








<font face="黑体">我是黑体字</font>

<font face="微软雅黑">我是微软雅黑</font>

<font face="STCAIYUN">我是华文彩云</font>

<font color=red>我是红色</font>

<font color=#008000>我是绿色</font>

<font color=Blue>我是蓝色</font>

<font size=5>我是尺寸</font>


<font face="黑体" color=#008000 size=2>我是黑体，绿色，尺寸为5</font>

<font face="黑体" color=green size=5>我是黑体，绿色，尺寸为5</font>

<font face="微软雅黑" color=red size=5> </font>
