#!/bin/bash


nexus_alarams=($(cat alarmlist.csv1 | awk -F " " '{ print $1 }'))


last_nexus_alarm=`cat limit.html | grep -B 13 "NEXUS_CLOUD ALARMS" | awk 'NR==1{print $1}' | sed -e 's/<[^>]*>//g'`


html_alarms_list=`cat limit.html | awk -F "<td>|</td>" '{ print $1 }' | awk -F "<tr>|</tr>" '{ print $0 }' | grep -A 2 "<tr>" | grep -v "<tr>\|--\|<code>\|<strong>" | awk -F "<p>|</p>" '{ if ( $2 != "") print $2 }'`

# echo $html_alarms_list
# sleep 90
# echo $last_nexus_alarm
# sleep 90
# echo $nexus_alarams
#
# sleep 90
new_alarms=('')

ok=true
completed=false


  for k in "${nexus_alarams[@]}";do
    for s in "${html_alarms_list[@]}";do
    echo "$k ------------------------ $s"
      if [[ "$k"=="$s" ]];then
      # echo "1111111111111111111111111111111111   $k"
        ok=false
        break
      fi
      if [[ "$s"=="$last_nexus_alarm" ]];then
        completed=true
        break
      fi
    done

  if $ok ;then
      new_alarms+=($k)
      # echo "#############################  $k"
  else
      ok=true
  fi

  if $completed ;then
      break
  fi

done


for s in "${new_alarms[@]}";do
  echo "1111111111111111111111111          $s"
done
