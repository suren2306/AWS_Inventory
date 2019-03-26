#AllProfiles.sh file is needed to run this script
#!/bin/bash
declare -a AllProfiles
#echo "Gathering profiles..."
AllProfiles=( $(./AllProfiles.sh ProfileNameOnly | awk '{print $1}') )
format='%s,%s,%s,%s,%s,%s,%s,%s,%s\n'
#echo "Outputting all EC2 instances from all profiles"
printf "$format" "Profile" "Region" "Instance Name" "Instance Type" "Instance ID" "State" "Private IP" "Public IP" "Created On"
#Enter a vaild aws profile in the below line
for regions in `aws ec2 describe-regions --region ap-south-1 --profile rgDevopsRND --output text | cut -f3`; do
    region=${1-"$regions"}
    for profile in ${AllProfiles[@]}; do
        #echo "Checking in $region for $profile account"
        aws ec2 describe-instances --output text --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`]|[0].Value,InstanceType,InstanceId,State.Name,PrivateIpAddress,PublicIpAddress,LaunchTime]' --profile $profile --region $region | awk -F $"\t" -v rgn=${region} -v var=${profile} -v fmt="${format}" '{printf fmt,var,rgn,$1,$2,$3,$4,$5,$6,$7}'
    done
done
echo
exit 0