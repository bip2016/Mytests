#!/bin/bash

FILEPID="/tmp/update_script.pid"
if test -f "$FILEPID"
then
    exit 1
else
    touch $FILEPID
fi