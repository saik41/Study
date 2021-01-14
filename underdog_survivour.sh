    #!/bin/bash -x


# KIND=$(curl -X GET -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/684786441  --header "Content-Type: application/json" -v)
# CHECK=$(echo "$KIND" | jq -r .version.number)
# echo $CHECK
# COUNTER=$CHECK
# while [ Your != "done" ]
# do
#      echo " $COUNTER "
#      COUNTER=$[$COUNTER +1]
# done
# let "CHECK++"
# echo $CHECK
# CHECK=$CHECK ./check.sh
# curl -D- \
#    -u sai.kiran1213@gmal.com:jekF0tQx4Pysibt3J7f6C582 \
#    -X GET \
#    -H "Content-Type: application/json" \
#    https://privafy.atlassian.net/wiki/spaces/NEXUSSYSTEM/pages/

# curl -X PUT -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/684786441  -d @test_alarm.json --header "Content-Type: application/json" -v

# CHECK=$(echo "$KIND" | jq -r .version.number)
# https://<domain>/rest/api/content/12345?expand=body.storage

# {"id":"684786441","type":"page",
# "title":"Test-Page","space":{"key":"~781690627"},"body":{"storage":{"value":
# "<p>This is the updated text for the new page</p>","representation":"storage"}},
# "version":{"number":2}}SCRIPT_PATH

FOUR_SQUARE=$(curl --output -X GET -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/131334443?expand=body.storage  --header "Content-Type: application/json" -v >alarm.json)
# # >alarm.json

# TABLE=$(curl -X GET -u saikiran.sarab.cslt@privafy.com:jekF0tQx4Pysibt3J7f6C582 https://privafy.atlassian.net/wiki/rest/api/content/684786441)
# echo $TABLE  >alarm.json
echo $FOUR_SQUARE
OLD_HTML=$(echo alarm.json | jq -r .body.storage.value)
echo $OLD_HTML >> limit.html
# HTML=$(echo "$TABLE" | jq -r .)

echo "----------------------------------------------script for html check-----------------"
# for file in $1/*.html; do
# fileName=$(basename "$file")

# if [ ! -f $2/$fileName ]; then
#     echo $fileName " not found! in "$2
# else
#     difLineCount=$(diff $file $2/$fileName | wc -l)
#     if [ $difLineCount -eq 0 ]; then
#         echo $file "is same " $2/$fileName;
#     else 
#        echo $file "is not same " $2/$fileName "." $difLineCount "lines are different"; 
#        #diff $file $2/$fileName
#     fi
# fi
# done

# for file in $2/*.html; do
# fileName=$(basename "$file")
#     if [ ! -f $1/$fileName ]; then
#             echo $fileName " not found! in "$1
#     fi
# done

echo "----------------------------------------------script for html check-----------------"

echo "-------------------------Optimized---------------------"
# sai_array=($(cat abc.csv | awk -F "," '{ print $1 }'))
#!/bin/bash


# sai=`cat limit.html | awk -F "<td>|</td>" '{ print $1 }' | awk -F "<tr>|</tr>" '{ print $0 }' | grep -A 2 "<tr>" | grep -v "<tr>\|--\|<code>\|<strong>" | awk -F "<p>|</p>" '{ if ( $2 != "") print $2 }'`


# for s in "${sai[@]}";do
#   echo $s
# done

echo "-----------------------Optimized-----------------------"

# ActiVe Commands 

cat limit.html | awk -F "<td>|</td>" '{ print $1 }' | awk -F "<tr>|</tr>" '{ print $0 }' | grep -A 5 "<tr>" | grep -v "<tr>\|--\|<code>\|<strong>" | awk -F "<p>|</p>" '{ if ( $2 != "") print $2 }'

cat optimise | xargs -n2 >>optimize