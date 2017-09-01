# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  #
  # Basic configuration
  #
  config.vm.box = 'opensuse/openSUSE-42.3-x86_64'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000, guest_ip: 'localhost'

  #
  # Synced folders
  #
  mount_options =
    if ENV['VAGRANT_USE_NFS'] == 'false'
      {}
    else
      { nfs: true, nfs_version: 3, nfs_udp: true }
    end
  config.vm.synced_folder '.', '/home/vagrant/project', mount_options

  #
  # Network
  #
  unless ENV['VAGRANT_USE_NFS'] == 'false'
    config.vm.network 'private_network', ip: '192.168.33.9'
  end

  #
  # Misc
  #
  config.vm.hostname = 'vm-hostname'
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true

  #
  # Provider
  #
  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 1024
  end

  config.vm.provider 'virtualbox' do |vbox|
    vbox.memory = 1024
  end

  #
  # Provisioning
  #
  config.vm.synced_folder 'salt/roots', '/srv/salt'
  config.vm.provision :salt do |salt|
    salt.masterless = true
    salt.run_highstate = true
    salt.verbose = true
    salt.colorize = true

    salt.pillar(
      'ruby' => {
        'lookup' => { 'version' => '2.4' }
      }
    )
  end

  # If a setup.sh script exists, it will be also executed during provisioning.
  setup_sh = File.join(File.dirname(__FILE__), 'provisioning', 'setup.sh')
  if File.exist?(setup_sh)
    config.vm.provision 'shell', privileged: false, path: setup_sh
  end
end
