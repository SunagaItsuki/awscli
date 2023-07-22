#/bin/bash

# 変数宣言
echo -e "\n******************EC2インスタンス作成処理開始******************\n"
echo -e "\n******************EC2インスタンス用変数を設定中******************\n"

AWS_DEFAULT_REGION='us-east-1'
EC2_AMI_ID='ami-your_ami_id'
EC2_INSTANCE_TYPE='t2.micro'
EC2_KEY_NAME='your_key_name'
EC2_SG_ID='sg-your_sg_id sg-your_sg_id'
EC2_SUBNET_ID='subnet-your_subnet_id'
EC2_IP_ADDRESS='10.0.0.10'
EC2_COUNT='1'
EC2_INSTANCE_TAG_NAME='your_ec2_name'
STRING_EC2_INSTANCE_TAG="ResourceType=instance,Tags=[{Key=Name,Value=${EC2_INSTANCE_TAG_NAME}}]"
STRING_EC2_VOLUME_TAG="ResourceType=volume,Tags=[{Key=Name,Value=${EC2_INSTANCE_TAG_NAME}}]"
STRING_EC2_NETWORK_INTERFACE_TAG="ResourceType=network-interface,Tags=[{Key=Name,Value=${EC2_INSTANCE_TAG_NAME}}]"

#IGW用変数確認
echo "EC2_AMI_ID:${EC2_AMI_ID}"
echo "EC2_INSTANCE_TYPE:${EC2_INSTANCE_TYPE}"
echo "EC2_KEY_NAME:${EC2_KEY_NAME}"
echo "EC2_SG_ID:${EC2_SG_ID}"
echo "EC2_SUBNET_ID:${EC2_SUBNET_ID}"
echo "EC2_IP_ADDRESS:${EC2_IP_ADDRESS}"
echo "EC2_COUNT:${EC2_COUNT}"
echo "EC2_INSTANCE_TAG_NAME:${EC2_INSTANCE_TAG_NAME}"
echo "STRING_EC2_INSTANCE_TAG:${STRING_EC2_INSTANCE_TAG}"
echo "STRING_EC2_VOLUME_TAG:${STRING_EC2_VOLUME_TAG}"
echo "STRING_EC2_NETWORK_INTERFACE_TAG:${STRING_EC2_NETWORK_INTERFACE_TAG}"
echo -e "\n******************EC2インスタンス用変数を設定完了******************\n"

# インスタンス作成
echo "インスタンス[${EC2_INSTANCE_TAG_NAME}]を作成します"
read -p "よろしいですか？(y/n):" answer
if [ $answer = "y" ]; then
aws ec2 run-instances \
  --image-id ${EC2_AMI_ID} \
  --instance-type ${EC2_INSTANCE_TYPE} \
  --key-name ${EC2_KEY_NAME} \
  --security-group-ids ${EC2_SG_ID} \
  --subnet-id ${EC2_SUBNET_ID} \
  --private-ip-address ${EC2_IP_ADDRESS} \
  --count ${EC2_COUNT} \
  --tag-specifications ${STRING_EC2_INSTANCE_TAG} \
                        ${STRING_EC2_VOLUME_TAG} \
                        ${STRING_EC2_NETWORK_INTERFACE_TAG} > /dev/null
else
  echo -e "\ny以外の文字が入力されました。"
  echo "スクリプトを終了します。"
  echo -e "\n******************EC2インスタンス作成処理異常終了******************\n"
  exit 1
fi


CREATED_INSTANCE_NAME=$(
  aws ec2 describe-instances \
    --filters Name=tag:Name,Values=${EC2_INSTANCE_TAG_NAME} \
    --query "Reservations[].Instances[].Tags[].Value" \
    --output text \
)

echo -e "\nEC2インスタンス[${CREATED_INSTANCE_NAME}]を作成しました\n"

echo -e "\n******************EC2インスタンス作成処理終了******************\n"
