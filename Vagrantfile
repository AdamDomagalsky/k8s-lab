
# -*- mode: ruby -*-
# vi: set ft=ruby :

# server_ip = "192.168.20.10"

# agents = { "agent1" => "192.168.20.11",
#            "agent2" => "192.168.20.12",
#            "agent3" => "192.168.20.13" }

Vagrant.configure("2") do |config|

    config.vm.define "cp1" do |cp1|
      cp1.vm.box = "generic/ubuntu2210"
      cp1.vm.hostname = "cp1"
      cp1.vm.network "private_network", ip: "192.168.20.10"
      cp1.vm.provision :hosts, :sync_hosts => true
      cp1.vm.provision "file", source: "./k3sup.pub", destination: "~/.ssh/k3sup.pub"
      cp1.vm.provision "shell", inline: <<-SHELL
        cat /home/vagrant/.ssh/k3sup.pub >> /home/vagrant/.ssh/authorized_keys
      SHELL
      cp1.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "4096"
        v.vmx["numvcpus"] = "4"
      end
    end

    config.vm.define "cp2" do |cp2|
      cp2.vm.box = "generic/ubuntu2210"
      cp2.vm.hostname = "cp2"
      cp2.vm.network "private_network", ip: "192.168.20.11"
      cp2.vm.provision :hosts, :sync_hosts => true
      cp2.vm.provision "file", source: "./k3sup.pub", destination: "~/.ssh/k3sup.pub"
      cp2.vm.provision "shell", inline: <<-SHELL
        cat /home/vagrant/.ssh/k3sup.pub >> /home/vagrant/.ssh/authorized_keys
      SHELL
      cp2.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "4096"
        v.vmx["numvcpus"] = "4"
      end
    end

    config.vm.define "cp3" do |cp3|
      cp3.vm.box = "generic/ubuntu2210"
      cp3.vm.hostname = "cp3"
      cp3.vm.network "private_network", ip: "192.168.20.12"
      cp3.vm.provision :hosts, :sync_hosts => true
      cp3.vm.provision "file", source: "./k3sup.pub", destination: "~/.ssh/k3sup.pub"
      cp3.vm.provision "shell", inline: <<-SHELL
        cat /home/vagrant/.ssh/k3sup.pub >> /home/vagrant/.ssh/authorized_keys
      SHELL
      cp3.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "4096"
        v.vmx["numvcpus"] = "4"
      end
    end

    config.vm.define "w1" do |w1|
      w1.vm.box = "generic/ubuntu2210"
      w1.vm.hostname = "w1"
      w1.vm.network "private_network", ip: "192.168.20.20"
      w1.vm.provision :hosts, :sync_hosts => true
      w1.vm.provision "file", source: "./k3sup.pub", destination: "~/.ssh/k3sup.pub"
      w1.vm.provision "shell", inline: <<-SHELL
        cat /home/vagrant/.ssh/k3sup.pub >> /home/vagrant/.ssh/authorized_keys
      SHELL
      w1.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "4096"
        v.vmx["numvcpus"] = "4"
      end
    end

    config.vm.define "w2" do |w2|
        w2.vm.box = "generic/ubuntu2210"
        w2.vm.hostname = "w2"
        w2.vm.network "private_network", ip: "192.168.20.21"
        w2.vm.provision :hosts, :sync_hosts => true
        w2.vm.provision "file", source: "./k3sup.pub", destination: "~/.ssh/k3sup.pub"
        w2.vm.provision "shell", inline: <<-SHELL
          cat /home/vagrant/.ssh/k3sup.pub >> /home/vagrant/.ssh/authorized_keys
        SHELL
        w2.vm.provider "vmware_desktop" do |v|
          v.vmx["memsize"] = "4096"
          v.vmx["numvcpus"] = "4"
        end
    end

    config.vm.define "w3" do |w3|
        w3.vm.box = "generic/ubuntu2210"
        w3.vm.hostname = "w3"
        w3.vm.network "private_network", ip: "192.168.20.22"
        w3.vm.provision :hosts, :sync_hosts => true
        w3.vm.provision "file", source: "./k3sup.pub", destination: "~/.ssh/k3sup.pub"
        w3.vm.provision "shell", inline: <<-SHELL
          cat /home/vagrant/.ssh/k3sup.pub >> /home/vagrant/.ssh/authorized_keys
        SHELL
        w3.vm.provider "vmware_desktop" do |v|
          v.vmx["memsize"] = "4096"
          v.vmx["numvcpus"] = "4"
        end
    end

  end