#-------------------------------------------------------------------------------
# CONFIGURATION FILE
#-------------------------------------------------------------------------------
# project name:  Systems Administration
# path name:     /etc/puppet/environments/%{environment}
# file name:     init.pp
# class:         baseconfig
# author:        Steve Vasta
# created:       February 21, 2017
# modified:      July 25, 2018
# description:   Performs initial configuration tasks
#                for all CentOS systems . . .

class baseconfig {
  if ! defined(Exec['yum update']) {
    exec { 'yum update':
      command => '/usr/bin/yum update -y',
    }
  }

  if ! defined(Exec['package-cleanup']) {
    exec { 'package-cleanup':
      command => '/usr/bin/package-cleanup --oldkernels --count=1 -y',
      require => Exec['yum update'];
    }
  }

  package {
    'epel-release':
      ensure => present,
      notify => Exec['yum update'];
  }

  package { ['most',
             'screen',
             'vim-common',
             'vim-enhanced']:
    ensure => present,
    require => Package['epel-release'];
  }

  file {
    '/etc/issue':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/baseconfig/issue';

    '/etc/issue.net':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/baseconfig/issue';

    '/etc/hosts':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("baseconfig/hosts.erb");

    '/root/.bashrc':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/baseconfig/bashrc';

    '/root/.bash_logout':
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      source  => 'puppet:///modules/baseconfig/bash_logout';

    '/root/.bash_profile':
      owner => 'root',
      group => 'root',
      mode  => '0644',
      source => 'puppet:///modules/baseconfig/bash_profile';

    '/root/.vim':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      before => File['/root/.vim/colors'];

    '/root/.vim/colors':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      before => File['/root/.vim/colors/zenburn.vim'];

    '/root/.vim/colors/zenburn.vim':
      owner => 'root',
      group => 'root',
      mode  => '0755',
      source => 'puppet:///modules/baseconfig/zenburn.vim';

    '/root/.vimrc':
      owner => 'root',
      group => 'root',
      mode  => '0644',
      source => 'puppet:///modules/baseconfig/vimrc',
      require => Package['vim-common', 'vim-enhanced'];

    '/home/vagrant/.bashrc':
      owner => 'vagrant',
      group => 'vagrant',
      mode  => '0644',
      source => 'puppet:///modules/baseconfig/bashrc';

    '/home/vagrant/.bash_logout':
      owner   => 'vagrant',
      group   => 'vagrant',
      mode    => '0644',
      source  => 'puppet:///modules/baseconfig/bash_logout';

    '/home/vagrant/.bash_profile':
      owner => 'vagrant',
      group => 'vagrant',
      mode  => '0644',
      source => 'puppet:///modules/baseconfig/bash_profile';

    '/home/vagrant/.vim':
      ensure => directory,
      owner  => 'vagrant',
      group  => 'vagrant',
      mode   => '0755',
      before => File['/home/vagrant/.vim/colors'];

    '/home/vagrant/.vim/colors':
      ensure => directory,
      owner  => 'vagrant',
      group  => 'vagrant',
      mode   => '0755',
      before => File['/home/vagrant/.vim/colors/zenburn.vim'];

    '/home/vagrant/.vim/colors/zenburn.vim':
      owner => 'vagrant',
      group => 'vagrant',
      mode  => '0644',
      source => 'puppet:///modules/baseconfig/zenburn.vim';

    '/home/vagrant/.vimrc':
      owner => 'vagrant',
      group => 'vagrant',
      mode  => '0644',
      source => 'puppet:///modules/baseconfig/vimrc',
      require => Package['vim-common', 'vim-enhanced'];

    '/home/vagrant/.r10k':
      ensure  => absent,
      force   => true;

    '/root/.r10k':
      ensure  => absent,
      force   => true;

    '/root/anaconda-ks.cfg':
      ensure  => absent,
      force   => true;

    '/root/original-ks.cfg':
      ensure  => absent,
      force   => true;

    '/home/vagrant/.cache':
      ensure  => absent,
      force   => true;
  }
}
