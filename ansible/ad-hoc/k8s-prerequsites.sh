####### HAPROXY
ansible haproxy -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "apt-get update && apt-get install haproxy -y"
ansible haproxy -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "mkdir /etc/haproxy"
ansible haproxy -m copy -i inventory.ini -b -a 'src=./ad-hoc/haproxy.cfg dest=/etc/haproxy/haproxy.cfg'
ansible haproxy -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "systemctl restart haproxy"

####### NFSv3
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "apt-get update && apt-get install nfs-kernel-server -y"
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "apt-get update && apt-get install nfs-common -y"
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "pvcreate /dev/sdb"
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "vgcreate k8s_data /dev/sdb"
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "lvcreate -n k8s_drive -L 99G k8s_data"
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "mkfs.ext4 -m 0 /dev/k8s_data/k8s_drive "
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "mkdir /var/nfs/k8s -p"
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "echo 'UUID=8bce7062-93e0-4046-9dd2-211152c556b3 /var/nfs/k8s ext4 defaults 0 1' >> /etc/fstab"
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "mount -a"
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "chown 1000:1000 /var/nfs/k8s"
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "echo '/var/nfs/k8s 192.168.20.0/24(rw,all_squash,anonuid=1000,anongid=1000)' > /etc/exports"
##TODO fstab entry for nfs data
ansible NFS -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "systemctl restart nfs-kernel-server"





####### PREPARE COMMON PARTS

ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "echo '192.168.20.100 kubeapi.lab' >> /etc/hosts"
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "echo 'overlay' >> /etc/modules"
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "echo 'br_netfilter' >> /etc/modules"
ansible cluster -m copy -b -i inventory.ini -a 'src=./ad-hoc/99-kubernetes-cri.conf dest=/etc/sysctl.d/99-kubernetes-cri.conf'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "sysctl --system"
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'export OS=xUbuntu_22.04 VER=1.28 WEBSITE=http://download.opensuse.org; echo "deb $WEBSITE/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VER/$OS/ /" | tee /etc/apt/sources.list.d/cri-o.list'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'export OS=xUbuntu_22.04 VER=1.28 WEBSITE=http://download.opensuse.org; curl -L $WEBSITE/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VER/$OS/Release.key | apt-key add -'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'export OS=xUbuntu_22.04 VER=1.28 WEBSITE=http://download.opensuse.org; echo "deb $WEBSITE/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" | tee  /etc/apt/sources.list.d/libcontainers.list'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'export OS=xUbuntu_22.04 VER=1.28 WEBSITE=http://download.opensuse.org; curl -L $WEBSITE/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "apt-get update && apt-get install -y cri-o cri-o-runc"
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "systemctl daemon-reload && systemctl enable crio && systemctl start crio"
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "systemctl status crio"
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a "cat /etc/apt/sources.list.d/kubernetes.list"
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'echo "deb  http://apt.kubernetes.io/  kubernetes-xenial  main" > /etc/apt/sources.list.d/kubernetes.list'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'apt-get update && apt-get install -y kubeadm=1.28.1-00 kubelet=1.28.1-00 kubectl=1.28.1-00'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'apt-mark hold kubelet kubeadm kubectl'
ansible cluster -m ansible.builtin.shell -i inventory.ini -b -B 360 -P 3 -a 'sed -i "s/\/swap/#\/swap/" /etc/fstab'


####### PREPARE INITIAL CP NODE
ansible master -m copy -i inventory.ini -b -a 'src=./ad-hoc/kubeadm-crio-new.yaml dest=/root/kubeadm-crio.yaml'
ansible master -m copy -i inventory.ini -b -a 'src=./ad-hoc/calico.yaml dest=/root/calico.yaml'
ansible master -m copy -i inventory.ini -b -a 'src=./ad-hoc/bgpconfig.yaml dest=/root/bgpconfig.yaml'
ansible master -m ansible.builtin.shell -i inventory.ini -b -B 600 -P 3 -a 'kubeadm init --config=/root/kubeadm-crio.yaml --upload-certs | tee kubeadm-init.out'
ansible master -m ansible.builtin.shell -i inventory.ini -b -B 600 -P 3 -a 'mkdir -p $HOME/.kube; cp -i /etc/kubernetes/admin.conf $HOME/.kube/config; chown $(id -u):$(id -g) $HOME/.kube/config'
ansible master -m ansible.builtin.shell -i inventory.ini -b -B 600 -P 3 -a 'cp /root/calico.yaml .'
ansible master -m ansible.builtin.shell -i inventory.ini -b -B 600 -P 3 -a 'cp /root/bgpconfig.yaml .'
ansible master -m ansible.builtin.shell -i inventory.ini -b -B 600 -P 3 -a 'kubectl apply -f calico.yaml'
ansible master -m ansible.builtin.shell -i inventory.ini -b -B 600 -P 3 -a 'kubectl apply -f bgpconfig.yaml'
# ansible master -m ansible.builtin.shell -i inventory.ini -b -B 600 -P 3 -a 'kubeadm token create'
# ansible master -m ansible.builtin.shell -i inventory.ini -b -B 600 -P 3 -a 'openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed "s/ˆ.* //"'

# ansible node -m ansible.builtin.shell -b -i inventory.ini -B 600 -P 3 -a 'echo "192.168.10.10 k8scp" >> /etc/hosts'


####### ADD MORE NODES
ansible cp2 -m ansible.builtin.shell -b -i inventory.ini -B 600 -P 3 -a 'kubeadm join kubeapi.lab:8080 --token abcdef.0123456789abcdef discovery-token-ca-cert-hash sha256:7d71283f7276ed5f9afec41e07049f110f3fbc459a82b172f60798677c6ed919 control-plane --certificate-key cdf96ec13f2ba8386e5af5f5ec55c8a4f8d694adcf71df89d5d42bdfab87051f --apiserver-advertise-address=192.168.20.11'
ansible cp3 -m ansible.builtin.shell -b -i inventory.ini -B 600 -P 3 -a 'kubeadm join kubeapi.lab:8080 --token abcdef.0123456789abcdef discovery-token-ca-cert-hash sha256:7d71283f7276ed5f9afec41e07049f110f3fbc459a82b172f60798677c6ed919 control-plane --certificate-key cdf96ec13f2ba8386e5af5f5ec55c8a4f8d694adcf71df89d5d42bdfab87051f --apiserver-advertise-address=192.168.20.12'
ansible workers -m ansible.builtin.shell -b -i inventory.ini -B 600 -P 3 -a 'kubeadm join kubeapi.lab:8080 --token abcdef.0123456789abcdef --discovery-token-ca-cert-hash sha256:7d71283f7276ed5f9afec41e07049f110f3fbc459a82b172f60798677c6ed919'

# jc51pk.bhfo1ksdcbyxfht4
# de94a0833c33460207660a74acaf6b59b7fa09f06384d3421ddefc5a767095a0

#######

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00
sudo apt-mark hold kubelet kubeadm kubectl


sudo kubeadm init --config=kubeadm-crio.yaml --upload-certs | tee kubeadm-init.out



#REMOVAL
ansible cluster -m ansible.builtin.shell -b -i inventory.ini -B 360 -P 3 -a 'rm -rf /etc/apt/sources.list.d/cri-0.list; rm -rf /etc/apt/sources.list.d/libcontainers.list; apt-get update'
ansible cluster -m ansible.builtin.shell -b -i inventory.ini -B 360 -P 3 -a 'rm -rf /etc/apt/sources.list.d/kubernetes.list; apt-get update'




#######