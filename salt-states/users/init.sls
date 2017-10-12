### create sysadmin user
sysadmin:
  user.present:
    - fullname: Navisite Admin
    - shell: /bin/bash
    - createhome: True
    - password: $1$mrUlsain$Gx5QxMKJP./cuWgsFezsG.
    - warndays: 7
    - mindays: 0
    - maxdays: 180
custroot:
  user.present:
    - fullname: Cusotmer Account
    - shell: /bin/bash
    - createhome: True
    - password: $1$j7ZuVnmC$QfQnsmaDvU.8nuIH5JsVh/
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
      - sysadmin ALL=(ALL)       ALL
      - custroot ALL=(ALL)       ALL
