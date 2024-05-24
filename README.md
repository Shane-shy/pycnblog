# pycnblog

本项目Fork自[pycnblog](https://github.com/dongfanger/pycnblog)，并在此基础上做了一定修改，在此感谢pycnblog开发者的无私开源。

## 功能

目前，仅支持上传至博客园的随笔。

- 默认“未发布”，可选择直接发布
- 重复上传，则更新博客
- 选择上传的分类。所选择的分类不存在，则创建分类

## 环境配置

1. 克隆仓库

`git clone git@github.com:Shane-shy/pycnblog.git`

2. 环境配置：需要`python`，`pip`以及库函数`pyyaml`，库函数可以自动安装。三种情况命令行都会进行相应提示。

3. 修改配置文件`config.yaml`

   - blog_url：在博客后台>设置，页面最下方的MetaWeblog访问地址
   - blog_id：blog_url的结尾部分
   - username：登录用户名，跟blog_id不一定是同一个，最好去用户设置内查看
   - password：在博客后台>设置，页面最下方的MetaWeblog访问令牌

4. 相关补充文件

   - `config.yaml`

   ```yaml
   # 注意引号
   blog_url: xxx
   blog_id: 'xxx'
   username: 'xxx'
   # MetaWeblog访问令牌
   password: 'xxx'
   
   # 是否生成图片替换后本地文件,默认False关闭
   gen_network_file: False
   
   # 上传后是否发布，默认未发布，设置True为发布
   publish: False
   
   # 图片自定义显示格式，默认不设置
   
   # 设置居中和宽度
   # img_format: "<center><img src="" style="width:100%;" /></center>"
   
   # 还原typora图片样式，居中，设置zoom，上传后无需再手动调整图片大小
   img_format: typora
   
   # 不设置
   #img_format: ""
   ```

   - `linux_upload_markdown.sh`

   ```shell
   #!/bin/bash
   
   # 设置upload_markdown.py的绝对路径
   PYTHON_SCRIPT_PATH=""
   
   # &> /dev/null：重定向并丢弃，避免将检测结果输出在终端，
   # 检查是否安装了 Python
   if  ! command -v python3 &> /dev/null;then
       echo "Python3 未安装，请安装 Python3。"
       exit 1
   fi
   
   # 检查是否安装了 pip
   if  ! command -v pip3 &> /dev/null;then
       echo "pip3 未安装，请安装 pip3。"
       exit 1
   fi
   
   # 检查是否安装了所需的 Python 包
   REQUIRED_PKG="pyyaml"
   for PKG in $REQUIRED_PKG; do
       if ! pip3 show $PKG &> /dev/null; then
           echo "$PKG 未安装，正在安装..."
           pip3 install $PKG
       fi
   done
   
   # 检测是否配置了Python脚本路径
   if [ -z $PYTHON_SCRIPT_PATH ];then
     echo "未配置Python脚本路径"
     exit 0
   fi
   
   
   while true; do
     # read：按行读取，可以一次性读取多个值；参数p：读入字符串之前，打印的提示字符串；
       read -p  "Please input file path: " filePath
       read -p  "Please input categories (separated by space): " category
       python "$PYTHON_SCRIPT_PATH" "$filePath" "$category"
       status=$?
       if [ $status -eq 0 ];then
         echo "Uploading success"
         break
       else
         echo "Uploading fail"
       fi
   done
   ```

   - `mac_upload_markdown`：应该与`linux_upload_markdown.sh`相同，**目前没有测试**
   - `win_upload_markdown.cmd` **目前没有测试**

   ```cmd
   @echo off
   
   REM 设置 upload_markdown.py的绝对路径
   set "PYTHON_SCRIPT_PATH=C:\path\to\your\script\upload_markdown.py"
   
   REM 检查是否安装了 Python
   where python >nul 2>nul
   if %errorlevel% neq 0 (
       echo Python3 未安装，请安装 Python3。
       exit /b 1
   )
   
   REM 检查是否安装了 pip
   where pip >nul 2>nul
   if %errorlevel% neq 0 (
       echo pip 未安装，请安装 pip。
       exit /b 1
   )
   
   REM 检查是否安装了所需的 Python 包
   set REQUIRED_PKG=pyyaml
   for %%P in (%REQUIRED_PKG%) do (
       pip show %%P >nul 2>nul
       if %errorlevel% neq 0 (
           echo %%P 未安装，正在安装...
           pip install %%P
       )
   )
   
   REM 检测是否配置了Python脚本路径
   if "%PYTHON_SCRIPT_PATH%"=="" (
       echo 未配置Python脚本路径
       exit /b 0
   )
   
   :loop
   REM 读取输入
   set "filePath="
   set "category="
   set /p filePath="Please input file path: "
   set /p category="Please input categories (separated by space): "
   
   REM 运行 Python 脚本
   python "%PYTHON_SCRIPT_PATH%" "%filePath%" "%category%"
   set status=%errorlevel%
   
   if %status% equ 0 (
       echo Uploading success
       goto :eof
   ) else (
       echo Uploading fail
       goto loop
   )
   ```

   

## 使用方法

- Linux：`bash linux_upload_markdown.sh`，根据提示执行之后操作。`Please input file path:`时，可以直接将文件拖入命令行，就能生成绝对路径。**通过测试。**
- windows：双击`win_upload_markdown.cmd`，之后同上。**注意：**Windows下输入路径需要加双引号。**目前没有测试。**
- macos：应该类似于Linux，**目前没有测试。**

**注意：**如果上传失败，留意终端的报错，并确保图片路径正确。

