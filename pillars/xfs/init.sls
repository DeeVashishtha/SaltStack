partitions:
  {% if "dbserver" in grains.get('roles', []) %}
  VG: datavg
  LV: datalv
  mount_point: /data
  {% else  %}
  VG: appvg
  LV: applv
  mount_point: /app
  {% endif %}
