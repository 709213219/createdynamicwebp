#!/bin/bash

:<<!
将一组图片转成webp格式文件，再生成动态的webp文件。
步骤:
1.将所有需要的图片存放在images文件夹下。
2.终端运行 sh createdynamicwebp.sh images。
!

path=$1 #指定的文件夹路径
count=0
if [ $path ] && [ -d $path ]; then #指定的文件夹路径存在
	`mkdir $path/webps` #创建一个临时文件夹

	order=webpmux #webpmux命令
	for file in `ls $path | sort -n `; do #遍历指定的文件夹下的所有文件，并以数字排序

		if [ -f $path/$file ]; then #判断是否为文件，而不是文件夹，为了排除创建的临时文件夹webps
			bname=$(basename $file) #获取不包含路径的文件名

			`cwebp $path/$bname -o $path/webps/$count.webp` #从png图片生成webp静态图
			order="$order -frame $path/webps/$count.webp +250" #webpmux命令添加每一帧信息

			count=$[ $count + 1 ]
		fi
	done	

	order="$order -loop 0 -bgcolor 255,255,255,255 -o anim.webp" #webpmux命令添加循环次数，背景颜色，输出信息
	`$order` #云信webpmux命令

	`rm -r $path/webps` #删除临时文件夹
else
	echo "请输入正确的文件目录"
fi