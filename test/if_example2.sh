#!/bin/bash
value=0
# 한 줄로 사용할 경우에는 if[ $value =0 ]; then으로 표현할 수 있음
if [ $value = 0 ]
then
    echo True
else
    echo False
fi
# value가 0이므로 True 출력
