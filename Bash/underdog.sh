#!/bin/bash -x
function branch_lock() {

  MYDIRNAME=`dirname $0`
  echo $MYDIRNAME
	MYDIRPATH=`cd $MYDIRNAME && pwd -P`
  echo $MYDIRPATH
	REPOFILEPATH=$MYDIRPATH/repositories.json
  echo $REPOFILEPATH
	IS_BRANCH_LOCK_FILE=$MYDIRPATH/$BUILD-PR-LOCK.json
  echo $IS_BRANCH_LOCK_FILE

  # sleep 60
  # sleep 120
	# if [[ "$REPOFILEPATH" -eq "0" ]] && [[ "$IS_BRANCH_LOCK_FILE" -eq "1" ]];
	# then
    # sleep 120
  #   echo "Branch $BRANCH is Locking"
  # REPOS=$(cat tree.json | jq -r .repo | jq -r 'keys' | tr -d ',[]""')
  # echo $REPOS
  # sleep 60
  # IFS=', ' read -r -a array <<< "`echo $REPOS`"
  # len=${#array[@]}
#   for (( i=0; i<$len; i++ ));do
#     repo=${array[$i]}
#     echo $repo
#     sleep 60
# REPO=$repo
# BRANCH=$(cat tree.json | jq -r '."'${REPO}'".'${BUILD}'')
# BRANCH_C=$(echo $BRANCH | tr "/*" -)
# USERNAME=$(cat repositories.json | jq -r '.auth[].username')
# PASSWORD=$(cat repositories.json | jq -r '.auth[].password')
# URL=$(cat repositories.json | jq -r ".url[].link")
echo $BRANCH
echo $USERNAME
# echo $PASSWORD
echo $URL
sleep 60
pushvalue='
	{
			"kind": "push",
			"pattern": "'$BRANCH'",
			"users": [{			}]
		}'
    	PUSH_LOCK=$(curl POST -u ${USERNAME}:${LOST} ${URL}/$REPO/branch-restrictions/ -d  "${pushvalue}" --header "Content-Type: application/json" -v)
      prvalue='
      {
        "kind": "restrict_merges",
        "pattern": "'$BRANCH'",
        "groups": [{
  					 "name": "developers" ,
  					 "slug": "Developers"
  					}]
        }'
        PR_LOCK=$(curl POST -u ${USERNAME}:${LOST} ${URL}/${REPO}/branch-restrictions/ -d  "${prvalue}" --header "Content-Type: application/json" -v)
        KEY=$(echo "$PR_LOCK" | jq -r .id)
        if [ -f $BUILD-PR-LOCK.json ]
    		then
    		echo "$(jq --arg REPO $REPO --arg KEY $KEY '.+{"'$REPO'": $KEY}' $BUILD-PR-LOCK.json)" > $BUILD-PR-LOCK.json
    		# sleep 60
    		else
    		jq -n --arg REPO $REPO --arg KEY $KEY '{"'$REPO'": $KEY}' > $BUILD-PR-LOCK.json
    		echo "$(jq --arg REPO $REPO --arg KEY $KEY '.+{"'$REPO'": $KEY}' $BUILD-PR-LOCK.json)" > $BUILD-PR-LOCK.json
    		sleep 60
    		fi
# done
# fi
}
function test(){
  REPOS=$(cat tree.json | jq -r .repo | jq -r 'keys' | tr -d ',[]""')
  # echo $REPOS
  # sleep 60
  IFS=', ' read -r -a array <<< "`echo $REPOS`"
  len=${#array[@]}
  for (( i=0; i<$len; i++ ));do
    repo=${array[$i]}
    echo $repo
    echo $CATCH
    # sleep 60
REPO=$repo
BRANCH=$(cat tree.json | jq -r '.repo."'${REPO}'".'${BUILD}'')
BRANCH_C=$(echo $BRANCH | tr "/*" -)
# USERNAME=$(cat repositories.json | jq -r '.auth[].username')
PASSWORD=$(cat repositories.json | jq -r '.auth[].password')
URL=$(cat repositories.json | jq -r ".url[].link")
if [ $CATCH == A ]
then
  branch_lock
  # s  sleep 60
# leep 60
elif [ $CATCH == B ]
then
branch_unlock
fi
done
}
function branch_unlock() {
  		echo "Branch $BRANCH is Unlocking"
  		REPOS=$(cat repositories.json | jq -r '.repos[]')
  		IFS=', ' read -r -a array <<< "`echo $REPOS`"
  		len=${#array[@]}
  		for (( i=0; i<$len; i++ ));do
  			repo=${array[$i]}
        REPO=$repo
        BRANCH=$(cat tree.json | jq -r '."'${REPO}'".'${BUILD}'')
        BRANCH_C=$(echo $BRANCH | tr "/*" -)
        USERNAME=$(cat repositories.json | jq -r '.auth[].username')
        PASSWORD=$(cat repositories.json | jq -r '.auth[].password')
        URL=$(cat repositories.json | jq -r ".url[].link")
          IS_BRANCH_UNLOCK_FILE=$(cat $BUILD-PR-LOCK.json >> /dev/null 2>&1; echo $?)
        if [ $IS_BRANCH_UNLOCK_FILE -eq 0 ]
        then
          ID=$(cat $BUILD-PR-LOCK.json | jq -r ".[\"$REPO\"]")
  		PR_UNLOCK=$(curl DELETE -u ${USERNAME}:${PASSWORD} $URL/$REPO/branch-restrictions/$ID  --header "Content-Type: application/json" -v)
      echo $?
  		rm -rf $BUILD-PR-LOCK.json
  	else
  		echo 'Please Check $BRANCH_C-PR-LOCK file is not-available,\nChecking On Bitbucket for active branch restriction rules....'
    fi
        done
  #statements
}

jsonvalue='
{
 "kind": "restrict_merges",
 "pattern": "hotfix/*",
 "groups": [{
            "name": "administrators" ,
            "slug": "Administrators"
           }]
}'

#
# {
# 	"kind": "push",
# 	"pattern": "develop",
# 	"groups": [{
# 		"name": "Developers",
# 		"account_privilege": null,
# 		"full_slug": "team-name:developers",
# 		"owner": {
# 			"username": "Developers",
# 			"display_name": "developers",
# 			"type": "team"
# 		},
# 		"type": "group",
# 		"slug": "developers"
# 	}]
# }
# [{
#         "owner": { "username": "developers" },
#         "slug": "Developers"
#     }]

MYDIRNAME=`dirname $0`

# echo $MYDIRNAME

MYDIRPATH=`cd $MYDIRNAME && pwd -P`

# echo $MYDIRPATH

REPOFILEPATH=$MYDIRPATH/repositories.json

# echo $REPOFILEPATH
# set `date`
# # echo "COUNT $#"
# # echo "$1 $2 $3 $4 $5 $6"
# # shift
# # echo "$1 $2 $3 $4 $5 $6"
# # shift
# # echo "$1 $2 $3 $4 $5 $6"
# # shift
# # echo "$1 $2 $3 $4 $5 $6"
# # shift
while [[ $# -gt 0 ]]
do
# echo $1
# sleep 30
arg="$1"
    case "${arg}" in
    --lock)
                echo "====================="
                BUILD=$2
                shift 2
                # unset LOST
                # echo -n "Enter the Username: "
                # read USERNAME
                read -s -p "Enter the Password: "
                SIGN="$REPLY"
                # PASSWORD="$LOST"
                # sleep 120
                CATCH=A
                # sleep 120


                echo $BUILD
                # shift 2
                # test
                # branch_lock
                # exit 0
                ;;

      --unlock)
                BUILD=$2
                echo $BUILD
                CATCH=B
                shift 2
                # test
                # branch_unlock
                # exit 0
                ;;
                --user)
                          USERNAME=$2
                          echo $USERNAME
                          sleep 60
                          ;;
                        esac
done

# function branch_unlock() {
#   echo $BRANCH
#   echo $USERNAME
#   echo $PASSWORD
#   #statements
# }
# sleep 120
# curl -X DELETE -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/getting-started/branch-restrictions/14416259  --header "Content-Type: application/json" -v
# PR=$(curl -X DELETE -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/getting-started/branch-restrictions/14476731     --header "Content-Type: application/json" -v)
# http_status=$(echo "$request_cmd" | grep HTTP |  awk '{print $2}')
# echo $http_status

# curl -X GET -u Psy-Kiran:S@9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/getting-started/branch-restrictions/14397827   --header "Content-Type: application/json" -v
# How do we give force merge permission to a user
# 1. Those who are in "administrator" group by default they can do.
# 2. we need to define any permission in "branch-restrictions" set-up.
# if we need to anything on "branch-restrictions" level please share me a screenshot for reference.
echo $?
# printhelp $@
# BRANCH=$1
#
# if [ $BRANCH = nexus ] || [ $BRANCH = nexus-cloud ] || [ $BRANCH = cirrus-tools ]   ; then
#    echo "Build Request is Not matching to any of our Dependencies" | exit 0
# fi
# ------------------------------------------------------------------------------------------------------------------------------------------


# jsonvalue='
# {
#   "kind": "require_approvals_to_merge",
#   "value": 1,
#   "pattern": "develop",
#   "users": [
#       {
#
#
#         }
#       ]
# }'
# curl POST -u Psy-Kiran:S@i9439070026 https://api.bitbucket.org/2.0/repositories/rmgtechnologies/getting-started/branch-restrictions/ -d "${jsonvalue}"  --header "Content-Type: application/json" -v
# jq '.data.messages[3] |= . + {"date": "2010-01-07T19:55:99.999Z", "xml": "xml_samplesheet_2017_01_07_run_09.xml", "status": "OKKK", "message": "metadata loaded into iRODS successfullyyyyy"}' inputJson
# jq '.data.messages[.data.messages| length] |= . + {"date": "2010-01-07T19:55:99.999Z", "xml": "xml_samplesheet_2017_01_07_run_09.xml", "status": "OKKK", "message": "metadata loaded into iRODS successfullyyyyy"}' inputJson
# jq '.data.messages += [{"date": "2010-01-07T19:55:99.999Z", "xml": "xml_samplesheet_2017_01_07_run_09.xml", "status": "OKKK", "message": "metadata loaded into iRODS successfullyyyyy"}]'
# jq -n --arg appname "$appname" '{"appname": $appname, "script": "./cms/bin/www"}'

# REPOS=$(cat repositories.json | jq 'keys[]')
# IFS=', ' read -r -a array <<< "`echo $REPOS`"
# len=${#array[@]}
# for (( i=0; i<$len; i++ ));do
# repo=${array[$i]}
# TRIM=$(echo "$repo" | tr -d '"')
# REPO=$TRIM
# echo "============================="
# echo $REPO
# BRANCH=$(cat repositories.json | jq -r '."$REPO"[]|.dev')
# echo "============================="
# echo $BRANCH
# echo "============================="
# done
# cat repositories.json | jq -r '.$REPO[] | .dev'
# echo "============Shift Example=================  "
# set `date`
# echo "Count $#"
# echo "$1 $2 $3 $4 $5"
# shift 2
# echo "$1 $2 $3 $4 $5"
