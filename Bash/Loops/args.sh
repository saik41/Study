#!/bin/bash

#go throuh all argument print them all

COUNT=1

for ARG in "$*"
do
	echo "$COUNT. argument: $ARG"
	let COUNT++
done
