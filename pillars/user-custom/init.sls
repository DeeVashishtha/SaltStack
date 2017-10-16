users:
  {% if "dbserver" in grains.get('roles', []) %}
  user_name: dbaadmin
  {% else %}
  user_name: appadmin
  {% endif %}
  user_pass: "ENCRYPTED PASSWORD"
