notify { 'Provisioning 389 Directory Server': }

class { 'dirsrv':
  manage_config               => true,
  manage_packetfilter         => false,
  serveridentifier            => 'vagrant',
  suffix                      => 'dc=example,dc=org',
  rootdn                      => 'cn=Directory Manager',
  rootdn_pwd                  => 'vagrant123',
  config_directory_admin_id   => 'admin',
  config_directory_admin_pwd  => 'vagrant',
  dirsrv_allow_ipv4_address   => '0.0.0.0/0',
  dirsrv_allow_ipv6_address   => '::1',
  allow_anonymous_access      => 'on',
  self_sign_cert              => true,
  self_sign_cert_valid_months => 60,
}

#file { '/var/backups/local':
#  ensure => 'directory',
#  owner  => 'root',
#  group  => 'root',
#  mode   => '0750',
#}

dirsrv::backup { 'vagrant':
  ensure           => 'present',
  serveridentifier => 'vagrant',
  suffix           => 'dc=example,dc=org',
  email            => 'root@localhost',
  rootdn           => 'cn=Directory Manager',
  output_dir       => '/var/backups/local/dirsrv',
}
