# David McCue 2015
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.provider "parallels" do |v|
    #v.update_guest_tools = true
    v.optimize_power_consumption = false
    v.memory = 2048
    v.cpus = 4
    v.customize ["set", :id, "--nested-virt", "on", "--time-sync", "off"]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook/playbook.yml"
    ansible.host_key_checking = false
    ansible.extra_vars = "main.yml"
    ansible.verbose = 'vv'
  end

  config.vm.provision "shell", path: "bootstrap.sh"

  #config.vm.provision "docker" do |d|
  #  d.pull_images "centos:6.6"
  #end

end
