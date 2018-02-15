#
# == Class: dirsrv::prequisites
#
# Prepare for 389ds installation
#
class dirsrv::prequisites inherits dirsrv::params {

    # The net-ldap rubygem is not required by 389ds. However, the ldap_entry 
    # puppet type included in the datacentred-ldap module will refuse to work if 
    # net-ldap is missing. Because ldap_entry is used to configure 389ds it 
    # needs to work. The end result: we must install the net-ldap gem. In 
    # addition net-ldap needs to be installed using the gem bundled with 
    # puppet-agent.
    include ::ruby

    package { 'net-ldap':
        ensure   => 'present',
        provider => 'puppet_gem',
    }
}
