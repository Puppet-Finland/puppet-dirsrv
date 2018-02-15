# This manifest is only used by Vagrant

$servermonitor = 'root@localhost'

include ::packetfilter::endpoint
include ::monit

class { '::dirsrv':
    manage_monit                 => true,
    manage_packetfilter          => true,
    serveridentifier             => 'dirsrv',
    suffix                       => 'dc=example,dc=org',
    rootdn_pwd                   => 'vagrant',
    server_admin_pwd             => 'vagrant',
    config_directory_admin_pwd   => 'vagrant',
    admin_bind_ip                => '0.0.0.0',
    dirsrv_allow_ipv4_address    => '0.0.0.0',
    dirsrv_allow_ipv6_address    => '::1',
    admin_srv_allow_ipv4_address => '0.0.0.0',
    admin_srv_allow_ipv6_address => '::1',
}
