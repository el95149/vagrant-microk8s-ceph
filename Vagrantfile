# -*- mode: ruby -*-
# vi: set ft=ruby :
# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version '>= 1.6.0'
VAGRANTFILE_API_VERSION = '2'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

# require 'json'
# servers = JSON.parse(File.read(File.join(File.dirname(__FILE__), 'servers.json')))
servers = [
  {
    :hostname => "kube01",
    :ip => "10.0.0.100",
    :role => "server"
  },
  {
    :hostname => "kube02",
    :ip => "10.0.0.101",
    :role => "worker"
  },
  {
    :hostname => "kube03",
    :ip => "10.0.0.102",
    :role => "worker"
  }
]
properties = {
  "masterNodeIP" => "10.0.0.100",
  "servers" => servers
}

Vagrant.configure("2") do |config|
  ##### DEFINE VM #####
  config.omnibus.chef_version = '15.8.23' # Fix chef client version

  servers.each do |machine|
    config.vm.define machine[:hostname] do |server|
      server.vm.hostname = machine[:hostname]
      server.vm.box = "peru/ubuntu-20.04-server-amd64"
      server.vm.box_version = "20210602.01"
      server.vm.box_check_update = false
      server.vm.network "private_network", ip: machine[:ip]

      {
        '.' => '/vagrant',
        ::File.join(Dir.home, "/.ssh") => '/home/vagrant/.ssh/local',
      }.each do |host_path, guest_path|
        server.vm.synced_folder host_path, guest_path
      end

      server.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--cpus", "4"]
        vb.customize ["modifyvm", :id, "--vram", 64]

        # Find out folder of VM
        # vm_folder = ""
        # vm_info = vb.customize['showvminfo', :id, '--machinereadable']
        # lines = vm_info.split("\n")
        # lines.each do |line|
        #   if line.start_with?("CfgFile")
        #     vm_folder = line.split("=")[1].gsub('"','')
        #     vm_folder = File.expand_path("..", vm_folder)
        #   end
        # end

        file_to_disk = File.realpath(".").to_s + "/.vagrant/machines/" + server.vm.hostname + "/virtualbox/ceph.vmdk"
        # file_to_disk = vm_folder + "/ceph.vmdk"
        if !File.file?(file_to_disk)
          vb.customize ['createhd', '--filename', file_to_disk, '--size', 10 * 1024, '--format', 'VMDK']
        end
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        vb.gui = false
      end

      server.vm.provision :chef_zero do |chef|
        # chef.log_level = :info
        chef.node_name = machine[:hostname]
        chef.cookbooks_path = 'cookbooks'
        chef.roles_path = 'roles'
        chef.environments_path = 'environments'
        # chef.data_bags_path = 'data_bags'
        chef.nodes_path = 'nodes'
        chef.environment = 'default'
        chef.add_role machine[:role]
        chef.json = properties
        chef.arguments = "--chef-license accept"
      end

    end
  end
end
