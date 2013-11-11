class znc::config(
  $port,
  $ssl,
) {
  File {
    owner => $znc::params::zc_user,
    group => $znc::params::zc_group,
    mode  => '0600',
  }
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin'
  }

  user { $znc::params::zc_user:
    ensure     => present,
    shell      => '/bin/bash',
    comment    => 'ZNC Service Account',
    managehome => 'true',
  }
  group { $znc::params::zc_group:
    ensure => present,
  }
  file { $znc::params::zc_config_dir:
    ensure => directory,
  }
  file { "${znc::params::zc_config_dir}/configs":
    ensure => directory,
  }
  file { "${znc::params::zc_config_dir}/configs/users":
     ensure  => directory,
     purge   => true,
     recurse => true,
     notify  => Exec['remove-unmanaged-users'],
  }
  file { "${znc::params::zc_config_dir}/configs/znc.conf.header":
    ensure  => file,
    content => template('znc/configs/znc.conf.header.erb'),
  }
  file { "${znc::params::zc_config_dir}/configs/znc.conf":
    ensure  => file,
    require => Exec['initialize-znc-config'],
  }
  file { '/etc/init.d/znc':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("znc/etc/init.d/znc.${znc::params::zc_suffix}.erb"),
  }
  file { "${znc::params::zc_config_dir}/configs/clean_users":
     ensure => file,
     owner  => 'root',
     group  => 'root',
     mode   => '0700',
     content => template('znc/bin/clean_znc_users.erb'),
  }

  # Bootstrap config files
  exec { 'initialize-znc-config':
    command => "cat ${znc::params::zc_config_dir}/configs/znc.conf.header > ${znc::params::zc_config_dir}/configs/znc.conf",
    creates => "${znc::params::zc_config_dir}/configs/znc.conf",
    require => File["${znc::params::zc_config_dir}/configs/znc.conf.header"],
  }
  exec { 'remove-unmanaged-users':
     command     => "${znc::params::zc_config_dir}/configs/clean_users",
     refreshonly => 'true',
     require     => File["${znc::params::zc_config_dir}/configs/clean_users"],
  }
}
