{% from "ruby/map.jinja" import ruby with context %}

ruby_packages:
  pkg.installed:
    - pkgs: 
      - ruby{{ ruby.version }}
      - ruby{{ ruby.version }}-rubygem-bundler
      - ruby{{ ruby.version }}-devel
      - gcc
      - gcc-c++
      - make

gemrc:
  file.managed:
    - name: /home/vagrant/.gemrc
    - source: salt://ruby/gemrc
    - user: vagrant
    - group: vagrant
    - mode: 644

/usr/local/bin/ruby:
  file.symlink:
    - target: /usr/bin/ruby.ruby{{ ruby.version }}

/usr/local/bin/gem:
  file.symlink:
    - target: /usr/bin/gem.ruby{{ ruby.version }}

/usr/local/bin/irb:
  file.symlink:
    - target: /usr/bin/irb.ruby{{ ruby.version }}

/home/vagrant/.profile:
  file.append:
    - text:
      - export PATH=/home/vagrant/.gem/ruby/{{ ruby.version }}.0/bin:$PATH
