#AllProfiles.sh file is needed to run this script
#!/bin/bash
#List information of first 5 attached disks, increase it if you need
declare -a AllProfiles
#echo "Gathering profiles..."
AllProfiles=( $(./AllProfiles.sh ProfileNameOnly | awk '{print $1}') )
format='%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n'
#echo "Outputting all EC2 instances from all profiles"
printf "$format" "Profile" "Region" "AMI Name" "AMI ID" "Description" "Disk 1" "Disk 2" "Disk 3" "Disk 4" "Disk 5"
for profile in ${AllProfiles[@]}; do
    #Enter a vaild aws profile in the below line
    for regions in `aws ec2 describe-regions --region ap-south-1 --profile $profile --output text | cut -f3`; do
    #echo -e Checking $regions for $profile
    aws ec2 describe-images --owner self --output text --query 'Images[].[Tags[?Key==`Name`]|[0].Value,CreationDate,ImageId,BlockDeviceMappings[]|[0].Ebs.VolumeSize,BlockDeviceMappings[]|[1].Ebs.VolumeSize,BlockDeviceMappings[]|[2].Ebs.VolumeSize,BlockDeviceMappings[]|[3].Ebs.VolumeSize,BlockDeviceMappings[]|[4].Ebs.VolumeSize]' --profile $profile --region $regions | awk -F $"\t" -v rgn=${regions} -v var=${profile} -v fmt="${format}" '{printf fmt,var,rgn,$1,$2,$3,$4,$5,$6,$7,$8}'
    done
done
echo
exit 0