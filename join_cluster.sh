#/bin/bash

if $1; then
    echo one
    /usr/local/bin/k3sup install --user vagrant --cluster --local
elif $2; then
    echo two
    /usr/local/bin/k3sup join --ip $3 --user vagrant --server-ip 192.168.20.10 --server-user vagrant --ssh-key /home/vagrant/vagrant-priv --k3s-version v1.25.6+k3s1 --server
else
    echo three
    /usr/local/bin/k3sup join --ip $3 --user vagrant --server-ip 192.168.20.10 --server-user vagrant --ssh-key /home/vagrant/vagrant-priv --k3s-version v1.25.6+k3s1
fi