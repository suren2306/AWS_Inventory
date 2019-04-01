#AllProfiles.sh file is needed to run this script
#!/bin/bash
#Maximum of 5 disks support, increase it if you need
declare -a AllProfiles
#echo "Gathering profiles..."
AllProfiles=( $(./AllProfiles.sh ProfileNameOnly | awk '{print $1}') )
format='%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n'
#echo "Outputting all EC2 instances from all profiles"
printf "$format" "Profile" "Region" "Snapshot Name" "Snapshot ID" "Volume ID" "Size" "Created On" "Status" "Description"
#Enter a vaild aws profile in the below line
for profile in ${AllProfiles[@]}; do
    for regions in `aws ec2 describe-regions --region ap-south-1 --profile $profile --output text | cut -f3`; do
    #echo -e Checking $regions for $profile
    aws ec2 describe-snapshots --owner self --output text --query 'Snapshots[].[Tags[?Key==`Name`]|[0].Value,SnapshotId,VolumeId,VolumeSize,StartTime,State,Description]' --profile $profile --region $regions | awk -F $"\t" -v rgn=${regions} -v var=${profile} -v fmt="${format}" '{printf fmt,var,rgn,$1,$2,$3,$4,$5,$6,$7,$8}'
    done
done
echo
exit 0