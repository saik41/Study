#!/bin/bash

function addition {

local FIRST=$1
local SECOND=$2
let RESULT=FIRST+SECOND
echo "Result is $RESULT"
let FIRST++
let SECOND++
}


#do the addition of the numbers
echo -n "Enter first number"
read FIRST
echo -n "Enter second number"
read SECOND

addition $FIRST $SECOND
echo "FIRST: $FIRST"
echo "SECOND: $SECOND"
