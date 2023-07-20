#/bin/bash

# 変数宣言
echo "VPC作成処理開始"
echo "VPC用変数を設定中"

export AWS_DEFAULT_REGION='us-east-1'
EC2_VPC_TAG_NAME='your_vpc_name'
EC2_VPC_CIDR='10.0.0.0/16'
STRING_EC2_VPC_TAG="ResourceType=vpc,Tags=[{Key=Name,Value=${EC2_VPC_TAG_NAME}}]" \

#VPC用変数確認
echo "AWS_DEFAULT_REGION:${AWS_DEFAULT_REGION}"
echo "EC2_VPC_TAG_NAME:${EC2_VPC_TAG_NAME}"
echo "EC2_VPC_CIDR:${EC2_VPC_CIDR}"
echo "STRING_EC2_VPC_TAG:${STRING_EC2_VPC_TAG}"

echo "VPC用変数の設定完了"

# VPC作成
echo "VPC[${EC2_VPC_TAG_NAME}]を作成します"

read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-vpc \
    --cidr-block ${EC2_VPC_CIDR} \
    --tag-specifications ${STRING_EC2_VPC_TAG} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# VPC作成結果確認
CREATED_VPC_NAME=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME}  \
    --query 'Vpcs[].Tags[?Key == `Name`].Value' \
    --output text
)

echo "VPC[${CREATED_VPC_NAME}]を作成しました"
echo "VPC作成処理終了"
