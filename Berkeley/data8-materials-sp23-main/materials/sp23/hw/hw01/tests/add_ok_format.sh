#!/bin/bash
# -*- coding: utf-8 -*-

# 获取当前文件夹下所有的.py文件
py_files=$(find . -name "*.py")

# 循环处理每个.py文件
for file in $py_files; do
    # 添加OK_FORMAT = True到第一行
    sed -i '' '1s/^/OK_FORMAT = True\n/' "$file"
done
