#/bin/bash

source ./env/global.env
source ./env/create_Subnets.env

for ((i=0; i<${EC2_SUBNET_COUNT[*]}; i++))
do
  echo -e "\n############################# $((i+1))個目のサブネット作成処理開始 #############################"
  echo -e "\n############################# 変数設定開始 #############################\n"

  EC2_AZ_NAME=${AWS_DEFAULT_REGION}${EC2_AZ_CODE[$i]}
  STRING_EC2_SUBNET_TAG="ResourceType=subnet,Tags=[{Key=Name,Value=${EC2_SUBNET_TAG_NAME[$i]}}]"
  EC2_VPC_ID=$( \
    aws ec2 describe-vpcs \
      --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME}  \
      --query 'Vpcs[].VpcId' \
      --output text \
  )

  # サブネット用変数確認
  echo "AWS_DEFAULT_REGION:${AWS_DEFAULT_REGION}"
  echo "EC2_AZ_CODE:${EC2_AZ_CODE[$i]}"
  echo "EC2_SUBNET_TYPE:${EC2_SUBNET_TYPE[$i]}"
  echo "EC2_SUBNET_TAG_NAME:${EC2_SUBNET_TAG_NAME[$i]}"
  echo "EC2_SUBNET_CIDR:${EC2_SUBNET_CIDR[$i]}"
  echo "EC2_AZ_NAME:${EC2_AZ_NAME}"
  echo "STRING_EC2_SUBNET_TAG:${STRING_EC2_SUBNET_TAG}"
  echo "EC2_VPC_TAG_NAME:${EC2_VPC_TAG_NAME}"
  echo "EC2_VPC_ID:${EC2_VPC_ID}"

  echo -e "\n############################# 変数設定完了 #############################"
  echo -e "\n############################# サブネット作成開始 #############################"

  # サブネット作成
  echo "サブネット[${EC2_SUBNET_TAG_NAME[$i]}]を作成します"

  read -p "よろしいですか？(y/n):" answer

  if [ $answer = "y" ]; then
    aws ec2 create-subnet \
      --vpc-id ${EC2_VPC_ID} \
      --cidr-block ${EC2_SUBNET_CIDR[$i]} \
      --availability-zone ${EC2_AZ_NAME} \
      --tag-specifications ${STRING_EC2_SUBNET_TAG} > /dev/null
  else
    echo "y以外の文字が入力されました。"
    echo "スクリプトを終了します。"
    exit 1
  fi

  # サブネット作成結果確認
  CREATED_SUBNET_NAME=$( \
    aws ec2 describe-subnets \
      --filters Name=vpc-id,Values=${EC2_VPC_ID} \
                Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME[$i]}  \
      --query 'Subnets[].Tags[?Key==`Name`].Value' \
      --output text
  )

  CREATED_SUBNET_CIDR=$( \
    aws ec2 describe-subnets \
      --filters Name=vpc-id,Values=${EC2_VPC_ID} \
                Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME[$i]}  \
      --query "Subnets[].CidrBlock" \
      --output text
  )

  echo "サブネット[${CREATED_SUBNET_NAME}]を作成しました"
  echo "作成したサブネット名:${CREATED_SUBNET_NAME}"
  echo "作成したサブネットCIDR:${CREATED_SUBNET_CIDR}"

  echo -e "\n############################# サブネット作成完了 #############################"
done


# 作成した全サブネットの名前確認
CREATED_SUBNETS_NAME=$(\
  aws ec2 describe-subnets \
    --filters Name=vpc-id,Values=${EC2_VPC_ID} \
    --query 'Subnets[].Tags[?Key == `Name`].Value' \
    --output text
)

echo -e "作成したサブネット名一覧:\n${CREATED_SUBNETS_NAME}"
echo -e "\n############################# サブネット作成処理終了 #############################"



