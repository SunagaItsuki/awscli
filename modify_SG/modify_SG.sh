export i=0
while read line; do
  echo "****************START****************"

  echo $i

  SG_ID=`echo ${line} | cut -d "," -f 1`
  SG_NAME=`echo ${line} | cut -d "," -f 2`
  SG_RULE_TYPE=`echo ${line} | cut -d "," -f 3`
  PROTOCOL=`echo ${line} | cut -d "," -f 4`
  PORT_RANGE_FROM=`echo ${line} | cut -d "," -f 5`
  PORT_RANGE_TO=`echo ${line} | cut -d "," -f 6`
  SOURCE_IP=`echo ${line} | cut -d "," -f 7`

  if [ $i -ne 0 ]; then
    echo "SG_ID:${SG_ID}"
    echo "SG_NAME:${SG_NAME}"
    echo "SG_RULE_TYPE:${SG_RULE_TYPE}"
    echo "PROTOCOL:${PROTOCOL}"
    echo "PORT_RANGE_FROM:${PORT_RANGE_FROM}"
    echo "PORT_RANGE_TO:${PORT_RANGE_TO}"
    echo "SOURCE_IP:${SOURCE_IP}"
    ((i++))
  else
    ((i++))
    echo "****************END****************"

    continue
  fi

  echo "****************END****************"

done < sg.csv 
