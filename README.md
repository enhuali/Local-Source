# Apt本地源

  基于docker制作镜像并运行的apt本地源;



## 使用方式

### 欲下载的软件包进行记录

```
vim service.list
#添加内容
php7.2
php7.2-common
php7.2-dev
php7.2-cli
php7.2-fpm
php7.2-xml
php7.2-mongodb
php7.2-phalcon
php7.2-zip
php7.2-curl
php7.2-redis
php7.2-mysql
.
.
.
.
.
```

比如此处针对php7.2进行欲下载记录，有其他包名时累加即可



### 下载软件包到本地

```
#download.sh 为下载脚本
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
```

本脚本将欲下载的软件包进行实际下载并存放于pack目录下；

可以调整每个软件的依赖层数，此脚本中为"5"



### 制作镜像

```
#制作镜像
docker buile -t registry:5000/library/apt-mirror .
```

`registry` 为私有仓库ip



### 启动容器

```
#启动
bash deploy/run.sh
```



### 配置本地源

```
#编辑/etc/apt/sources.list
sudo vim /etc/apt/sources.list

#添加内容
deb http://apt-mirror-ip debs/

#更新源
sudo apt-get update
```

`apt-mirror-ip` 为私有源ip