k3sup install --ip 192.168.20.10 --user vagrant --cluster --ssh-key ./k3sup
k3sup join --ip 192.168.20.11 --user vagrant --server-ip 192.168.20.10 --server-user vagrant --ssh-key ./k3sup --k3s-version v1.25.6+k3s1 --server
k3sup join --ip 192.168.20.12 --user vagrant --server-ip 192.168.20.10 --server-user vagrant --ssh-key ./k3sup --k3s-version v1.25.6+k3s1 --server
k3sup join --ip 192.168.20.20 --user vagrant --server-ip 192.168.20.10 --server-user vagrant --ssh-key ./k3sup --k3s-version v1.25.6+k3s1
k3sup join --ip 192.168.20.21 --user vagrant --server-ip 192.168.20.10 --server-user vagrant --ssh-key ./k3sup --k3s-version v1.25.6+k3s1
k3sup join --ip 192.168.20.22 --user vagrant --server-ip 192.168.20.10 --server-user vagrant --ssh-key ./k3sup --k3s-version v1.25.6+k3s1