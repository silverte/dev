#!/bin/bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
# UserData 실행 로그를 /var/log/user-data.log에 저장

#####1.01 root계정 원격 접속 제한
chgrp wheel /usr/bin/su         # /usr/bin/su 파일을 wheel 그룹으로 변경
chmod 4750 /bin/su              # 사용 권한 변경
#usermod -G wheel "계정명" 명령어로 SU가 필요한 계정을 wheel 그룹에 추가

#####1.02 패스워드 복잡성 설정
sed -i 's/# minlen = 8/minlen = 8/g' /etc/security/pwquality.conf # 최소길이 8자
sed -i 's/# minclass = 0/minclass = 3/g' /etc/security/pwquality.conf # 영문대소문자, 숫자, 특수문자 중 3종류가 섞인 패스워드 복잡성 설정
sed -i 's/pam_pwquality.so try_first_pass local_users_only retry=3/pam_pwquality.so try_first_pass local_users_only retry=5/g' /etc/pam.d/system-auth
# 5번 시도 후 접속 실패처리

#####1.03 계정 잠금 임계값 설정
if ! grep -q "auth required pam_faillock.so preauth silent audit deny=5 unlock_time=600" /etc/pam.d/password-auth; then
    echo "auth required pam_faillock.so preauth silent audit deny=5 unlock_time=600" >> /etc/pam.d/password-auth
fi # 5번 실패 시 10분간 접속 금지
if ! grep -q "account required pam_faillock.so" /etc/pam.d/password-auth; then
    echo "account required pam_faillock.so" >> /etc/pam.d/password-auth
fi # FailLock 활성화

#####1.04 패스워드 파일 보호
#####2.01 root 홈, 패스 디렉터리 권한 및 패스 설정
#####2.02 파일 및 디렉터리 소유자 설정
# 초기 설정에는 소유자가 존재하지 않은 파일 및 디렉토리가 없음
# 서버의 최종 설정 이후 추가 검색 필요
# find / -nouser -o -nogroup

#####2.03 /etc/passwd 파일 소유자 및 권한 설정
#####2.04 /etc/shadow 파일 소유자 및 권한 설정

#####2.05 /etc/hosts 파일 소유자 및 권한 설정
# 디폴트로 소유자는 root, 권한은 644 임
if [ $(stat -c %a /etc/hosts) -gt 600 ]; then
    chmod 600 /etc/hosts
fi # 권한이 600보다 높을경우 600로 변경

#####2.06 /etc/(x)inetd.conf 파일 소유자 및 권한 설정
#####2.07 /etc/syslog.conf 파일 소유자 및 권한 설정
#####2.08 /etc/services 파일 소유자 및 권한 설정

#####2.09 SUID, SGID, Sticky bit 설정 파일 점검
chmod -s /usr/sbin/unix_chkpwd
chmod -s /usr/bin/at
chmod -s /usr/bin/newgrp

#####2.10 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정
find /home -type f -exec chmod o-rwx {} \;
# 디폴트 설정상 변경이 필요한 사용자는 모두 /home 안에 생성되므로 해당 디렉토리 안의 모든 파일들의 other권한 제거

#####2.11 world writable 파일 점검
#####2.12 /dev에 존재하지 않는 device 점검
#####2.13 $HOME/.rhosts, hosts.equiv 사용 금지

#####2.14 접속 IP 및 포트 제한
# 초기에 /etc/hosts.deny에 ALL:ALL 설정을 넣으면 구성에 혼선이 있을 수 있으므로
# 향후 /etc/hosts.allow에 설정이 완료 된 후 사용자가 수동으로 설정
echo "# After completing the additional configuration in the /etc/hosts.allow file, remove the comments." >> /etc/hosts.deny
echo "#ALL: ALL" >> /etc/hosts.deny

#####3.01 Finger 서비스 비활성화
#####3.02 AnonymoudFTP 비활성화
#####3.03 r 계열 서비스 비활성화

#####3.04 cron 파일 소유자 및 권한 설정
chmod 640 /etc/crontab
chmod 640 /etc/cron.daily/*
chmod 640 /etc/cron.hourly/*
chmod 640 /etc/cron.monthly/*
chmod 640 /etc/cron.weekly/*

#####3.05 DoS 공격에 취약한 서비스 비활성화

#####3.06 NFS 서비스 비활성화
systemctl disable nfs-server
systemctl disable rpcbind
systemctl disable nfs-mountd
systemctl disable nfs-idmapd
systemctl disable rpc-statd

#####3.07 NFS 접근 통제
#####3.08 automountd 제거
#####3.09 RPC 서비스 확인
#####3.10 NIS, NIS+ 점검
#####3.11 tftp, talk 서비스 비활성화
#####3.12 Sendmail 버전 점검
#####3.13 스팸 메일 릴레이 제한
#####3.14 일반사용자의 Sendmail 실행 방지
#####3.15 DNS 보안 버전 패치
#####3.16 DNS ZoneTransfer 설정
#####4.01 최신 보안패치 및 벤더 권고사항 적용
#####5.01 로그의 정기적 검토 및 보고