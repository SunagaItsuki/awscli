#/bin/bash

# 変数宣言
echo "パブリックルートテーブル作成処理開始"
echo "パブリックルートテーブル用変数を設定中"

source ./env/global.env
source ./env/create_RTB.env
STRING_EC2_PUBLIC_ROUTE_TABLE_TAG="ResourceType=route-table,Tags=[{Key=Name,Value=${EC2_PUBLIC_ROUTE_TABLE_TAG_NAME}}]"
EC2_VPC_ID=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME} \
    --query "Vpcs[].VpcId" \
    --output text \
)

# ルートテーブル用変数確認
echo "AWS_DEFAULT_REGION:${AWS_DEFAULT_REGION}"
echo "EC2_PUBLIC_ROUTE_TABLE_TAG_NAME:${EC2_PUBLIC_ROUTE_TABLE_TAG_NAME}"
echo "STRING_EC2_PUBLIC_ROUTE_TABLE_TAG:${STRING_EC2_PUBLIC_ROUTE_TABLE_TAG}"
echo "EC2_VPC_TAG_NAME:${EC2_VPC_TAG_NAME}"
echo "EC2_VPC_ID:${EC2_VPC_ID}"
echo "EC2_PUBLIC_SUBNET_TAG_NAME:${EC2_PUBLIC_SUBNET_TAG_NAME}"
echo "パブリックルートテーブル用変数を設定完了"

# プライベートルートテーブル用変数設定
STRING_EC2_PRIVATE_ROUTE_TABLE_TAG="ResourceType=route-table,Tags=[{Key=Name,Value=${EC2_PRIVATE_ROUTE_TABLE_TAG_NAME}}]"


# ルートテーブル作成
echo "パブリックルートテーブル[${EC2_PUBLIC_ROUTE_TABLE_TAG_NAME}]を作成します"
read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-route-table \
    --vpc-id ${EC2_VPC_ID} \
    --tag-specifications ${STRING_EC2_PUBLIC_ROUTE_TABLE_TAG} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# ルートテーブル作成結果確認
CREATED_PUBLIC_ROUTE_TABLE_NAME=$(aws ec2 describe-route-tables \
--filters Name=vpc-id,Values=${EC2_VPC_ID} \
        Name=tag:Name,Values=${EC2_PUBLIC_ROUTE_TABLE_TAG_NAME} \
--query "RouteTables[].Tags[?Key == \`Name\`].Value" \
--output text
)

echo "パブリックルートテーブル[${CREATED_PUBLIC_ROUTE_TABLE_NAME}]を作成しました"
echo "パブリックルートテーブル作成処理終了"

echo "パブリックルートテーブルとサブネットの関連付け処理開始"

# 変数宣言
EC2_PUBLIC_ROUTE_TABLE_ID=$( \
  aws ec2 describe-route-tables \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_PUBLIC_ROUTE_TABLE_TAG_NAME} \
    --query "RouteTables[].RouteTableId" \
    --output text
)

EC2_PUBLIC_SUBNET_ID=$( \
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_PUBLIC_SUBNET_TAG_NAME} \
    --query "Subnets[].SubnetId" \
    --output text \
)

# パブリックルートテーブルアタッチ用変数確認
# echo "EC2_PUBLIC_ROUTE_TABLE_ID:${EC2_PUBLIC_ROUTE_TABLE_ID}"
# echo "EC2_PUBLIC_SUBNET_ID:${EC2_PUBLIC_SUBNET_ID}"


# パブリックルートテーブルアタッチ
echo "パブリックルートテーブル[${EC2_PUBLIC_ROUTE_TABLE_TAG_NAME}]を、サブネット[${EC2_PUBLIC_SUBNET_TAG_NAME}]へアタッチします"

aws ec2 associate-route-table \
  --subnet-id ${EC2_PUBLIC_SUBNET_ID} \
  --route-table-id ${EC2_PUBLIC_ROUTE_TABLE_ID} > /dev/null
  
# パブリックルートテーブルアタッチ結果確認
ATTACHED_PUBLIC_SUBNET_ID=$(
  aws ec2 describe-route-tables \
    --route-table-ids ${EC2_PUBLIC_ROUTE_TABLE_ID} \
    --query "RouteTables[].Associations[].SubnetId" \
    --output text
)

ATTACHED_PUBLIC_SUBNET_NAME=$( \
  aws ec2 describe-subnets \
    --filters Name=subnet-id,Values=${ATTACHED_PUBLIC_SUBNET_ID} \
    --query "Subnets[].Tags[].Value" \
    --output text \
)

echo "パブリックルートテーブル[${EC2_PUBLIC_ROUTE_TABLE_TAG_NAME}]を、サブネット[${ATTACHED_PUBLIC_SUBNET_NAME}]へアタッチしました"
echo "パブリックルートテーブルとサブネットの関連付け処理終了"


# --------------------------------------------------------------------------------------------------------------------------------プライベート↓

# 変数宣言
echo "プライベートルートテーブル作成処理開始"
echo "プライベートルートテーブル用変数を設定中"

echo "EC2_PRIVATE_ROUTE_TABLE_TAG_NAME:${EC2_PRIVATE_ROUTE_TABLE_TAG_NAME}"
echo "STRING_EC2_PRIVATE_ROUTE_TABLE_TAG:${STRING_EC2_PRIVATE_ROUTE_TABLE_TAG}"
echo "EC2_PLIVATE_SUBNET_TAG_NAME:${EC2_PRIVATE_SUBNET_TAG_NAME}"
echo "プライベートルートテーブル用変数の設定完了"

#プライベートルートテーブル作成
echo "プライベートルートテーブル[${EC2_PRIVATE_ROUTE_TABLE_TAG_NAME}]を作成します"
read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-route-table \
    --vpc-id ${EC2_VPC_ID} \
    --tag-specifications ${STRING_EC2_PRIVATE_ROUTE_TABLE_TAG} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# プライベートルートテーブル作成結果確認
CREATED_PRIVATE_ROUTE_TABLE_NAME=$(aws ec2 describe-route-tables \
--filters Name=vpc-id,Values=${EC2_VPC_ID} \
        Name=tag:Name,Values=${EC2_PRIVATE_ROUTE_TABLE_TAG_NAME} \
--query "RouteTables[].Tags[?Key == \`Name\`].Value" \
--output text
)

echo "プライベートルートテーブル[${CREATED_PRIVATE_ROUTE_TABLE_NAME}]を作成しました"
echo "プライベートルートテーブル作成処理終了"

echo "プライベートルートテーブルとサブネットの関連付け処理開始"

# 変数宣言
EC2_PRIVATE_ROUTE_TABLE_ID=$( \
  aws ec2 describe-route-tables \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_PRIVATE_ROUTE_TABLE_TAG_NAME} \
    --query "RouteTables[].RouteTableId" \
    --output text
)

EC2_PRIVATE_SUBNET_ID=$( \
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
              Name=tag:Name,Values=${EC2_PRIVATE_SUBNET_TAG_NAME} \
    --query "Subnets[].SubnetId" \
    --output text \
)

# プライベートルートテーブルアタッチ用変数確認
# echo "EC2_PRIVATE_ROUTE_TABLE_ID:${EC2_PRIVATE_ROUTE_TABLE_ID}"
# echo "EC2_PRIVATE_SUBNET_ID:${EC2_PRIVATE_SUBNET_ID}"


# プライベートルートテーブルアタッチ
echo "プライベートルートテーブル[${EC2_PRIVATE_ROUTE_TABLE_TAG_NAME}]を、サブネット[${EC2_PRIVATE_SUBNET_TAG_NAME}]へアタッチします"

aws ec2 associate-route-table \
--subnet-id ${EC2_PRIVATE_SUBNET_ID} \
--route-table-id ${EC2_PRIVATE_ROUTE_TABLE_ID} > /dev/null
  
# プライベートルートテーブルアタッチ結果確認
ATTACHED_PRIVATE_SUBNET_ID=$(
  aws ec2 describe-route-tables \
    --route-table-ids ${EC2_PRIVATE_ROUTE_TABLE_ID} \
    --query "RouteTables[].Associations[].SubnetId" \
    --output text
)

ATTACHED_PRIVATE_SUBNET_NAME=$( \
  aws ec2 describe-subnets \
    --filters Name=subnet-id,Values=${ATTACHED_PRIVATE_SUBNET_ID} \
    --query "Subnets[].Tags[].Value" \
    --output text \
)

echo "プライベートルートテーブル[${EC2_PRIVATE_ROUTE_TABLE_TAG_NAME}]を、サブネット[${ATTACHED_PRIVATE_SUBNET_NAME}]へアタッチしました"
echo "プライベートルートテーブルとサブネットの関連付け処理終了"
