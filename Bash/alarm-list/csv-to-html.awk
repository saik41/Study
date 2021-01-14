#!/usr/bin/awk -f

# Set field separator as comma for csv and print the HTML header line
IS_ALARM_LIST_FILE_NEXUS_CLOUD=$(cat uniq_nexus_cloud_alarms.csv >> /dev/null 2>&1; echo $?)
while[ $IS_ALARM_LIST_FILE_NEXUS_CLOUD -eq 0 ]; do 
BEGIN {
    FS=",";
print "<p>List of Alarms raised/cleared directly from code. Ideally these should be stats and eventually alarms raised based
on threshold values.</p>
<p />
<p>NEXUS ALARMS</p>
<p />
<table data-layout=\"full-width\">
<tbody>
    <tr>
        <th>
            <p><strong>Alarm Name</strong></p>
        </th>
        <th>
            <p><strong>Service</strong></p>
        </th>
        <th>
            <p><strong>Description</strong></p>
        </th>
        <th>
            <p><strong>Handling (manual/auto clearing)</strong></p>
        </th>
    </tr>"
}
# Function to print a row with one argument to handle either a 'th' tag or 'td' tag
function printRow(tag) {
    print <tr>
    print "<td>";
    for(i=1; i<=NF; i++) print "<p>"$i"</p>";
    print "</td>"
    print</tr>
}
# If CSV file line number (NR variable) is 1, call printRow fucntion with 'th' as argument
# NR==1 {
#     printRow("th")
# }
# # If CSV file line number (NR variable) is greater than 1, call printRow fucntion with 'td' as argument
# NR>1 {
#     printRow("td")
# }
# Print HTML footer
END {
    print "    </tbody>
</table>
<p />
<p /> " 
} 

done 

IS_ALARM_LIST_FILE_NEXUS=$(cat build_info.json >> /dev/null 2>&1; echo $?)
while[ $IS_ALARM_LIST_FILE_NEXUS -eq 0 ]; do 


BEGIN {
    FS=",";
    print "<p>NEXUS_CLOUD ALARMS</p>
<p />
<table data-layout=\"full-width\">
    <tbody>
        <tr>
            <th>
                <p><strong>Nexus-Cloud</strong></p>
            </th>
            <th>
                <p />
            </th>
            <th>
                <p />
            </th>
            <th>
                <p />
            </th>
        </tr>"
}
# Function to print a row with one argument to handle either a 'th' tag or 'td' tag
function printRow(tag) {
    print "<tr>"
    print "<td>";
    for(i=1; i<=NF; i++) print "<p>"$i"</p>";
    print "</td>"
    print "</tr>"
}
# If CSV file line number (NR variable) is 1, call printRow fucntion with 'th' as argument
# NR==1 {
#     printRow("th")
# }
# # If CSV file line number (NR variable) is greater than 1, call printRow fucntion with 'td' as argument
# NR>1 {
#     printRow("td")
# }
# Print HTML footer
END {
    print "    </tbody>
</table>
<p />"
}
done