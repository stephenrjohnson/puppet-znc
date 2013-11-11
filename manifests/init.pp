class znc(
  $ssl                 = $znc::params::zc_ssl,
  $port                = $znc::params::zc_port
) inherits znc::params {
  package { $znc::params::zc_packages:
    ensure => present,
    require => Class['znc::config'],
  }
  service { 'znc':
    ensure  => 'running',
    enable  => 'true',
    require => Package[$znc::params::zc_packages],
  }
  class { 'znc::config':
       ssl                 => $ssl,
       port                => $port,
     }
}