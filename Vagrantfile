# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/zesty64"

  # Use VirtualBox VM provider
  config.vm.provider "virtualbox" do |vb|

    # Set a name for the virtual machine
    vb.name = "jenkins-master"

    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of cpus for the VM:
    vb.cpus = 2

    # Customize the amount of memory on the VM:
    vb.memory = "1024"

    vb.customize [
      "modifyvm", :id,
      "--chipset", "ich9",
      "--vram", "10",
      "--nictype1", "virtio",
      "--nictype2", "virtio"
    ]
  end

  # Provision with ansible
  config.vm.provision "ansible" do |ansible|
    ansible.config_file = "ansible.cfg"
    ansible.playbook = "ansible/playbooks/main.yml"
  end
end
