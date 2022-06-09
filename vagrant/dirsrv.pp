notify { 'Provisioning 389 Directory Server': }

class { 'dirsrv':
  manage_config              => true,
  manage_packetfilter        => false,
  serveridentifier           => 'vagrant',
  suffix                     => 'dc=example,dc=org',
  rootdn                     => 'cn=Directory Manager',
  rootdn_pwd                 => 'vagrant123',
  config_directory_admin_id  => 'admin',
  config_directory_admin_pwd => 'vagrant',
  dirsrv_allow_ipv4_address  => '0.0.0.0/0',
  dirsrv_allow_ipv6_address  => '::1',
  allow_anonymous_access     => 'on',
  self_sign_cert             => true,
}
