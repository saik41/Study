#!/bin/bash

#show 3 lines of ps command only to root user

WHOAMI=$(whoami)
echo $WHOAMI
if [ "$WHOAMI" != "root" ]
then
	echo "you are not root"
	exit 1
fi

ps -ef | head -3
