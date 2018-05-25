#!/bin/bash


if [ -z $1 ]
then
	echo "usage: upgrade_from_task.sh taskid";
	exit 1;
fi

TESTTASK=$(apt-repo list $1 | grep "404 Not Found")
if [ -n "$TESTTASK" ];
then
	echo "task not found";
	exit 2;
fi

echo "Install test packages from P8"

(apt-repo list $1 |while read a; do echo "install ${a} -y "; done; echo commit; echo y ) | apt-shell;

echo "Upgrade packages from task $1"
echo y | apt-repo test $1
