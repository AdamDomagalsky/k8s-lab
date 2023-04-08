#Before running on windows vagrant up make sure the following variable is set
# $Env:VAGRANT_EXPERIMENTAL = "disks"

default_gateway= File.read("default_gateway.sh")
# join_cluster_script = File.read("join_cluster.sh")

VAGRANTFILE_API_VERSION = "2"
NUM_BOXES = 6
CP_BOXES = 3
IP_OFFSET = 9
MEMORY = "4096"
HAPROXY_MEMORY = "2048"
CPU = "4"
HAPROXY_CPU = "2"
HAPROXY_IP = "192.168.20.100"
NFS_CPU = "2"
NFS_MEMORY = "2048"
NFS_IP = "192.168.20.50"

def ip_from_num(i)
  "192.168.20.#{IP_OFFSET+i}"
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  (1..NUM_BOXES).each do |i|
    is_main = (i == 1)
    is_cp = (i <= CP_BOXES)
    config.vm.define "node#{i}".to_sym do |node|
      node.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = MEMORY
        v.vmx["numvcpus"] = CPU
      end
      node.vm.box = "generic/ubuntu2210"
      node.vm.hostname = "node#{i}"
      # node.vm.disk :disk, name: "storage", size: "20GB"
      node.vm.network "private_network", ip: ip_from_num(i)
      node.vm.provision :hosts, :sync_hosts => true
      node.vm.provision "file", source: "./vagrant.pub", destination: "~/.ssh/vagrant.pub"
      node.vm.provision "shell", inline: <<-SHELL
        cat /home/vagrant/.ssh/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
        sudo echo "kubeapi.lab 192.168.20.100" >> /etc/hosts
      SHELL
      node.vm.provision "file", source: "./vagrant-priv", destination: "~/vagrant-priv"
      node.vm.provision "shell", inline: default_gateway
      # node.vm.provision "shell" do |s|
      #   s.inline = join_cluster_script
      #   s.args = "#{is_main} #{is_cp} #{ip_from_num(i)}"
      # end
    end
  end
  config.vm.define "haproxy" do |node|
    node.vm.provider "vmware_desktop" do |v|
      v.vmx["memsize"] = HAPROXY_MEMORY
      v.vmx["numvcpus"] = HAPROXY_CPU
    end
    node.vm.box = "generic/ubuntu2210"
    node.vm.hostname = "haproxy"
    node.vm.network "private_network", ip: HAPROXY_IP
    node.vm.provision "file", source: "./vagrant.pub", destination: "~/.ssh/vagrant.pub"
    # node.vm.provision "file", source: "./haproxy.cfg", destination: "/home/vagrant/haproxy.cfg"
    node.vm.provision "shell", inline: <<-SHELL
      cat /home/vagrant/.ssh/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
    SHELL
    node.vm.provision "shell", inline: default_gateway
    node.vm.provision :hosts, :sync_hosts => true
  end
  config.vm.define "NFS" do |node|
    node.vm.provider "vmware_desktop" do |v|
      v.vmx["memsize"] = NFS_MEMORY
      v.vmx["numvcpus"] = NFS_CPU
    end
    node.vm.box = "generic/ubuntu2210"
    node.vm.hostname = "NFS"
    node.vm.network "private_network", ip: NFS_IP
    node.vm.disk :disk, name: "storage1", size: "100GB"
    node.vm.provision "file", source: "./vagrant.pub", destination: "~/.ssh/vagrant.pub"
    # node.vm.provision "file", source: "./NFS.cfg", destination: "/home/vagrant/NFS.cfg"
    node.vm.provision "shell", inline: <<-SHELL
      cat /home/vagrant/.ssh/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
    SHELL
    node.vm.provision "shell", inline: default_gateway
    node.vm.provision :hosts, :sync_hosts => true
  end

end