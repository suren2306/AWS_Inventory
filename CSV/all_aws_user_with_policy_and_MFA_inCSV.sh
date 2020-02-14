#!/bin/bash
#AllProfiles.sh file is needed to run this script
declare -a AllProfiles
declare -a AcctUsers
declare -a AccountID

AllProfiles=( $(/root/AWS_Inventory/AllProfiles.sh ProfileNameOnly | awk '{print $1}') )

printf "%s,%s,%s,%s,%s \n" "Profile" "Account ID" "User Name" "MFA" "AttachedPolicies"
# Cycles through each profile
for profile in ${AllProfiles[@]}; do
	#echo "Running for profile: $profile"
    AccountID=$(aws sts get-caller-identity --query Account --output text --profile $profile)
	AcctUsers=( $(aws iam list-users --output text --query 'Users[].UserName' --profile $profile | tr '\t' '\n') )
	for user in ${AcctUsers[@]}; do
        mfa_status=`aws iam list-mfa-devices --user-name $user --profile $profile --output text`
        if [ -z "$mfa_status" ]; then MFA="No"; else MFA="Yes"; fi
        #echo $MFA
		aws iam list-attached-user-policies --user-name $user --profile $profile --output text --query 'AttachedPolicies[].PolicyName' | tr '\t' '\n' | awk -F $"\t" -v var=${profile} -v var2=${user} -v var3=${MFA} -v var4=${AccountID} '{printf "%s,%s,%s,%s,%s \n",var,var4,var2,var3,$1}'
		aws iam list-user-policies --user-name $user --profile $profile --output text --query 'PolicyNames' | tr '\t' '\n' | awk -F $"\t" -v var=${profile} -v var2=${user} -v var3=${MFA} -v var4=${AccountID} '{printf "%s,%s,%s,%s,%s \n",var,var4,var2,var3,$1}'
	done
done

echo
exit 0
