#!/bin/bash

# create script for printing fiels, which will display also line numbers

#argument check

if [ $# -ne 1 ]
then 
	echo "Exactly one arg is needed, run $0 file-path"
	exit 1
fi

#Cchek provided argument is a file
if ! [ -f "$1" ]
then
	echo "FILE you have specified doesn't exists"
	exit 2
fi
	
FILENAME=$1

COUNT=1

cat "$FILENAME" | 
while read line 
do 
	echo "$COUNT: $line"
	let COUNT++
done
