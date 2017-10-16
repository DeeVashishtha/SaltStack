mounts:
  {% if "dbserver" in grains.get('roles', []) %}
  mount_point: "/data_logs"
  mount_source: "x.x.x.x:/data_logs"
  {% else  %}
  mount_point: "/app_logs"
  mount_source: "x.x.x.x:/app_logs"
  {% endif %}
