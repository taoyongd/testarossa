# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

LOCAL_BRANCH = ENV.fetch("LOCAL_BRANCH", "master")

SMALL_XS_HOST = "10.71.216.90" # perfuk-01-01
MED_XS_HOST = "10.71.136.108" # xrtuk-05-08-perf
LARGE_XS_HOST = "10.71.160.64" # xrtuk-08-05

USER = ENV.fetch("USER")

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

# Small pool of 3 hosts
(1..3).each do |i|
    hostname = "small#{i}"
    config.vm.define hostname do |host|
      host.vm.box = "jonludlam/#{LOCAL_BRANCH}"
      host.vm.network "public_network", bridge: "xenbr0"
      host.vm.synced_folder "scripts", "/scripts", type:"rsync", rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]
      host.vm.synced_folder "test-vm", "/boot/guest", type:"rsync", rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]
      config.vm.provider "xenserver" do |xs|
        xs.name = hostname
        xs.memory = 1024
        xs.xs_host = SMALL_XS_HOST
      end
      host.vm.provision "shell", path: "scripts/xs/update.sh"
      if i==3
        host.vm.provision :ansible do |ansible|
          ansible.groups = {
              "small" => (1..3).map{|i| "small#{i}"}
          }
         ansible.playbook = "playbook.yml"
         ansible.limit = "small"
        end
      end
    end
  end


# Medium pool of 16 hosts
(1..16).each do |i|
    hostname = "med#{i}"
    config.vm.define hostname do |host|
      host.vm.box = "jonludlam/#{LOCAL_BRANCH}"
      host.vm.network "public_network", bridge: "xenbr0"
      host.vm.synced_folder "scripts", "/scripts", type:"rsync", rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]
      host.vm.synced_folder "test-vm", "/boot/guest", type:"rsync", rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]
      config.vm.provider "xenserver" do |xs|
        xs.name = hostname
        xs.memory = 6144
        xs.xs_host = MED_XS_HOST
      end
      host.vm.provision "shell", path: "scripts/xs/update.sh"
      if i==16
        host.vm.provision :ansible do |ansible|
          ansible.groups = {
              "med" => (1..16).map{|i| "med#{i}"}
          }
         ansible.playbook = "playbook.yml"
         ansible.limit = "med"
        end
      end
    end
  end


# Defines scale{1,2,3} for pool size investigation
  N = 64
  S_NAMES = Hash[ (1..N).map{|i| [i, "scale#{i}"]} ]
  (1..N).each do |i|
    hostname = S_NAMES[i]
    config.vm.define hostname do |host|
      host.vm.box = "jonludlam/#{LOCAL_BRANCH}"
      host.vm.network "public_network", bridge: "xenbr0"
      host.vm.synced_folder "scripts", "/scripts", type:"rsync", rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]
      host.vm.synced_folder "test-vm", "/boot/guest", type:"rsync", rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]
      config.vm.provider "xenserver" do |xs|
        xs.name = hostname
        xs.memory = 6144
        xs.xs_host = LARGE_XS_HOST
      end
      host.vm.provision "shell", path: "scripts/xs/update.sh"
      if i==N
        host.vm.provision :ansible do |ansible|
          ansible.groups = {
              "scale" => S_NAMES.collect { |k, v| v }
          }
         ansible.playbook = "playbook.yml"
         ansible.limit = "scale"
        end
      end
    end
  end

  config.vm.provider "xenserver" do |xs|
    xs.use_himn = true
    xs.memory = 1024
    xs.xs_username = "root"
    xs.xs_password = "xenroot"
  end
end
