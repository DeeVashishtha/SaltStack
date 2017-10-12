
### Copying desired configuration for new disk
sda_config:
  file.managed:
   - name: /tmp/sda.txt
   - source: salt://xfs/files/sda.txt
sdb_config:
  file.managed:
    - name: /tmp/sdb.txt
    - source: salt://xfs/files/sdb.txt


### create new partition on SDA
create_partitions_in_sda:
  cmd.run:
    - name: fdisk /dev/sda < /tmp/sda.txt


###  create new partition on SDB
create_partitions_in_sdb:
  cmd.run:
    - name: fdisk /dev/sdb < /tmp/sdb.txt

##### make system to read new partition table
read_new_partition_table:
  cmd.run:
    - name: partprobe

### create new Physical Volumes for LVM
create_pv:
  lvm.pv_present:
    - name: /dev/sdb1,/dev/sdb2,/dev/sda3,/dev/sda4 


### create new Volume Groups for LVM
#create_datavg:
#  lvm.vg_present:
#    - name: datavg
#    - devices: /dev/sdb1
#create_appvg:
#  lvm.vg_present:
#    - name: appvg
#    - devices: /dev/sdb2
create_vg:
  lvm.vg_present:
    - name: {{ pillar['partitions']['VG'] }}
    - devices: /dev/sdb1


### Extend existing rhel LV
extend_rhelvg:
  lvm.vg_present:
    - name: rhel
    - devices: /dev/sda2,/dev/sda3,/dev/sda4

### create new LV
#create_datalv:
#  lvm.lv_present:
#    - name: datalv
#    - vgname: datavg
#    - extents: 511
#    - pv: /dev/sdb1
#create_applv:
#  lvm.lv_present:
#    - name: applv
#    - vgname: appvg
#    - extents: 511 
#    - pv: /dev/sdb2

create_lv:
  lvm.lv_present:
    - name: {{ pillar['partitions']['LV'] }}
    - vgname: {{ pillar['partitions']['VG'] }}
    - extents: 511 
    - pv: /dev/sdb1

### extend root LV
extend_root-lv:
  module.run:
    - name: lvm.lvresize
    - size: 6G
    - lvpath: /dev/mapper/rhel-root

###working on Swap
turn_swap_off:
  cmd.run:
    - name: swapoff -a

extend_swap-lv:
  module.run:
    - name: lvm.lvresize
    - size: 3G
    - lvpath: /dev/mapper/rhel-swap

create_swap_space:
  cmd.run:
    - name: mkswap /dev/mapper/rhel-swap

turn_swap_on:
  cmd.run:
    - name: swapon -a

### create new file systems
#create_app_fs:
#  module.run:
#    - name: xfs.mkfs
#    - device: /dev/mapper/appvg-applv
#create_data_fs:
#  module.run:
#    - name: xfs.mkfs
#    - device: /dev/mapper/datavg-datalv

create_fs:
  module.run:
    - name: xfs.mkfs
    - device: /dev/mapper/{{ pillar['partitions']['VG'] }}-{{ pillar['partitions']['LV'] }}

### extend / partition
extend_root:
  cmd.run:
    - name: xfs_growfs /dev/mapper/rhel-root 


### mount app partition
#/apps:
#  mount.mounted:
#    - device: /dev/mapper/appvg-applv
#    - fstype: xfs
#    - mkmnt: True


### mount data partition
#/data:
#  mount.mounted:
#    - device: /dev/mapper/datavg-datalv
#    - fstype: xfs
#    - mkmnt: True

{{ pillar['partitions']['mount_point'] }}:
  mount.mounted:
    - device: /dev/mapper/{{ pillar['partitions']['VG'] }}-{{ pillar['partitions']['LV'] }}
    - fstype: xfs
    - mkmnt: True
