cat << PWQUALITY >> /etc/security/pwquality.conf

# password must be 14 characters or more
minlen = 14 
#
# provide at least 1 digit
dcredit = -1
#
# provide at least one uppercase character
ucredit = -1
#
# provide at least one special character
ocredit = -1
#
# provide at least one lowercase character
lcredit = -1
PWQUALITY

cat << SYSTEM-AUTH > /etc/pam.d/system-auth-local
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=1800
auth        [success=1 default=bad] pam_unix.so
auth        [default=die] pam_faillock.so authfail audit deny=5 unlock_time=1800
auth        sufficient    pam_faillock.so authsucc audit deny=5 unlock_time=1800
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        required      pam_deny.so

account     required      pam_faillock.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=8
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
SYSTEM-AUTH

cat << PASSWD-AUTH > /etc/pam.d/password-auth-local
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=1800
auth        [success=1 default=bad] pam_unix.so
auth        [default=die] pam_faillock.so authfail audit deny=5 unlock_time=1800
auth        sufficient    pam_faillock.so authsucc audit deny=5 unlock_time=1800
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        required      pam_deny.so

account     required      pam_faillock.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=8
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
PASSWD-AUTH

cd /etc/pam.d/
ln -s -f system-auth-local system-auth
ln -s -f password-auth-local password-auth

useradd -D -f 35

# remove rhgb quiet from grub2.conf
sed -i 's/rhgb//g' /etc/sysconfig/grub
sed -i 's/quiet//g' /etc/sysconfig/grub
sed -i 's/rhgb//g' /etc/default/grub
sed -i 's/quiet//g' /etc/default/grub
sed -i 's/rhgb//g' /boot/grub2/grub.cfg 
sed -i 's/quiet//g' /boot/grub2/grub.cfg

# Add bonding module
#cat << BONDING > /etc/modprobe.d/bonding.conf
#alias netdev-bond0 bonding
#BONDING

# configure sudo logging to /var/log/sudo.log
sed -i  's/Defaults    requiretty/Defaults    requiretty\nDefaults    syslog=auth\nDefaults    log_year,logfile=\/var\/log\/sudo.log/g' /etc/sudoers

# Add sysadmin user to sudoers
#cat << SUDOERS >> /etc/sudoers
#sysadmin        ALL=(ALL)       NOPASSWD: ALL
#SUDOERS

# 7.1.1 - Set Password Expiration Days 
sed -i 's/^PASS_MAX_DAYS.*$/PASS_MAX_DAYS 180/g' /etc/login.defs

# 7.1.2 - Set Password Change Minimum Number of Days 
sed -i 's/^PASS_MIN_DAYS.*$/PASS_MIN_DAYS 1/g' /etc/login.defs

# 7.1.3 - Set Password Expiring Warning Days 
sed -i 's/^PASS_WARN_AGE.*$/PASS_WARN_AGE 8/g' /etc/login.defs

# disable min password change policy on sysadmin and root
chage -m 0 sysadmin
chage -m 0 root

# configure date/time for history command
cat << HIST >> /etc/profile.d/history.sh 
export HISTTIMEFORMAT='%F %T '

