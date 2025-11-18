#!/usr/bin/env bash
set -e

S3_BUCKET="s3://www.kasseh.com/"
DISTRIBUTION_ID="E1GZFO8GZZDYJY"
AWS_PROFILE="mr-ouss"
TEMPFILE=$(mktemp)
####################################

echo "1. Deleting all DS_Store files..."
find . -name *DS_Store -exec rm {} \;

echo "2. Copying files with content type..."
aws s3 sync . $S3_BUCKET \
  --exclude ".git/*" \
  --exclude ".git*" \
  --exclude ".DS_Store" \
  --exclude "refresh.sh" \
  --exclude "README.md" \
  --delete \
  --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers \
  --profile $AWS_PROFILE | tee -a $TEMPFILE

echo "3. Invalidating Cloudfront cache..."
grep "upload\|deleted" $TEMPFILE | sed -e "s|.*upload.*to $S3_BUCKET|/|" | sed -e "s|.*delete: $S3_BUCKET|/|" | tr '\n' ' ' | xargs \
  aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths --profile $AWS_PROFILE

echo "Done. Bye!"
