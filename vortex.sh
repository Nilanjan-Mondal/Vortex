#!/bin/bash

# ╔════════════════════════════════════════════════════════════╗
# ║                VORTEX - AWS Resource Viewer                ║
# ║────────────────────────────────────────────────────────────║
# ║ Script Name : awscli.sh                                    ║
# ║ Description : Interactive tool to fetch AWS resource       ║
# ║               information in JSON and tabular format.      ║
# ║                                                            ║
# ║ Usage       : ./awscli.sh <aws_region> <aws_service>       ║
# ║ Example     : ./awscli.sh us-east-1 ec2                    ║
# ║                                                            ║
# ║ Output      :                                              ║
# ║    - JSON file  → output_logs/output_<service>.json        ║
# ║    - Table file → output_logs/output_<service>_table.txt   ║
# ║                                                            ║
# ║ Author      : Json Brewer                                  ║
# ║ Version     : 1.0                                          ║
# ║ Requirements: AWS CLI, jq (optional for JSON formatting)   ║
# ╚════════════════════════════════════════════════════════════╝


# ── Colors ─────────────────────────────────────────────────────
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
BLUE="\033[0;34m"
BOLD="\033[1m"
RESET="\033[0m"

# ── Start ──────────────────────────────────────────────────────
clear

# ── Banner ─────────────────────────────────────────────────────
printf "\n"
printf "${YELLOW}██╗   ██╗ ██████╗ ██████╗ ████████╗███████╗██╗  ██╗\n"
printf "${YELLOW}██║   ██║██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝╚██╗██╔╝\n"
printf "${YELLOW}██║   ██║██║   ██║██████╔╝   ██║   █████╗   ╚███╔╝ \n"
printf "${YELLOW}╚██╗ ██╔╝██║   ██║██╔══██╗   ██║   ██╔══╝   ██╔██╗ \n"
printf "${YELLOW} ╚████╔╝ ╚██████╔╝██║  ██║   ██║   ███████╗██╔╝ ██╗\n"
printf "${YELLOW}  ╚═══╝   ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝${RESET}\n\n"

printf "${BLUE}~ Developed by Json Brewer (Nilanjan Mondal)\n"
printf "${BLUE}~ copyright (c) 2025, Nilanjan Mondal\n\n"

# ── Argument Check ─────────────────────────────────────────────
if [ $# -ne 2 ]; then
    printf "${CYAN}┌────────────────────────────────────────────────────┐\n"
    printf "${CYAN}│${RESET} ${RED} ${BOLD} Usage: ./vortex.sh <aws_region> <aws_service>${CYAN}    │\n"
    printf "${CYAN}└────────────────────────────────────────────────────┘${RESET}\n"
    printf "${GREEN}[i] Example: ./vortex.sh us-east-1 ec2${RESET}\n"
    exit 1
fi

aws_region=$1
aws_service=$2

output_dir="output_logs"
mkdir -p "$output_dir"
json_file="${output_dir}/output_${aws_service}.json"
table_file="${output_dir}/output_${aws_service}_table.txt"

# ── Pre-checks ────────────────────────────────────────────────
if ! command -v aws > /dev/null 2>&1; then
    printf "${RED}[✘] AWS CLI is not installed. Please install it and try again.${RESET}\n"
    exit 1
fi

if [ ! -d ~/.aws ]; then
    printf "${RED}[✘] AWS CLI is not configured. Run 'aws configure' first.${RESET}\n"
    exit 1
fi

# ── Header Box ────────────────────────────────────────────────
printf "${CYAN}┌────────────────────────────────────────────────────────────┐\n"
printf "${CYAN}│${RESET}  ${BOLD}                  Lisiting AWS Resource                   ${CYAN}│\n"
printf "${CYAN}└────────────────────────────────────────────────────────────┘${RESET}\n"
printf "\n"
printf "${YELLOW}[i] Region: ${aws_region}${RESET}\n"
printf "${YELLOW}[i] Service: ${aws_service}${RESET}\n"

# ── Dispatcher ────────────────────────────────────────────────
case $aws_service in
    ec2)
        aws ec2 describe-instances --region "$aws_region" --output json > "$json_file"
        aws ec2 describe-instances --region "$aws_region" \
            --query "Reservations[].Instances[].{ID: InstanceId, Type: InstanceType, State: State.Name}" \
            --output table > "$table_file"
        ;;
    rds)
        aws rds describe-db-instances --region "$aws_region" --output json > "$json_file"
        aws rds describe-db-instances --region "$aws_region" \
            --query "DBInstances[].{ID: DBInstanceIdentifier, Engine: Engine, Status: DBInstanceStatus}" \
            --output table > "$table_file"
        ;;
    s3)
        aws s3api list-buckets --output json > "$json_file"
        aws s3api list-buckets \
            --query "Buckets[].{Name: Name, Created: CreationDate}" \
            --output table > "$table_file"
        ;;
    cloudfront)
        aws cloudfront list-distributions --output json > "$json_file"
        aws cloudfront list-distributions \
            --query "DistributionList.Items[].{ID: Id, Domain: DomainName, Status: Status}" \
            --output table > "$table_file"
        ;;
    vpc)
        aws ec2 describe-vpcs --region "$aws_region" --output json > "$json_file"
        aws ec2 describe-vpcs --region "$aws_region" \
            --query "Vpcs[].{ID: VpcId, CIDR: CidrBlock, State: State}" \
            --output table > "$table_file"
        ;;
    iam)
        aws iam list-users --output json > "$json_file"
        aws iam list-users \
            --query "Users[].{User: UserName, ARN: Arn, Created: CreateDate}" \
            --output table > "$table_file"
        ;;
    route53)
        aws route53 list-hosted-zones --output json > "$json_file"
        aws route53 list-hosted-zones \
            --query "HostedZones[].{Name: Name, ID: Id, Private: Config.PrivateZone}" \
            --output table > "$table_file"
        ;;
    cloudwatch)
        aws cloudwatch describe-alarms --region "$aws_region" --output json > "$json_file"
        aws cloudwatch describe-alarms --region "$aws_region" \
            --query "MetricAlarms[].{Name: AlarmName, State: StateValue, Metric: MetricName}" \
            --output table > "$table_file"
        ;;
    cloudformation)
        aws cloudformation describe-stacks --region "$aws_region" --output json > "$json_file"
        aws cloudformation describe-stacks --region "$aws_region" \
            --query "Stacks[].{Name: StackName, Status: StackStatus}" \
            --output table > "$table_file"
        ;;
    lambda)
        aws lambda list-functions --region "$aws_region" --output json > "$json_file"
        aws lambda list-functions --region "$aws_region" \
            --query "Functions[].{Name: FunctionName, Runtime: Runtime}" \
            --output table > "$table_file"
        ;;
    sns)
        aws sns list-topics --region "$aws_region" --output json > "$json_file"
        aws sns list-topics --region "$aws_region" \
            --query "Topics[].{TopicArn: TopicArn}" \
            --output table > "$table_file"
        ;;
    sqs)
        aws sqs list-queues --region "$aws_region" --output json > "$json_file"
        aws sqs list-queues --region "$aws_region" \
            --query "QueueUrls[]" \
            --output table > "$table_file"
        ;;
    dynamodb)
        aws dynamodb list-tables --region "$aws_region" --output json > "$json_file"
        aws dynamodb list-tables --region "$aws_region" \
            --query "TableNames[]" \
            --output table > "$table_file"
        ;;
    ebs)
        aws ec2 describe-volumes --region "$aws_region" --output json > "$json_file"
        aws ec2 describe-volumes --region "$aws_region" \
            --query "Volumes[].{ID: VolumeId, Size: Size, State: State}" \
            --output table > "$table_file"
        ;;
    *)
        printf "${RED}[✘] Invalid service: '${aws_service}'${RESET}\n"
        exit 1
        ;;
esac

# ── Output Display ────────────────────────────────────────────
printf "${GREEN}[✔] JSON saved to: ${json_file}${RESET}\n"
printf "${GREEN}[✔] Table saved to: ${table_file}${RESET}\n"
printf "${YELLOW}[i] Displaying table output below:${RESET}\n\n"

sed -E "s/([|+-])/$(printf "${CYAN}")\1$(printf "${RESET}")/g" "$table_file"


# ── Pause and Clear ───────────────────────────────────────────
echo
