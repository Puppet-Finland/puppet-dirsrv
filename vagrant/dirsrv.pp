# This manifest is only used by Vagrant

$servermonitor = 'root@localhost'

class { '::dirsrv':
    serveridentifier           => 'dirsrv',
    suffix                     => 'dc=example,dc=org',
    rootdn_pwd                 => 'vagrant',
    server_admin_pwd           => 'vagrant',
    config_directory_admin_pwd => 'vagrant',
    admin_bind_ip              => '0.0.0.0',
}
