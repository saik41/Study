#! /bin/bash -x
awk -F "</*td>|</*tr>" '/<\/*t[rd]>.*[A-Z][A-Z]/ {print $3 "=\"" $5, $7 "\"" }' old.html
