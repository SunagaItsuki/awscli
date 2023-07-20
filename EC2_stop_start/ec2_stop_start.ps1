# Nameタグで指定したEC2が、停止していれば起動し、起動していれば停止するスクリプト

# 全EC2のインスタンスid、状態、タグを取得する
# aws ec2 describe-instances --query 'Reservations[*].Instances[0].[InstanceId, State, Tags]'

echo 処理開始します。

echo Nameタグを設定中
# Nameタグを指定
$EC2_NAME_TAG="your_ec2_name"
echo Nameタグ：$EC2_NAME_TAG

# タグ名によってサーバ側出力を絞り込むときは"Name=tag:<キー>,Values=<値>"で指定する
# aws ec2 describe-instances --filters "Name=tag:Name,Values=$EC2_NAME_TAG"
echo インスタンスIDを取得中
$EC2_INSTANCE_ID=aws ec2 describe-instances --output text --filters "Name=tag:Name,Values=$EC2_NAME_TAG" --query "Reservations[*].Instances[0].[InstanceId]"
echo インスタンスID：$EC2_INSTANCE_ID

echo 現在のインスタンスの状態を取得中
$EC2_STATE=aws ec2 describe-instances --instance-ids $EC2_INSTANCE_ID --query "Reservations[*].Instances[0].[State]" --output text
#filterで表すならこっち
#--filters "Name=instance-id,Values=$EC2_INSTANCE_ID"

if($EC2_STATE -match "running"){ 
    echo 現在のインスタンスの状態：起動中
} elseif ($EC2_STATE -match "stopped"){
    echo 現在のインスタンスの状態：停止中
} else {
    echo 現在のインスタンスの状態：$EC2_STATE
}

if($EC2_STATE -match "running"){ 
    $EC2_TARGET_NAME=aws ec2 describe-instances --instance-ids $EC2_INSTANCE_ID --query "Reservations[*].Instances[].Tags[0].Value" --output text
    echo インスタンス[$EC2_TARGET_NAME]を停止します。
    aws ec2 stop-instances --instance-ids $EC2_INSTANCE_ID
    while ($true){
        $EC2_STATE=aws ec2 describe-instances --instance-ids $EC2_INSTANCE_ID --query "Reservations[*].Instances[0].[State]" --output text
        if ($EC2_STATE -match "stopped"){
            echo インスタンス[$EC2_TARGET_NAME]を正常に停止しました。
            break
        } else {
            echo インスタンス[$EC2_TARGET_NAME]を停止中です。
            sleep 1
        }
    }
} elseif ($EC2_STATE -match "stopped"){
    $EC2_TARGET_NAME=aws ec2 describe-instances --instance-ids $EC2_INSTANCE_ID --query "Reservations[*].Instances[].Tags[0].Value" --output text
    echo インスタンス[$EC2_TARGET_NAME]を起動します。
    aws ec2 start-instances --instance-ids $EC2_INSTANCE_ID
    while ($true){
        $EC2_STATE=aws ec2 describe-instances --instance-ids $EC2_INSTANCE_ID --query "Reservations[*].Instances[0].[State]" --output text
        if ($EC2_STATE -match "running"){
            echo インスタンス[$EC2_TARGET_NAME]を正常に起動しました。
            break
        } else {
            echo インスタンス[$EC2_TARGET_NAME]を起動中です。
            sleep 1
        }
    }
}

echo 処理を終了します。
