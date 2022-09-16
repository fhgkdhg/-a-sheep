#!/bin/bash

# @author:    Ace
# @date:      2022/9/17
# @usage:     1. 将自己的token放入下行单引号内，没有安装jq工具的话脚本会自动安装
#             2. 执行sheep.sh pass-times
#                example: sheep.sh 100

token=' your token '                # 把单引号里面的内容换成自己的 token
host='cat-match.easygame2021.com'
encoding='gzip,compress,br,deflate'
agent='Mozilla/5.0 (iPhone; CPU iPhone OS 15_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.27(0x18001b37) NetType/WIFI Language/zh_CN'
refer='https://servicewechat.com/wx141bfb9b73c970a9/17/page-frame.html'
type='application/json'
url='https://cat-match.easygame2021.com/sheep/v1/game/game_over'

success=0;
fail=0;
total=0;

if [ "$(whereis jq)" == "jq:" ]
then
    echo "jq has not been installed, intalling...";
    sudo apt install jq;
else
    echo "you have installed jq";
fi

while (( $total < $1 ))
do
    random_t=`expr 10 + $RANDOM % 10`;
    cmd=`curl -k -s $url \
    -G \
    -d "rank_score=1" \
    -d "rank_state=1" \
    -d "rank_time=$random_t" \
    -d "rank_role=1" \
    -d "skin=1" \
    -H "User-Agent: $agent" \
    -H "t: $token" \
    -H "Host: $host" \
    -H "User-Agent: $agent" \
    -H "Referer: $refer" \
    -H "Content-Type: $type"`;
    
    res=`echo $cmd`;
    err=`echo $res | jq '.err_code'`;
    
    if [ $err -eq 0 ]
    then
        success=`expr $success + 1`;
    else
        fail=`expr $fail + 1`;
    fi

    total=`expr $total + 1`;
    echo -ne "total: $total   success: $success   failed: $fail \r";
    sleep 0.5s;
done

echo -e "\nfinished";

exit 0