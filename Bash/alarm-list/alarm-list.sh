#!/bin/bash

REPOLIST=()
if [ -z "$NEXUS_CLOUD_COMMON_REPO" ]
then
	echo "NEXUS_CLOUD_COMMON_REPO should set to the repository nexus-cloud"
	exit 0
fi

if [ -z "$LEDGER_REPO" ]
then
	echo "NEXUS_SYSTEM_REPO should set to the repository ledger repo"
	exit 0
fi

if [ -z "$NEXUS_SYSTEM_REPO" ]
then
	echo "NEXUS_SYSTEM_REPO should be set to the repositoy nexus"
	exit 0
fi

REPOLIST=($NEXUS_CLOUD_COMMON_REPO $NEXUS_SYSTEM_REPO $LEDGER_REPO)
#grep -inr 'raisealarm\|clearalaram' | awk '{print $2}' | grep -i alarm | cut -d '(' -f 2 | cut -d ',' -f 1

ALARMLISTFILE="./alarmlist.csv"

if [ -f $ALARMLISTFILE ]
then
	rm  $ALARMLISTFILE
fi
# function main(){
# fi
# }
i=1
for repo in ${REPOLIST[@]}
do
	# echo "---------------$repo--------------" >> $ALARMLISTFILE
	alarmService=$(grep -r '.RaiseAlarm\|.ClearAlarm' $repo | grep -v Binary  | awk '{print $1}')
	alarmNames=`grep -r '.RaiseAlarm\|.ClearAlarm' $repo | grep -v Binary | awk '{print $2}' | cut -d '(' -f 2 | cut -d ',' -f 1 | tr -d '"'`
	alarmServiceArray=($alarmService)
	alarmNameArray=($alarmNames)
	size=${#repo}
	for index in ${!alarmServiceArray[@]}
	do
		y=${alarmServiceArray[$index]:$size}
		z=$(echo $y | cut -d '/' -f 2 )
		echo ${alarmNameArray[$index]} $z
		echo ${alarmNameArray[$index]} $z >> $ALARMLISTFILE
	done
	tmpfile="$ALARMLISTFILE$i"
	echo $tmpfile
	if [[ -f $ALARMLISTFILE ]]
	then
        	awk '!v[$1]++' $ALARMLISTFILE >> $tmpfile
			i=$((++i))
        	rm $ALARMLISTFILE
	fi
done


KIND=$(curl -X GET -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/684786441  --header "Content-Type: application/json" -v)
# CHECK=$(echo "$KIND" | jq -r .version.number)
#
# echo $CHECK
# let "CHECK++"
# echo $CHECK

# ./htmlconvert.sh $CHECK
