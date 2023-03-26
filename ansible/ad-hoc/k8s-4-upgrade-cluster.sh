#UPGRADE CONTROL PLANE NODE
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'kubectl -n kube-system exec -it etcd-k8scp -- sh -c "ETCDCTL_API=3 ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key etcdctl snapshot save /var/lib/etcd/snapshot.db"'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo cp /var/lib/etcd/snapshot.db $HOME/backup/snapshot.db-$(date +%m-%d-%y)'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo cp /etc/kubernetes/admin.conf backup/'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo cp -r /etc/kubernetes/pki/etcd $HOME/backup/'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-mark unhold kubeadm'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-get install -y kubeadm=1.23.1-00'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-mark hold kubeadm'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'kubectl drain k8scp --ignore-daemonsets'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo kubeadm upgrade plan'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo kubeadm upgrade apply v1.23.1'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-mark unhold kubelet kubectl'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-get install -y kubelet=1.23.1-00 kubectl=1.23.1-00'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-mark hold kubelet kubectl'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo systemctl daemon-reload'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'sudo systemctl restart kubelet'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'kubectl uncordon k8scp'



#UPGRADE WORKER NODES
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-mark unhold kubeadm'
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-get install -y kubeadm=1.23.1-00'
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-mark hold kubeadm'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'kubectl drain node1 --ignore-daemonsets; kubectl drain node2 --ignore-daemonsets; kubectl drain node3 --ignore-daemonsets'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'kubectl get nodes'
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo kubeadm upgrade node'
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-mark unhold kubelet kubectl'
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-get install -y kubelet=1.23.1-00 kubectl=1.23.1-00'
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo apt-mark hold kubelet kubectl'
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo systemctl daemon-reload'
ansible node -m ansible.builtin.shell -B 600 -P 10 -a 'sudo systemctl restart kubelet'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'kubectl get nodes'
ansible master -m ansible.builtin.shell -B 600 -P 10 -a 'kubectl uncordon node1; kubectl uncordon node2; kubectl uncordon node3'


