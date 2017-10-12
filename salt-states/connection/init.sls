test-LEMSS-proxy:
 module.run:
  - name: network.connect
  - host: x.x.x.x # IP address of LEMSS-proxy
  - port: 25253
test-LEMSS-web:
  module.run:
    - name: network.connect
    - host: x.x.x.x # IP address of LEMSS-web
    - port: 80
test-RHUI:
   module.run:
    - name: network.connect
    - host: x.x.x.x # IP/Hostname of Redhat repository
    - port: 80
test-Splunk:
  module.run:
    - name: network.connect
    - host: x.x.x.x # IP address of Splunk Console
    - port: 8089
