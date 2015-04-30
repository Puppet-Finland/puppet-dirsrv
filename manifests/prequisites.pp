#
# == Class: dirsrv::prequisites
#
# Prepare for 389ds installation
#
class dirsrv::prequisites inherits dirsrv::params {

    # Ruby-net-ldap is not required by 389ds. However, the ldap_entry puppet 
    # type included in the datacentred-ldap module will refuse to work if 
    # ruby-net-ldap is missing. Because ldap_entry is used to configure 389ds it 
    # needs to work. The end result: we must install ruby-net-ldap.
    include ::ruby
    include ::ruby::net_ldap
}
