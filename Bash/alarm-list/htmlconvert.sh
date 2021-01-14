filecsv=alarmlist.csv
REPOLIST=($NEXUS_CLOUD_COMMON_REPO $NEXUS_SYSTEM_REPO $LEDGER_REPO)
i=1
for repo in ${REPOLIST[@]}
do
	IFS='/'
	x=($repo)
	#echo ${x[-1]}
	#echo "</p><p /><p>${x[-1]} alarms </p><p /><table data-layout=\"full-width\"><tbody>"
	value=$value"<p>${x[-1]}"' alarms </p><table data-layout=\"full-width\"><tbody>'
	IFS=' '
	filename="$filecsv$i"
	while read line; do
		#echo $line
		array=($line)
		#echo "<tr><td><p>${array[0]}</p></td><td><p>${array[1]}</p></td></tr>"
		value=$value"<tr><td><p>${array[0]}</p></td><td><p>${array[1]}</p></td></tr>"
	done<$filename
	i=$((++i))
	value=$value"</tbody></table>"
done

echo $value > "test.html"
# FOUR_LEGS=$(curl -X GET -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/131334443?expand=body.storage  --header "Content-Type: application/json" -v)
# OLD_HTML=$(echo $FOUR_LEGS | jq -r .body.storage.value)
# echo "------------------------------------------------------------"
# diff <( echo "$OLD_HTML" ) <( echo "$value" ) >>test.html
# echo $LATEST
# echo $OLD_HTML
# echo "------------------------------------------------------------"
# KIND=$(curl -X GET -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/684786441  --header "Content-Type: application/json" -v)
# CHECK=$(echo "$KIND" | jq -r .version.number)
echo $1
jsonvalue='
{
	"id":"684786441",
	"type":"page",
	"title":"Test-Page",
	"space":
	{
		"key":"~781690627"
	},
	"body":
	{
		"storage":
		{
			"value": "'$value'",
			"representation": "storage"
		}
	},
	"version":
	{
		"number": '$1'
	}
}'
echo $1
echo $CHECK
echo $jsonvalue > escape.json
# echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"
# curl -X PUT -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/684786441  -d '${jsonvalue}' --header "Content-Type: application/json" -v 
curl -X PUT -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/684786441  -d @escape.json --header "Content-Type: application/json" -v 
