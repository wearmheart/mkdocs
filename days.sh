#!/bin/bash
cd /home/warmheart/mkdocs
git pull 

# 获取当前时间戳并将其转换为可读的时间格式
now=$(date -d @$(date +%s) +"%Y-%m-%d %H:%M:%S")

echo "当前时间是：$now"

git add .

git commit -m "${now}"
 
git   push  

mkdocs gh-deploy