#/bin/bash

# 変数宣言
echo "SG作成処理開始"
echo "SG用変数を設定中"

source ./env/global.env
source ./env/create_SG.env
EC2_VPC_ID=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME} \
    --query "Vpcs[].VpcId" \
    --output text \
)


#SG用変数確認
echo "AWS_DEFAULT_REGION:${AWS_DEFAULT_REGION}"
echo "EC2_SECURITY_GROUP_NAME:${EC2_SECURITY_GROUP_NAME}"
echo "EC2_SECURITY_GROUP_DESCRIPTION:${EC2_SECURITY_GROUP_DESCRIPTION}"
echo "EC2_VPC_TAG_NAME:${EC2_VPC_TAG_NAME}"
echo "EC2_VPC_ID:${EC2_VPC_ID}"
echo "SG用変数を設定完了"

# SG作成
echo "SG[${EC2_SECURITY_GROUP_NAME}]を作成します"
read -p "よろしいですか？(y/n):" answer

if [ $answer = "y" ]; then
  aws ec2 create-security-group \
    --group-name ${EC2_SECURITY_GROUP_NAME} \
    --description "${EC2_SECURITY_GROUP_DESCRIPTION}" \
    --tag-specifications ${EC2_SECURITY_GROUP_NAME} \
    --vpc-id ${EC2_VPC_ID} > /dev/null
else
  echo "y以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  exit 1
fi

# SG作成結果確認
CREATED_IGW_NAME=$(aws ec2 describe-internet-gateways \
--filters Name=tag:Name,Values=${EC2_INTERNET_GATEWAY_TAG_NAME} \
--query "InternetGateways[].Tags[].Value" \
--output text)

echo "IGW[${CREATED_IGW_NAME}]を作成しました"

echo "IGW作成処理終了"

echo "IGWアタッチ処理開始"
# 変数宣言
EC2_INTERNET_GATEWAY_ID=$( \
aws ec2 describe-internet-gateways \
--filters Name=tag:Name,Values=${EC2_INTERNET_GATEWAY_TAG_NAME} \
--query "InternetGateways[].InternetGatewayId" \
--output text)

EC2_VPC_ID=$( \
  aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME} \
    --query "Vpcs[].VpcId" \
    --output text \
)

#IGW用変数確認
# echo "EC2_INTERNET_GATEWAY_ID:${EC2_INTERNET_GATEWAY_ID}"
# echo "EC2_VPC_ID:${EC2_VPC_ID}"


# IGWアタッチ
echo "IGW[${EC2_INTERNET_GATEWAY_TAG_NAME}]を、VPC[${EC2_VPC_TAG_NAME}]へアタッチします"

aws ec2 attach-internet-gateway \
--vpc-id ${EC2_VPC_ID} \
--internet-gateway-id ${EC2_INTERNET_GATEWAY_ID} > /dev/null

# IGWアタッチ結果確認
ATTACHED_VPC_ID=$(aws ec2 describe-internet-gateways \
--filters Name=tag:Name,Values=${EC2_INTERNET_GATEWAY_TAG_NAME} \
--query "InternetGateways[].Attachments[?VpcId==\`${EC2_VPC_ID}\`].VpcId" \
--output text)

echo "IGW[${EC2_INTERNET_GATEWAY_TAG_NAME}]を、VPC[${EC2_VPC_TAG_NAME}]へアタッチしました"

echo "IGWアタッチ処理終了"
