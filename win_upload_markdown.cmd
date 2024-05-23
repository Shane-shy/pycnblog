@echo off

REM 设置 Python 脚本的绝对路径
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
