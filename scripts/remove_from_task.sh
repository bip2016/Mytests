#!/bin/bash


if [ -z $1 ]
then
	echo "usage: remove_from_task.sh taskid";
	exit 1;
fi
TESTTASK=$(apt-repo list $1 | grep "404 Not Found")
if [ -n "$TESTTASK" ];
then
	echo "task not found";
	exit 2;
fi

echo "Remove test packages from system"
(apt-repo list $1 |while read a; do echo "remove ${a} -y "; done; echo commit; echo y ) | apt-shell;

