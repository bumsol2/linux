#!/bin/bash

value=""
#한줄표현 if [-z $value ]; then으로 표현할 수 있음
if [ -z $value]
then
    echo True
else
    echo False
fi
# value의 길이가 0이므로 True 출력
