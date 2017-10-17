### create sysadmin user
support:
  user.present:
    - fullname: Support 
    - shell: /bin/bash
    - createhome: True
    - password: "ENCRYPTED PASSWORD"
    - warndays: 7
    - mindays: 0
    - maxdays: 180
customer:
  user.present:
    - fullname: Cusotmer Account
    - shell: /bin/bash
    - createhome: True
    - password: "ENCRYPTED PASSWORD"
    - warndays: 7
    - mindays: 1
    - maxdays: 180
root:
  user.present:
    - fullname: root
    - warndays: 7
    - mindays: 0
    - maxdays: 180

### add users to sudoers file
/etc/sudoers:
  file.append:
    - text:
      - support ALL=(ALL)       ALL
      - customer ALL=(ALL)       ALL
