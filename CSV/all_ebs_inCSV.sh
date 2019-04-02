#!/bin/bash
declare -a AllProfiles
#echo "Gathering profiles..."
format='%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n'
#echo "Outputting all EC2 instances from all profiles"
printf "$format" "Profile" "Region" "Volume Name" "Volume ID" "Volume Type" "Size" "Iops" "State" "Attached To" "Mount Point" "Created On" 
AllProfiles=( $(./AllProfiles.sh ProfileNameOnly | awk '{print $1}') )
for profile in ${AllProfiles[@]}; do
    for regions in `aws ec2 describe-regions --region ap-south-1 --profile $profile --output text | cut -f3`; do
    #echo -e Checking $regions for $profile
    aws ec2 describe-volumes --output text --query 'Volumes[].[Tags[?Key==`Name`]|[0].Value,VolumeId,VolumeType,Size,Iops,State,Attachments[]|[0].InstanceId,Attachments[]|[0].Device,CreateTime]' --profile $profile --region $regions | awk -F $"\t" -v rgn=${regions} -v var=${profile} -v fmt="${format}" '{printf fmt,var,rgn,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10}'
    done
done
echo
exit 0