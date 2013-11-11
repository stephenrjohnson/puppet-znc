class znc(
  $auth_type           = $znc::params::zc_auth_type,
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
    require => Package['$znc::params::zc_packages'],
  }
  class { 'znc::config':
       auth_type           => $auth_type,
       ssl                 => $ssl,
       organizationName    => $organizationName,
       localityName        => $localityName,
       stateOrProvinceName => $stateOrProvinceName,
       countryName         => $countryName,
       emailAddress        => $emailAddress,
       commonName          => $commonName,
       port                => $port,
     }
}