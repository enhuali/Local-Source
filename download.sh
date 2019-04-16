#!/bin/bash
#在有网环境下下载deb包及相关依赖，读取当前目录service.list下的内容，存放于/var/cache/apt/archives
logfile=/var/log/downlog
ret=""
function getDepends()
{
   echo "fileName is" $1>>$logfile
   ret=`apt-cache depends $1|grep Depends |cut -d: -f2 |tr -d "<>"`
   echo $ret|tee  -a $logfile
}
#libs="$1"      # 或者用$1，从命令行输入库名字
for libs in `cat ./service.list`:
do
apt-get install --reinstall $libs -d -y
i=0
while [ $i -lt 5 ] ;
do
    let i++
    echo $i
    newlist=" "
    for j in $libs
    do
        added="$(getDepends $j)"
        newlist="$newlist $added"
        apt install $added --reinstall -d -y
    done

    libs=$newlist
done
done
