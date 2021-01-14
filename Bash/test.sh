#!/bin/bash
echo $0
CURR=$(cd "$(dirname "$0")" ; pwd -P )
function collection(){
		CONFIG_FILE=$(cat $CURR/tree.json >> /dev/null 2>&1; echo $?)
    IS_BRANCH_LOCK_FILE=$(cat $CURR/$BUILD-PR-LOCK.json >> /dev/null 2>1; echo $?)
    case $STATUS in
      LOCK) if [ $IS_BRANCH_LOCK_FILE -eq 0 ]
      then
        echo "Please check the $BUILD-PR-LOCK.json is still available,"
        echo "Kindly cross-check the branch permission rules on Bitbucket."
        echo "Exiting......"
        exit 1
      fi
        esac

if [ $CONFIG_FILE -eq 0 ]
then
  REPOS=$(cat $CURR/tree.json | jq -r .repos | jq -r 'keys' | tr -d ',[]""')
  IFS=', ' read -r -a array <<< "`echo $REPOS`"
  len=${#array[@]}
  for (( i=0; i<$len; i++ ));do
    repo=${array[$i]}
		REPO=$repo
		BRANCH=$(cat $CURR/tree.json | jq -r '.repos."'${REPO}'".'${BUILD}'')
		USERNAME=$(cat $CURR/tree.json | jq -r '.auth[].username')
		PASSWORD=$(cat $CURR/tree.json | jq -r '.auth[].password')
		GROUP_NAME=$(cat $CURR/tree.json | jq -r '.groups[].name' )
		GROUP_SLUG=$(cat $CURR/tree.json | jq -r '.groups[].slug')
		URL=$(cat $CURR/tree.json | jq -r ".url[].link")
if [ $STATUS == 'LOCK' ]
then
  	lock
	elif [ $STATUS == 'UNLOCK' ]
	then
		unlock
	elif [ $STATUS == 'CHECK' ]
	then
		merge_check
	fi
	done
else
	echo "tree.json file is not available Please try once you get the file."
	echo "Exiting......"
	exit 1
	if [ $STATUS == 'UNLOCK' ]
	then
		rm -rf $CURR/$BUILD-PR-LOCK.json
	fi
fi
}

function lock(){

	IS_BRANCH_LOCK_FILE=$(cat $CURR/$BUILD-PR-LOCK.json >> /dev/null 2>1; echo $?)

	# if [ $IS_BRANCH_LOCK_FILE -eq 1 ]
	# # &&
	# then
    echo $STATUS
    echo $GROUP_NAME
    echo $USERNAME
    # sleep 90
		pushvalue='
			{
					"kind": "push",
					"pattern": "'$BRANCH'",
					"users": [{			}]
				}'
		PUSH_LOCK=$(curl POST -u ${USERNAME}:${PASSWORD} ${URL}/$REPO/branch-restrictions/ -d  "${pushvalue}" --header "Content-Type: application/json" -v)
		prvalue='
		 {
		   "kind": "restrict_merges",
		   "pattern": "'$BRANCH'",
		   "groups": [{
				 "name": "developers" ,
				 "slug": "Developers"
				}]
		   }'
		  PR_LOCK=$(curl POST -u ${USERNAME}:${PASSWORD} ${URL}/${REPO}/branch-restrictions/ -d  "${prvalue}" --header "Content-Type: application/json" -v)
			KEY=$(echo "$PR_LOCK" | jq -r .id)
		  # if [ -f $BUILD-PR-LOCK.json ]
			# then
			# echo "$(jq --arg REPO $REPO --arg KEY $KEY '.+{"'$REPO'": $KEY}' $CURR/$BUILD-PR-LOCK.json)" > $CURR/$BUILD-PR-LOCK.json
			# else
			# jq -n --arg REPO $REPO --arg KEY $KEY '{"'$REPO'": $KEY}' > $CURR/$BUILD-PR-LOCK.json
			# echo "$(jq --arg REPO $REPO --arg KEY $KEY '.+{"'$REPO'": $KEY}' $CURR/$BUILD-PR-LOCK.json)" > $CURR/$BUILD-PR-LOCK.json
			# fi

}
function test(){
  if [ $IS_BRANCH_LOCK_FILE -eq 1 ]
  then
    echo "======================================================="
    echo $KEY
    sleep 120
    jq -n --arg REPO $REPO --arg KEY $KEY '{"'$REPO'": $KEY}' > "$CURR/$BUILD-PR-LOCK.json"
    echo "$(jq --arg REPO $REPO --arg KEY $KEY '.+{"'$REPO'": $KEY}' $CURR/$BUILD-PR-LOCK.json)" > $CURR/$BUILD-PR-LOCK.json


  else
    echo ""@@@@@@@@@@@@@@@@@@@@@@@@@@@@""
    echo $KEY
    sleep 120
    # exit 1
echo "$(jq --arg REPO $REPO --arg KEY $KEY '.+{"'$REPO'": $KEY}' $CURR/$BUILD-PR-LOCK.json)" > $CURR/$BUILD-PR-LOCK.json

  fi

}

function unlock(){
	IS_BRANCH_UNLOCK_FILE=$(cat $CURR/$BUILD-PR-LOCK.json >> /dev/null 2>&1; echo $?)
	if [ $IS_BRANCH_UNLOCK_FILE -eq 0 ]

	then
		# echo "Branch $BRANCH is Unlocking"
    #
    #     ID=$(cat $CURR/$BUILD-PR-LOCK.json | jq -r ".[\"$REPO\"]")
    #
		# PR_UNLOCK=$(curl -X DELETE -u ${USERNAME}:${PASSWORD} ${URL}/$REPO/branch-restrictions/$ID  --header "Content-Type: application/json" -v)
    echo $STATUS
    echo $UNLOCK


	# fi
	else
		echo "Please Check $BUILD-PR-LOCK file is not-available Check On Bitbucket for active branch restriction rules...."
		echo "Exiting....."
    exit 1
	fi
}

function merge_check(){

	if [ "$REPO" = "nexus" ] || [ "$REPO" = "nexus-cloud" ] || [ "$REPO" = "cirrus-tools" ];
	then
		jsonvalue='
		{
			"kind": "require_passing_builds_to_merge",
			"value": 1,
			"pattern": "'$BRANCH'"
		}'
		curl -X POST -u ${USERNAME}:${PASSWORD} $URL/$REPO/branch-restrictions/ -d "${jsonvalue}"  --header "Content-Type: application/json" -v
	fi
	MERGE_CHECKS="require_approvals_to_merge require_default_reviewer_approvals_to_merge require_tasks_to_be_completed"
	for checks in $MERGE_CHECKS
	do
		if [ "$checks" = "require_approvals_to_merge"	];
		then
			jsonvalue='
			{
			  "kind": "'$checks'",
			  "value": 1,
			  "pattern": "'$BRANCH'"
			}'
			curl -X POST -u ${USERNAME}:${PASSWORD} $URL/$REPO/branch-restrictions/ -d "${jsonvalue}"  --header "Content-Type: application/json" -v
		elif [ "$checks" = "require_default_reviewer_approvals_to_merge" ];
		then
			jsonvalue='
			{
				"kind": "'$checks'",
				"value": 1,
				"pattern": "'$BRANCH'"
			}'
			curl -X POST -u ${USERNAME}:${PASSWORD} $URL/$REPO/branch-restrictions/ -d "${jsonvalue}"  --header "Content-Type: application/json" -v

		elif [ "$planet" = "require_tasks_to_be_completed" ];
		 then
			 jsonvalue='
			 {
				 "kind": "'$checks'",
				 "pattern": "'$BRANCH'"
			 }'
			 curl -X POST -u ${USERNAME}:${PASSWORD} $URL/$REPO/branch-restrictions/ -d "${jsonvalue}"  --header "Content-Type: application/json" -v

fi
done

}

argscount=$#

argscount=$#

if [ $argscount -lt 2 ] || [ $argscount -gt 2 ]

then

	echo "invalid number of options provided"
  echo "Try option -h or --help"
  exit 0

# elif [ $argscount -gt 2 ]
# then
#
#   echo "excess number of options provided"
#   echo "Try option -h or --help"
#   exit 0
fi
while [[ $# -gt 0 ]]
do
arg="$1"
    case "${arg}" in
  -l|--lock)
									BUILD="$2"
                	shift 2
									STATUS='LOCK'
									# sleep 120
									collection
                	;;
-un|--unlock)
									BUILD="$2"
                	shift 2
									STATUS='UNLOCK'
									collection
                	;;

-c|--check)				BUILD="$2"
									shift 2
									STATUS='CHECK'
									collection
									;;


# -u|--user)        USERNAME="$2"
# 									read -s -p "Enter the password: "
# 									PASSWORD="$REPLY"
# 									COLLECTION
									# exit 0
									# ;;
-h|--help)

									echo "use options"

									echo -e "-l or --lock [build-name] \n-un or --unlock [build-name] \n-c or --check [build-name]"

									echo "For example -"

									echo "./branch-lock.sh -l develop/drone/release"

									echo "./branch-lock.sh -un develop/drone/release"

									echo "./branch-lock.sh -c develop/drone/release"

									exit  0

									;;
		 *)
                  echo "Unknown Option $1"
							    echo "Try option -h or --help"
									echo "Exiting...."
							    exit 0
                  ;;
esac
done
