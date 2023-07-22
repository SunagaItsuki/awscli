#/bin/bash

source ./env/global.env
source ./env/create_RTB.env

for ((i=0; i<${EC2_ROUTE_TABLE_COUNT[*]}; i++))
do

  echo -e "\n############################# $((i+1))個目のルートテーブル作成処理開始 #############################"
  echo -e "\n############################# 変数設定開始 #############################\n"

  STRING_EC2_ROUTE_TABLE_TAG="ResourceType=route-table,Tags=[{Key=Name,Value=${EC2_ROUTE_TABLE_TAG_NAME[$i]}}]"
  EC2_VPC_ID=$( \
    aws ec2 describe-vpcs \
      --filters Name=tag:Name,Values=${EC2_VPC_TAG_NAME} \
      --query "Vpcs[].VpcId" \
      --output text \
  )

  # ルートテーブル用変数確認
  echo "AWS_DEFAULT_REGION:${AWS_DEFAULT_REGION}"
  echo "EC2_ROUTE_TABLE_TAG_NAME:${EC2_ROUTE_TABLE_TAG_NAME[$i]}"
  echo "STRING_EC2_ROUTE_TABLE_TAG:${STRING_EC2_ROUTE_TABLE_TAG}"
  echo "EC2_VPC_TAG_NAME:${EC2_VPC_TAG_NAME}"
  echo "EC2_VPC_ID:${EC2_VPC_ID}"
  echo "EC2_SUBNET_TAG_NAME:${EC2_SUBNET_TAG_NAME[$i]}"

  echo -e "\n############################# 変数設定完了 #############################"
  echo -e "\n############################# ルートテーブル作成開始 #############################"

  # ルートテーブル作成
  echo "ルートテーブル[${EC2_ROUTE_TABLE_TAG_NAME[$i]}]を作成します"
  read -p "よろしいですか？(y/n):" answer

  if [ $answer = "y" ]; then
    aws ec2 create-route-table \
      --vpc-id ${EC2_VPC_ID} \
      --tag-specifications ${STRING_EC2_ROUTE_TABLE_TAG} > /dev/null
  else
    echo "y以外の文字が入力されました。"
    echo "スクリプトを終了します。"
    exit 1
  fi

  # ルートテーブル作成結果確認
  CREATED_ROUTE_TABLE_NAME=$(aws ec2 describe-route-tables \
  --filters Name=vpc-id,Values=${EC2_VPC_ID} \
          Name=tag:Name,Values=${EC2_ROUTE_TABLE_TAG_NAME[$i]} \
  --query "RouteTables[].Tags[?Key == \`Name\`].Value" \
  --output text
  )

  echo "ルートテーブル[${CREATED_ROUTE_TABLE_NAME}]を作成しました"
  echo -e "\n############################# サブネット作成完了 #############################"


  echo "ルートテーブルとサブネットの関連付け処理開始"

  # 変数宣言
  EC2_ROUTE_TABLE_ID=$( \
    aws ec2 describe-route-tables \
      --filters Name=vpc-id,Values=${EC2_VPC_ID} \
                Name=tag:Name,Values=${EC2_ROUTE_TABLE_TAG_NAME[$i]} \
      --query "RouteTables[].RouteTableId" \
      --output text
  )

  EC2_SUBNET_ID=$( \
    aws ec2 describe-subnets \
      --filters Name=vpc-id,Values=${EC2_VPC_ID} \
                Name=tag:Name,Values=${EC2_SUBNET_TAG_NAME[$i]} \
      --query "Subnets[].SubnetId" \
      --output text \
  )

  # ルートテーブルアタッチ用変数確認
  echo "EC2_ROUTE_TABLE_ID:${EC2_ROUTE_TABLE_ID}"
  echo "EC2_SUBNET_ID:${EC2_SUBNET_ID}"



  # ルートテーブルアタッチ
  echo "ルートテーブル[${EC2_ROUTE_TABLE_TAG_NAME}]を、サブネット[${EC2_SUBNET_TAG_NAME}]へアタッチします"

  aws ec2 associate-route-table \
    --subnet-id ${EC2_SUBNET_ID} \
    --route-table-id ${EC2_ROUTE_TABLE_ID} > /dev/null
    
  # ルートテーブルアタッチ結果確認
  ATTACHED_SUBNET_ID=$(
    aws ec2 describe-route-tables \
      --route-table-ids ${EC2_ROUTE_TABLE_ID} \
      --query "RouteTables[].Associations[].SubnetId" \
      --output text
  )

  ATTACHED_SUBNET_NAME=$( \
    aws ec2 describe-subnets \
      --filters Name=subnet-id,Values=${ATTACHED_SUBNET_ID} \
      --query "Subnets[].Tags[].Value" \
      --output text \
  )

  echo "ルートテーブル[${EC2_ROUTE_TABLE_TAG_NAME}]を、サブネット[${ATTACHED_SUBNET_NAME}]へアタッチしました"
  echo "ルートテーブルとサブネットの関連付け処理終了"

done


  echo -e "\n############################# ルートテーブル作成処理完了 #############################"