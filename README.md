# About this repository

This repository contains a `Vagrantfile` and some Salt States that I use to set up my own
development environments. Obviously, you are free to get anything you want from here in case that,
for any reason, you find something useful.

## Base image

The `Vagrantfile`, based on the [official openSUSE Leap 42.3
image](https://app.vagrantup.com/opensuse/boxes/openSUSE-42.3-x86_64), should work with
[VirtualBox](https://www.vagrantup.com/docs/virtualbox/) and
[Libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt) providers.

## NFS

In order to [improve
performance](http://mitchellh.com/comparing-filesystem-performance-in-virtual-machines), NFS is used
for [synced folders](https://www.vagrantup.com/docs/synced-folders/). If you want to disable this
behavior, just set the environment variable `VAGRANT_USE_NFS` to `false`.

Bear in mind that, if you use the *Libvirt* provider, you need to stick to NFS.

## Salt States

Salt states are defined under `salt/roots/` directory. Although all of them are regular Salt states,
we could classify them as *final* and *auxiliary*. For the time being, only *final* states will be
described in this section. Feel free to explore the rest by yourself.

To enable any state, just add its name to the `salt/roots/top.sls` file. For instance, if you want
to set up a Ruby on Rails development environment, write this:

```yaml
base:
  '*':
    - rails
```

### Ruby

The `ruby` state is used to install a given version of Ruby using the openSUSE packages. You can set
pillars data on the Vagrantfile in order to specify which version should be installed. For instance,
to install Ruby 2.3:

```ruby
  salt.pillar(
      'ruby' => {
        'lookup' => { 'version' => '2.3' }
      }
  )
```

Version 2.4 will be installed by default.

### Ruby on Rails

If you want to set up a Ruby on Rails development environment, use the `rails` state. It relies on
other states (like `postgresql` or `headless`) and it includes:

* [Ruby on Rails](https://rubyonrails.org/) gems in the `vagrant` user home directory (no
  system-wide installation).
* [PostgreSQL](https://postgresql.org/) server and development libraries. A user called `rails` will
  be added and, just for convenience, authentication will be disabled when connecting from
  *localhost*.
* [SQLite](https://sqlite.org/) and development libraries.

## Custom provisioning script

Although you may prefer to use Salt, sometimes it is useful to run some script during the
provisioning phase. Therefore, if a `provisioning/setup.sh` script is found, it will be ran after
Salt provisioner finishes. The script will run without privileges, so make sure you use `sudo` when
needed.

## Usage

After adjusting the list of states at `roots/salt/top.sls`, run:

    vagrant up

Remember that you can choose a provider using the `--provider` switch (or setting the
`VAGRANT_DEFAULT_PROVIDER` environment variable):

    vagrant up --provider=libvirt

If you need to re-run the Salt provisioner on an already existing virtual machine, just type:

    vagrant provision
