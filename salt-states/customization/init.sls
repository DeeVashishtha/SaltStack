### Update Host file
hostname_with _domain:
  cmd.run:
    - name: sed -i "s/abc.com/test.com/g;s/127.0.1.1/$(hostname -I)/g" /etc/hosts

### Prepare NFS client
install_packages_for_nfs:
  pkg.installed:
    - pkgs:
      - nfs-utils
      - rpcbind

### start rpcbind:
rpcbind:
  service.running:
    - enable: True
    - reload: True
    
### Mount NFS shares
nfs.mounts:
  mount.mounted:
    - name: {{ pillar['mounts']['mount_point'] }}
    - device: {{ pillar['mounts']['mount_source'] }}
    - fstype: nfs
    - mkmnt: True
    - persist: True
    - mount: True
    - opts:
      - defaults
