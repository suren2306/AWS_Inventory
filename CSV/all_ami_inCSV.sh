#AllProfiles.sh file is needed to run this script
#!/bin/bash
#List information of first 5 attached disks, increase it if you need
declare -a AllProfiles
declare -a AccountID
#echo "Gathering profiles..."
AllProfiles=($(/root/AWS_Inventory/AllProfiles.sh ProfileNameOnly | awk '{print $1}'))
format='%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n'
#echo "Outputting all EC2 instances from all profiles"
printf "$format" "Profile" "Account ID" "Region" "AMI Name" "AMI ID" "Created On" "Disk 1" "Disk 2" "Disk 3" "Disk 4" "Disk 5" "Description"
for profile in ${AllProfiles[@]}; do
    AccountID=$(aws sts get-caller-identity --query Account --output text --profile $profile)
    #Enter a vaild aws profile in the below line
    for regions in $(aws ec2 describe-regions --region ap-south-1 --profile $profile --output text | cut -f3); do
        #echo -e Checking $regions for $profile
        aws ec2 describe-images --owner self --output text --query 'Images[].[Tags[?Key==`Name`]|[0].Value,ImageId,CreationDate,BlockDeviceMappings[]|[0].Ebs.VolumeSize,BlockDeviceMappings[]|[1].Ebs.VolumeSize,BlockDeviceMappings[]|[2].Ebs.VolumeSize,BlockDeviceMappings[]|[3].Ebs.VolumeSize,BlockDeviceMappings[]|[4].Ebs.VolumeSize,Description]' --profile $profile --region $regions | awk -F $"\t" -v rgn=${regions} -v var=${profile} -v id=${AccountID} -v fmt="${format}" '{printf fmt,var,id,rgn,$1,$2,$3,$4,$5,$6,$7,$8,$9}'
    done
done
echo
exit 0
