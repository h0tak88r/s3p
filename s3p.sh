#!/bin/bash

# Default values
BUCKET_NAME=""
TEST_FILE="s3_test_file.txt"
LOCAL_FILE="/tmp/$TEST_FILE"
NO_SIGN_REQUEST=false

# Colors for output
GREEN="\033[1;32m"
RED="\033[1;31m"
BLUE="\033[1;34m"
NC="\033[0m" # No color

# Function to display usage
usage() {
    echo -e "${BLUE}Usage: $0 -b <bucket_name> [-n]${NC}"
    echo -e "  -b <bucket_name>  : Specify the S3 bucket name"
    echo -e "  -n                : Use --no-sign-request (for public buckets)"
    exit 1
}

# Parse command-line arguments
while getopts "b:n" opt; do
    case "${opt}" in
        b) BUCKET_NAME="${OPTARG}" ;;
        n) NO_SIGN_REQUEST=true ;;
        *) usage ;;
    esac
done

# Check if bucket name is provided
if [[ -z "$BUCKET_NAME" ]]; then
    echo -e "${RED}Error: Bucket name is required.${NC}"
    usage
fi

# Set AWS command flag
AWS_FLAG=""
if [[ "$NO_SIGN_REQUEST" == true ]]; then
    AWS_FLAG="--no-sign-request"
fi

# Create a temporary local file for testing write permissions
echo "This is a test file." > "$LOCAL_FILE"

# Function to check permissions
check_permission() {
    local perm_name="$1"
    local aws_command="$2"

    echo -ne "🔍 Checking ${perm_name} permission... ⏳ "
    if eval "$aws_command" &>/dev/null; then
        echo -e "✅ ${GREEN}ALLOWED${NC}"
    else
        echo -e "❌ ${RED}DENIED${NC}"
    fi
}

# Display header
echo -e "\n📊 ${BLUE}Testing S3 Bucket Permissions: ${BUCKET_NAME}${NC}\n"

# Run permission checks
check_permission "Read" "aws s3 ls s3://$BUCKET_NAME $AWS_FLAG"
check_permission "Write" "aws s3 cp $LOCAL_FILE s3://$BUCKET_NAME/$TEST_FILE $AWS_FLAG && aws s3 rm s3://$BUCKET_NAME/$TEST_FILE $AWS_FLAG"
check_permission "READ_ACP" "aws s3api get-bucket-acl --bucket $BUCKET_NAME $AWS_FLAG"
check_permission "WRITE_ACP" "aws s3api put-bucket-acl --bucket $BUCKET_NAME --acl private $AWS_FLAG"
check_permission "FULL_CONTROL" "aws s3api put-bucket-acl --bucket $BUCKET_NAME --acl private $AWS_FLAG && aws s3 cp $LOCAL_FILE s3://$BUCKET_NAME/$TEST_FILE $AWS_FLAG && aws s3 rm s3://$BUCKET_NAME/$TEST_FILE $AWS_FLAG && aws s3 ls s3://$BUCKET_NAME $AWS_FLAG"

# Clean up local test file
rm "$LOCAL_FILE"

# Final message
echo -e "\n✅ ${GREEN}Permission check complete.${NC}\n"
