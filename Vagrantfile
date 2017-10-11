# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

LOCAL_BRANCH = ENV.fetch("LOCAL_BRANCH", "master")

SMALL_XS_HOST = "10.71.216.90" # perfuk-01-01
MED_XS_HOST = "10.71.136.108" # xrtuk-05-08-perf
LARGE_XS_HOST = ["10.71.136.103",  # xrtuk-05-03-perf
                 "10.71.136.104",  # xrtuk-05-04-perf
                 "10.71.136.106",  # xrtuk-05-06-perf
                 "10.71.136.107"]  # xrtuk-05-07-perf

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
    end
  end


# Defines scale{1,2,3} for pool size investigation
  num_hosts = 4
  num_per_host = 16
  (0..num_hosts-1).each do |i|
    (1..num_per_host).each do |j|
      id = i*num_per_host + j #1-64
      hostname = "scale#{id}"
      config.vm.define hostname do |host|
        host.vm.box = "jonludlam/#{LOCAL_BRANCH}"
        host.vm.network "public_network", bridge: "xenbr0"
        host.vm.synced_folder "scripts", "/scripts", type:"rsync", rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]
        host.vm.synced_folder "test-vm", "/boot/guest", type:"rsync", rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]
        config.vm.provider "xenserver" do |xs|
          xs.name = hostname
          xs.memory = 6144
          xs.xs_host = LARGE_XS_HOST[i]
        end
        host.vm.provision "shell", path: "scripts/xs/update.sh"
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
