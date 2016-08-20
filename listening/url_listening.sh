#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# need you set this URL and Listening CONTEXT
URL='www.baidu.com'
CONTEXT='百度一下'
# define url
WEB_URL=('http://'+$URL)

# check network
NET_ALIVE=$(ping -c 5 $URL |grep 'received'|awk 'BEGIN {FS=","} {print $2}'|awk '{print $1}')
if [ $NET_ALIVE == 0 ]; then
    echo "Network is not active,please check your network configuration!"
    exit 0
fi
# check url
for((i=0; i!=${#WEB_URL[@]}; ++i))
{
  ALIVE=$(curl -o /dev/null -s -m 30 -connect-timeout 30 -w %{http_code} ${WEB_URL[i]} |grep $CONTEXT)
  echo $ALIVE
if [[ $ALIVE =~ $CONTEXT ]]; then
     echo "'${WEB_URL[i]}' is OK!"
  else
    echo "failed!"
        service spider-guodian stop
        service spider-guodian start
  fi
}