#!/bin/bash

########################################
########## CentOS 7.7 취약점 ############
########################################

sed -i '5 i\auth\t   required\t/lib/security/pam_securetty.so' /etc/pam.d/login
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

#패스워드 복잡성 설정#
sed -i '15 i\password    requisite\t  pam_cracklib.so retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1' /etc/pam.d/system-auth

#root 계정 su 제한#
groupadd wheel
chgrp wheel /usr/bin/su
chmod 4750 /usr/bin/su
usermod -G wheel sol
usermod -G wheel root

#패스워드 최소 길이 설정#
sed -i '27,27 s/PASS_MIN_LEN.*/PASS_MIN_LEN\t8/g' /etc/login.defs

#패스워드 최대 사용기간 설정#
sed -i '25,25 s/PASS_MAX_DAYS.*/PASS_MAX_DAYS\t90/g' /etc/login.defs

#패스워드 최소 사용기간 설정#
sed -i '26,26 s/PASS_MIN_DAYS.*/PASS_MIN_DAYS\t1/g' /etc/login.defs

#패스워드 변경 경고 보내는 일수
#sed -i '28,28 s/PASS_WARN_AGE.*/PASS_WARN_AGE\t7/g' /etc/login.defs centos7은 7일로 되어있어서 안해도 됨

#Session Timeout 설정
echo -e "TMOUT=600\nexport TMOUT\n" >> /etc/profile
source /etc/profile

#정책에 따른 시스템 로깅 설정#
sed -i '67, 67 s/:omusrmsg:*//g' /etc/rsyslog.conf
sed -i '75 i\*.alert\t\t\t\t\t    /dev/console' /etc/rsyslog.conf 
systemctl restart rsyslog

#crond 파일 소유자 및 권한 설정#
chmod 750 /usr/bin/crontab
chmod 640 /etc/crontab
chmod 600 /etc/cron.deny 

#at 서비스 권한 설정#
chmod 750 /usr/bin/at
chmod 640 /etc/at.deny

#로그온 시 경고 메시지 제공#
#서버 로그인 메세지#
echo > /etc/motd
sed -i '1 i\*************************************************************************' /etc/motd
sed -i '2 i\This is a private computer facility.' /etc/motd
sed -i '3 i\Access for any reason must be specifically authrized by the manager.' /etc/motd
sed -i '4 i\Unless you are so authorized, your continued access and ant other use may' /etc/motd
sed -i '5 i\expose you to criminaland or civil proceedings' /etc/motd
sed -i '6 i\*************************************************************************' /etc/motd

# ssh 로그인 메세지#
sed -i '124 i\Banner /etc/issue' /etc/ssh/sshd_config
echo > /etc/issue
sed -i '1 i\*************************************************************************' /etc/issue
sed -i '2 i\This is a private computer facility.' /etc/issue
sed -i '3 i\Access for any reason must be specifically authrized by the manager.' /etc/issue
sed -i '4 i\Unless you are so authorized, your continued access and ant other use may' /etc/issue
sed -i '5 i\expose you to criminaland or civil proceedings' /etc/issue
sed -i '6 i\*************************************************************************' /etc/issue

#/etc/hosts 파일 소유자 및 권한 설정#
chmod 600 /etc/hosts

#/etc/syslog.conf 파일 소유자 및 권한 설정#
chmod 640 /etc/rsyslog.conf

#SUID, SGID 설정 파일점검#
chmod -s /sbin/unix_chkpwd
chmod -s /usr/bin/newgrp
chmod -s /usr/bin/at

#DB취약점
#데이터베이스의 주요 설정파일, 패스워드 파일 등과 같은 주요 파일들의 접근 권한이 적절하게 설정#
chmod 640 /etc/my.cnf
#Tomcat 취약점
#관리서버 디렉토리 권한 설정
chmod 750 /data/tomcat/work/Catalina/localhost/webapps
chmod 750 /data/tomcat/webapps

#설정 파일 권한 설정
chmod 600 /data/tomcat/conf/*.xml  
chmod 600 /data/tomcat/conf/*.properties 
chmod 600 /data/tomcat/conf/*.policy   

#로그 디렉토리/파일 권한 설정
chmod 750 /data/tomcat/logs

#로그 포맷 설정
sed -i '165d' /data/tomcat/conf/server.xml
sed -i '165 i\ \t\pattern="combined"\t resolveHosts="false"\t />' /data/tomcat/conf/server.xml

#불필요한 파일 및 디렉토리 삭제
rm -rf /data/tomcat/webapps/examples
rm -rf /data/tomcat/webapps/examples/WEB-INF/classes/examples
rm -rf /data/tomcat/webapps/examples/WEB-INF/classes/jsp2/examples

#패스워드 파일 권한 설정##
chmod 600 /data/tomcat/conf/tomcat-users.xml  
#완료
