#/bin/bash

# 変数宣言
echo "IGW作成処理開始"
echo "IGW用変数を設定中"

export AWS_DEFAULT_REGION='us-east-1'
EC2_INTERNET_GATEWAY_TAG_NAME='Lab-igw'
STRING_EC2_INTERNET_GATEWAY_TAG="ResourceType=internet-gateway,Tags=[{Key=Name,Value=${EC2_INTERNET_GATEWAY_TAG_NAME}}]"
EC2_VPC_TAG_NAME='Lab'

#IGW用変数確認
echo "AWS_DEFAULT_REGION:${AWS_DEFAULT_REGION}"
echo "EC2_INTERNET_GATEWAY_TAG_NAME:${EC2_INTERNET_GATEWAY_TAG_NAME}"
echo "STRING_EC2_INTERNET_GATEWAY_TAG:${STRING_EC2_INTERNET_GATEWAY_TAG}"
echo "EC2_VPC_TAG_NAME:${EC2_VPC_TAG_NAME}"
echo "IGW用変数を設定完了"

# IGW作成
echo "IGW[${EC2_INTERNET_GATEWAY_TAG_NAME}]を作成し、VPC[${EC2_VPC_TAG_NAME}]へアタッチします"
read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-internet-gateway \
    --tag-specifications ${STRING_EC2_INTERNET_GATEWAY_TAG} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# IGW作成結果確認
CREATED_IGW_NAME=$(
  aws ec2 describe-internet-gateways \
    --filters Name=tag:Name,Values=${EC2_INTERNET_GATEWAY_TAG_NAME} \
    --query "InternetGateways[].Tags[].Value" \
    --output text \
)

echo "IGW[${CREATED_IGW_NAME}]を作成しました"

echo "IGW作成処理終了"

echo "IGWアタッチ処理開始"
# 変数宣言
EC2_INTERNET_GATEWAY_ID=$( \
  aws ec2 describe-internet-gateways \
    --filters Name=tag:Name,Values=${EC2_INTERNET_GATEWAY_TAG_NAME} \
    --query "InternetGateways[].InternetGatewayId" \
    --output text \
)

EC2_VPC_ID=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME} \
    --query "Vpcs[].VpcId" \
    --output text \
)

#IGW用変数確認
echo "EC2_INTERNET_GATEWAY_ID:${EC2_INTERNET_GATEWAY_ID}"
echo "EC2_VPC_ID:${EC2_VPC_ID}"


# IGWアタッチ
echo "IGW[${EC2_INTERNET_GATEWAY_TAG_NAME}]を、VPC[${EC2_VPC_TAG_NAME}]へアタッチします"

aws ec2 attach-internet-gateway \
  --vpc-id ${EC2_VPC_ID} \
  --internet-gateway-id ${EC2_INTERNET_GATEWAY_ID} > /dev/null

# IGWアタッチ結果確認
ATTACHED_VPC_ID=$(
  aws ec2 describe-internet-gateways \
    --filters Name=tag:Name,Values=${EC2_INTERNET_GATEWAY_TAG_NAME} \
    --query "InternetGateways[].Attachments[?VpcId==\`${EC2_VPC_ID}\`].VpcId" \
    --output text \
)

echo "IGW[${EC2_INTERNET_GATEWAY_TAG_NAME}]を、VPC[${EC2_VPC_TAG_NAME}]へアタッチしました"

echo "IGWアタッチ処理終了"