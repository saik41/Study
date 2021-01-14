#!/bin/bash


function branch_lock(){
MYDIRNAME=`dirname $0`
MYDIRPATH=`cd $MYDIRNAME && pwd -P`
REPOFILEPATH=$MYDIRPATH/repositories.json
IS_BRANCH_LOCK_FILE=$(cat $BRANCH_C-$DENCW-PR-LOCK >> /dev/null 2>&1; echo $?)
if [ $IS_REPO_FILE -eq 0 ] || [ $IS_BRANCH_LOCK_FILE -eq 1 ]
then
    echo "Branch $BRANCH is Locking"
		REPOS=$(cat repositories.json | jq -r '.repos[]')
		IFS=', ' read -r -a array <<< "`echo $REPOS`"
		len=${#array[@]}
		for (( i=0; i<$len; i++ ));do
		repo=${array[$i]}
		BRANCH=$(cat tree.json | jq -r '.repos.ledger[].hotfix')
pushvalue='
	{
			"kind": "push",
			"pattern": "'$BRANCH'",
			"users": [{			}]
		}'


	PUSH_LOCK=$(curl -X POST -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/$TRIM/branch-restrictions/ -d  "${pushvalue}" --header "Content-Type: application/json" -v)
	# CATCH=$(echo "$PUSH_LOCK" | jq -r .id)
	# echo {} >$STATUS-$DENCW-PUSH-LOCK.json
	# echo $(jq --arg TRIM $TRIM --arg CATCH $CATCH '.+{"'$TRIM'":$CATCH}' $STATUS-$DENCW-PUSH-LOCK.json ) >$STATUS-$DENCW-PUSH-LOCK.json

		prvalue='
		{
			"kind": "restrict_merges",
			"pattern": "'$BRANCH'",
			"groups": [{
					 "name": "developer" ,
					 "slug": "Developer"
					}]
			}'
		PR_LOCK=$(curl -X POST -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/$TRIM/branch-restrictions/ -d  "${prvalue}" --header "Content-Type: application/json" -v)
		#lock_status=$(echo "$PR_LOCK" | grep HTTP |  awk '{print $2}')
		CHECK=$(echo "$PR_LOCK" | jq -r .id)
		if [ -f $BRANCH_C-$DENCW-PR-LOCK.json ]
		then
		echo "$(jq --arg TRIM $TRIM --arg CHECK $CHECK '.+{"'$TRIM'": $CHECK}' $BRANCH_C-$DENCW-PR-LOCK.json)" > $BRANCH_C-$DENCW-PR-LOCK.json
		# sleep 60
		else
		jq -n --arg TRIM $TRIM --arg CHECK $CHECK '{"'$TRIM'": $CHECK}' > $BRANCH_C-$DENCW-PR-LOCK.json
		echo "$(jq --arg TRIM $TRIM --arg CHECK $CHECK '.+{"'$TRIM'": $CHECK}' $BRANCH_C-$DENCW-PR-LOCK.json)" > $BRANCH_C-$DENCW-PR-LOCK.json
		# sleep 60
		fi
		# if [ $lock_status -eq 201 ]
		# then
		# 	shift
			merge_checks $TRIM $BRANCH
		# fi

	 done
 else
	 echo -e $"Please Check $BRANCH_C-$DENCW-PR-LOCK file is sill available,\nSo check the branch lock status on Bitbucket"
fi
}

function branch_unlock(){
	IS_BRANCH_UNLOCK_FILE=$(cat $BRANCH_C-lock-PR-LOCK.json >> /dev/null 2>&1; echo $?)
	if [ $IS_BRANCH_UNLOCK_FILE -eq 0 ]
	then
		echo "Branch $STATUS is Unlocking"
		REPOS=$(cat repositories.json | jq '.repos[]')
		IFS=', ' read -r -a array <<< "`echo $REPOS`"
		len=${#array[@]}
		for (( i=0; i<$len; i++ ));do
			repo=${array[$i]}
			TRIM=$(echo "$repo" | tr -d '"')
      if [ $IS_BRANCH_UNLOCK_FILE -eq 0 ]
      then
				echo "---------------------------------------------------------------"
        KEY=$(cat $BRANCH_C-lock-PR-LOCK.json | jq -r ".[\"$TRIM\"]")
				# echo $KEY
				# echo ${KEY}
				# sleep 120
		URL=$(curl -X DELETE -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/$TRIM/branch-restrictions/${KEY}  --header "Content-Type: application/json" -v)

		rm -rf $BRANCH_C-lock-PR-LOCK.json
	fi
		done
	else
		echo $'Please Check $BRANCH_C-$DENCW-PR-LOCK file is not-available,\nSo check the branch permissions status on Bitbucket'
	fi
	   # if [ $? -eq 0 ]
	   # thencat sai.json | jq -r '."nexus-cloud"'
		 #   echo "Branch $STATUS unlocked in all listed repositories"
	   # else
		 #   echo "There is some issue with the branch $STATUS unlocking"
	   # fi
	# else
	# 	echo "Please check the $STATUS branch permission on bitbucket"

}

function merge_checks(){
	echo $TRIM
	echo $STATUS
	if [ $TRIM = nexus ] || [ $TRIM = nexus-cloud ] || [ $TRIM = cirrus-tools ]
	then
		jsonvalue='
		{
			"kind": "require_passing_builds_to_merge",
			"value": 1,
			"pattern": "'$STATUS'"
		}'
	fi
	PLANETS="require_approvals_to_merge require_default_reviewer_approvals_to_merge require_tasks_to_be_completed"
	for planet in $PLANETS
	do
		echo $planet
		if [ $planet = require_approvals_to_merge	]
		then
			jsonvalue='
			{
			  "kind": "'$planet'",
			  "value": 1,
			  "pattern": "'$STATUS'"
			}'
			curl -X POST -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/$TRIM/branch-restrictions/ -d "${jsonvalue}"  --header "Content-Type: application/json" -v
		elif [ $planet = require_default_reviewer_approvals_to_merge ]
		then
			jsonvalue='
			{
				"kind": "'$planet'",
				"value": 1,
				"pattern": "'$STATUS'"
			}'
			curl -X POST -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/$TRIM/branch-restrictions/ -d "${jsonvalue}"  --header "Content-Type: application/json" -v
		elif [ $planet = require_tasks_to_be_completed ]
		 then
			 jsonvalue='
			 {
				 "kind": "'$planet'",
				 "pattern": "'$STATUS'"
			 }'
			 curl -X POST -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/$TRIM/branch-restrictions/ -d "${jsonvalue}"  --header "Content-Type: application/json" -v

fi
done

}
argscount=$#

if [ $argscount -lt 3 ]

then

	echo "less number of options provided"

	echo "Try option -h or --help"

fi
while [[ $# -gt 0 ]]
do
# echo $1
# sleep 30
arg="$1"
    case "${arg}" in
  -l|--lock) BRANCH_C=$2
             shift
             branch_lock
             ;;
-u|--unlock)
						 BRANCH_C=$2
             shift
             branch_unlock
             ;;

-c|--check)	 BRANCH_C=$2
						 BRANCH_C=$(echo $BRANCH | tr "/*" -)
						 shift
						 merge_checks
						 ;;
-h|--help)

			echo "use options"

			echo -e "-l or --lock [branch-name] \n-u or --unlock [branch-name] \n-c or --check [branch-name]"

			echo "For example -"

			echo "./branch-lock.sh -l dev"

			echo "./branch-lock.sh -u dev"

			echo "./branch-lock.sh -c dev"

			exit  0

			;;
	*)
        	 echo "Unknown Option $1"
					 echo "Try option -h or --help"
					 exit 0
        	 ;;
esac
done
