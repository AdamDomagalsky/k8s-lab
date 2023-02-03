cd /home/vagrant
sudo ip route add default via 192.168.192.2
curl -sLS https://get.k3sup.dev | sh
# sudo install ./k3sup /usr/local/bin/