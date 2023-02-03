install_k3sup_script= File.read("install_k3sup.sh")
join_cluster_script = File.read("join_cluster.sh")

VAGRANTFILE_API_VERSION = "2"
NUM_BOXES = 6
CP_BOXES = 3
IP_OFFSET = 9
MEMORY = "4096"
CPU = "4"

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
      node.vm.disk :disk, name: "storage", size: "20GB"
      node.vm.network "private_network", ip: ip_from_num(i)
      node.vm.provision :hosts, :sync_hosts => true
      node.vm.provision "file", source: "./vagrant.pub", destination: "~/.ssh/vagrant.pub"
      node.vm.provision "shell", inline: <<-SHELL
        cat /home/vagrant/.ssh/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
      SHELL
      node.vm.provision "file", source: "./vagrant-priv", destination: "~/vagrant-priv"
      node.vm.provision "shell", inline: install_k3sup_script
      node.vm.provision "shell" do |s|
        s.inline = join_cluster_script
        s.args = "#{is_main} #{is_cp} #{ip_from_num(i)}"
      end
    end
  end
end