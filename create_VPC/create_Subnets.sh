#/bin/bash

# パブリックサブネットa用変数宣言
echo "サブネット作成処理開始"
echo "パブリックサブネットa用変数設定中"

AWS_DEFAULT_REGION='us-east-1'
EC2_AZ_CODE="a"
EC2_SUBNET_TYPE="public"
EC2_SUBNET_TAG_NAME="your_public_subnet_name(az:a)"
EC2_SUBNET_CIDR='10.0.1.0/24'
EC2_AZ_NAME=${AWS_DEFAULT_REGION}${EC2_AZ_CODE}
STRING_EC2_SUBNET_TAG="ResourceType=subnet,Tags=[{Key=Name,Value=${EC2_SUBNET_TAG_NAME}}]"
EC2_VPC_TAG_NAME='your_vpc_name'
EC2_VPC_ID=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME}  \
    --query 'Vpcs[].VpcId' \
    --output text \
)

# パブリックサブネットa用変数確認
echo "AWS_DEFAULT_REGION:${AWS_DEFAULT_REGION}"
echo "EC2_AZ_CODE:${EC2_AZ_CODE}"
echo "EC2_SUBNET_TYPE:${EC2_SUBNET_TYPE}"
echo "EC2_SUBNET_TAG_NAME:${EC2_SUBNET_TAG_NAME}"
echo "EC2_SUBNET_CIDR:${EC2_SUBNET_CIDR}"
echo "EC2_AZ_NAME:${EC2_AZ_NAME}"
echo "STRING_EC2_SUBNET_TAG:${STRING_EC2_SUBNET_TAG}"
echo "EC2_VPC_TAG_NAME:${EC2_VPC_TAG_NAME}"
echo "EC2_VPC_ID:${EC2_VPC_ID}"

echo "パブリックサブネットa用変数の設定完了"

# パブリックサブネットa作成
echo "サブネット[${EC2_SUBNET_TAG_NAME}]を作成します"

read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-subnet \
    --vpc-id ${EC2_VPC_ID} \
    --cidr-block ${EC2_SUBNET_CIDR} \
    --availability-zone ${EC2_AZ_NAME} \
    --tag-specifications ${STRING_EC2_SUBNET_TAG} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# パブリックサブネットa作成結果確認
CREATED_SUBNET_NAME=$( \
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME}  \
    --query 'Subnets[].Tags[?Key==`Name`].Value' \
    --output text
)

CREATED_SUBNET_CIDR=$( \
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME}  \
    --query "Subnets[].CidrBlock" \
    --output text
)

echo "サブネット[${CREATED_SUBNET_NAME}]を作成しました"
echo "作成したサブネット名:${CREATED_SUBNET_NAME}"
echo "作成したサブネットCIDR:${CREATED_SUBNET_CIDR}"

# **********************************************************************************************************パブリックサブネットC↓

echo "パブリックサブネットc用変数設定中"
EC2_AZ_CODE="c"
EC2_SUBNET_TYPE="public"
EC2_SUBNET_TAG_NAME="your_public_subnet_name(az:c)"
EC2_SUBNET_CIDR='10.0.2.0/24'
EC2_AZ_NAME=${AWS_DEFAULT_REGION}${EC2_AZ_CODE}
STRING_EC2_SUBNET_TAG="ResourceType=subnet,Tags=[{Key=Name,Value=${EC2_SUBNET_TAG_NAME}}]"
EC2_VPC_ID=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME}  \
    --query 'Vpcs[].VpcId' \
    --output text \
)

# パブリックサブネットc用変数確認
echo "EC2_AZ_CODE:${EC2_AZ_CODE}"
echo "EC2_SUBNET_TYPE:${EC2_SUBNET_TYPE}"
echo "EC2_SUBNET_TAG_NAME:${EC2_SUBNET_TAG_NAME}"
echo "EC2_SUBNET_CIDR:${EC2_SUBNET_CIDR}"
echo "EC2_AZ_NAME:${EC2_AZ_NAME}"
echo "STRING_EC2_SUBNET_TAG:${STRING_EC2_SUBNET_TAG}"
echo "EC2_VPC_ID:${EC2_VPC_ID}"

echo "パブリックサブネットc用変数の設定完了"


# パブリックサブネットC作成
echo "サブネット[${EC2_SUBNET_TAG_NAME}]を作成します"
read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-subnet \
    --vpc-id ${EC2_VPC_ID} \
    --cidr-block ${EC2_SUBNET_CIDR} \
    --availability-zone ${EC2_AZ_NAME} \
    --tag-specifications ${STRING_EC2_SUBNET_TAG} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# パブリックサブネットc作成結果確認
CREATED_SUBNET_NAME=$( \
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME}  \
    --query 'Subnets[].Tags[?Key==`Name`].Value' \
    --output text
)

CREATED_SUBNET_CIDR=$( \
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME}  \
    --query "Subnets[].CidrBlock" \
    --output text
)

echo "サブネット[${CREATED_SUBNET_NAME}]を作成しました"
echo "作成したサブネット名:${CREATED_SUBNET_NAME}"
echo "作成したサブネットCIDR:${CREATED_SUBNET_CIDR}"


# **********************************************************************************************************プライベートサブネットa↓

echo "プライベートサブネットa用変数設定中"
EC2_AZ_CODE="a"
EC2_SUBNET_TYPE="private"
EC2_SUBNET_TAG_NAME="your_private_subnet_name(az:a)"
EC2_SUBNET_CIDR='10.0.100.0/24'
EC2_AZ_NAME=${AWS_DEFAULT_REGION}${EC2_AZ_CODE}
STRING_EC2_SUBNET_TAG="ResourceType=subnet,Tags=[{Key=Name,Value=${EC2_SUBNET_TAG_NAME}}]"
EC2_VPC_ID=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME}  \
    --query 'Vpcs[].VpcId' \
    --output text
)

# プライベートサブネットa用変数確認
echo "EC2_AZ_CODE:${EC2_AZ_CODE}"
echo "EC2_SUBNET_TYPE:${EC2_SUBNET_TYPE}"
echo "EC2_SUBNET_TAG_NAME:${EC2_SUBNET_TAG_NAME}"
echo "EC2_SUBNET_CIDR:${EC2_SUBNET_CIDR}"
echo "EC2_AZ_NAME:${EC2_AZ_NAME}"
echo "STRING_EC2_SUBNET_TAG:${STRING_EC2_SUBNET_TAG}"
echo "EC2_VPC_ID:${EC2_VPC_ID}"
echo "プライベートサブネットa用変数の設定完了"

# プライベートサブネットa作成
echo "サブネット[${EC2_SUBNET_TAG_NAME}]を作成します"
read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-subnet \
    --vpc-id ${EC2_VPC_ID} \
    --cidr-block ${EC2_SUBNET_CIDR} \
    --availability-zone ${EC2_AZ_NAME} \
    --tag-specifications ${STRING_EC2_SUBNET_TAG} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# プライベートサブネットa作成結果確認
CREATED_SUBNET_NAME=$(\
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME}  \
    --query 'Subnets[].Tags[?Key==`Name`].Value' \
    --output text
)

CREATED_SUBNET_CIDR=$(\
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME}  \
    --query "Subnets[].CidrBlock" \
    --output text
)

echo "サブネット[${CREATED_SUBNET_NAME}]を作成しました"
echo "作成したサブネット名:${CREATED_SUBNET_NAME}"
echo "作成したサブネットCIDR:${CREATED_SUBNET_CIDR}"


# **********************************************************************************************************プライベートサブネットc↓

echo "プライベートサブネットc用変数設定中"
EC2_AZ_CODE="c"
EC2_SUBNET_TYPE="private"
EC2_SUBNET_TAG_NAME="your_private_subnet_name(az:c)"
EC2_SUBNET_CIDR='10.0.200.0/24'
EC2_AZ_NAME=${AWS_DEFAULT_REGION}${EC2_AZ_CODE}
STRING_EC2_SUBNET_TAG="ResourceType=subnet,Tags=[{Key=Name,Value=${EC2_SUBNET_TAG_NAME}}]"
EC2_VPC_ID=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME}  \
    --query 'Vpcs[].VpcId' \
    --output text
)

# プライベートサブネットc用変数確認
echo "EC2_AZ_CODE:${EC2_AZ_CODE}"
echo "EC2_SUBNET_TYPE:${EC2_SUBNET_TYPE}"
echo "EC2_SUBNET_TAG_NAME:${EC2_SUBNET_TAG_NAME}"
echo "EC2_SUBNET_CIDR:${EC2_SUBNET_CIDR}"
echo "EC2_AZ_NAME:${EC2_AZ_NAME}"
echo "STRING_EC2_SUBNET_TAG:${STRING_EC2_SUBNET_TAG}"
echo "EC2_VPC_ID:${EC2_VPC_ID}"
echo "プライベートサブネットc用変数の設定完了"

# プライベートサブネットc作成
echo "サブネット[${EC2_SUBNET_TAG_NAME}]を作成します"
read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-subnet \
    --vpc-id ${EC2_VPC_ID} \
    --cidr-block ${EC2_SUBNET_CIDR} \
    --availability-zone ${EC2_AZ_NAME} \
    --tag-specifications ${STRING_EC2_SUBNET_TAG} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# プライベートサブネットc作成結果確認
CREATED_SUBNET_NAME=$(\
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME}  \
    --query 'Subnets[].Tags[?Key==`Name`].Value' \
    --output text
)

CREATED_SUBNET_CIDR=$(\
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME}  \
    --query "Subnets[].CidrBlock" \
    --output text
)

echo "サブネット[${CREATED_SUBNET_NAME}]を作成しました"
echo "作成したサブネット名:${CREATED_SUBNET_NAME}"
echo "作成したサブネットCIDR:${CREATED_SUBNET_CIDR}"


# 作成した全サブネットの名前確認
CREATED_SUBNETS_NAME=$(\
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
    --query 'Subnets[].Tags[?Key == `Name`].Value' \
    --output text
)

echo -e "作成したサブネット名一覧:\n${CREATED_SUBNETS_NAME}"
echo "サブネット作成処理終了"
