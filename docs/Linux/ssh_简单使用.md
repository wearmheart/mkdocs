# ssh 登录

<details open>
<summary> 登陆流程 </summary>

```
本地向远程服务端发起连接
 
服务端随机生成一个字符串发送给发起登录的本地端
 
本地对该字符串使用私钥（~/.ssh/id_rsa）加密发送给服务端
 
服务端使用公钥（~/.ssh/id_rsa.pub）对私钥加密后的字符串进行解密
 
服务端对比解密后的字符串和第一次发送给客户端未加密的字符串，若一致则判断为登录成功
```
</details>

## 远程登录服务器
**ssh user@hostname**

## 配置文件

创建文件 ~/.ssh/config
```
#config的文件内容

Host myserver1
    HostName IP地址或域名
    User 用户名

Host myserver2
    HostName IP地址或域名
    User 用户名
。。。
```
## 密钥登录
```
创建密钥：

ssh-keygen
执行结束后，~/.ssh/目录下会多两个文件：
id_rsa：私钥
id_rsa.pub：公钥
之后想免密码登录哪个服务器，就将公钥传给哪个服务器即可。
两种方法

1.touch ~/.ssh/authorized_keys
将公钥中的内容，复制到myserver中的~/.ssh/authorized_keys文件里即可

2.也可以使用如下命令一键添加公钥：
ssh-copy-id myserver
```
# ssh数据传输
SSH不仅可以用于远程主机登录，还可以直接在远程主机上执行操作。
##ssh 上传文件/文件夹
```
scp source destination
将source路径下的文件复制到destination中
可以一次多个source
```
## ssh 下载文件/文件夹
```
scp -r ~/home myserver:/home/acs/
将本地家目录中的home文件夹复制到myserver服务器中的/home/acs/目录下。
scp -r myserver:homework .
将myserver服务器中的~/homework/文件夹复制到本地的当前路径下 .可以为其他目录
```
# ssh 远程操控服务器
```
ssh myserver mkdir homework/dir -p
在服务器上执行命令

```


 [其他的](https://www.cnblogs.com/weafer/archive/2011/06/10/2077852.html)
