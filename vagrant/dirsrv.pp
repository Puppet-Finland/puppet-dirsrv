notify { 'Provisioning 389 Directory Server': }

class { 'dirsrv':
  manage_config               => true,
  serveridentifier            => 'vagrant',
  suffix                      => 'dc=example,dc=org',
  rootdn                      => 'cn=Directory Manager',
  rootdn_pwd                  => 'vagrant123',
  allow_anonymous_access      => 'on',
  self_sign_cert              => true,
  self_sign_cert_valid_months => 60,
}

dirsrv::backup { 'vagrant':
  ensure        => 'present',
  instance      => 'vagrant',
  bind_dn       => 'cn=Directory Manager',
  bind_password => 'vagrant123',
}
