# SaltStack
Build Automation using Salt Stack 

# Getting Started

This project is intended to automate post deployment tasks using salt stack. These tasks include (but not limited to) file system creation, user account creation, common and customized package installation , OS update etc. Ultimate goal of this automation is to build a server even with out a single login to the new machine. 
In a real time situation, you are expected to build a group of servers segregated on basis of their role (DB or Web server) or enviorment (i.e. prod or dev etc.). all servers in one group need to have identical configuartion. for instance, all DB servers should have a mount point called /data and nfs sahre /data_logs whereas all Web servers should have a mount point called /app and nfs sahre called /app_logs. There could be many other such requirements which can be taken care by salt using custom grains. 

All pre-requists and detailed information about all the tasks is described in next secion of this document. 

# Pre-requisites 
In order to test this automation, you need to have:
- 2 Running RedHat 7 machines with below mentioned configuration:
  - 2 disks of 10 GB each attached to the VMs
  - / partition 4 GB and swap 1 GB created on first disk
- connectivity between salt-master and Linux machines on port 22 , 4505, 4506

# Build tasks covered by this automation

- Verfiy connectivity of Linux machines with all required networks like LEMSS Proxy, Splunk Console, Redhat repositories etc. 
- creation of requested filesystem using LVM.
- mount nfs shares based on server role
- Extend any existing filesystem and swap 
- user creattion based on server role
- add users in sudoers
- Install packages and other tools like LEMSS/Splunk
- configure snmp/ntp etc. 
- Perform OS hardening
- udpate host file 

# Brief desctiption of Salt states

  # pre-minion
    - This is a small shell script which pushes salt-minon on target machines and configure custom grains
  # connection 
    - This state file verifies connectivty of new Linux machines with requried network
  # XFS
    - This state file creates required LVM objects and XFS file systems based on pillar data 
  # users
    - This state file create standard users, set passwords and add them to sudoers
  # users-custom
    - creats users based on pillar data
  # system
    - it takes care of package installation, configuartion udpate, OS hardening.
  # customization
    - non-standard configuration are taken care by this state
  
 Please expect few more edits to to this README document. Feel free to share your thoughts and suggestions around this document.
  
  
   
