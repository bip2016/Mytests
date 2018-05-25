#!/bin/bash

if [ -z $1 ]
then
	echo "usage: install_from_task.sh taskid";
	exit 1;
fi

TESTTASK=$(apt-repo list $1 | grep "404 Not Found")
if [ -n "$TESTTASK" ];
then
	echo "task not found";
	exit 2;
fi

echo "Install test packages from task"

echo y | apt-repo test $1
