# Django

Django是一个开放源代码的Web应用框架,由Python写成。采用了MTV的框架模式,即模型M,视图V和模版T。



django-admin startproject mysitel
cd mysitel 
sudo lsof -i: 端口 

## manage.py包含项目管理的子命令,如:

1. python3 manage.py runserver启动服务

2. python3 manage.py startapp创建应用

3. python3 manage.py migrate数据库迁移

4. 直接执行python3 manage.py可列出所有的Django子命令

## 项目结构-项目同名文件夹

项目同名文件夹- mysite1/mysite1
-  `__init__`  : Python包的初始化文件
- wsgi.py : WEB服务网关的配置文件- Django正式启动时，需要用到
- urls.py : 项目的主路由配置- HTTP请求进入Django时，优先调用该文件
- settings.py : 项目的配置文件-包含项目启动时需要的配置

## 项目结构- settings.py

- settings.py 包含了Django项目启动的所有配置项
- 配置项分为公有配置和自定义配置
- 配置项格式例: BASE DIR = 'xxxx'
- 公有配置-Django官方提供的基础配置 https://docs.djangoproject.com/en/2.2/ref/settings/

## 项目 项目结构-公有配置

### BASEDIR

- 用于绑定当前项目的绝对路径(动态计算出来的)，所有文件夹都可以依懒此路径

### DEBUG

- 用于配置Django项目的启动模式,取值:
- True表示开发环境中使用开发调试模式(用于开发中)
- False 表示当前项目运行在生产环境中

- INSTALLED_ APPS -指定当前项目中安装的应用列表 :
- MIDDLEWARE -用于注册中间件
- TEMPLATES -用于指定模板的配置信息
- DATABASES -用于指定数据库的配置信息
- LANGUAGE CODE -用于指定语言配置
    - 英文: "en-us"
    - 中文: "zh-Hans"

- TIME_ZONE-用于指定当前服务器端时区
    * 世界标准时间: "UTC"
    * 中国时区: "Asia/Shanghai"
- ROOT_ _URLCONF -用于配置主 url配置'mysite1.urls'
- ROOT URLCONF = 'mysite 1.urls'

## 项目结构-自定义配置
- settings.py中也可以添加开发人员自定义的配置
- 配置建议:名字尽量个性化-以防覆盖掉公有配置
    * 例如: (ALIPAY KEY\= 'xxXxXX'
    * settings.py中的所有配置项，都可以按需的在代码中引入
    * 引入方式: from django.conf import settings

## URL和视图 
URL - 结构
- 定义一即统一资源定位符Uniform Resource Locator
- 作用-用来表示互联网上某个资源的地址
- URL的一般语法格式为(注: []代表其中的内容可省略) :
protocol :// hostname[:port] / path [?query][#fragment]
●http://tts.tmooc.cn/video/showVideo?menuld =657421
&version= AID999#subject

1. protocol (协议) http://tts.tmooc.cn
    * http通过HTTP访问该资源。 格式http:// 
    * https通过安全的HTTPS访问该资源。格式https://
    * file资源是本地计算机.上的文件。格式: file:///
2. hostname (主机名) http://tts.tmooc.cn
是指存放资源的服务器的域名系统(DNS)主机名、域名或IP地址

3. port (端口号) http://tts.tmooc.cn:80
    * 整数，可选，省略时使用方案的默认端口
    * 各种传输协议都有默认的端口号,如http的默认端口为80
4. path (路由地址) http://tts.tmooc.cn/video/showVideo
    * 由零或多个"/"符号隔开的字符串，一般用来表示主机上的
    一个目录或文件地址。路由地址决定了服务器端如何处理这
    个请求

5. query(查询)
    * /video/showVided?menuld=657421 &version= AID999
    * 可选，用于给动态网页传递参数，可有多个参数,用“&”符
    号隔开，每个参数的名和值用“=" 符号隔开。
6. fragment (信息片断)
    * version= AID999#subject
    * 字符串，用于指定网络资源中的片断。例如一个网页中有多个
    名词解释，可使用fragment直接定位到某一名词解释。

## 处理URL请求
浏览器地址栏- > http://127.0.0.1:8000/page/2003

1. Django 从配置文件中根据ROOT_ URLCONF找到主路由文件;默认情况下,
该文件在项目同名目录下的urls;例如 mysite1/mysite1/urls.py
2. Django 加载主路由文件中的urlpatterns 变量[包含很多路由的数组]
3. 依次匹配urlpatterns中的path，匹配到第一 个合适的中断后续匹配
4. 匹配成功-调用对应的视图函数处理请求，返回响应
5. 匹配失败-返回404响应

## 主路由- urls.py
- 主路由-urls.py样例

```python
from django.urls import path
from . import views
urlpatterns[
    path('admin/', admin.site.urls),
    path('page/2003/', views.page_ 2003),
    path('page/2004/', views.page_ 2004), 
]
```

## 视图函数

- 视图函数是用于接收一个浏览器请求(HttpRequest对象)
- 并通过HttpResponse对象返回响应的函数。
- 此函数可以接收浏览器请求并根据业务逻辑返回相应的响应内容给浏览器
- 语法:
```python
def xXX_ _view(request[, 其它参数..]):
return HttpResponse对象
```

## 小结

●URL全貌
●Django处理URL对应请求流程
●主路由
●视图函数


## 路由配置- path
- path()函数.
- 导入- from django.urls import path
- 语法- path(route, views, name= None)
- 参数:
    1. route:字符串类型，匹配的请求路径
    2. views:指定路径所对应的视图处理函数的名称()
    3. name:为地址起别名，在模板中地址反向解析时使用

## path转换器

- 语法: <转换器类型:自定义>
- 作用: 若转换器类型匹配到对应类型的数据，则将数据按照关键字传参的方式传递给视图函数
- 例子: path('page/ <int:page>', views.xxx)



| 转换器类型 | 作用                                                    | 样例                                                 |
| ---------- | ------------------------------------------------------- | ---------------------------------------------------- |
| str        | 匹配除了'/' 之外的非空字符串                            | "v1/users/ <str:username>" 匹配 /v1/users/guoxiaonao |
| int        | 匹配0或任何正整数。返回一个 int                         | "page/ <int:page>" 匹配 /page/100                    |
| slug       | 匹配任意由ASCII字母或数字以及连字符和下划线组成的短标签 | "detail/ <slug:sl>" 匹配 /detail/this-is-django      |
| path       | 匹配非空字段,包括路径分隔符'/'                          | "v1/users/ <path:ph> 匹配 /v1/goods/a/b/C            |



## 路由配置- re_path()

- re_ path()函数
- 在url的匹配过程中可以使用正则表达式进行精确匹配
- 语法:
  - re_ path(reg, view, name=xxx)
  - 正则表达式为命名分组模式(?P<name>pattern) ;匹配提取
  参数后用关键字传参方式传递给视图函数




## 请求方法

| 序号 | 方法    | 描述                                                                                                                                    |
| ---- | ------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | GET     | 请求指定的页面信息，并返回实体主体。                                                                                                    |
| 2    | HEAD    | 类似于get请求，只不过返回的响应中没有具体的内 容，甩于获取报头                                                                          |
| 3    | POST    | 向指定资源提交数据进行处理请求(例如提交表单或者上传文件)。数据被包含在请求体中。POST请求  可能会导致新的资源的建立和/或已有资源的修改。 |
| 4    | PUT     | 从客户端向服务器传送的数据取代指定的文档的内容。                                                                                        |
| 5    | DELETE  | 请求服务器删除指定的页面。                                                                                                              |
| 6    | CONNECT | HTTP/1.1协议中预留给能够将连接改为管道方式的代理服务器。                                                                                |
| 7    | OPTIONS | 允许客户端查看服务器的性能。                                                                                                            |
| 8    | TRACE   | 回显服务器收到的请求，主要用于测试或诊断。                                                                                              |

## Django中的请求

- 请求在Django中实则就是视图函数的第一-个参数， 即HttpRequest对象
- Django接收到http协议的请求后，会根据请求数据报文创建HttpRequest对象
- HttpRequest对象通过属性描述了请求的所有相关信息

## Django中的请求(续)

- path_ info: URL字符串
- method:字符串，表示HTTP请求方法，常用值: 'GET'、 'POST'
- GET: QueryDict查询字典的对象，包含get请求方式的所有数据
- POST: QueryDict查询字典的对象，包含post请求方式的所有数据
- FILES: 类似于字典的对象，包含所有的上传文件信息


- COOKIES: Python字典， 包含所有的cookie, 键和值都为字符串
- session: 似于字典的对象，表示当前的会话
- body:字符串，请求体的内容(POST或PUT)
- scheme :请求协议('http'/'https')
- request.get_ full_ path() :请求的完整路径
- request.META: 请求中的元数据(消息头)
- request.META['REMOTE ADDR'] :客户端IP地址

## HTTP状态码的英文为HTTP Status Code

下面是常见的HTTP状态码:
- 200 -请求成功
- 301 -永久重定向-资源(网页等)被永久转移到其它URL
- 302 -临时重定向
- 404 -请求的资源(网页等)不存在
- 500 -内部服务器错误;


## Django中的响应对象

构造函数格式:

    HttpResponse(content=响应体，content_type= 响应体数据类型(default = html), status=状态码)

作用: 

    向客户端浏览器返回响应，同时携带响应体内容

常用的Content-Type如下

  - 'text/htm]' (默认的，htmI文件)
  - 'text/plain' (纯文本)
  - 'text/css' (css文件)
  - 'text/javascript' (js文件)
  - 'multipart/form-data' (文件提交)
  - 'application/json' (json传输)
  - 'application/xml' (xml文件)


## HttpResponse子类


| 类型                    | 作用           | 状态码 |
| ----------------------- | -------------- | ------ |
| HttpResponseRedirect    | 重定向         | 302    |
| HttpResponseNotModified | 未修改         | 304    |
| HttpResponseBadRequest  | 错误请求       | 400    |
| HttpResponseNotFound    | 没有对应的资源 | 404    |
| HttpResponseForbidden   | 请求被禁止     | 403    |
| HttpResponseServerError | 服务器错误     | 500    |

## GET请求和POST请求

无论是GET还是POST，统一都由视图函数接收请求，通过判断request.method区分具体的请求动作

样例:



```python
if request. method == 'GET':
    处理GET请求时的业务逻辑
elif request . method == ' POST' :
    处理POST请求的业务逻辑
else:
    其他请求业务逻辑
```


- GET请求动作， - -般用于向 服务器获取数据
- 能够产生GET请求的场景:
  - 浏览器地址栏中输入URL,回车后
  - `<a href="地址?参数=值&参数=值" >`
  -  form表单中的method为get


GET请求方式中，如果有数据需要传递给服务器，通常会用
查询字符串(Query String)传递
[注意:不要传递敏感数据]

URL格式: xxx?参数名1=值1&参数名2=值2...
 - 如: http://127.0.0.1:8000/page1?a= 100&b=200

服务器端接收参数

  * 获取客户端请求GET请求提交的数据_

## GET处理 
方法示例:
```python
request.GET[ '参数名' ]
# QueryDict
request.GET.get('参数名'，'默认值')
request.GET.getlist('参数名' )
# mypage?a=100&b=200&C= 300&b=400
# request. GET=QueryDict({'a':['100'] ，'b':[ ' 200', '400']，'c':[' 300'] 


# a = request.GET[' a'] 
# b = request.GET.getlist('b')
```


## POST处理 

- POST请求动作，-般用于向服务器提交大量/隐私数据数 据

-客户端通过表单等POST请求将数据传递给服务器端，如:

```html
<form method= " post' actign="/1ogin">
姓名: <input type="text" name=" username">
<input type= ' submit' value='登陆 '>
</form>
</html>
```

## Django的设计模式及模板层


![传统的MVC](https://foruda.gitee.com/images/1676289633364816667/a79cf741_10213136.png "传统的MVC")


![Django的MTV模式](https://foruda.gitee.com/images/1676289868421836822/48404061_10213136.png "Django的MTV模式")

## 模板配置 TEMPLATES

创建模板文件夹<项目名>/templates

- 在settings.py中TEMPLATES配置项
  1. BACKEND :指定模板的引擎
  2. DIRS: 模板的搜索目录(可以是一-个或多个)
  3. APP_DIRS:是否要在应用中的templates文件夹中搜索模板文件
  4. OPTIONS :有关模板的选项
- 配置项中需要修改部分
- 
设置 DIRS - "DIRS': [os.path.join(BASE_ DIR, 'templates')],


在视图函数中:
```python
from django. shortcuts import render
return render(request, '模板文件名'，字典数据)
```


## 视图层与模板层之间的交互

1. 视图函数中可以将Python变量封装到字典中传递到模板

样例:
```python
def xXx_ _vi ew( request)
dic={
"变量1":"值1"，
"变量2":"值2"，
}
return render( request，'xxx.html' ,dic) 
```

1. 模板中，我们可以用{{变量名}}的语法调用视图传进来的变量


## 模板层-变量和标签

视图函数中可以将Python变量封装到字典中传递到模板上

样例:

```python
def xxx_view( request)
    dic,= {
    "变量1":"值1",
    "变量2":"值2",
    }
    return render(request，' xxx.htm1'，dict)
```

能传递到模板中的数据类型

1. str 字符串 
2. int- 整型
3. list -数组
4. tuple -元组
5. dict -字典
6. func-方法
7. obj-类实例化的对象


在模板中使用变量语法

- {{变量名}}
- {{变量名.index }}
- {{变量名.key}}
- {{对象.方法}
- {{函数名}}

作用:将一些服务器端的功能嵌入到模板中，例如流程控制等
标签语法

```python
{%标签、%}
{%结束标签%}
```


if标签 语法:

```python
{% if条件表达式1 %}
...
{% elif条件表达式2 %}
...
{% elif条件表达式3 %}
...
{% eIse %}
...
{% endif %}
```


注意:

1. if条件表达式里可以用的运算符==,!=, <,>, <=,>=, in, not  in, is, is not, not、 and、or
2. 在if标记中使用实际括号是无效的语法。如果您需要它们指示优先级，则应使用嵌套的if标记。

## 模板过滤器
- 定义:在变量输出时对变量的值进行处理
- 作用:可以通过使用过滤器来改变变量的输出显示
- 语法: {{变量|过滤器1:参数值1' | 过滤器2:参数值2' .. }}
官方文档:
https://docs.djangoproject.com/en/2.2/ref/templates/builtins/


常用过滤器
| 过滤器            | 说明                                                                                        |
| ----------------- | ------------------------------------------------------------------------------------------- |
| lower             | 将字符串转换为全部小写。                                                                    |
| upper             | 将字符串转换为大写形式                                                                      |
| safe              | 默认不对变量内的字符串进行htmI转义                                                          |
| add: "n"          | 将value的值增加n                                                                            |
| truncatechars:'n' | 如果字符串字符多于指定的字符数量,那么会被截断。截断的字符串将以可翻译的省略号序列....结尾。 |



## URL解析 
1. 绝对地址:  http://127.0.0.1:8000/page/1
2. 相对地址: 
    1. '/page/1' - '' 开头的相对地址，浏览器会把当前地址栏
   里的协议，ip和端口加上这个地址，作为最终访问地址，即如果当
   前页面地址栏为http://127.0.0.1:8000/page/3;当前相对地址最终
   结果为http://127.0.0.1:8000 + /page/1
   2.  'page/1'- 没有/' 开头的相对地址，浏览器会根据当前
url的最后-一个 `/` 之前的内容加上该相对地址作为最终访问地址，例
如当前地址栏地址为http://127.0.0.1:8000/topic`/`detail; 则该相对
地址最终结果为http://127.0.0.1:8000/topic/ + page/1

## URL反向解析 
- url反向解析是指在视图或模板中，用path定义的名称来动态查找
或计算出相应的路由
- path函数的语法
    - path(route, views, name="别名")
    - path('page', views.page_view, name='page_url')

- 根据path中的name='关键字传参给url确定了个唯一确定的名字，在模板或视图中，可以通过这个名字反向推断出此url信息


<details open>
<summary>模板中-通过ur|标签实现地址的反向解析 </summary>

```shell
{% ur] '别名' %}
{% ur] 别名' ' 参数值1' '参数值2' %}
ex :
{% ur] 'pagen' '400' %}
{% ur] 'person' age='18' name='gxn' %}
```
</detail>

## url反向解析(续1)

<details open>
<summary> 在视图函数中->可调用django中的reverse方法进行反向 </summary>

```python
from django.ur1s import reverse
reverse('别名'，args=[]， kwargs={})
ex :
print( reverse(' pagen' , args= [ 300] ))
print( reverse(' person'，kwargS=
{' name': 'xixi','age' :18}))
```
</details>


## 小结

- 请求(request)和响 应(HttpResponse)
- GET/POST处理- request.GET/POST
- MVC和MTV
- 模板层基础配置
- 模板变量/标签/过滤器/继承
- url反向解析

## 静态文件 

静态文件配置- settings.py中[该配置默认存在]

1. 配置静态文件的访问路径
    - 通过哪个ur|地址找静态文件
    - STATIC URL = '/static/'
    - 说明:
    指定访问静态文件时是需要通过/static/xxx或
    http://127.0.0.1:8000/static/xxx
    [xxx表示具体的静态资源位置]
2. 配置静态文件的存储路径 `STATICELES_DIRS`
<details open>
<summary> STATICFILES_DIRS 保存的是静态文件在服务器端的存储位置 </summary>

```shell
# file: setting.py
STATICFILES_DIRS = (
os.path.join(BASE_DIR,"static"),
)
```
</details>


## 静态文件访问(续)

模板中访问静态文件- img标签为例
方案2

通过{%static%}标签访问静态文件
1. 加载 static - {% load static %}
2. 使用静态资源- {% static '静态资源路径' %}
   示例

```html
<img src="{% static 'images/lena.jpg' %}">
```

## Django 应用分布式路由 
![什么是应用?](https://foruda.gitee.com/images/1676475979524645667/45b27197_10213136.png "什么是应用?")

### 创建应用
1. 步骤1:  用manage.py中的子命令 `startapp` 创建应用文件夹
`python3 manage.py startapp music`
2. 步骤2:  在settings.py的 `INSTALLED_APPS` 列表中配置安装此应用 

<details open>
<summary> settings.py配置样例 </summary>

```python
INSTALLED_APPS = [
    # ....
    'user', # 用户信息模块 
    'music',# 音乐模块
]
```
</details>

<details open>
<summary> 创建后 </summary>

```shell
├── music
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations    # M: DB 数据库
│   │   └── __init__.py
│   ├── models.py     # M: DB 模型层
│   ├── tests.py      # 测试模块
│   └── views.py      # V: 应用视图
```
</details>



![分布式路由](https://foruda.gitee.com/images/1676476577884293103/b1bf5d48_10213136.png "分布式路由")

## 配置分布式路由 

### 步骤 1 - 主路由中调用include函数
- 语法: `include('app名 字.url模块名')`
- 作用:用于将当前路由转到各个应用的路由配置文件的urlpatterns
进行分布式处理

示例：
以 `http://127.0.0.1:8000/music/index` 为例:

```python
from django.urls import path,include 
from . import views
urlpatterns = [
    path( 'admin/'，admin.site.urls) ,
    path( 'test static' ，views.test_static) ,
    path( 'music/', include('music.urls' ) )
]
```

### 步骤2 - 应用下配置 urls.py
应用下手动创建 uris.py 文件
内容结构同主路由完全一样

```python
from django.urls import path
from . import views
urlpatterns =[
    #http://127.0.0.1:8000/music/index
    path( 'index'， views.index_view )
]
```


## 应用内部可以配置模板目录

1. 应用下手动创建 `templates` 文件夹 N
2. settings.py中 开启应用模板功能
  `TEMPLATE配置项中的'APP_DIRS'值为True即可`

应用下 `templates` 和外层 `templates` 都存在时，django 查找模板规则
1. 优先查找外层 `templates` 目录下的模板
2. 按 `INSTALLED_APPS` 配置下的应用顺序逐层查找


## 小结
- 应用
  - 创建
  - 注册
- 分布式路由
  - 主路由 - include
  - 应用下urls.py编写 urlpatterns

## 模型层 

![MTV](https://foruda.gitee.com/images/1676478089132948278/958ced12_10213136.png "MTV")

## Django配置mysq|
- 安装mysqlclient [版本mysqlclient 1.3.13以上]
- 安装前确认ubuntu是否已安装`python3-dev` 和`default-libmysqlclient-dev`

1. `sudo apt list --installed|grep -E 'libmysqlclient-dev|python3-dev'` .
2. 若命令无输出则需要安装 - `sudo apt-get install python3-dev default-libmysqlclient-dev`

`sudo pip3 install mysqlclient` 注意：`conda 环境直接用 conda  install mysqlclient 就好`

检测是否装好 `mysqlclient` 包：
```shell
(qqhr) warmheart@VM-12-12-ubuntu:~/learn_django$ sudo pip3 freeze|grep -i 'mysql'
mysqlclient==2.1.1
```
## mysql的安装（linux、ubuntu20.04）

- 第一步 安装:
    - 步骤一； 打开管理员权限+输入密码；

      ```shell
      $ sudo su
      ```

    - 步骤二；安装

      ```shell
      $ apt install mysql-server
      ```

- 第二步 安装完查看mysql启动状态:
    ```shell
    $ systemctl status mysql 
    ```
    或者
    ```shell
    $ service mysql status
    ```

- 第三步 直接使用root账户登录然后修改密码就可以了，可代替下面第3步的操作：
    1. `sudo mysql -uroot -p  `    回车输入`密码` 登录
    2. 修改密码：`alter user 'root'@'localhost' identified with mysql_native_password by '这里是密码';`  注意：`;`号结尾 。
    3. 执行：`flush privileges;`；使密码生效，然后使用root用户登录。

- 第四步 创建自己的用户：
    ```shell
    create user '用户名'@'%' identified with mysql_native_password by '密码';
    grant all privileges on *.* to '用户'@'%' with grant option;
    flush privileges; # 保存策略 
    # 完成了，直接远程登录。
    ```
    注意： "localhost"，是指该用户只能在本地登录，不能在另外一台机器上远程登录。如果想远程登录的话，将"localhost"改为"%"，表示在任何一台电脑上都可以登录。也可以指定某台机器可以远程登录。

- 其他 数据库的启动|重启|关机命令 ；

    | 数据库的            | 启动  | 重启    | 关机命令 |
    | ------------------- | ----- | ------- | -------- |
    | sudo  service mysql | strat | restart | stop     |

    及是 `sudo service mysql start/restart/stop`

相关教程:
- [Ubuntu 20.04 安装mysql数据库教程](https://blog.csdn.net/cyz141001/article/details/119028923)


或者

systemctl status mysql.service



## Django配置mysql (续)


- 1. 创建数据库,进入mysql数据库执行
     - `create database 数据库名 default charset utf8;`
     - `通常数据库名跟项目名保持一致`

- 2. settings.py里进行数据库的配置修改 
    1.  `DATABASES` 配置项的内容，由 `'ENGINE': 'django.db.backends.sqlite3'` 变为 `'ENGINE': 'django.db.backends.mysql'`,
    2.  添加 其他配置示例如下:
   
    ```python
        DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME':'mysitel', # 数据库名
            'USER': 'warmheart',
            'PASSWORD':'13467947371fwFW!',
            'HOST':'127.0.0.1',
            'PORT':'3306'
        }
    }
    ```

## 什么是模型

- 模型是一个Python类,它是由django.db.models.Model派生出的子类。
  
- 一个模型类代表数据库中的一张数据表

- 模型类中每一个类属性都代表数据库中的一个字段。

- 模型是数据交互的接口，是表示和操作数据库的方法和方式

## ORM框架


![ORM](https://foruda.gitee.com/images/1676482006679819467/afffe6cf_10213136.png "ORM")


- 定义: ORM (Object Relational Mapping) 即对象关系映射，它
是一种程序技术，它允许你使用类和对象对数据库进行操作，从而
避免通过SQL语句操作数据库

- 作用:
  1. 建立模型类和表之间的对应关系，允许我们通过面向对象的方式来操作数据库。
  2. 根据设计的模型类生成数据库中的表格。
  3. 通过简单的配置就可以进行数据库的切换。

## ORM框架(续)
### 优点:
- 只需要面向对象编程，不需要面向数据库编写代码.
  - 对数据库的操作都转化成对类属性和方法的操作.
  - 不用编写各种数据库的sql语句.
- 实现了数据模型与数据库的解耦，屏蔽了不同数据库操作上的差
异.
  - 不在关注用的是mysql、oracl..等数据库的内部细节.
  - 通过简单的配置就可以轻松更换数据库,而不需要修改代码

### 缺点
- 对于复杂业务，使用成本较高
- 根据对象的操作转换成SQL语句，根据查询的结果转化成对象,
在映射过程中有性能损失.

## 模型示例

- 此示例为添加一个 `bookstore_book` 数据表来存放图书
馆中书目信息

1. **添加一个bookstore的app**
    ```shell
    $ python3 manage.py startapp bookstore
    ```

2. **添加模型类并注册app**

模型类代码示例

```python
# file : bookstore/models.py 
from django.db import models

# Create your models here.
class Book(models.Model):
    title = models.CharField("书名",max_length=50,default='')
    price = models.DecimalField('定价',max_digits=7,decimal_places=2,default=0.0) # 00000.00
```

3. 数据库迁移
      - 迁移是Django同步您对模型所做更改(添加字段，删除模型等)到您的数据库模式的方式
      - 生成迁移文件- 执行 `python manage.py makemigrations` 将应用下的models.py文件生成一个中间文 件并保存在 `migrations` 文件夹中
      - 执行迁移脚本程序-执行 `python manage.py migrate`执行迁移程序实现迁移。将每个应用下的migrations目录中的中间文件同步回数据库

 
`python manage.py migrate`可能遇到错误:

```shell
django.db.utils.OperationalError: (1044, "Access denied for user 'warmheart'@'%' to database 'mysitel'")
```

原因权限不够：
解决方案，在Mysql里面写入本地访问权限：
`GRANT ALL PRIVILEGES ON *.* TO 'warmheart'@'%';`

- [访问MySQL数据库提示权限不够的解决方案](https://huaweicloud.csdn.net/6335795ed3efff3090b584b7.html?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Eactivity-1-116140575-blog-113163490.pc_relevant_3mothn_strategy_recovery&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Eactivity-1-116140575-blog-113163490.pc_relevant_3mothn_strategy_recovery&utm_relevant_index=2)

- [修改mysql的密码时遇到问题ERROR 1064 (42000): You have an error in your SQL syntax； check the manual that corre](https://blog.csdn.net/lic1697067085/article/details/120234287)

其他 mysql常用指令:
```shell
$ SHOW DATABASES;  # 语句用于列出数据库系统中所有的数据库
$ flush privileges; # 保存策略
$ desc table; # 查看表结构
```
## 模型类-创建
●模型类-创建

```python
from django.db import models
class 模型类名(models.Mode1):
    字段名= models.字段类型(字段选项)
```
## 小结
- 模型层介绍
- 配置mysql
- ORM
- 创建模型类 

## 创建模型类流程(续)
- 任何关于表结构的修改，务必在对应模型类.上修改
  
例:为bookstore_ book表添加一个名为info的字段
varchar(100)
解决方案
1. 模型类中添加对应类属性
2. 执行数据库迁移

## 模型类- 字段类型
- BooleanField()
      1. 数据库类型:tinyint(1)
      2. 编程语言中:使用Irue或Fa!se来表示值
      3. 在数据库中:使用1或0来表示具体的值

- CharField()
      1. 数据库类型:varchar
      2. 注意:必须要指定max_length参数值
      3. 

- DateField()
    1. 数据库类型:date
    2. 作用:表示日期.
    3. 参数:
        1. auto_ now:每次保存对象时，自动设置该字段为当前时间(取值:True/False)。
        2. auto_now_add:当对象第-次被创建时自动设置当前时间(取值:True/False)。
        3. default: 设置当前时间(取值:字符串格式时间如: '2019-6-1)。
        4. 以上三个参数只能多选一


- DateTimeField()
    1. 数据库类型:datetime(6)
    2. 作用:表示日期和时间
    3. 参数同DateField

- FloatField()
    1. 数据库类型:double
    2. 编程语言中和数据库中都使用小数表示值


- DecimalField()
    1. 数据库类型:decimal(x,y)
    2. 编程语言中:使用小数表示该列的值
    3. 在数据库中:使用小数
    4. 参数:
       - max_ digits: 位数总数，包括小数点后的位数。该值必须大于等于decimal_places.
       - decimal_places:小数点后的数字数量


- EmailField()
    1. 数据库类型:varchar
    2. 编程语言和数据库中使用字符串
   
- IntegerField()
    1. 数据库类型:int
    2. 编程语言和数据库中使用整数

- ImageField()
    1. 数据库类型:varchar(100)
    2. 作用:在数据库中为了保存图片的路径
    3. 编程语言和数据库中使用字符串
- TextField()
    1. 数据库类型:longtext
    2. 作用:表示不定长的字符数据

更多精彩请阅官方文档
https://docs.djangoproject.com/en/2.2/ref/models/fields/#field-types

## 模型类-字段选项

- 字段选项,指定创建的列的额外的信息
- 允许出现多个字段选项，多个选项之间使用,隔开
- primary_key: 如果设置为True,表示该列为主键，如果指定一个字段为主键，则此
数库表不会创建id字段
- blank: 设置为True时， 字段可以为空。设置为 False 时, 字段是必须填写
- null:
    - 如果设置为True,表示该列值允许为空。
    - 默认为False,如果此选项为False建议加入 default 选项来设置默认值
  
- default：设置所在列的默认值如果字段选项 null = False 建议添加此项
- db_ index： 如果设置为True,表示为该列增加索引
- unique： 如果设置为True,表示该字段在数据库中的值必须是唯一(不能
重复出现的)
- db_column：指定列的名称如果不指定的话则采用属性名作为列名
- verbose_ name： 设置此字段在admin界面以上的显示名称
  
字段选项样例
```python
#创建一个属性,表示用户名称，长度30个字符,必须是唯一的,不能为空，添加
索引
name = mode1s.charFie1d (max_1ength=30，unique=True ，
nu11=False，db_index=True)
```

更多精彩，请参阅官方文档
https://docs.djangoproject.com/en/2.2/ref/models/fields/#field-options

好习惯:修改过字段选项{添加或更改] 均要执行
makemigrations和migrate

## 模型类-Meta类
使用内部Meta类来给模型赋予属性，Meta类下有很多内建的类属
性，可对模型类做一些控制
示例: .
# file : bookstore/models.py
```python
from django.db import models

# Create your models here.
class Book(models.Model):
    title = models.CharField("书名",max_length=50,default='')
    price = models.DecimalField('定价',max_digits=7,decimal_places=2,default=0.0) # 00000.00 
    class Meta:
        db_table = 'book' # 可改变当前模型类对应的表名
```



## 修改模型类
模型类 - **Book表名book**
- title - CharField(50)-书名唯一

- pub - CharField(100)-出版社(非空

- (price - DecimalField - 图书定价 ~ 总位7/小数点2位

- market price -图书零售价总位7/小数点2位

模型类 - **Author表名author**
- name - CharField(11)– 姓名非空
- age - IntegerField - 年龄默认值为 1
- email - EmailField - 邮箱允许为空

## 小结
字段选项& Meta内部类

## ORM-基本操作-创建数据
数据库的迁移文件混乱的解决办法
数据库中django_migte与之对应，否则migrate会报错目各应用中的migrate文件应与之对应，否则migrate会报错
解决方案:
- 1.删除所有migrations 里所有的000?_XXXX.py ( _init_.py 除外)
- 2．删除数据库: `sql> drop database mywebdb;`
- 3.重新创建数据库 sql> create datebase mywebdb default charset...;
- 4.重新生成migrations里所有的000?_XXXX.pypython3 manage.py makemigrations 
- 5.重新更新数据库 python3 manage.py migrate


## ORM-操作

基本操作包括增删改查操作，即(CRUD操作)
CRUD是指在做计算处理时的增加(Create)、读取查询(Read)、更新(Update)和删除(Delete)
心
ORM CRUD核心->模型类.管理器对象

## 创建数据

每个继承自models.Model的模型类，都会 有一个objects对象被同样继承下来。这个对象叫管理器对象
数据库的增删改查可以通过模型的管理器实现

class MyMode1 (models.Mode1):
    MyMode1.objects.create(...) # objects是管理器对象

DjangoORM使用一种直观的方式把数据库表中的数据表示成
Python对象
创建数据中每一条记录就是创建一个数据对象

- 方案1 MyModel.objects.create(属性1=值1,属性2=值...)
    - 成功:返回创建好的实体对象
    - 失败: 抛出异常

- 方案2 创建MyModel实例对象，并调用save()进行保存
    ```python
    obj = MyMode1 (属性=值,属性=值)
    obj.属性=值
    obj.save()
    ```

Django Shell

在Django提供了一个交互式的操作项目叫 `Django Shell` 它能够在
交互模式用项目工程的代码执行相应的操作
利用`Django Shell`可以代替编写view的代码来进行直接操作
注意:项目代码发生变化时，重新进入Django shell
启动方式: 
 `python3 manage.py shell`

```shell
show databases; # 查看数据库，选中使用数据库，并查看数据库表，具体操作命令如下：
use xxxx;
show tables;
```

##  ORM-查询操作

- 数据库的查询需要使用管理器对象进行
- 通过MyModel.objects管理器方法调用查询方法
| 方法      | 说明                              |
| --------- | --------------------------------- |
| all()     | 查询全部记录,返回QuerySet查询对象 |
| get()     | 查询符合条件的单一记录            |
| filter()  | 查询符合条件的多条记录            |
| exclude() | 查询符合条件之外的全部记录        |

- all()方法
用法: MyModel.objects.all()
作用:查询MyModel实体中所有的数据
等同于 select * from tabel
返回值: QuerySet容器对象，内部存放MyModel实例
```python
from bookstore.models import Book
books = Book.objects.a11()
for book in books :
print("书名"，book.title， ' 出版社:'，book. pub)
```


可以在模型类中定义 __str__ 方法， 自定义 `QuerySet` 中的输出格式
例如在Book模型类下定义如下:
```python
def __str__(self):
    return '%S_ %S_ %S_ %S'%(self.title, self.price, self.pub
,self.market_ price)
```

```shell
则在djangoshell中可得到如下显示输出
In [20]: Book.objects.all()
0ut[20]: <QuerySet [<Book: Python_ 20.00 清华大学出版社25. 00
>，<Book: Django_ 70.00_ 清华大学出版社_ 75.00>， <Book: HTML5_ 9
0.00_清华大学出版社_ 105.00>, <Book: JQuery_ 90.00_ 机械工业出
版社_ 85. 00>, <Book: Linux_ 80.00机械工业出版社_ 65. 00>]>
```

- values('列1'，'列2'..)
    - 用法: MyModel.objects.values(..)
    - 作用: 查询部分列的数据并返回
    - 等同于 select 列1，列2 from xXx
    - 返回值: QuerySet
    - 返回查询结果容器，容器内存字典，每个字典代表一条数据,
    - 格式为 : {'列1':值1,'列2':值2}

-  values_list('列1';列...)
   - 用法:MyModel.objects.values_list(...)
   - 作用:返回元组形式的查询结果
   - 等同于select列1,列2 from xxx
   - 返回值:QuerySet容器对象,内部存放元组
   - 会将查询出来的数据封装到元组中，再封装到查询集合QuenySer中

- order_by()
- 用法:MyModel.objects.order_by('-列;列")
- 作用:与all()方法不同，它会用SQL语句的ORDER BY子句对查询结果
进行根据某个字段选择性的进行排序
说明:
- 默认是按照升序排序，降序排序则需要在列前增加'-'表示

## 小结

●查询方法- all()

●查询方法- values()

●查询方法- values_ list()

●查询方法-order_ _by()

```html
    <table border="l">
        <tr>
            <th> id</th>
            <th>title</th>
            <th>pub</th>
            <th>price</th>
            <th> market_price</th>
            <th> op </th>
        </tr>

        {% for book in all_book %}
            <tr>
                <th>{{ book.id }}</th>
                <th>{{ book.title }}</th>
                <th>{{ book.pub }}</th>
                <th>{{ book.price }} </th>
                <th>{{ book.mark_price }}</th>
                <td>
                    <a href="">更新</a>
                    <a href="">删除</a>
                </td>
            </tr>
        {% endfor %}
```
```shell
+----+--------+-------+------------+-----------------+
| id | title  | price | mark_price | pub             |
+----+--------+-------+------------+-----------------+
|  1 | Python | 20.00 |      25.00 | 清华出版社      |
|  2 | HTML   | 90.00 |     100.00 | 清华出版社      |
|  3 | Vuen   | 20.00 |      35.00 | 清华出版社      |
+----+--------+-------+------------+-----------------+
```



## ORM-查询操作-2
> 条件查询，怎么加条件
- filter(条件)
    - 语法: MyModel.objects.filter(属性1=值1,属性2=值2)
    - 作用:返回包含此条件的全部的数据集
    - 返回值:QuerySet容器对象，内部存放MyModel实例
    说明: 当多个属性在一起时为"与"关系，即当

![输入图片说明](https://foruda.gitee.com/images/1676559782766302544/319e3eba_10213136.png "屏幕截图")

![输入图片说明](https://foruda.gitee.com/images/1676559924965392641/9dfabedc_10213136.png "屏幕截图")

![输入图片说明](https://foruda.gitee.com/images/1676559963190245200/f314e324_10213136.png "屏幕截图")

思考?如何做非等值的过滤查询，即where id > 1

尝试: Book.objects.filter(id > 1) ?

![输入图片说明](https://foruda.gitee.com/images/1676560311810794298/6fc5ecdc_10213136.png "屏幕截图")

![输入图片说明](https://foruda.gitee.com/images/1676560336738175966/de77bc00_10213136.png "屏幕截图")

![输入图片说明](https://foruda.gitee.com/images/1676560413733223425/b8fd47f3_10213136.png "屏幕截图")

![输入图片说明](https://foruda.gitee.com/images/1676560440059950264/4cf897b3_10213136.png "屏幕截图")

更多精彩，请参阅官方文档: 
https://docs.djangoproject.com/en/2.2/ref/models/querysets/#field-lookups

## 小结 
条件查询
1.  filter/exclude - QuerySet
2. get - obj
- 查询谓词
- 类属性 + '__' + 谓词


## ORM - 更新操作

## ORM - 删除操作

## F对象 和 Q对象

## 聚合查询和原生数据库操作

## 项目部署

1. 用 `uWSGI` 替代 `python manage.py runserver` 方法启动服务器
2. 配置 `nginx` 反向代理服务器
3. 用 `nginx` 配置静态文件路径解决静态路径问题

WSGI (Web Server Gateway Interface)Web服务器网关接口，是
Python应用程序或框架和Web服务器之间的一种接口，被广泛使
用,使用 `python manage.py runserver` 通常只在开发和测试环境中使用, 当开发结束后，完善的项目代码需要在一个高效稳定的环境中运行这时可以使用WSGI。

uWSGI是WSGI的一种, 它实现了http协议WSGl协议以及uwsgi协议
uWSGI功能完善，支持协议众多，在python web圈热度极高

**uWSGI主要以学习配置为主**
## 配置uWSGI

添加配置文件项目同名文件夹/uwsgi.ini
如: `mysite1/mysite1/uwsgi.ini`
文件以[uwsgi]开头，有如下配置项:

套接字方式的IP地址:端口号[此模式 需要有nginx]

`socket= 127.0.0.1:8000`

Http通信方式的IP地址:端口号

`http = 127.0.0.1:8000`


![输入图片说明](https://foruda.gitee.com/images/1676560795505499865/f28b933c_10213136.png "屏幕截图")


<summary>uwsgi.ini</summary>

```shell
项目当前工作目录
  chdir=/home/tarena/.../my_project
项目中wsgi.py文件的目录，相对于当前工作目录
  wsgi-file = my_project/wsgi.py
进程个数
  process=4
每个进程的线程个数
 threads=2
服务的pid记录文件
 pidfile=uwsgi.pid
服务的目志文件位置
 daemonize=uwsgi.log
开启主进程管理模式
 master=True
```
注意:
<details close>
<summary> 解决conda环境安装 uwsgi 错误 </summary>

```shell
I almost want to give up, then I find this page: https://github.com/conda-forge/uwsgi-feedstock

Now you can install uwsgi though conda:

conda config --add channels conda-forge

conda install uwsgi
```
</details>

特殊说明: Django 的settings.py需要做如下配置

1. 修改settings.py将 DEBUG=True 改为 DEBUG=False
2. 修改settings.py将 ALLOWED_HOSTS = [] 改为
ALLOWED_HOSTS = ['网站域名']或者['服务监听的ip地址']

## uWSGI的运行管理
- 启动uwsgi
cd到 uWSGI.ini 配置文件所在目录
```shell
$   uwsgi --ini uwsgi.ini
```
- 停止uwsgi 
  
cd到 uWSGI.ini 配置文件所在目录 
```shell
$  uwsgi --stop uwsgi.pid
```
- 检测： `ps aux | grep 'uwsgi'`


## 配置 nginx 
修改nginx的配置文件 `/etc/nginx/sites-enabled/default`;
`sudo vim 该文件`
```
#在server节点下添加新的Tocation项，指向uwsgi的ip与端口。
server {
 location / {
uwsgi_pass 127.0.0.1:8000; # 重定向到127 .0.0.1的
8000端口
include /etc/nginx/uwsgi_params; #将所有的参数转到uwsgi下
  }
}
```

## nginx 启动/停止
```shell
$ sudo /etc/init.d/nginx start|stop|restart|status
#或
$ sudo service nginx start|stop|restart|status
```
- 启动- sudo /etc/init.d/nginx start
- 停止- sudo /etc/init.d/nginx stop
- 重启- sudo /etc/init.d/nginx restart

注意: nginx配置 只要修改，就需要进行重启，否则配置不生效

- `sudo nginx -t` 检测配置文件语法

![输入图片说明](https://foruda.gitee.com/images/1676611029506777917/37d3b521_10213136.png "屏幕截图")


## nginx配置静态文件


## git Action 入门教程 

持续集成（Continuous integration），也就是我们经常说的CI。它是一种软件开发实践，可以让团队在持续的基础上收到反馈并进行改进，不必等到开发后期才寻找和修复缺陷，常运用于软件的敏捷开发中。Jenkins就是我们常用的持续集成平台工具。

理解了持续集成的概念之后，下面我简单讲一下使用持续集成的好处：

提高效率，减少了重复性工作：一些重复性的工作写成脚本交给持续集成服务执行。

减少了人工带来的错误：机器通过预先写好的脚本执行犯错的几率比人工低很多。

减少等待的时间：一套完备的持续集成服务涵盖了开发、集成、测试、部署等各个环节。

提高产品质量：很多大公司在代码提交后都会有一套代码检视脚本（俗称门禁）来检查代码的提交是否符合规范，从而从源头遏制问题的产生。 

[https://docs.github.com/zh/actions/using-workflows](https://docs.github.com/zh/actions/using-workflows)

[GitHub Actions 入门教程](http://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html)

[GitHub也能CI/CD了 如何使用GitHub的Action？](https://blog.csdn.net/qq_41636947/article/details/121683905)

[手把手教你如何巧用Github的Action功能](https://www.bilibili.com/read/cv9190554)

1. workflow（工作流程）：持续集成一次运行的过程，就是一个workflow。

2. job（任务）：一个workflow由一个或多个jobs构成，含义是一次持续集成的运行，可以完成多个任务。

3. step（步骤）：每个job由多个step构成，一步步完成。

4. action（动作）：每个step可以依次执行一个或多个命令（action）。 作者：xuexiangjys https://www.bilibili.com/read/cv9190554 出处：bilibili

- steps具体描述了该怎么执行脚本 `uses` 是使用了别人已经预先定义好的脚本，这里的 `actions/checkout@v2` 就是一个把仓库拉取到最新的脚本, 我们将仓库拉到最新后就直接运行 