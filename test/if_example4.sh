#!/bin/bash

value=5
#한줄 if [ $value -gt 0 ] && [ $value -lt 10]; then 으로 가능
if [ $value -gt 0 ] && [ $value -lt 10 ]
then
     echo True
else
     echo False
fi
# value값은 0보다 크고, 10보다 작으므로 True 출력
