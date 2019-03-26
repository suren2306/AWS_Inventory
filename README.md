# AWS_Inventory
I customised few scripts from paulbayer's [Inventory_scripts](https://github.com/paulbayer/Inventory_Scripts)<br>

All profiles.sh script gathers the AWS profiles information. <br>

aws_user_policy_with_MFA.sh list the users with the attached policies and their MFA status in all aws accounts.<br>

all_my_instances.sh captures details of EC2 instances across all regions<br>

ebs-report.py gathers ebs volume details. It can be run with python ebs-report.py --regions "region-name". <br>

ebs_report_all_regions.sh runs the python script for all regions.<br>


For CSV report, go into the CSV folder and run all_my_instances_inCSV.sh > Filename.csv<br>

*Known Issue : Sometimes you will get all the resources listed twice, as a workaround you can remove/rename the config file insde your .aws directory*


