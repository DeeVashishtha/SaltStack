#ssh-copy-id -i /etc/salt/pki/master/ssh/salt-ssh.rsa.pub root@x.x.x.x # IP address of new Linux machine
#ssh-copy-id -i /etc/salt/pki/master/ssh/salt-ssh.rsa.pub root@x.x.x.x # IP address of new Linux machine
#ssh-copy-id -i /etc/salt/pki/master/ssh/salt-ssh.rsa.pub root@x.x.x.x # IP address of new Linux machine

salt-ssh '*' -r 'yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm ; yum clean expire-cache; yum -y install salt-minion; easy_install pip; pip install certifi;yum -y install policycoreutils-python;systemctl enable salt-minion;systemctl restart salt-minion'

salt-ssh '*' -r 'echo master: (x.x.x.x IP address of master) >> /etc/salt/minion.d/minion.conf;echo environment: dev >> /etc/salt/minion.d/minion.conf;systemctl restart salt-minion'

scp /srv/salt/environment/dev/prep-minion/db/db-grains root@x.x.x.x:/etc/salt/grains
scp /srv/salt/environment/dev/prep-minion/app/app-grains root@x.x.x.x:/etc/salt/grains

salt-ssh '*' -r 'systemctl restart salt-minion'
