#!/bin/bash

# 任务目录
task_dir=./task
# 任务完成目录
finish_dir=./finish
# 任务执行失败目录
task_err_dir=./err_task
# 执行日志路径
log_path=./log
# 间隔时间
sleep_time=10

while :
do

	for t in `ls $task_dir`
	do
		echo 'start task '$t' at '`date` >> $log_path

		# docke命令
		sleep 1
	
		if [ "$?" -eq 0 ] 
		then	
			echo 'finished task '$t' success at '`date` >> $log_path
			mv $task_dir/$t $finish_dir/$t
		else
			echo ' task '$t' error at '`date` >> $log_path
			mv $task_dir/$t $task_err_dir/$t
		fi
	done

	sleep $sleep_time
done
