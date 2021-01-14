#!/bin/bash

STR1="hello buddy"
STR2="HELLO buddy"

if [ "$STR1" = "$STR2" ]
then 
	echo equal
else
	echo not equal
fi
