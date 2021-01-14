#!/bin/bash

#for provided file print summary of what permission user has granted
#example: ./filetest.sh hello.txt
#READ: YES
#WRITE: NO
#EXECUTE: NO

#argument check

if [ $# -ne 1  ]
then
	echo "provide exactly one argument"
	exit 1
fi

#variable assignment

FILE=$1

#check if the file exists

if [ -f $FILE ]
then 
	VAR_READ="NO"
	VAR_WRITE="NO"
	VAR_EXE="NO"
	#check if file is readable
	if [ -r $FILE ]
	then 
		VAR_READ="YES"
	fi

	#check if file is writable
	if [ -w $FILE ]
	then
		VAR_WRITE="YES"
	fi

	#check if file is executabe
	if   [ -x $FILE  ]
	then
		VAR_EXEC="YES"
	fi


	#Summary
	echo ====FILE: $FILE====
	echo "READ: $VAR_READ"
	echo "WRITE: $VAR_WRITE"
	echo "EXECUTABLE: $VAR_EXEC"
else
	if [ -d $FILE ]
	then 
		echo $FILE is  a directory
	else

	echo "$FILE DOesn't exist"

	fi
fi

