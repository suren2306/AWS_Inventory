#!/bin/bash
# Last month 1st day:
lastmonthdate=$(date -d "`date +%Y%m01` -1 month" +%Y-%m-%d)
# This month 1st day:
thismonthdate=$(date -d "`date +%Y%m01`" +%Y-%m-%d)
lastmonth=$(cal -3|awk 'NR==1{print toupper(substr($1,1,3))"-"$2}')
declare -a AllProfiles
declare -a AccountID
format='%s,%s,%s,%s\n'
printf "$format" "Profile" "Account ID" "Month" "Bill Amount"
AllProfiles=( $(/root/AWS_Inventory/AllProfiles.sh ProfileNameOnly | awk '{print $1}') )
for profile in ${AllProfiles[@]}; do
AccountID=$(aws sts get-caller-identity --query Account --output text --profile $profile)
aws ce get-cost-and-usage --time-period Start=$lastmonthdate,End=$thismonthdate --granularity MONTHLY --metrics "BlendedCost" --query 'ResultsByTime[].[Total.BlendedCost.Amount]' --profile $profile --region us-east-1 --output text | awk -F $"\t" -v rgn="Global" -v var=${profile} -v id=${AccountID} -v month=${lastmonth} -v fmt="${format}" '{printf fmt,var,id,month,$1}'
done
echo
exit 0
