#!/bin/bash
date=`date +%Y%m%d`
echo "Running Ec2 Script"
./all_instances_inCSV.sh > EC2
echo "Running Snapshots Script"
./all_snapshots_inCSV.sh > Snapshots
echo "Running EBS script"
./all_ebs_inCSV.sh > EBS
echo "Running AMI Script"
./all_ami_inCSV.sh > AMI
echo "Running Users Script"
./all_aws_user_with_policy_and_MFA_inCSV.sh > Users
#ssconvert package needs to be installed already
ssconvert --merge-to=AWS_Report_$date.xls EC2 EBS Users AMI Snapshots
rm EC2 Users AMI Snapshots EBS
