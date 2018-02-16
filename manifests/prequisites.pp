#
# == Class: dirsrv::prequisites
#
# Prepare for 389ds installation
#
class dirsrv::prequisites inherits dirsrv::params {

    package { 'net-ldap':
        ensure   => 'present',
        provider => 'puppet_gem',
    }
}
