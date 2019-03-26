for region in `aws ec2 describe-regions --output text | cut -f3`
do
    result_fname=$region'_ebs.csv'
    python ebs-report.py --regions $region --file $result_fname
done
head -1 $result_fname > ebs_final.csv
for filename in $(ls *ebs.csv); do sed 1d $filename >> ebs_final.csv ; done
rm *ebs.csv