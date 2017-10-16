### OS update
#update_OS:
#  cmd.run:
#    - name: yum -y update

net-snmp:
  pkg.installed:
    - name: net-snmp

configure_snmpd_file:
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - source: salt://system/files/snmpd.conf
    - replace: True 

add_new_partitions:
  file.append:
    - name: /etc/snmp/snmpd.conf
    - text:
      - disk {{ pillar['partitions']['mount_point'] }} 

snmpd_srv:
  service:
    - name: snmpd
    - running
    - enable: True
    - require:
      - pkg: net-snmp

Java:
  pkg.installed:
    - name: java-1.6.0-openjdk
Bc:
  pkg.installed:
    - name: bc
ntp:
  pkg.installed:
    - name: ntp
ntpd_srv:
  service:
    - name: ntpd
    - running
    - enable: True
    - require:
      - pkg: ntp
### disable firewall and selinux
disable_firewalld:
  cmd.run:
    - name: systemctl disable firewalld
disable_selinux:
  selinux.mode:
    - name: disabled
##### SSAE-16
/tmp/ssae-16.sh:
  file.managed:
    - source: salt://system/files/ssae-16.sh

execute_ssae16_script:
  cmd.run:
    - name: chmod 755 /tmp/ssae-16.sh;sh /tmp/ssae-16.sh
/etc/motd:
  file.append:
    - text: |
        ======================================================================

        * ACCESS RESTRICTED TO AUTHORIZED PERSONNEL             *
        *                                                       *
        * WARNING:  IF YOU DO NOT HAVE EXPLICIT PERMISSION TO   *
        * ACCESS THIS SYSTEM ** PLEASE LEAVE IMMEDIATELY!! **   *
        * UNAUTHORIZED OR ILLEGAL ENTRY TO THIS MACHINE         *
        * WILL BE PROSECUTED TO THE FULLEST EXTENT OF THE LAW   *

        ======================================================================

#### disable direct root access
didable_direct_root_Access:
  cmd.run:
    - name: sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

### Install LEMSS
/tmp/UnixPatchAgent.tar:
  file.managed:
    - source: salt://system/files/lemss/UnixPatchAgent.tar
install_lemss:
  cmd.run:
    - name: 'mkdir /root/UnixPatchAgent; cp /tmp/UnixPatchAgent.tar /root/UnixPatchAgent/; cd /root/UnixPatchAgent;tar -xvf UnixPatchAgent.tar; ./install -silent -d /usr/local -p http://IP-OF-LEMSS-Console -sno xxxxxxxx-xxxxxxxx -proxy x.x.x.x -port 25253'

### Install Splunk:
/tmp/splunkforwarder-6.4.3-b03109c2bad4-linux-2.6-x86_64.rpm:
  file.managed:
    - source: salt://system/files/splunk/splunkforwarder-6.4.3-b03109c2bad4-linux-2.6-x86_64.rpm
install_splunk:
  cmd.run:
    - name: rpm -ivh /tmp/splunkforwarder-6.4.3-b03109c2bad4-linux-2.6-x86_64.rpm;/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --auto-ports --no-prompt;/opt/splunkforwarder/bin/splunk enable boot-start;/opt/splunkforwarder/bin/splunk set deploy-poll x.x.x.x:8089 --accept-license --answer-yes --auto-ports --no-prompt -auth username:password;/opt/splunkforwarder/bin/splunk restart

#### Install Backup Agent:
install-xinted:
  pkg.installed:
    - pkgs:
      - xinetd
xinetd:
  service.running:
    - enable: True
    - reload: True

/tmp/OB2-CORE-A.09.00-1.x86_64.rpm:
  file.managed:
    - source: salt://system/files/hpdp/OB2-CORE-A.09.00-1.x86_64.rpm
install_backup_agent-core:
  cmd.run:
    - name: rpm -ivh /tmp/OB2-CORE-A.09.00-1.x86_64.rpm
/tmp/OB2-DA-A.09.00-1.x86_64.rpm:
  file.managed:
    - source: salt://system/files/hpdp/OB2-DA-A.09.00-1.x86_64.rpm
install_backup_agent-DA:
  cmd.run:
    - name: rpm -ivh /tmp/OB2-DA-A.09.00-1.x86_64.rpm
