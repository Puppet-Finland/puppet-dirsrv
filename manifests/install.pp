#
# == Class: dirsrv::install
#
# Install 389 Directory Server
#
class dirsrv::install
(
    $manage_epel

) inherits dirsrv::params
{

    if $::osfamily == 'RedHat' {
        if $manage_epel {
            include ::epel
        }
        # This module depends on EPEL even if it does not include it
        $require = [ Class['::epel'], Package['rubygem-net-ldap'] ]
    } else {
        $require = Package['rubygem-net-ldap']
    }

    package { 'rubygem-net-ldap':
        ensure   => 'present',
        name     => 'net-ldap',
        provider => 'puppet_gem',
    }

    package { $::dirsrv::params::metapackage_name:
        ensure   => installed,
        flavor   => 'default',
        provider => 'dnfmodule',
        require  => $require,
    }
}
