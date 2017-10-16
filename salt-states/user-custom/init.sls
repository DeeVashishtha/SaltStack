users:
  user.present:
      - name: {{ pillar['users']['user_name'] }}
      - shell: /bin/bash
      - home: /home/{{ pillar['users']['user_name'] }}
      - password: {{pillar ['users']['user_pass']}}
      - warndays: 7
      - mindays: 1
      - maxdays: 180
