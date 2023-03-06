#!/bin/bash
cd /home/warmheart/mkdocs
git pull 

# 获取当前时间戳并将其转换为可读的时间格式
now=$(date -d @$(date +%s) +"%Y-%m-%d")

git checkout -b $now 

sel=$1

echo "当前时间是：$now" 


git add .

git commit -m "${now}"

if test "$sel" = "1";then
    git push --set-upstream origin $now  
else
    git push  
fi


if test "$sel" = "2";then
    mkdocs gh-deploy
fi 
