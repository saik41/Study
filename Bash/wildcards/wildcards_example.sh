#!/bin/bash

#back up all .pdf files from prod location: /home to backup destination

PROD=/home/Desktop/Study/Bash/wildcards

#argument check

if [ $# -ne 1 ]
then
	echo "only one argumnet is needed"
fi


